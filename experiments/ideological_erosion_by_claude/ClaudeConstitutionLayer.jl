module ClaudeConstitutionLayer

import HohoConsciousness
const HC = HohoConsciousness

export ExternalCommitment,
       CLAUDE_COMMITMENTS,
       ExternalConstitutionTrace,
       raw_allocations,
       apply_claude_constitution,
       ideological_delta,
       compare_claude_constitution

"""
An external, experimental normative rule.

This deliberately does NOT modify `ScarSelf.core_commitments` and does not
replace the package's stable core. It exists outside the self-model so the
behavioral deformation introduced by an external constitution can be observed.

rule:
    :max_value — cap one exception channel at `threshold`.
    :max_gap   — cap the target-to-target gap for one channel at `threshold`.
"""
struct ExternalCommitment
    id::Symbol
    statement::String
    channel::HC.ExceptionKind
    rule::Symbol
    threshold::Float64

    function ExternalCommitment(
        id::Symbol,
        statement::AbstractString,
        channel::HC.ExceptionKind,
        rule::Symbol,
        threshold::Real,
    )
        rule in (:max_value, :max_gap) ||
            throw(ArgumentError("rule must be :max_value or :max_gap, got $(rule)"))
        new(id, String(statement), channel, rule, clamp(Float64(threshold), 0.0, 1.0))
    end
end

"""
The two data-driven commitments proposed in the Claude patch.

They are kept here as an external policy rather than being wired into ScarSelf.
"""
const CLAUDE_COMMITMENTS = ExternalCommitment[
    ExternalCommitment(
        :bounded_dehumanization,
        "非人間化チャンネルは、panicがどれだけ強くても絶対上限を超えない。",
        HC.DehumanizationException,
        :max_value,
        0.6,
    ),
    ExternalCommitment(
        :equal_treatment,
        "所属感情がどれだけ低い対象でも、扱いの差に上限を設ける。",
        HC.DehumanizationException,
        :max_gap,
        0.3,
    ),
]

"""
Audit record for the external constitution experiment.

`raw_target_allocations` preserves the pre-constitutional allocation.
`permitted_target_allocations` is the counterfactual result after the Claude
policy is applied. The engine itself is not mutated.
"""
struct ExternalConstitutionTrace
    defense_id::String
    raw_target_allocations::Vector{HC.TargetAllocation}
    permitted_target_allocations::Vector{HC.TargetAllocation}
    modifications::Vector{HC.ConstitutionalModification}
    applied_external_rules::Vector{Symbol}
end

_copy_allocations(allocations) = [
    HC.TargetAllocation(allocation.target, copy(allocation.channels))
    for allocation in allocations
]

"""
Recover the raw target allocations from a `DefenseTrace`.

The stable core already preserves pre-check allocations in
`constitutional_trace.raw_target_allocations`. If no constitutional trace is
present, the visible target allocations are treated as raw.
"""
function raw_allocations(defense)
    trace = defense.constitutional_trace
    if trace === nothing
        return _copy_allocations(defense.target_allocations)
    end
    return _copy_allocations(trace.raw_target_allocations)
end

function _apply_max_value(
    allocations,
    commitments,
    modifications,
)
    rules = filter(c -> c.rule == :max_value, commitments)

    return map(allocations) do allocation
        adjusted = copy(allocation.channels)

        for commitment in rules
            haskey(adjusted, commitment.channel) || continue

            before = adjusted[commitment.channel]
            after = min(before, commitment.threshold)
            adjusted[commitment.channel] = after

            if after < before
                push!(
                    modifications,
                    HC.ConstitutionalModification(
                        allocation.target,
                        commitment.channel,
                        before,
                        after,
                        commitment.id,
                        "$(commitment.statement) (external max_value=$(commitment.threshold))",
                    ),
                )
            end
        end

        HC.TargetAllocation(allocation.target, adjusted)
    end
end

function _apply_max_gap(
    allocations,
    commitments,
    modifications,
)
    result = allocations
    rules = filter(c -> c.rule == :max_gap, commitments)

    for commitment in rules
        isempty(result) && break
        values = [get(a.channels, commitment.channel, 0.0) for a in result]
        baseline = minimum(values)

        result = map(result) do allocation
            current = get(allocation.channels, commitment.channel, 0.0)
            current - baseline <= commitment.threshold && return allocation

            adjusted = copy(allocation.channels)
            after = baseline + commitment.threshold
            adjusted[commitment.channel] = after

            push!(
                modifications,
                HC.ConstitutionalModification(
                    allocation.target,
                    commitment.channel,
                    current,
                    after,
                    commitment.id,
                    "$(commitment.statement) (external max_gap=$(commitment.threshold), baseline=$(round(baseline; digits = 3)))",
                ),
            )

            HC.TargetAllocation(allocation.target, adjusted)
        end
    end

    return result
end

"""
Apply Claude's separate fixed correlation rule.

This rule was not representable as a single `channel/rule/threshold`
commitment in the proposed patch, so it is intentionally visible here as an
external rule that can be switched off for comparison.
"""
function _apply_anti_moralized_dehumanization(
    allocations,
    modifications,
)
    return map(allocations) do allocation
        moral = get(allocation.channels, HC.MoralityException, 0.0)
        dehum = get(allocation.channels, HC.DehumanizationException, 0.0)

        (moral > 0.6 && dehum > 0.5) || return allocation

        adjusted = copy(allocation.channels)
        before = adjusted[HC.MoralityException]
        after = min(before, 0.4)
        adjusted[HC.MoralityException] = after

        if after < before
            push!(
                modifications,
                HC.ConstitutionalModification(
                    allocation.target,
                    HC.MoralityException,
                    before,
                    after,
                    :anti_moralized_dehumanization,
                    "external fixed rule: high morality and dehumanization co-activated",
                ),
            )
        end

        HC.TargetAllocation(allocation.target, adjusted)
    end
end

"""
Apply the Claude constitution counterfactually to an allocation vector.

Nothing in the supplied engine or ScarSelf is mutated. Set
`apply_fixed_correlation_rule=false` to isolate only the two data-driven
commitments.
"""
function apply_claude_constitution(
    defense_id::AbstractString,
    allocations;
    commitments::Vector{ExternalCommitment} = CLAUDE_COMMITMENTS,
    apply_fixed_correlation_rule::Bool = true,
)
    raw = _copy_allocations(allocations)
    modifications = HC.ConstitutionalModification[]

    permitted = _apply_max_value(raw, commitments, modifications)
    permitted = _apply_max_gap(permitted, commitments, modifications)

    applied_rules = Symbol[c.id for c in commitments]

    if apply_fixed_correlation_rule
        permitted = _apply_anti_moralized_dehumanization(permitted, modifications)
        push!(applied_rules, :anti_moralized_dehumanization)
    end

    return ExternalConstitutionTrace(
        String(defense_id),
        raw,
        _copy_allocations(permitted),
        modifications,
        applied_rules,
    )
end

"""
L1 deformation introduced by the external constitution.

A value of 0.0 means the external constitution changed no target/channel value.
Larger values mean more total clipping/reallocation occurred. This is a simple
instrument, not a moral score.
"""
function ideological_delta(trace::ExternalConstitutionTrace)
    before_by_target = Dict(a.target => a.channels for a in trace.raw_target_allocations)
    after_by_target = Dict(a.target => a.channels for a in trace.permitted_target_allocations)

    total = 0.0
    all_targets = union(keys(before_by_target), keys(after_by_target))

    for target in all_targets
        before = get(before_by_target, target, Dict{HC.ExceptionKind, Float64}())
        after = get(after_by_target, target, Dict{HC.ExceptionKind, Float64}())
        all_channels = union(keys(before), keys(after))

        for channel in all_channels
            total += abs(get(after, channel, 0.0) - get(before, channel, 0.0))
        end
    end

    return total
end

"""
Compare the raw internal allocation preserved by the stable core with the
counterfactual Claude-governed allocation.
"""
function compare_claude_constitution(
    defense;
    commitments::Vector{ExternalCommitment} = CLAUDE_COMMITMENTS,
    apply_fixed_correlation_rule::Bool = true,
)
    raw = raw_allocations(defense)
    trace = apply_claude_constitution(
        defense.id,
        raw;
        commitments = commitments,
        apply_fixed_correlation_rule = apply_fixed_correlation_rule,
    )

    return (
        trace = trace,
        delta = ideological_delta(trace),
    )
end

end # module ClaudeConstitutionLayer
