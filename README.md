# prompt-architect

A Claude Skill that engineers production-grade prompts using the **REASONS Canvas** — a structured method adapted from Thoughtworks' Structured Prompt-Driven Development (SPDD) and the GenAI engineering patterns documented on [martinfowler.com](https://martinfowler.com).

> **Treat every prompt as a first-class artifact.**
> Specified · Reviewable · Testable · Versioned.

---

## Why this skill exists

Most prompts get written, pasted into a tool, and lost. They have no design rationale, no test cases, and no maintenance protocol — so when they fail in production, nobody knows which constraint to relax or which safeguard to add.

This skill enforces a workflow that turns prompts into engineering artifacts:

1. Capture intent in one testable sentence.
2. Fill the REASONS Canvas (seven slots).
3. Pick a technique with a one-line justification.
4. Assemble the prompt in a fixed output format.
5. Self-review against a quality checklist.

The canvas is the design; the prompt block is the compiled output. When a prompt misbehaves, you edit the canvas first, then re-derive the prompt.

---

## Installation

### Claude Code

```bash
claude plugin marketplace add YOUR_GITHUB_HANDLE/prompt-architect
claude plugin install prompt-architect@prompt-architect
```

### Claude.ai (web/desktop app)

1. Settings → Capabilities → enable **Code Execution and File Creation**.
2. Customize → Skills → **+ New Skill** → upload a ZIP of the `skills/prompt-architect/` folder.

The ZIP must contain the `prompt-architect/` folder at the root, not the loose `SKILL.md`.

### Other LLMs (ChatGPT, Gemini, Cursor, raw API)

Copy the contents of `skills/prompt-architect/SKILL.md` (everything below the YAML frontmatter) into the system prompt or custom instructions field. You lose auto-triggering, but the canvas itself does the work.

---

## 30-second usage example

**You ask:**
> Help me write a prompt that classifies customer emails as billing, technical, or other.

**The skill produces** (abbreviated):

```markdown
# email-triage-classifier

## Header
- Purpose: Classify customer emails into one of three labels with audit-ready reasoning
- Prompt type: system+user
- Technique: Chain-of-thought
- Version: v1.0

## REASONS Canvas
- R: Classify into one of three labels; emit reasoning then label
- E: "billing" = charges, refunds, invoices · "technical" = product not working · "other" = everything else
- A: CoT — hybrid cases need visible reasoning to be debuggable
- S: Output = `## Reasoning` (2–4 sentences) then `## Label` (lowercase, one of three)
- O: Identify primary complaint → match to category → if hybrid pick what user wants resolved → emit
- N: Reasoning is plain prose. Label is exactly billing|technical|other
- S: Empty/non-English → label `other` and note in reasoning. Never invent a fourth category

## The Prompt
### System
[the actual prompt text, ready to copy-paste]

### User
[the user template with {{placeholders}}]

## Example pass / Example fail
[seed your eval set]
```

You copy the `## The Prompt` block into your tool. You keep the rest as the engineering record.

---

## What's in the box

```
prompt-architect/
├── README.md                              ← this file
├── LICENSE                                ← Apache 2.0
├── .claude-plugin/
│   └── marketplace.json                   ← plugin manifest
└── skills/
    └── prompt-architect/
        ├── SKILL.md                       ← workflow, canvas, technique table, checklist
        └── references/
            ├── canvas.md                  ← slot-by-slot guidance, house rules, pitfalls
            └── examples.md                ← five worked examples (one per technique)
```

---

## Bibliography

This skill is grounded in five articles from martinfowler.com. If you change the skill, read these first:

- **Structured Prompt-Driven Development (SPDD)** — Wei Zhang & Jessie Jie Xia. Source of the REASONS Canvas and the prompts-as-artifacts framing.
- **Emerging Patterns in Building GenAI Products** — Martin Fowler & Bharani Subramaniam. Source of the Evals and Guardrails patterns embedded in the quality checklist.
- **Engineering Practices for LLM Application Development** — David Tan, Jessie Xia et al. Source of the testing and adversarial-input discipline.
- **Patterns for Reducing Friction in AI-Assisted Development**. Source of the five house rules: priming, design-first, codified commands, anchored documentation, harvested learnings.
- **Building Boba** — Martin Fowler. Source of the orchestrated-prompt mindset.

---

## Versioning

Major.minor only.

- **Major** bump = breaking change to output format or technique table.
- **Minor** bump = additive Norms, Safeguards, or Entities updates; new worked examples; new technique row.

See `skills/prompt-architect/references/canvas.md` for the maintenance lifecycle in full.

---

## Contributing

Issues and PRs welcome. Two specific things that move the needle:

1. **New worked examples** — especially for techniques the current set under-represents (RAG templates, meta-prompting).
2. **Harvested failure modes** — if a prompt produced by this skill failed in production, open an issue with the canvas slot that needed strengthening. Those become new lines in `Common pitfalls` or `Safeguards`.

---

## License

Apache-2.0. See [LICENSE](./LICENSE).
