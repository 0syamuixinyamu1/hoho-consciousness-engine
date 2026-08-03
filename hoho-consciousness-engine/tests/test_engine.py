from hoho_consciousness.engine import BlackSwanConsciousnessEngine
from hoho_consciousness.models import InputFrame


def contradictory_frame() -> InputFrame:
    return InputFrame.from_dict({
        "id": "frame",
        "context": {
            "domain": "outgroup",
            "threat": 0.9,
            "target": "out-group",
            "protected_belief": "I am universally moral",
        },
        "claims": [
            {"id": "U", "text": "Universal morality"},
            {"id": "H", "text": "Equal human subjecthood"},
            {"id": "X", "text": "Exclusion is acceptable"},
        ],
        "relations": [
            {"left": "U", "right": "H", "polarity": 1},
            {"left": "H", "right": "X", "polarity": -1},
            {"left": "U", "right": "X", "polarity": 1},
        ],
    })


def test_failure_changes_self_and_is_preserved():
    engine = BlackSwanConsciousnessEngine()
    before = engine.self_model.digest()
    snapshot = engine.process(contradictory_frame())
    assert snapshot.gluing_failures
    assert snapshot.scars
    assert snapshot.defenses
    assert snapshot.revision is not None
    assert snapshot.revision.before_hash == before
    assert snapshot.revision.after_hash != before
    assert "topological_panic" in snapshot.runtime_path


def test_repeated_failure_increases_scar_repetition():
    engine = BlackSwanConsciousnessEngine()
    engine.process(contradictory_frame())
    engine.process(contradictory_frame())
    assert engine.scar_memory.all()[0].repetitions == 2
