# Canvas, House Rules, Pitfalls, and Maintenance

## Slot-by-slot guidance

### R — Requirements
What outcome does this prompt need to produce? Who is the audience of the output? What does success look like in concrete, observable terms? Replace vague verbs ("help with", "improve") with verbs that have testable outputs: "classify", "extract", "summarize in N sentences", "rewrite at reading level X".

When R has two or more distinct success criteria, number them as **AC1, AC2, AC3** (Acceptance Criteria). Reference them from O steps and S lines as `(AC1)` or `(AC1, AC3)` to force traceability. Single-goal prompts skip numbering.

Example (multi-goal): `AC1: output is valid JSON; AC2: all input dates appear in output; AC3: no PII in output.`

### E — Entities
The domain vocabulary the model must use correctly. List key nouns, jargon, named concepts, and any term where the wrong synonym would be a defect. This is **priming**: building shared vocabulary so the model is not guessing what your words mean.

### A — Approach
Which technique fits this task, and why? Pick one from the technique selector in SKILL.md. State the choice and a one-line reason. If the task is hybrid (e.g., extraction + reasoning), say so and pick the dominant technique.

### S — Structure
The shape of input and output. Specify:
- Input schema (what the caller passes in, including any `{{placeholders}}`)
- Output schema (JSON, markdown sections, plain prose, table, etc.)
- Field-level constraints (lengths, enums, required vs. optional)

For **ReAct / Tool-use** prompts, the Structure slot must also define tool schemas (name, parameters, return type). For **prompt chaining**, the output schema here *is* the input schema for the next step — document it as the interface contract explicitly.

If the output will be parsed by code, use machine-readable formats (JSON, fenced code blocks) over prose.

### O — Operations
The steps the model should execute internally to go from input to output. Write steps explicitly even in zero-shot — doing so surfaces ambiguity in Requirements.

For **chain-of-thought**, this section *is* the reasoning scaffold.
For **ReAct**, this section is an action loop: Reason → Act (tool call) → Observe → repeat until done or max_iterations reached.
For **self-critique**, this section must include three sequential phases: Draft → Critique → Revise. Skipping any phase breaks the technique.

When R uses numbered ACs, annotate each O step with the AC(s) it satisfies, e.g., "Step 4 — redact PII (AC3)."

### N — Norms
Tone, voice, persona, formatting conventions, length defaults, style choices. When a norm shows up in three or more prompts for the same project, lift it into a reusable Norms block — do not re-derive it each time (the **codified commands** pattern).

### S — Safeguards
Failure modes and guardrails. Structure as two sub-blocks:

**Prohibitions** — one "Do NOT" imperative per line. Imperative negation lands more reliably than soft prose.
- Do NOT generate output before reading the full input.
- Do NOT speculate beyond cited sources.
- Do NOT change field names or schema structure.

**Recovery** — positive imperatives for malformed input, refusals, and exact refusal wording.
- If input is empty, respond with: `"INPUT_REQUIRED"`.
- If asked off-topic, respond with: `"OUT_OF_SCOPE: ..."`.
- If a required field is missing, halt and request it before proceeding.

Include at least one Prohibition and one Recovery line. Privacy, safety, and compliance constraints belong in Prohibitions.

A prompt without explicit Safeguards is a prompt waiting to fail in production.

---

## House rules (apply by default)

1. **Priming** — every prompt declares its vocabulary up front (the Entities slot exists for this reason). Do not let the model guess what domain words mean.
2. **Design-first** — for non-trivial prompts, fill the canvas before writing prose. The canvas is the design; the final prompt is the implementation.
3. **Codified commands** — when a constraint appears in three or more prompts for the same project, lift it into a shared Norms block and reference it.
4. **Anchored documentation** — every prompt artifact carries a Header recording: who it serves, what it replaces, and one example that should pass. This is what makes the prompt reviewable next quarter.
5. **Harvested learnings** — when a prompt fails in production, capture the failure as a new Safeguard line. Prompts get stronger over time instead of forgetting their scars.

---

## Common pitfalls to flag back to the user

When reviewing an existing prompt, watch for these root causes of bad output:

- **No success criterion** — prompt says "help with X" instead of naming an observable output.
- **Buried instructions** — the most important constraint is in sentence eight of a paragraph; surface it as a section header.
- **Conflicting norms** — "be concise" and "explain your reasoning thoroughly" in the same prompt. Pick one or partition explicitly.
- **No failure path** — prompt assumes well-formed input. Real input is rarely well-formed.
- **Examples that disagree with instructions** — few-shot examples that subtly violate the rules stated in prose. The model follows examples over instructions; reconcile them.
- **Mixed output formats** — asking for JSON but with a "feel free to add commentary" clause. Pick one mode.

---

## Maintenance lifecycle

Ship the first draft only when the quality checklist passes. After that, when the prompt misbehaves in production, follow the Canvas-First Principle: fix the slot, not the prose.

**Issue-to-slot map:**

| Failure observed                           | Slot to edit        |
|--------------------------------------------|---------------------|
| Wrong outcome, vague goal, untestable      | R — Requirements    |
| Wrong/missing domain term in output        | E — Entities        |
| Wrong technique or reasoning shape         | A — Approach        |
| Output schema/format drift, fields missing | S — Structure       |
| Wrong step order, missing/skipped step     | O — Operations      |
| Wrong tone, length, persona, formatting    | N — Norms           |
| Model did forbidden thing, refused wrong   | S — Safeguards      |

**Iteration workflow:**

1. **Capture.** Record failing input, actual output, expected behavior.
2. **Classify.** Use the issue-to-slot map above to identify the slot.
3. **Edit canvas.** Fix the identified slot — not the prompt prose.
4. **Version.** Bump minor (additive) or major (breaking) and add a changelog entry.
5. **Re-derive prompt.** Regenerate the `## The Prompt` block from the updated canvas.
6. **Re-test.** Re-run Example pass and Example fail; add the captured failure as a new Example fail if it represents a recurring class.

**Versioning:** major.minor only. Major = breaking output format or technique change. Minor = additive Norms, Safeguards, or Entities update.

**Harvested learnings:** if a prompt has not been edited in six months and is still in production, audit it — that is suspicious, not impressive.
