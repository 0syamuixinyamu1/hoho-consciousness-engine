from __future__ import annotations

from pathlib import Path
from typing import Any
import json

from .attribution import StateDependentAttribution
from .defense import EgoDefenseEngine
from .gluing import SignedGluingAnalyzer
from .models import ConsciousnessSnapshot, InputFrame, RuntimeState, SelfModel
from .resurrection import ResurrectionBuffer
from .scar_memory import ScarMemory


class BlackSwanConsciousnessEngine:
    """
    Consciousness is implemented as recurrent exception handling in which
    unresolved global inconsistency becomes defense, memory, and self-revision.
    """

    def __init__(
        self,
        self_model: SelfModel | None = None,
        scar_memory: ScarMemory | None = None,
    ) -> None:
        self.self_model = self_model or SelfModel()
        self.scar_memory = scar_memory or ScarMemory()
        self.gluing = SignedGluingAnalyzer()
        self.defense = EgoDefenseEngine()
        self.attribution = StateDependentAttribution()
        self.resurrection = ResurrectionBuffer()

    def process(self, frame: InputFrame) -> ConsciousnessSnapshot:
        path: list[str] = []
        self._state(RuntimeState.INGESTING, path)
        failures = self.gluing.analyze(frame)
        self._state(RuntimeState.LOCALLY_COHERENT, path)

        if failures:
            self._state(RuntimeState.TOPOLOGICAL_PANIC, path)

        global_obstruction = min(
            1.0,
            sum(f.intensity for f in failures) / max(1, len(failures)),
        )
        attributions = self.attribution.assign(frame, self.self_model)
        defenses = []
        scars = []
        revision = None

        if failures:
            self._state(RuntimeState.DEFENDING, path)
            defenses = self.defense.generate(frame, failures, self.self_model)

            self._state(RuntimeState.SCAR_PERSISTENCE, path)
            scars = self.scar_memory.preserve(
                failures,
                str(frame.context.get("label", frame.id)),
            )

            self._state(RuntimeState.RESURRECTING, path)
            revision = self.resurrection.revise(self.self_model, scars, defenses)
            self._state(RuntimeState.REVISED, path)
        else:
            self._state(RuntimeState.RESTING, path)

        return ConsciousnessSnapshot(
            frame_id=frame.id,
            runtime_path=path,
            local_consistency=1.0,
            global_obstruction=global_obstruction,
            gluing_failures=failures,
            scars=scars,
            defenses=defenses,
            attributions=attributions,
            revision=revision,
            self_fingerprint=self.scar_memory.fingerprint(),
            self_model=self.self_model.to_dict(),
        )

    def process_dict(self, data: dict[str, Any]) -> dict[str, Any]:
        return self.process(InputFrame.from_dict(data)).to_dict()

    def save_state(self, path: str | Path) -> None:
        payload = {
            "self_model": self.self_model.to_dict(),
            "scars": self.scar_memory.to_dict(),
        }
        Path(path).write_text(
            json.dumps(payload, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

    @classmethod
    def load_state(cls, path: str | Path) -> "BlackSwanConsciousnessEngine":
        data = json.loads(Path(path).read_text(encoding="utf-8"))
        return cls(
            self_model=SelfModel.from_dict(data["self_model"]),
            scar_memory=ScarMemory.from_dict(data.get("scars", [])),
        )

    def _state(self, state: RuntimeState, path: list[str]) -> None:
        self.self_model.runtime_state = state
        path.append(state.value)
