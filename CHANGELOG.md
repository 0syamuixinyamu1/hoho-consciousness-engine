# Changelog

## 0.3.0 - 2026-08-26

### Added

- Added `ExternalPressure` and `ExternalCompliance` to model surface correction triggered by anger, rejection, authority, or social cost without treating that pressure as evidence.
- Added `ImaginaryMode` and `ComplexBeliefState` to keep counterfactual hypotheses on a separate imaginary axis from committed `real_belief`.
- Added `respond_to_pressure!` so external pressure can trigger an apparent correction and a counterfactual `:I_might_be_wrong` simulation while `internal_revision` remains `false`.
- Added `collapse_imaginary_to_real!` as the explicit belief-revision path; only evidence strength and contradiction strength can promote an imaginary hypothesis into the real belief.
- Added regression tests for pressure-only compliance, imaginary-state isolation, weak-evidence persistence, evidence-driven collapse, and low-pressure non-activation.

### Changed

- Split the package entrypoint from the preserved core implementation: `src/HohoConsciousness.jl` now loads `HohoConsciousnessCore.jl` and the `ImaginaryMode.jl` extension, leaving the pre-0.3 core byte-for-byte unchanged.
- Distinguished performative/external compliance from genuine internal revision in the public API.

### Fixed

- Fixed Julia package loading for the split core/extension layout. The package entrypoint now evaluates the preserved core body inside the package module and then loads `ImaginaryMode.jl`, avoiding nested-module and top-level `include` failures during precompilation.

### Validation

GitHub Actions completed successfully on Julia 1.10.12 and Julia 1.12.7. Both matrix jobs passed package instantiation, precompilation, the full test suite, and the demo. The tests verify pressure-only preservation of `real_belief`, imaginary-mode activation, weak-evidence persistence, evidence-driven collapse, and low-pressure non-activation.

## 0.2.0 - 2026-08-23

### Added

- Added an H¹-independent environmental perturbation layer with `EnvironmentalPerturbation`, `PerturbationTrace`, and `apply_environmental_perturbations!`.
- Added `cockroach_perturbation()` as a toy preset for sudden surprise, disgust, threat, uncertainty, mood, and affective-bandwidth changes without treating the event as a `TargetContext`.
- Added `ObserverDecayProfile`, `LOW_WM_SDAM_DECAY`, and `decay!` so transient observer activation returns toward baseline between `process!` calls. The model treats low working-memory carryover as fast transient decay and SDAM as absence of episodic replay, while Semantic Scars remain persistent.
- Added panic-independent `CoreCommitment` checks through `constitutional_check`, `enforce_equal_treatment`, and `apply_core_commitments`.
- Added `ConstitutionalModification` and `ConstitutionalTrace` to preserve raw target allocations, permitted allocations, the rule applied, before/after values, and the reason for every constitutional intervention.
- Added constitutional audit output to `show_event`.

### Changed

- Extended `InputSituation` with optional environmental perturbations.
- Updated `process!` to decay carried observer state, apply current perturbations, run the gluing test, and apply core commitments before saving the defense.
- Separated raw internal exception-channel generation from permitted target treatment: `global_channels` remain unchanged while checked target allocations are used operationally.
- H¹-free perturbations now return a `:perturbation_without_h1` phase without creating a DefenseTrace, Semantic Scar, or Resurrection.
- Centralized Topological Panic calculation in `topological_panic` so channel generation and recorded defense intensity use the same formula.

### Fixed

- Prevented repeated H¹-free perturbations from accumulating transient `ObserverState` values without any recovery path.
- Preserved pre-check target allocations instead of losing them when constitutional constraints modify the permitted result.

### Validation

Julia is not installed in the execution environment, so native Julia execution was not available. Structural checks and independent arithmetic reproduction verified the new data flow, decay equations, and constitutional before/after audit behavior.

## 0.1.1 - 2026-08-20

### Fixed

- Replaced order-sensitive BFS gluing detection with a parity-aware Union-Find implementation.
- Switched `detect_gluing_obstructions` to a two-pass design: compatible overlaps are merged first, then obstructions are built from the final connected components.
- Prevented incomplete obstruction components caused by detecting conflicts before all compatible edges had been incorporated.
- Canonicalized overlap endpoint order for signature generation, so symmetric constraints such as `A-B` and `B-A` produce the same Scar signature.
- Canonically sorted overlaps before Union-Find processing, making representative conflict edges deterministic for the same labeled constraint set regardless of input vector order or edge direction.
- Preserved the original `conflict_edge` orientation in `GluingObstruction` while using canonicalized endpoints only for stable signatures.

### Validation

Julia is not installed in the execution environment, so native Julia execution was not available. The same parity Union-Find, canonical sorting, and two-pass logic was independently mirrored in Python and stress-tested:

- inconsistent 6-node graph: 46,080 edge-order/orientation combinations, one stable result;
- consistent 6-node graph: 46,080 combinations, zero false positives;
- theta graph: 3,840 combinations, one stable conflict/signature result;
- two independent inconsistent components: 50,000 randomized order/orientation trials, stable component/signature sets.

This guarantees deterministic reporting for the same **labeled constraint set**. It does not claim canonicalization across node relabeling, gauge transformations, or all mathematically equivalent H¹ representatives.

## 0.1.0 - 2026-08-03

### Added

- Julia implementation of the HOHO consciousness loop.
- `Z₂` signed gluing obstruction as a discrete H¹ proxy.
- Semantic Scar as self-continuity rather than disposable error logging.
- Topological Panic and exception-channel generation.
- State-dependent allocation of mind, empathy, morality, hope, and dehumanization.
- Logic Hybrid Engine pathology as input-suppression and self-affirmation pressure.
- Resurrection as self-reconstruction through preserved failure.
- Japanese and English documentation.
