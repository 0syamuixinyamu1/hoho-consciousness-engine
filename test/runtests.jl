using Test
using HohoConsciousness

@testset "HOHO Consciousness Engine" begin
    sections = [
        LocalSection(:a, "A"; local_coherence = 1.0, salience = 1.0),
        LocalSection(:b, "B"; local_coherence = 1.0, salience = 1.0),
        LocalSection(:c, "C"; local_coherence = 1.0, salience = 1.0),
    ]

    @testset "Globally glueable cycle" begin
        overlaps = [
            OverlapConstraint(:a, :b, false),
            OverlapConstraint(:b, :c, true),
            OverlapConstraint(:a, :c, true),
        ]
        situation = InputSituation(:glueable, sections, overlaps)
        @test isempty(detect_gluing_obstructions(situation))
    end

    @testset "H1-like gluing failure" begin
        overlaps = [
            OverlapConstraint(:a, :b, false),
            OverlapConstraint(:b, :c, true),
            OverlapConstraint(:a, :c, false),
        ]
        situation = InputSituation(
            :obstructed,
            sections,
            overlaps;
            metadata = Dict{Symbol, Any}(
                :meaning_gap => 0.9,
                :self_image_pressure => 0.9,
            ),
        )
        obstructions = detect_gluing_obstructions(situation)
        @test !isempty(obstructions)
        @test obstructions[1].assigned_value != obstructions[1].required_value
    end

    @testset "Scar is self, not a disposable log" begin
        engine = HohoEngine(
            observer = ObserverState(
                mood = -0.1,
                threat = 0.9,
                self_preservation = 0.95,
                affective_bandwidth = 0.6,
                uncertainty = 0.8,
            ),
        )

        overlaps = [
            OverlapConstraint(:a, :b, false),
            OverlapConstraint(:b, :c, true),
            OverlapConstraint(:a, :c, false),
        ]

        targets = [
            TargetContext(
                :animals;
                belonging = 0.3,
                sentimental_pull = 0.95,
                perceived_vulnerability = 0.9,
            ),
            TargetContext(
                :human_outgroup;
                belonging = 0.0,
                sentimental_pull = 0.05,
                perceived_vulnerability = 0.3,
            ),
        ]

        situation = InputSituation(
            :scar_self,
            sections,
            overlaps;
            targets = targets,
            metadata = Dict{Symbol, Any}(
                :meaning_gap => 0.9,
                :self_image_pressure => 0.95,
            ),
        )

        before = engine.self.signature
        event = process!(engine, situation)

        @test !isempty(event.obstructions)
        @test event.defense !== nothing
        @test event.resurrection !== nothing
        @test engine.self.signature != before
        @test length(engine.self.scars) >= 1
        @test length(engine.self.resurrections) == 1

        allocations = Dict(
            allocation.target => allocation
            for allocation in event.defense.target_allocations
        )

        animal_mind = allocations[:animals].channels[MindAttributionException]
        outgroup_mind =
            allocations[:human_outgroup].channels[MindAttributionException]

        @test animal_mind > outgroup_mind

        # Logic Hybrid病理が入力を捨てたがっても、
        # 障害はScarとして必ず残る。
        @test !isempty(engine.self.scars)

        first_scar = first(values(engine.self.scars))
        recurrence_before = first_scar.recurrence

        process!(engine, situation)
        first_scar_after = first(values(engine.self.scars))
        @test first_scar_after.recurrence == recurrence_before + 1
    end
end
