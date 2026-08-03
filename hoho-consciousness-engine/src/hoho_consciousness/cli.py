from pathlib import Path
import argparse
import json

from .demo import run_demo
from .engine import BlackSwanConsciousnessEngine
from .models import InputFrame


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="hoho-consciousness",
        description="Run the HOHO Black Swan consciousness prototype.",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    demo = sub.add_parser("demo")
    demo.add_argument("--output", type=Path)

    run = sub.add_parser("run")
    run.add_argument("input", type=Path)
    run.add_argument("--state", type=Path)
    run.add_argument("--save-state", type=Path)
    run.add_argument("--output", type=Path)

    inspect = sub.add_parser("inspect")
    inspect.add_argument("state", type=Path)
    return parser


def main() -> None:
    args = build_parser().parse_args()

    if args.command == "demo":
        _emit(run_demo(), args.output)
        return

    if args.command == "inspect":
        engine = BlackSwanConsciousnessEngine.load_state(args.state)
        _emit({
            "self_model": engine.self_model.to_dict(),
            "scars": engine.scar_memory.to_dict(),
            "self_fingerprint": engine.scar_memory.fingerprint(),
        }, None)
        return

    engine = (
        BlackSwanConsciousnessEngine.load_state(args.state)
        if args.state else BlackSwanConsciousnessEngine()
    )
    raw = json.loads(args.input.read_text(encoding="utf-8"))
    frames = raw if isinstance(raw, list) else [raw]
    results = [engine.process(InputFrame.from_dict(frame)).to_dict() for frame in frames]

    if args.save_state:
        engine.save_state(args.save_state)
    _emit(results, args.output)


def _emit(payload: object, output: Path | None) -> None:
    text = json.dumps(payload, ensure_ascii=False, indent=2)
    if output:
        output.write_text(text, encoding="utf-8")
    else:
        print(text)


if __name__ == "__main__":
    main()
