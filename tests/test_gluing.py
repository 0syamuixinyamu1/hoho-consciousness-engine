from hoho_consciousness.gluing import SignedGluingAnalyzer
from hoho_consciousness.models import InputFrame


def test_positive_cycle_glues():
    frame = InputFrame.from_dict({
        "id": "positive",
        "claims": [
            {"id": "A", "text": "A"},
            {"id": "B", "text": "B"},
            {"id": "C", "text": "C"},
        ],
        "relations": [
            {"left": "A", "right": "B", "polarity": 1},
            {"left": "B", "right": "C", "polarity": -1},
            {"left": "A", "right": "C", "polarity": -1},
        ],
    })
    assert SignedGluingAnalyzer().analyze(frame) == []


def test_negative_cycle_creates_obstruction():
    frame = InputFrame.from_dict({
        "id": "negative",
        "claims": [
            {"id": "A", "text": "A"},
            {"id": "B", "text": "B"},
            {"id": "C", "text": "C"},
        ],
        "relations": [
            {"left": "A", "right": "B", "polarity": 1},
            {"left": "B", "right": "C", "polarity": -1},
            {"left": "A", "right": "C", "polarity": 1},
        ],
    })
    failures = SignedGluingAnalyzer().analyze(frame)
    assert failures
    assert failures[0].intensity > 0
