# Claude Skills

A collection of skills for [Claude AI](https://claude.ai). Each one adds a specific workflow, and Claude triggers it automatically once your message matches its description.

**[Get started in claude.ai &rarr;](https://claude.ai/new?q=I%20have%20a%20product%20idea%20and%20want%20to%20work%20through%20the%20full%20planning%20flow%20from%20the%20Claude%20Skills%20repo%20%28https%3A//github.com/ToddE/claude-skills%29%20in%20this%20chat%2C%20fetching%20each%20skill%27s%20SKILL.md%20from%20raw.githubusercontent.com%20as%20we%20reach%20that%20stage.%20Start%20by%20fetching%20https%3A//raw.githubusercontent.com/ToddE/claude-skills/main/working-backwards-prfaq/SKILL.md%20and%20follow%20it%20to%20help%20me%20write%20a%20Working%20Backwards%20PR/FAQ.%20Once%20that%27s%20done%2C%20offer%20to%20continue%20into%20use%20case%20discovery%20%28use-case-discovery/SKILL.md%29%2C%20writing%20each%20use%20case%20%28use-case-uml/SKILL.md%29%2C%20test%20cases%20%28use-case-test-cases/SKILL.md%29%2C%20and%20functional%20requirements%20%28use-case-requirements/SKILL.md%29%2C%20fetching%20each%20one%20from%20that%20repo%20when%20we%20get%20there.%20Start%20with%20your%20first%20question%20for%20the%20PR/FAQ.)** opens a new claude.ai chat pre-loaded with the whole planning flow. It requires a plan with web fetching enabled; see Option 0 below if it doesn't work.

*This README follows the Clean Style skill below.*

## Skills at a Glance

| Skill | What it does | Suggested model |
| --- | --- | --- |
| [Clean Style](#clean-style) | Applies a strict anti-AI-slop checklist to external-facing prose. The baseline every other skill's output defers to. | Sonnet 5, medium |
| [Working Backwards PR/FAQ](#working-backwards-prfaq) | Generates Amazon-style PR/FAQ documents for a new product or initiative. The natural starting point for a new idea. | Sonnet 5, medium-high (the Internal FAQ's business judgment benefits from the extra effort) |
| [Use Case Discovery](#use-case-discovery) | Breaks a high-level feature into a candidate list of use cases. | Sonnet 5, medium |
| [Use Case UML](#use-case-uml) | Writes a use case in a fixed, repeatable format. | Sonnet 5, medium (low is often enough once the flow is already clear) |
| [Use Case Test Cases](#use-case-test-cases) | Generates test cases from a use case's paths and post-conditions. | Sonnet 5, low-medium (mostly mechanical extraction) |
| [Use Case Requirements](#use-case-requirements) | Derives trackable requirements from a use case, or from a short interview when no use case exists yet, and exports them to CSV or GitHub Issues. | Sonnet 5, medium (mode A is mostly extraction; mode B's interview benefits from more) |
| [Architect Review](#architect-review) | Gives a structured architectural recommendation from a specific Sr. Architect persona's point of view, using whatever pipeline artifacts exist. | Sonnet 5, high (the most synthesis-heavy skill here) |

## How to Use These Skills

Skills are packaged as `.skill` files and attached to [GitHub Releases](https://github.com/ToddE/claude-skills/releases). If you want to try one before committing to it, start with Option 0. For persistent use, pick from Options 1-3.

### Option 0: Try it for one session, no install

This repo is public. Give Claude a skill's `SKILL.md` URL, either paste it or ask Claude to fetch it, and ask it to follow those instructions for the conversation. This works in claude.ai chat and in Claude Code, as long as the surface can fetch the URL or you paste the file's contents directly.

This works well to kick the tires. Nothing persists between sessions, and it won't trigger automatically on a later message the way an installed skill does. Once you know you want a skill, install it with one of the options below.

### Option 1: Install from file (any Claude Code host)

1. Download the `.skill` file for the skill you want. The links in the table above and the sections below always point to the latest release.
2. Open Claude Code settings and go to **Skills**.
3. Click **Install from file** and select the `.skill` file, or drag and drop it.

### Option 2: Drop the folder into `.claude/skills`

These skills are all plain folders too: `SKILL.md`, a `references/` directory, and a `LICENSE` file. Skip the `.skill` packaging and use the folder directly.

- **Project-level** (scoped to one repo): clone this repo, then copy the folder you want into `<your-project>/.claude/skills/<skill-name>/`.
- **User-level** (available in every Claude Code session on your machine): copy the folder into `~/.claude/skills/<skill-name>/`.

Claude Code picks up either location automatically. There's no install step and no restart. This is the fastest option if you plan to edit the skill for your own use, like custom actor names or a different export format, since you're working directly against the source folder.

After install, the skill activates automatically when your message matches its trigger conditions. No slash command needed. You can also invoke a skill directly by describing what you want in its own terms, like "let's do a PR/FAQ" or "write a use case for...".

### Option 3: Use the content as a rule instead of a skill

A skill is a triggered, multi-step workflow: interview, draft, handoff. A rule is a standing constraint with no trigger of its own; it loads every time. Not everything here needs the full skill treatment. The Clean Style skill below is a standing style constraint. Most people should install it as a rule instead.

To use content this way:
- **Project-level**: paste the relevant section into your project's `CLAUDE.md`.
- **User-level**: save it as its own file under `~/.claude/rules/`, like `~/.claude/rules/writing-style.md`. Any `.md` file there loads into every session automatically. The Clean Style skill's `references/rules.md` file is written to drop in as-is.

One question decides which fits: would you say "do this when I ask for X," or "always write like this"? The first is a skill. The second is a rule.

## Available Skills

### Clean Style

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/clean-style.skill)

A strict anti-AI-slop checklist applied to any external-facing prose, and the shared baseline every other skill's output defers to. Works as a triggered skill or, better for most people, as an always-on rule (see Option 3 above). Developed independently of, and before, [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop). The two converge on nearly the same guidance.

**Triggers when you mention:** drafting anything external-facing (emails, customer-facing docs, decks, blog posts), or ask to "clean this up," "make this sound less like AI wrote it," or "tighten this."

**What it does:**
- Applies the checklist while drafting, not as a bolted-on proofread pass
- Cuts em-dashes, hedging, contrastive constructions, filler transitions, and passive/inanimate-subject sentences
- Fixes violations directly rather than just flagging them
- Defers to another skill's own writing rules when that skill already governs the output (e.g. Working Backwards PR/FAQ below)

**Example prompts:**
- "Clean this email up so it doesn't sound like AI wrote it"
- "Tighten this customer-facing doc"
- "Rewrite this blog post draft to read naturally"

### Working Backwards PR/FAQ

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/working-backwards-prfaq.skill) · **Using Gemini?** [Try this similar Gemini Gem](https://gemini.google.com/gem/1STzL1kLVqmZ1-UugsA_6QYbRAQNiKQYw?usp=sharing)

Generates Amazon-style Working Backwards PR/FAQ documents for new products, partnerships, or initiatives.

**Triggers when you mention:** PR/FAQ, press release FAQ, Working Backwards, product announcement draft, launch announcement, product vision document, or narrative product proposal in the Amazon style.

**What it does:**
- Interviews you for context before generating anything
- Produces a full PR/FAQ with press release, stakeholder quotes, external FAQ, and internal FAQ
- Follows Amazon's Working Backwards methodology: write the press release before you build the product
- Enforces strict writing rules (no jargon, no hyperbole, customer-centric framing)
- Covers internal rigor: market size, unit economics, risks, success metrics, and business case

**Example prompts:**
- "I want to write a PR/FAQ for a new developer tool we're launching"
- "Help me do a Working Backwards document for this partnership"
- "Draft a press release FAQ for our Q3 product initiative"

### Use Case Discovery

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/use-case-discovery.skill)

Interviews you about a feature or initiative at a high level and decomposes it into a candidate list of use cases before any of them get fully written up. Feeds into the Use Case UML skill below.

**Triggers when you mention:** figuring out what use cases you need, breaking a feature down, or scoping out use cases before writing them.

**What it does:**
- Gathers the initiative's goals, rough actors, and explicit out-of-scope items
- Decomposes the initiative into a candidate list (Name, Summary, Rough Actors, Rough Trigger) at the same granularity use-case-uml expects
- Flags likely merge/split candidates and actor-naming inconsistencies before drafting starts
- Hands off confirmed candidates to Use Case UML, carrying forward the Name/Summary/Actors so its interview can focus on the flow itself

**Example prompts:**
- "What use cases do we need for this feature?"
- "Help me break this initiative down into use cases"
- "Scope out the use cases before we write them"

### Use Case UML

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/use-case-uml.skill)

Writes integration and user-flow use cases (actors, basic path, alternate paths, exception paths) in one fixed, repeatable format.

**Triggers when you mention:** use case, integration use case, user flow, or documenting a system/actor interaction with a basic path plus alternate and exception branches.

**What it does:**
- Gathers assumptions, actors, trigger, and the happy path before drafting
- Produces Assumptions, Actors, Trigger(s), Basic Path (table), Alternate Paths, Exception Paths, Post-Condition(s), and Open Issues/Notes, in that exact order
- Keeps actor names and cross-links consistent across multiple use cases in the same document
- Uses `TBD` for failure modes that are known but not yet worked out, instead of skipping them

**Example prompts:**
- "Write a use case for how a new device gets linked to a user account"
- "Add an alternate path to this use case for when the webhook fails"
- "Document the integration flow between our app and [PARTNER_NAME]'s API"

### Use Case Test Cases

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/use-case-test-cases.skill)

Generates test cases directly from a Use Case UML document: one per Basic Path, Alternate Path, and Exception Path, with expected results pulled from the use case's Post-Condition(s). Pairs with the Use Case UML skill above.

**Triggers when you mention:** writing test cases, generating tests, or turning a use case into test cases.

**What it does:**
- Reads a completed use case (Basic Path, Alternate Paths, Exception Paths, Post-Condition(s))
- Produces one test case per path with a Test Case ID, Preconditions, Steps, and an Expected Result traced directly back to the use case's Post-Condition(s), never invented
- Flags it, and refuses to guess, if the source use case's Post-Condition(s) aren't written as checkable states yet

**Example prompts:**
- "Write test cases for this use case"
- "Generate tests from the Chef Input use case"
- "Turn the alternate and exception paths into test cases too"

### Use Case Requirements

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/use-case-requirements.skill)

Derives trackable functional requirements two ways: from a completed Use Case UML document, or from a short interview when no use case exists yet. It traces each requirement to a specific source, a Basic Path step, an Alternate/Exception Path, a Post-Condition, or an interview answer, and exports the list as a generic CSV (Jira-importable) or GitHub Issues-ready markdown.

**Triggers when you mention:** turning a use case into requirements, generating functional requirements, creating issues from a use case, exporting to Jira/GitHub, or wanting requirements for something that has no use case yet.

**What it does:**
- From a use case: derives one requirement per distinct system behavior, each citing the exact Basic/Alternate/Exception Path step(s) it came from
- Without a use case: runs a short interview modeled on Working Backwards PR/FAQ's intake, then derives requirements from the answers instead of asking you to write a use case first
- Reuses a use case's Post-Condition(s) wording directly as Acceptance Criteria where they map; asks you directly for it in interview mode instead of inventing one
- Refuses to guess Priority or invent tracker-specific fields (epic key, sprint) it wasn't given
- Exports a Jira-importable CSV and/or GitHub Issues markdown blocks ready for `gh issue create`

**Example prompts:**
- "Turn this use case into functional requirements"
- "Generate issues from the Client Update use case for GitHub"
- "I have an idea for a feature, no use case yet, help me turn it into requirements"

### Architect Review

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/architect-review.skill)

Gives a structured architectural recommendation from a specific Sr. Architect persona's point of view, using whatever pipeline artifacts exist: PR/FAQ, use cases, requirements, or just a description. Ships with two personas: The Pragmatic Modulith Architect (modulith-first, contract-first APIs, privacy and compliance by design, cost-conscious infrastructure), and The Assembler (buys over builds, composes best-in-class vendor services, treats velocity as the primary risk to manage). Built to hold more.

**Triggers when you mention:** wanting an architecture review, a technical recommendation, "how should we build this," or a specific persona's take (e.g. "what would the Pragmatic Modulith Architect say" or "what would the Assembler do").

**What it does:**
- Reads whatever's available in the pipeline; works with a partial set or just a description if that's all there is
- Applies a persona's actual philosophy and tradeoff-handling pattern, not just its preferred tech stack
- Produces a fixed-format recommendation: Recommended Approach, Key Tradeoffs, Risks/Open Questions, Alternatives Considered
- Traces every recommendation back to an input artifact or the persona's stated philosophy; flags anything it had to ask about instead of guessing
- Can run two personas against the same input, each producing its own separate recommendation, so you can compare two different approaches, not the same advice in a different voice
- Can run an opt-in debate between two personas on request, grounded in a short product-manager intake (budget, operational appetite, failure visibility, risk tolerance, timeline), ending in a "take this approach if..." rule for each

**Example prompts:**
- "Give me an architecture review of this"
- "What would the Pragmatic Modulith Architect say about this approach"
- "Have the Pragmatic Modulith Architect and the Assembler debate this one"

## License

This work is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

You are free to use, adapt, and redistribute these skills, including for commercial purposes, provided you give appropriate credit:

> Skills by Todd Emerson: [github.com/ToddE/claude-skills](https://github.com/ToddE/claude-skills)
