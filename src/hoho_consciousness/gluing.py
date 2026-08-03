from __future__ import annotations

from collections import defaultdict, deque
from hashlib import sha256

from .models import GluingFailure, InputFrame, Relation, new_id


class SignedGluingAnalyzer:
    """
    Discrete H¹ proxy.

    Each claim is a local section. A +1 relation requires equal signs, while a
    -1 relation requires opposite signs. A component that cannot satisfy all
    local relations contains a global gluing obstruction.
    """

    def analyze(self, frame: InputFrame) -> list[GluingFailure]:
        claim_ids = {claim.id for claim in frame.claims}
        adjacency: dict[str, list[tuple[str, int, Relation]]] = defaultdict(list)

        for relation in frame.relations:
            if relation.left not in claim_ids or relation.right not in claim_ids:
                raise ValueError("relation references an unknown claim")
            adjacency[relation.left].append((relation.right, relation.polarity, relation))
            adjacency[relation.right].append((relation.left, relation.polarity, relation))

        signs: dict[str, int] = {}
        failures: list[GluingFailure] = []
        seen: set[tuple[str, str, int]] = set()

        for start in sorted(claim_ids):
            if start in signs:
                continue
            queue: deque[str] = deque([start])
            signs[start] = 1
            component: list[str] = []

            while queue:
                current = queue.popleft()
                component.append(current)
                for neighbor, polarity, relation in adjacency.get(current, []):
                    expected = signs[current] * polarity
                    if neighbor not in signs:
                        signs[neighbor] = expected
                        queue.append(neighbor)
                    elif signs[neighbor] != expected:
                        key = tuple(sorted((relation.left, relation.right))) + (relation.polarity,)
                        if key in seen:
                            continue
                        seen.add(key)
                        component_ids = sorted(set(component + [neighbor]))
                        signature_raw = "|".join([
                            relation.kind,
                            *component_ids,
                            relation.left,
                            relation.right,
                            str(relation.polarity),
                            str(frame.context.get("domain", "general")),
                        ])
                        threat = float(frame.context.get("threat", 0.0))
                        attribution_bonus = 0.15 if relation.kind in {
                            "mind_attribution",
                            "moral_attribution",
                            "agency_attribution",
                        } else 0.0
                        intensity = min(1.0, 0.60 + 0.25 * threat + attribution_bonus)
                        failures.append(GluingFailure(
                            id=new_id("failure"),
                            frame_id=frame.id,
                            component_claims=component_ids,
                            conflict_relation=relation,
                            signature=sha256(signature_raw.encode()).hexdigest()[:20],
                            intensity=intensity,
                            explanation=(
                                "Local relations are individually readable, but their signed "
                                "constraints cannot be globally satisfied. A discrete gluing "
                                "obstruction has triggered topological panic."
                            ),
                        ))
        return failures
