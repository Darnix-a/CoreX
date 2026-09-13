# CoreX Development & TUI Design Guidelines

When developing, refactoring, or adding commands to CoreX (`cx`), strictly adhere to the following interface and architectural guidelines.

## 1. FZF & TUI Layout Invariants

- **No Nested Fixed-Width Boxes in Preview Panes**:
  - FZF already draws border boxes (`--border=rounded`, `--preview-window=border-rounded`).
  - Never render fixed-width ASCII boxes (`box_header`, `width=70`) inside FZF preview panes. On standard terminal splits (e.g., 50% split on 120–140 column screens), fixed 70-column widths cause border characters and text to wrap onto new lines, causing visual corruption (e.g., `└ wrap)`).
  - Use clean typography, section headers, and horizontal divider rules that never exceed 54 columns (`div = "─" * 52`).

- **Header vs. Footer Placement**:
  - Keep `--header` concise and strictly single-line (e.g., category filter hints like `Filter: @ai @audio @gpu ...`).
  - Place global keyboard shortcuts in `--footer` with `--footer-label=" KEYBINDINGS "`. Never crowd multi-line shortcuts into the left pane header.

- **List Item Column Budgeting**:
  - In `format_cockpit_items`, keep the prefix columns $\le 30$ characters:
    - Tag: `@category` (8 chars)
    - Status Badge: `▲ ` (missing dep), `⚡ ` (sudo required), or `• ` (2 chars)
    - Command ID: 18 chars (`id:<18`)
    - Separator: `│`
  - This guarantees status badges are immediately visible and descriptions have 35–45 characters to breathe without premature truncation (`..`).

- **Preview Telemetry vs. Usage Notes**:
  - Differentiate dynamic shell telemetry from static notes in `spec.preview_cmd`.
  - Commands with static descriptions (e.g., `echo '...'`) must be displayed as clean `USAGE & NOTES` sections, never in a dedicated subprocess or box.
  - Live telemetry commands (`df -h`, `free`, `nvidia-smi`, `ip -br a`) should be indented with `│` and capped at 10 lines.

## 2. In-Context UX over Disconnected CLI Utilities

- When users request telemetry or status for interactive features (e.g., "show currently streaming song" for radio):
  1. Integrate the live display directly into the primary player/tuner cockpit in real time.
  2. Display the live metadata in the selection/preview picker (`__preview_radio`).
  3. Offer secondary CLI aliases (`cx song`, `cx now-playing`) as supplementary shortcuts, not replacements for the in-app experience.
