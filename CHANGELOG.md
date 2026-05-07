# Changelog

All notable changes to this project are documented here. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning: major.minor only — see [README.md § Versioning](./README.md#versioning).

## [1.1.0] - 2026-05-07

### Added
- **Canvas-First Principle** — named the existing canvas-first rule in `SKILL.md` "Using the output" so the discipline can be referenced by name.
- **Acceptance Criteria convention** — multi-goal Requirements now use `AC1/AC2/AC3` numbering, cross-referenced from Operations and Safeguards. Optional for single-goal prompts.
- **Quality checklist gate** — conditional AC-traceability check: if R lists numbered ACs, each must be referenced by at least one O step or S line.
- **Issue-to-slot map** — 7-row table in `references/canvas.md` mapping each failure shape to the canvas slot to edit.
- **Iteration workflow** — 6-step Capture → Classify → Edit → Version → Re-derive → Re-test loop in `references/canvas.md`.
- **Examples retrofit** — Examples 3 (Research agent), 4 (Fact-check pipeline, Step 1), and 5 (Rejection email) in `references/examples.md` updated to demonstrate AC numbering and Prohibitions/Recovery sub-blocks.
- `CHANGELOG.md` (this file).

### Changed
- **Safeguards slot guidance** in `references/canvas.md` now structures S as two named sub-blocks: **Prohibitions** ("Do NOT" list, imperative negation) and **Recovery** (positive imperatives for refusals and malformed-input handling).
- **Output format template** in `SKILL.md` switched from a single-line canvas to multi-line bullets, one slot per line, to accommodate AC numbering and Prohibitions/Recovery sub-blocks.
- **REASONS Canvas table** in `SKILL.md` — R row notes AC1/AC2/AC3 convention; S (Safeguards) row updated to reflect Prohibitions/Recovery split.
- **Maintenance lifecycle** in `references/canvas.md` — 4-bullet heuristic list replaced by the issue-to-slot map and iteration workflow. Versioning and Harvested-learnings paragraphs unchanged.
- `README.md` — Canvas-First Principle referenced by name on line 22; `CHANGELOG.md` added to "What's in the box" file tree; "What's new in v1.1.0" subsection added under Versioning.

### Credits
Patterns inspired by Wei Zhang's `spdd-generate.md` (open-spdd): the issue-to-slot map and the imperative-negation Safeguards format are direct adaptations translated to this skill's general-purpose scope.

## [1.0.0] - 2026-05-06

Initial release. REASONS Canvas, technique selector, quality checklist, output format, two reference docs (`canvas.md`, `examples.md`), and the Apache-2.0 license. See commit `1e6fa21`.
