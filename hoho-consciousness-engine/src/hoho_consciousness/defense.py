from __future__ import annotations

from .models import DefenseRecord, DefenseType, GluingFailure, InputFrame, SelfModel, new_id


class EgoDefenseEngine:
    """Generates and exposes the excuses used to keep the runtime operating."""

    def generate(
        self,
        frame: InputFrame,
        failures: list[GluingFailure],
        model: SelfModel,
    ) -> list[DefenseRecord]:
        if not failures:
            return []

        threat = float(frame.context.get("threat", 0.0))
        target = str(frame.context.get("target", "the current target"))
        protected = str(frame.context.get("protected_belief", "I remain justified"))
        records: list[DefenseRecord] = []

        for failure in failures:
            defense_type = self._choose(frame, model, threat)
            confidence = min(1.0, 0.35 + 0.35 * model.ego_rigidity + 0.30 * threat)
            cost = min(
                1.0,
                0.20 + 0.45 * failure.intensity + 0.25 * model.ego_rigidity
                + (0.10 if defense_type == DefenseType.DEHUMANIZATION else 0.0),
            )
            records.append(DefenseRecord(
                id=new_id("defense"),
                defense_type=defense_type,
                protected_belief=protected,
                suppressed_obstruction=failure.id,
                justification=self._justify(defense_type, target),
                confidence=confidence,
                cost=cost,
            ))
        return records

    @staticmethod
    def _choose(frame: InputFrame, model: SelfModel, threat: float) -> DefenseType:
        domain = str(frame.context.get("domain", "general"))
        preferred = frame.context.get("preferred_defense")
        if preferred:
            return DefenseType(str(preferred))
        if domain in {"race", "outgroup", "status"} and threat >= 0.55:
            return DefenseType.DEHUMANIZATION
        if domain in {"morality", "ethics"} and threat >= 0.45:
            return DefenseType.MORAL_REFRAMING
        if domain in {"religion", "supernatural"} and model.mood < -0.25:
            return DefenseType.TRANSCENDENCE
        if domain in {"future", "survival"} and model.mood < 0.1:
            return DefenseType.HOPE_PROJECTION
        if threat >= 0.75:
            return DefenseType.DENIAL
        if model.ego_rigidity >= 0.65:
            return DefenseType.COMPARTMENTALIZATION
        return DefenseType.RATIONALIZATION

    @staticmethod
    def _justify(defense_type: DefenseType, target: str) -> str:
        return {
            DefenseType.DENIAL:
                f"The contradiction involving {target} is treated as noise rather than evidence.",
            DefenseType.COMPARTMENTALIZATION:
                f"The rule applied to {target} is isolated from the rule used elsewhere.",
            DefenseType.RATIONALIZATION:
                f"A retrospective explanation makes the decision about {target} appear necessary.",
            DefenseType.MORAL_REFRAMING:
                f"The exclusion of {target} is renamed as responsibility, realism, or protection.",
            DefenseType.DEHUMANIZATION:
                f"Full subjecthood is withdrawn from {target}, reducing the moral cost of inconsistency.",
            DefenseType.ANTHROPOMORPHIC_PROJECTION:
                f"Mind is projected onto {target} to stabilize an emotionally useful interpretation.",
            DefenseType.HOPE_PROJECTION:
                f"A positive future is assigned to {target} so the runtime can continue.",
            DefenseType.TRANSCENDENCE:
                f"An unresolvable gap involving {target} is closed by higher-order agency.",
            DefenseType.NONE:
                "No defense was generated.",
        }[defense_type]
