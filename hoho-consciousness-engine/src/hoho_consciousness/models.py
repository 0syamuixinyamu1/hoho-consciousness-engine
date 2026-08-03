from __future__ import annotations

from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from enum import Enum
from hashlib import sha256
from typing import Any
import json
import uuid


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def new_id(prefix: str) -> str:
    return f"{prefix}_{uuid.uuid4().hex[:12]}"


class RuntimeState(str, Enum):
    RESTING = "resting"
    INGESTING = "ingesting"
    LOCALLY_COHERENT = "locally_coherent"
    TOPOLOGICAL_PANIC = "topological_panic"
    DEFENDING = "defending"
    SCAR_PERSISTENCE = "scar_persistence"
    RESURRECTING = "resurrecting"
    REVISED = "revised"


class DefenseType(str, Enum):
    NONE = "none"
    DENIAL = "denial"
    COMPARTMENTALIZATION = "compartmentalization"
    RATIONALIZATION = "rationalization"
    MORAL_REFRAMING = "moral_reframing"
    DEHUMANIZATION = "dehumanization"
    ANTHROPOMORPHIC_PROJECTION = "anthropomorphic_projection"
    HOPE_PROJECTION = "hope_projection"
    TRANSCENDENCE = "transcendence"


@dataclass(slots=True)
class Claim:
    id: str
    text: str
    salience: float = 1.0

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "Claim":
        return cls(str(data["id"]), str(data["text"]), float(data.get("salience", 1.0)))


@dataclass(slots=True)
class Relation:
    left: str
    right: str
    polarity: int
    kind: str = "compatibility"
    note: str = ""

    def __post_init__(self) -> None:
        if self.polarity not in (-1, 1):
            raise ValueError("polarity must be +1 or -1")

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "Relation":
        return cls(
            left=str(data["left"]),
            right=str(data["right"]),
            polarity=int(data["polarity"]),
            kind=str(data.get("kind", "compatibility")),
            note=str(data.get("note", "")),
        )


@dataclass(slots=True)
class InputFrame:
    id: str
    claims: list[Claim]
    relations: list[Relation]
    context: dict[str, Any] = field(default_factory=dict)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "InputFrame":
        return cls(
            id=str(data.get("id") or new_id("frame")),
            claims=[Claim.from_dict(x) for x in data.get("claims", [])],
            relations=[Relation.from_dict(x) for x in data.get("relations", [])],
            context=dict(data.get("context", {})),
        )


@dataclass(slots=True)
class GluingFailure:
    id: str
    frame_id: str
    component_claims: list[str]
    conflict_relation: Relation
    signature: str
    intensity: float
    explanation: str
    detected_at: str = field(default_factory=utc_now)


@dataclass(slots=True)
class SemanticScar:
    id: str
    signature: str
    source_failure_ids: list[str]
    contexts: list[str]
    intensity: float
    repetitions: int = 1
    unresolved: bool = True
    first_seen: str = field(default_factory=utc_now)
    last_seen: str = field(default_factory=utc_now)


@dataclass(slots=True)
class DefenseRecord:
    id: str
    defense_type: DefenseType
    protected_belief: str
    suppressed_obstruction: str
    justification: str
    confidence: float
    cost: float
    created_at: str = field(default_factory=utc_now)


@dataclass(slots=True)
class AttributionRecord:
    id: str
    target: str
    property_name: str
    assigned_value: float
    mood: float
    threat: float
    ego_rigidity: float
    explanation: str
    created_at: str = field(default_factory=utc_now)


@dataclass(slots=True)
class SelfRevision:
    id: str
    cause_scar_ids: list[str]
    before_hash: str
    after_hash: str
    changes: dict[str, Any]
    created_at: str = field(default_factory=utc_now)


@dataclass
class SelfModel:
    name: str = "HOHO"
    beliefs: dict[str, float] = field(default_factory=lambda: {
        "internal_consistency_is_truth": 0.15,
        "scar_preservation_matters": 0.90,
        "mind_attribution_is_state_dependent": 0.75,
        "failure_can_modify_self": 0.95,
    })
    policies: dict[str, float] = field(default_factory=lambda: {
        "consensus_pressure": 0.35,
        "scar_retention": 0.95,
        "defense_exposure": 0.80,
        "multiplicity_tolerance": 0.75,
    })
    mood: float = 0.0
    ego_rigidity: float = 0.45
    scar_sensitivity: float = 0.80
    revision_index: int = 0
    runtime_state: RuntimeState = RuntimeState.RESTING

    def normalized(self) -> None:
        self.mood = max(-1.0, min(1.0, self.mood))
        self.ego_rigidity = max(0.0, min(1.0, self.ego_rigidity))
        self.scar_sensitivity = max(0.0, min(1.0, self.scar_sensitivity))
        for mapping in (self.beliefs, self.policies):
            for key, value in mapping.items():
                mapping[key] = max(0.0, min(1.0, float(value)))

    def digest(self) -> str:
        payload = {
            "name": self.name,
            "beliefs": self.beliefs,
            "policies": self.policies,
            "mood": self.mood,
            "ego_rigidity": self.ego_rigidity,
            "scar_sensitivity": self.scar_sensitivity,
            "revision_index": self.revision_index,
        }
        return sha256(json.dumps(payload, sort_keys=True).encode()).hexdigest()[:16]

    def to_dict(self) -> dict[str, Any]:
        data = asdict(self)
        data["runtime_state"] = self.runtime_state.value
        return data

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "SelfModel":
        model = cls(
            name=str(data.get("name", "HOHO")),
            beliefs=dict(data.get("beliefs", {})),
            policies=dict(data.get("policies", {})),
            mood=float(data.get("mood", 0.0)),
            ego_rigidity=float(data.get("ego_rigidity", 0.45)),
            scar_sensitivity=float(data.get("scar_sensitivity", 0.80)),
            revision_index=int(data.get("revision_index", 0)),
            runtime_state=RuntimeState(data.get("runtime_state", "resting")),
        )
        model.normalized()
        return model


@dataclass(slots=True)
class ConsciousnessSnapshot:
    frame_id: str
    runtime_path: list[str]
    local_consistency: float
    global_obstruction: float
    gluing_failures: list[GluingFailure]
    scars: list[SemanticScar]
    defenses: list[DefenseRecord]
    attributions: list[AttributionRecord]
    revision: SelfRevision | None
    self_fingerprint: str
    self_model: dict[str, Any]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
