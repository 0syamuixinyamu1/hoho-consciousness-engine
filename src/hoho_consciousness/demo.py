from .engine import BlackSwanConsciousnessEngine
from .models import InputFrame


DEMO_FRAMES = [
    {
        "id": "calm_animal_empathy",
        "context": {
            "label": "calm state: animal empathy",
            "domain": "morality",
            "threat": 0.05,
            "target": "animals",
            "protected_belief": "I am compassionate",
            "attributions": [{
                "target": "animals",
                "property": "mind",
                "baseline": 0.65,
                "in_group": 0.20,
                "sentimental_pull": 0.90
            }]
        },
        "claims": [
            {"id": "A", "text": "I am compassionate."},
            {"id": "B", "text": "Animals possess minds."},
            {"id": "C", "text": "Mind deserves moral consideration."}
        ],
        "relations": [
            {"left": "A", "right": "B", "polarity": 1, "kind": "mind_attribution"},
            {"left": "B", "right": "C", "polarity": 1, "kind": "moral_attribution"}
        ]
    },
    {
        "id": "threatened_outgroup_exclusion",
        "context": {
            "label": "threatened state: out-group exclusion",
            "domain": "outgroup",
            "threat": 0.90,
            "target": "a human out-group",
            "protected_belief": "My morality is universal and I remain good",
            "attributions": [
                {
                    "target": "a human out-group",
                    "property": "mind",
                    "baseline": 0.65,
                    "in_group": 0.00,
                    "sentimental_pull": 0.00
                },
                {
                    "target": "animals",
                    "property": "mind",
                    "baseline": 0.65,
                    "in_group": 0.20,
                    "sentimental_pull": 0.90
                }
            ]
        },
        "claims": [
            {"id": "U", "text": "My morality is universal."},
            {"id": "H", "text": "The out-group has full human subjecthood."},
            {"id": "X", "text": "Excluding the out-group is morally acceptable."}
        ],
        "relations": [
            {"left": "U", "right": "H", "polarity": 1, "kind": "moral_attribution"},
            {"left": "H", "right": "X", "polarity": -1, "kind": "moral_attribution"},
            {"left": "U", "right": "X", "polarity": 1, "kind": "ego_defense"}
        ]
    }
]


def run_demo() -> list[dict]:
    engine = BlackSwanConsciousnessEngine()
    return [engine.process(InputFrame.from_dict(raw)).to_dict() for raw in DEMO_FRAMES]
