from __future__ import annotations

from dataclasses import asdict
from hashlib import sha256
from typing import Iterable
import json

from .models import GluingFailure, SemanticScar, new_id, utc_now


class ScarMemory:
    """Stores recurring failure signatures rather than vivid episodic replay."""

    def __init__(self, scars: Iterable[SemanticScar] | None = None) -> None:
        self._scars = {scar.signature: scar for scar in (scars or [])}

    def preserve(self, failures: list[GluingFailure], context_label: str) -> list[SemanticScar]:
        touched: list[SemanticScar] = []
        for failure in failures:
            scar = self._scars.get(failure.signature)
            if scar is None:
                scar = SemanticScar(
                    id=new_id("scar"),
                    signature=failure.signature,
                    source_failure_ids=[failure.id],
                    contexts=[context_label],
                    intensity=failure.intensity,
                )
                self._scars[failure.signature] = scar
            else:
                scar.source_failure_ids.append(failure.id)
                scar.contexts.append(context_label)
                scar.repetitions += 1
                scar.intensity = min(
                    1.0,
                    (scar.intensity * (scar.repetitions - 1) + failure.intensity)
                    / scar.repetitions,
                )
                scar.last_seen = utc_now()
                scar.unresolved = True
            touched.append(scar)
        return touched

    def all(self) -> list[SemanticScar]:
        return sorted(
            self._scars.values(),
            key=lambda scar: (scar.repetitions, scar.intensity),
            reverse=True,
        )

    def fingerprint(self) -> str:
        payload = [
            {
                "signature": scar.signature,
                "repetitions": scar.repetitions,
                "intensity": round(scar.intensity, 1),
                "unresolved": scar.unresolved,
            }
            for scar in self.all()
        ]
        return sha256(json.dumps(payload, sort_keys=True).encode()).hexdigest()[:20]

    def to_dict(self) -> list[dict]:
        return [asdict(scar) for scar in self.all()]

    @classmethod
    def from_dict(cls, rows: list[dict]) -> "ScarMemory":
        return cls(SemanticScar(**row) for row in rows)
