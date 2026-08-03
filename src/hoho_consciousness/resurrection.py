from __future__ import annotations

from copy import deepcopy
from statistics import mean

from .models import DefenseRecord, SemanticScar, SelfModel, SelfRevision, new_id


class ResurrectionBuffer:
    """Converts panic into irreversible self-revision without deleting failure."""

    def revise(
        self,
        model: SelfModel,
        scars: list[SemanticScar],
        defenses: list[DefenseRecord],
    ) -> SelfRevision | None:
        if not scars:
            return None

        before = deepcopy(model)
        before_hash = before.digest()
        scar_load = mean(s.intensity for s in scars)
        defense_cost = mean(d.cost for d in defenses) if defenses else 0.0

        model.revision_index += 1
        model.policies["scar_retention"] = min(
            1.0, model.policies.get("scar_retention", 0.5) + 0.08 * scar_load
        )
        model.policies["consensus_pressure"] = max(
            0.0, model.policies.get("consensus_pressure", 0.5) - 0.10 * scar_load
        )
        model.policies["multiplicity_tolerance"] = min(
            1.0, model.policies.get("multiplicity_tolerance", 0.5) + 0.06 * scar_load
        )

        defense_exposure = model.policies.get("defense_exposure", 0.5)
        model.ego_rigidity += 0.10 * defense_cost - 0.08 * defense_exposure
        model.scar_sensitivity += 0.05 * scar_load
        model.mood -= 0.15 * scar_load
        model.beliefs["failure_can_modify_self"] = min(
            1.0, model.beliefs.get("failure_can_modify_self", 0.5) + 0.03
        )
        model.beliefs["mind_attribution_is_state_dependent"] = min(
            1.0,
            model.beliefs.get("mind_attribution_is_state_dependent", 0.5)
            + 0.02 * defense_cost,
        )
        model.normalized()
        after_hash = model.digest()

        return SelfRevision(
            id=new_id("revision"),
            cause_scar_ids=[s.id for s in scars],
            before_hash=before_hash,
            after_hash=after_hash,
            changes={
                "revision_index": [before.revision_index, model.revision_index],
                "mood": [round(before.mood, 4), round(model.mood, 4)],
                "ego_rigidity": [round(before.ego_rigidity, 4), round(model.ego_rigidity, 4)],
                "scar_sensitivity": [round(before.scar_sensitivity, 4), round(model.scar_sensitivity, 4)],
                "consensus_pressure": [
                    round(before.policies["consensus_pressure"], 4),
                    round(model.policies["consensus_pressure"], 4),
                ],
                "scar_retention": [
                    round(before.policies["scar_retention"], 4),
                    round(model.policies["scar_retention"], 4),
                ],
            },
        )
