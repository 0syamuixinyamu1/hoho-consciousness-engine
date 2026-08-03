from hoho_consciousness.attribution import StateDependentAttribution
from hoho_consciousness.models import InputFrame, SelfModel


def test_threat_withdraws_outgroup_attribution():
    model = SelfModel()
    analyzer = StateDependentAttribution()

    calm = InputFrame.from_dict({
        "id": "calm",
        "context": {
            "threat": 0.0,
            "attributions": [{
                "target": "outgroup",
                "property": "mind",
                "baseline": 0.65,
                "in_group": 0.0,
                "sentimental_pull": 0.0
            }]
        },
        "claims": [],
        "relations": []
    })

    threatened = InputFrame.from_dict({
        "id": "threatened",
        "context": {
            "threat": 1.0,
            "attributions": [{
                "target": "outgroup",
                "property": "mind",
                "baseline": 0.65,
                "in_group": 0.0,
                "sentimental_pull": 0.0
            }]
        },
        "claims": [],
        "relations": []
    })

    assert analyzer.assign(threatened, model)[0].assigned_value < analyzer.assign(calm, model)[0].assigned_value
