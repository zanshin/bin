#!/usr/bin/env python3
"""
Rewrite Hugo post front matter so keys appear in order:
  title, date, type: post, tags (+ list items), then nothing else
  (comment and layout are dropped; add them to KEEP_EXTRA if you want them preserved)

Usage:
    # Dry run (no files written):
    python rewrite_frontmatter.py content/posts

    # Write changes:
    python rewrite_frontmatter.py content/posts --write
"""

import argparse
import re
import sys
from pathlib import Path

# Keys to carry over after the required ones, in this order.
# Add 'comment', 'layout', etc. here if you want to keep them.
KEEP_EXTRA: list[str] = ["draft","linkurl"]


def parse_front_matter(text: str) -> tuple[dict, str] | None:
    """
    Split a file into (front_matter_lines, body).
    Returns None if no valid YAML front matter is found.
    """
    if not text.startswith("---"):
        return None
    # Find the closing ---
    rest = text[3:]
    # The closing delimiter must be on its own line
    match = re.search(r"\n---[ \t]*\n", rest)
    if not match:
        # Try end-of-file variant
        match = re.search(r"\n---[ \t]*$", rest)
        if not match:
            return None
        yaml_block = rest[: match.start()]
        body = ""
    else:
        yaml_block = rest[: match.start()]
        body = rest[match.end() :]

    return yaml_block, body


def parse_yaml_manually(yaml_text: str) -> dict:
    """
    A minimal parser for the simple front matter structure described:
      scalar values and list values (tags).
    Falls back to python-frontmatter / PyYAML if available.
    """
    try:
        import yaml  # type: ignore

        return yaml.safe_load(yaml_text) or {}
    except ImportError:
        pass

    data: dict = {}
    current_key = None
    for line in yaml_text.splitlines():
        # List item
        if line.startswith("  - ") or line.startswith("- "):
            item = re.sub(r"^\s*-\s+", "", line).strip().strip('"').strip("'")
            if current_key is not None:
                data.setdefault(current_key, [])
                if not isinstance(data[current_key], list):
                    data[current_key] = []
                data[current_key].append(item)
            continue
        # Key: value
        m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)', line)
        if m:
            current_key = m.group(1)
            value = m.group(2).strip().strip('"').strip("'")
            data[current_key] = value if value else None
    return data


def format_yaml_value(key: str, value) -> str:
    """
    Render a single YAML key/value pair as a string, preserving simple
    formatting. Lists get block-style entries.
    """
    if value is None:
        return f"{key}:\n"
    if isinstance(value, list):
        if not value:
            return f"{key}: []\n"
        items = "".join(f"  - {item}\n" for item in value)
        return f"{key}:\n{items}"
    # Scalar — quote only if it contains special characters
    s = str(value)
    needs_quoting = any(c in s for c in (':', '#', '{', '}', '[', ']', ',', '&', '*', '?', '|', '-', '<', '>', '=', '!', '%', '@', '`'))
    if needs_quoting and not (s.startswith('"') and s.endswith('"')):
        s = '"' + s.replace('"', '\\"') + '"'
    return f"{key}: {s}\n"


def build_front_matter(data: dict) -> str:
    """
    Build front matter string with keys in the required order.
    """
    lines = ["---\n"]

    # Required keys in order
    for key in ("title", "date"):
        if key in data:
            lines.append(format_yaml_value(key, data[key]))

    # Always inject type: post
    lines.append("type: post\n")

    # Tags
    if "tags" in data and data["tags"]:
        lines.append(format_yaml_value("tags", data["tags"]))

    # Any extra keys the caller wants preserved
    for key in KEEP_EXTRA:
        if key in data and data[key] is not None:
            lines.append(format_yaml_value(key, data[key]))

    lines.append("---\n")
    return "".join(lines)


def process_file(path: Path, write: bool) -> bool:
    """
    Process a single file. Returns True if a change was detected.
    """
    original = path.read_text(encoding="utf-8")
    result = parse_front_matter(original)
    if result is None:
        print(f"  SKIP (no front matter): {path}")
        return False

    yaml_text, body = result
    data = parse_yaml_manually(yaml_text)

    new_fm = build_front_matter(data)
    new_content = new_fm + body

    if new_content == original:
        return False  # Nothing to do

    if write:
        path.write_text(new_content, encoding="utf-8")
        print(f"  UPDATED: {path}")
    else:
        print(f"  WOULD UPDATE: {path}")

    return True


def main():
    parser = argparse.ArgumentParser(description="Rewrite Hugo post front matter.")
    parser.add_argument("directory", help="Path to content/posts directory")
    parser.add_argument("--write", action="store_true", help="Actually write changes (default: dry run)")
    args = parser.parse_args()

    posts_dir = Path(args.directory)
    if not posts_dir.is_dir():
        print(f"Error: {posts_dir} is not a directory", file=sys.stderr)
        sys.exit(1)

    files = list(posts_dir.rglob("*.md"))
    print(f"Found {len(files)} markdown files in {posts_dir}")
    print(f"Mode: {'WRITE' if args.write else 'DRY RUN'}\n")

    changed = 0
    for f in files:
        if process_file(f, args.write):
            changed += 1

    print(f"\n{changed}/{len(files)} files {'updated' if args.write else 'would be updated'}.")
    if not args.write and changed:
        print("Re-run with --write to apply changes.")


if __name__ == "__main__":
    main()
