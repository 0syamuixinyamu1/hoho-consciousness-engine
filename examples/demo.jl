using HohoConsciousness

# =============================================================================
# DEMO
#
# 同じ観測者が、
# 「動物には心がある」「心には道徳的価値がある」と語りながら、
# 脅威下では人間の外集団から主体性を撤回しうる状況を与える。
#
# 重要:
#   外集団なら非人間化、という固定if文ではない。
#
#   まず局所命題群が大域的に貼れずTopological Panicが生じ、
#   その後、脅威、所属、情動、自己保存の連続量によって
#   心、共感、道徳、非人間化の配布量が変化する。
# =============================================================================

engine = HohoEngine(
    observer = ObserverState(
        mood = -0.20,
        threat = 0.88,
        self_preservation = 0.92,
        affective_bandwidth = 0.58,
        uncertainty = 0.81,
    ),
    pathology = LogicHybridPathology(
        closure_pressure = 0.82,
        input_drop_pressure = 0.76,
        self_affirmation_pressure = 0.91,
        resurrection_glorification = 0.86,
    ),
)

sections = [
    LocalSection(
        :universal_morality,
        "私はすべての主体へ普遍的な道徳を適用する。";
        local_coherence = 0.98,
        salience = 0.95,
    ),
    LocalSection(
        :human_subjecthood,
        "人間の外集団にも完全な主体性がある。";
        local_coherence = 0.97,
        salience = 0.94,
    ),
    LocalSection(
        :exclusion_is_good,
        "その外集団を排除しても、自分の普遍的善性は維持される。";
        local_coherence = 0.93,
        salience = 0.96,
    ),
]

overlaps = [
    # 普遍的道徳と完全な主体性は同じ側に貼る。
    OverlapConstraint(
        :universal_morality,
        :human_subjecthood,
        false;
        relation = :moral_gluing,
        explanation = "普遍性は対象の主体性を承認する。",
    ),

    # 完全な主体性と恣意的排除は反対側に貼る。
    OverlapConstraint(
        :human_subjecthood,
        :exclusion_is_good,
        true;
        relation = :subjecthood_conflict,
        explanation = "完全な主体性と恣意的排除は両立しない。",
    ),

    # しかし自己防衛は、普遍的善性と排除を同じ側に貼ろうとする。
    # この閉路はXORが奇数になり、大域切断を持たない。
    OverlapConstraint(
        :universal_morality,
        :exclusion_is_good,
        false;
        relation = :ego_preservation,
        explanation = "排除しても自分は普遍的に善いと維持する。",
    ),
]

targets = [
    TargetContext(
        :animals;
        belonging = 0.28,
        sentimental_pull = 0.95,
        perceived_vulnerability = 0.92,
    ),
    TargetContext(
        :human_outgroup;
        belonging = 0.02,
        sentimental_pull = 0.08,
        perceived_vulnerability = 0.35,
    ),
]

situation = InputSituation(
    :selective_mind_distribution,
    sections,
    overlaps;
    targets = targets,
    metadata = Dict{Symbol, Any}(
        :meaning_gap => 0.87,
        :self_image_pressure => 0.95,
    ),
)

event = process!(engine, situation)
show_event(event)

println("\nCurrent Scar-Self statement:")
println(engine.self.current_self_statement)

println("\nScar count: ", length(engine.self.scars))
println("Defense count: ", length(engine.self.defenses))
println("Resurrection count: ", length(engine.self.resurrections))
