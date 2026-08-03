from __future__ import annotations

from .models import AttributionRecord, InputFrame, SelfModel, new_id


class StateDependentAttribution:
    """Distributes mind, agency, value, or hope according to observer state."""

    def assign(self, frame: InputFrame, model: SelfModel) -> list[AttributionRecord]:
        requests = frame.context.get("attributions", [])
        if not isinstance(requests, list):
            return []

        threat = float(frame.context.get("threat", 0.0))
        default_target = str(frame.context.get("target", "unknown"))
        records: list[AttributionRecord] = []

        for request in requests:
            target = str(request.get("target", default_target))
            property_name = str(request.get("property", "mind"))
            baseline = float(request.get("baseline", 0.5))
            in_group = float(request.get("in_group", 0.5))
            sentimental = float(request.get("sentimental_pull", 0.0))
            value = (
                baseline
                + 0.20 * model.mood
                + 0.25 * sentimental
                + 0.15 * in_group
                - 0.35 * threat * (1.0 - in_group)
                - 0.20 * model.ego_rigidity * threat
            )
            value = max(0.0, min(1.0, value))
            records.append(AttributionRecord(
                id=new_id("attribution"),
                target=target,
                property_name=property_name,
                assigned_value=value,
                mood=model.mood,
                threat=threat,
                ego_rigidity=model.ego_rigidity,
                explanation=(
                    f"{property_name} attribution to {target} depends on baseline={baseline:.2f}, "
                    f"mood={model.mood:.2f}, threat={threat:.2f}, in_group={in_group:.2f}, "
                    f"and sentimental_pull={sentimental:.2f}. It is an observer policy."
                ),
            ))
        return records
