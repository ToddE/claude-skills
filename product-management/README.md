# Product Management Pipeline (Claude Code plugin)

Six skills covering an initiative's lifecycle end to end: from a rough idea, through a
Working Backwards PR/FAQ, broken into use cases, written up in full, turned into test cases
and trackable requirements, and finally into a persona-driven architecture recommendation.
They're bundled as one plugin because they hand off to each other; installing one without
the others still works, but the value is in the chain.

See the [repo root README](../README.md) for the other skill here (Clean Style) and the
general install options. This file covers what's specific to this plugin.

## Install

### In a terminal (Claude Code CLI)

```
/plugin marketplace add ToddE/claude-skills
/plugin install product-management
```

Skills inside the plugin are namespaced, e.g. `/product-management:working-backwards-prfaq`,
but still trigger automatically from a matching request the same as any standalone skill;
the namespace only matters if you want to invoke one by name directly.

> **Name collision risk**: "working-backwards-prfaq" isn't a unique skill name. A live test
> found that in a session where another skill of the same name is also installed (in that
> test, a personal custom skill synced to that account, unrelated to this repo), calling
> the bare name (`Skill(skill: "working-backwards-prfaq")`) silently ran the other one, with
> no error and no indication a different implementation answered. Only the fully-qualified
> name (`product-management:working-backwards-prfaq`) is guaranteed to run this repo's
> version, and fails cleanly with `Unknown skill` if it isn't installed. If you have another
> skill by this name in your account (custom or from another plugin), invoke this one by
> its qualified name to be sure which one runs. See
> `test/output/2026-09-22-classpods-cold-run/README.md` for the full writeup.

**Testing a local checkout before it's pushed**, or working on the skills themselves: point
the marketplace at your local path instead of the GitHub repo:

```
/plugin marketplace add /path/to/your/claude-skills
/plugin install product-management
```

Claude Code re-reads the local path each time, so edits to `SKILL.md` or `references/`
files take effect without reinstalling.

### In VS Code or VSCodium

Install the Claude Code extension first: from the VS Code Marketplace in VS Code, or from
[Open VSX](https://open-vsx.org/extension/Anthropic/claude-code) in VSCodium and other VS
Code forks (this is Anthropic's documented, supported path for forks, not a workaround).

Once installed, type `/plugins` in the chat panel to open **Manage plugins**:
1. **Marketplaces** tab &rarr; add a marketplace &rarr; enter `ToddE/claude-skills` (or a
   local path if you're working from a checkout).
2. **Plugins** tab &rarr; find `product-management` (and `clean-style` separately, since
   it's a different plugin in the same marketplace) &rarr; **Install**.

This is a graphical dialog, not the typed `/plugin marketplace add` command; the extension
exposes plugin management this way instead. Once installed, skills trigger automatically
from a matching request exactly as they do in the terminal.

Two extension limitations worth knowing about here: the `!` bash-shortcut and tab
completion in prompts aren't supported inside the extension, and only a subset of CLI
commands are available (type `/` to see what's exposed in your version). Neither affects
how these skills trigger or run once installed.

**Per-skill installs** (skip the plugin, install just one): each skill is also packaged as
its own `.skill` file and a plain folder, exactly like Clean Style. See the root README's
"How to Use These Skills" for Options 0-4 (fetch-once, plugin, `.skill` file, folder-drop,
or rule). The folder path for these six is `product-management/skills/<skill-name>/`, not
the repo root.

## The pipeline

```
Working Backwards PR/FAQ
        |
        v
Use Case Discovery  (scope: what use cases does this need?)
        |
        v
Use Case UML  (write each one out in full)
       / \
      v   v
Test Cases   Requirements  (CSV / GitHub Issues)
        |
        v
Architect Review  (persona recommendation, optional debate between two)
```

Each stage works standalone; none of them require you to have run the one before. A skill
only ever *offers* to hand off to the next one, checking first whether that skill is
actually available in your current session, and pointing you at this repo to install it if
it isn't. Partial input is fine everywhere downstream: Architect Review will run off just a
one-line description if that's all that exists yet, and say plainly that the
recommendation is less grounded as a result.

## The skills

### Working Backwards PR/FAQ

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/working-backwards-prfaq.skill) · **Using Gemini?** [Try this similar Gemini Gem](https://gemini.google.com/gem/1STzL1kLVqmZ1-UugsA_6QYbRAQNiKQYw?usp=sharing)

Generates Amazon-style Working Backwards PR/FAQ documents for new products, partnerships, or initiatives.

**Triggers when you mention:** PR/FAQ, press release FAQ, Working Backwards, product announcement draft, launch announcement, product vision document, or narrative product proposal in the Amazon style.

**What it does:**
- Interviews you for context before generating anything
- Produces a full PR/FAQ with press release, stakeholder quotes, external FAQ, and internal FAQ
- Follows Amazon's Working Backwards methodology: write the press release before you build the product
- Defers to the Clean Style skill for general prose quality, keeping only PR/FAQ-specific structural rules (tense, word limits, "the customer" framing) of its own
- Covers internal rigor: market size, unit economics, risks, success metrics, and business case

**Example prompts:**
- "I want to write a PR/FAQ for a new developer tool we're launching"
- "Help me do a Working Backwards document for this partnership"
- "Draft a press release FAQ for our Q3 product initiative"

### Use Case Discovery

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/use-case-discovery.skill)

Interviews you about a feature or initiative at a high level and decomposes it into a candidate list of use cases before any of them get fully written up. Feeds into Use Case UML below.

**Triggers when you mention:** figuring out what use cases you need, breaking a feature down, or scoping out use cases before writing them.

**What it does:**
- Gathers the initiative's goals, rough actors, and explicit out-of-scope items
- Decomposes the initiative into a candidate list (Name, Summary, Rough Actors, Rough Trigger) at the same granularity Use Case UML expects
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

Generates test cases directly from a Use Case UML document: one per Basic Path, Alternate Path, and Exception Path, with expected results pulled from the use case's Post-Condition(s). Pairs with Use Case UML above.

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
- From a use case: derives one requirement per distinct system behavior, splitting on owning component and on distinct effects (calculate, decide, persist, notify), each citing the exact Basic/Alternate/Exception Path step(s) it came from
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

## See it run end to end

`test/output/` has full pipeline runs kept in the repo as reviewable evidence, each
including the actual intake dialogue, not just the final documents: a meta run (Claude
Skills announcing itself), a non-commercial city-department program (PlotShare), a
for-profit small-business tool (DispatchIQ), a physical-manufacturing run (Continental
Circuits), a physical-retail RFID run that reuses this repo's own historical worked-example
use case as real content (Ebisu Kaiten IQ), and a cold run that deliberately didn't invoke
every skill directly, to test whether each one offers its own handoff unprompted (it
surfaced a real skill-naming collision instead; see that run's README).
`test/GENERATE-EXAMPLE.md` documents the repeatable process behind these, for generating a
new one.

**[Watch one play back &rarr;](../examples.html)** — the root of this repo's GitHub Pages
site has a page that replays a run's dialogue turn by turn, or jumps straight to what it
produced.

## License

MIT. See [LICENSE](LICENSE). (The rest of this repo, outside this plugin, remains CC BY 4.0; see [../LICENSE](../LICENSE).)
