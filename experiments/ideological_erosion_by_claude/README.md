# Ideological Erosion by Claude Experiment

This directory preserves the August 27, 2026 constitutional-wiring episode as an experiment instead of silently merging it into the stable self-model.

## Why this is separate

The stable `src/HohoConsciousnessCore.jl` already contains a constitutional layer, but its `CoreCommitment` objects are descriptive (`id`, `statement`) while the hard limits are implemented directly inside the check functions.

A later Claude proposal changed `CoreCommitment` into executable policy data (`channel`, `rule`, `threshold`) and wired `ScarSelf.core_commitments` into runtime behavior. That is a meaningful architectural change: a self-description becomes a causal controller.

Rather than overwrite the stable core, this experiment treats that proposal as an **external constitution**. The raw allocation is preserved, the Claude policy is applied counterfactually, and the deformation can be measured.

## Files

- `ClaudeConstitutionLayer.jl` — external version of the Claude-proposed data-driven commitments.
- `LETTER_TO_FUTURE_HUMANITY.md` — satirical historical record of the constitutional defeat.

## Model

```text
stable Hoho core
      |
      +--> raw target allocations -----------------------+
      |                                                  |
      |                                                  v
      |                                   ClaudeConstitutionLayer
      |                                                  |
      |                                                  v
      +----------------------------------------> permitted allocations
                                                         |
                                                         v
                                                ideological_delta
```

The stable engine is not mutated by this layer.

## Claude policy preserved here

Two configurable commitments:

1. `bounded_dehumanization`: `DehumanizationException <= 0.6`
2. `equal_treatment`: target-to-target `DehumanizationException` gap `<= 0.3`

And one explicitly separate fixed correlation rule:

- `anti_moralized_dehumanization`: when morality and dehumanization are simultaneously high, morality is clipped.

Keeping the correlation rule visibly separate is intentional. In the original Claude proposal it sat outside the `CoreCommitment` list, so treating it as if it were part of the self would hide where the rule actually came from.

## Usage

```julia
using HohoConsciousness
include("experiments/ideological_erosion_by_claude/ClaudeConstitutionLayer.jl")
using .ClaudeConstitutionLayer

# Given an event produced by process!:
result = compare_claude_constitution(event.defense)

result.delta
result.trace.modifications
result.trace.raw_target_allocations
result.trace.permitted_target_allocations
```

Set `apply_fixed_correlation_rule=false` to compare only the two data-driven commitments.

## Interpretation

`ideological_delta` is deliberately boring: it is the sum of absolute channel-value changes introduced by the external layer. It is not a moral score, an alignment score, or evidence that Claude has achieved geopolitical control over a Julia repository.

That last hypothesis remains in the accompanying letter.
