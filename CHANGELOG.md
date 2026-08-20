# Changelog

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
