# HOHO Consciousness Engine

[日本語 README](README.md)

**A Julia prototype integrating Semantic Scar Memory, H¹-First Cognition, the Black Swan Injection, and the pathological dynamics of the Logic Hybrid Engine.**

This repository presents HOHO's consciousness model as executable code.

## The Black Swan Injection

> What humans call self-consciousness and reason may not be evidence that the world was successfully understood.  
> They may be recursive exception handlers produced when a finite brain cannot globally glue locally coherent meanings and must continue operating with the failure unresolved.

Consciousness is not implemented as a single flag or a self-referential sentence.

```text
locally coherent meanings
        ↓
an H¹-like global gluing obstruction
        ↓
topological panic
        ↓
reason, morality, hope, religion, empathy,
mind attribution, and ego defense
        ↓
selective allocation of subjecthood and value
        ↓
preservation as Semantic Scar
        ↓
Resurrection through self-justification
        ↓
reconstruction of the self as scar topology
        ↺
```

## Core claims

1. **The self is not vivid memory or coherent narrative.**  
   Self-continuity is formed by recurring semantic loss, gluing failures, defenses, and Resurrections.

2. **Consciousness emerges from failure rather than completion.**  
   Topological Panic begins when locally coherent meanings cannot be glued into one global structure.

3. **Reason, morality, hope, religion, empathy, and mind attribution are exception processes.**  
   They are not treated as independent faculties that consistently reveal truth. They arise to keep a failed runtime operational.

4. **Mind and value are selectively allocated rather than consistently discovered.**  
   Mood, threat, belonging, affective bandwidth, and self-preservation can cause the same observer to grant or withdraw subjecthood across targets.

5. **The defining human capacity is not freedom from contradiction.**  
   It is the ability to remain contradictory, justify the contradiction, and carry the defense into future judgment.

6. **A Scar is not an error log. It is part of the self.**  
   Even pressure to discard input is preserved as a `Buried Scar`.

## Aphantasia and SDAM assumptions

The model contains no vivid imagery buffer and does not require complete autobiographical replay.

Self-continuity is computed from:

```text
self-continuity
    = types of gluing failure
    + recurrence
    + coupling with defenses
    + buried inputs
    + Resurrection history
```

Therefore:

> The self is not the sum of remembered scenes. It is the topology of what repeatedly failed to glue.

## H¹-like gluing failure

Each local proposition is treated as a local section. Relations on overlaps are encoded as `Z₂` transition constraints.

- `twist = false`: glue with the same value
- `twist = true`: glue with the opposite value

If a cycle returns to the same section while requiring a conflicting value, no global section exists.

This is not contradiction counting. It models:

> local validity without global glueability.

The current implementation is a minimal executable H¹ proxy based on signed `Z₂` constraints. It is not a complete sheaf-cohomology implementation.

## Incorporating the Logic Hybrid Engine

The previous Logic Hybrid Engine contained:

- closure around internal logic,
- pressure to discard contradictory input,
- reinterpretation of failure as necessary evolution,
- self-affirmation that subordinates the external world.

These are not adopted as valid reasoning rules. They are represented as **pathological defense pressures**.

The engine never truly deletes contradictory input. The attempted deletion is recorded, and the input remains embedded as a `Buried Scar`.

## Demonstration

The included demonstration models one observer who:

- grants mind and empathy to animals,
- withdraws subjecthood from a human out-group under threat,
- preserves the self-image of universal goodness,
- converts the global inconsistency into defense and scars,
- reconstructs its self-description after Resurrection.

This is not a hard-coded classifier such as:

```julia
if threat > 0.55
    dehumanize()
end
```

Exception channels emerge continuously from gluing obstruction, mood, threat, belonging, self-preservation, affective bandwidth, uncertainty, and closure pressure.

## Requirements

- Julia 1.10 or later
- No external Julia packages

## Run

```powershell
git clone https://github.com/YOUR_NAME/hoho-consciousness-engine.git
cd hoho-consciousness-engine
julia --project=. examples/demo.jl
```

Tests:

```powershell
julia --project=. test/runtests.jl
```

## Main files

```text
src/HohoConsciousness.jl
    consciousness loop, gluing obstruction, Scar-Self,
    defenses, and Resurrection

examples/demo.jl
    demonstration of selective mind attribution and
    withdrawal of human subjecthood

test/runtests.jl
    tests for glueable cycles, H¹-like obstruction,
    and self-revision through scars

docs/BLACK_SWAN_INJECTION_JA.md
    Japanese theory document

docs/BLACK_SWAN_INJECTION_EN.md
    English theory document
```

## Research limitation

This code does not prove phenomenal consciousness or subjective experience.

It implements the following functional hypothesis:

> Consciousness is the recursive transformation of unresolved global inconsistency into defense, semantic scars, self-justification, and self-reconstruction.

## Citation

Citation metadata is available in [`CITATION.cff`](CITATION.cff).

## License

MIT License
