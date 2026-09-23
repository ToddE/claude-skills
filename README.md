# Claude Skills

A collection of skills for [Claude AI](https://claude.ai). Each one adds a specific workflow, and Claude triggers it automatically once your message matches its description.

**[Get started in claude.ai &rarr;](https://claude.ai/new?q=I%20have%20a%20product%20idea%20and%20want%20to%20work%20through%20the%20full%20planning%20flow%20from%20the%20Claude%20Skills%20repo%20%28https%3A//github.com/ToddE/claude-skills%29%20in%20this%20chat%2C%20fetching%20each%20skill%27s%20SKILL.md%20from%20raw.githubusercontent.com%20as%20we%20reach%20that%20stage.%20All%20six%20pipeline%20skills%20live%20under%20product-management/skills/%3Cname%3E/SKILL.md%20in%20that%20repo.%20Start%20by%20fetching%20https%3A//raw.githubusercontent.com/ToddE/claude-skills/main/product-management/skills/working-backwards-prfaq/SKILL.md%20and%20follow%20it%20to%20help%20me%20write%20a%20Working%20Backwards%20PR/FAQ.%20Once%20that%27s%20done%2C%20offer%20to%20continue%20into%20use%20case%20discovery%20%28product-management/skills/use-case-discovery/SKILL.md%29%2C%20writing%20each%20use%20case%20%28product-management/skills/use-case-uml/SKILL.md%29%2C%20test%20cases%20%28product-management/skills/use-case-test-cases/SKILL.md%29%2C%20and%20functional%20requirements%20%28product-management/skills/use-case-requirements/SKILL.md%29%2C%20fetching%20each%20one%20from%20that%20repo%20when%20we%20get%20there.%20Start%20with%20your%20first%20question%20for%20the%20PR/FAQ.)** opens a new claude.ai chat pre-loaded with the whole planning flow. It requires a plan with web fetching enabled; see Option 0 below if it doesn't work.

*This README follows the Clean Style skill below.*

## Skills at a Glance

| Skill / Plugin | What it does | Suggested model |
| --- | --- | --- |
| [Clean Style](#clean-style) | Applies a strict anti-AI-slop checklist to external-facing prose. The baseline every other skill's output defers to. | Sonnet 5, medium |
| [Product Management Pipeline](product-management/README.md) (plugin, 6 skills) | Working Backwards PR/FAQ &rarr; Use Case Discovery &rarr; Use Case UML &rarr; {Test Cases, Requirements} &rarr; Architect Review. Full detail, triggers, and example prompts for each: [product-management/README.md](product-management/README.md). | Varies per skill; see that file |

## How to Use These Skills

This repo holds two kinds of things: Clean Style, a general-purpose writing skill, and a
product-management pipeline (Working Backwards PR/FAQ through Architect Review) bundled
together as one plugin, since those six skills hand off to each other across an
initiative's lifecycle rather than working alone. Each of the six is also packaged
individually as a `.skill` file and attached to [GitHub Releases](https://github.com/ToddE/claude-skills/releases)
if you only want one. If you want to try one before committing to it, start with Option 0.
For persistent use, pick from Options 1-4.

### Option 0: Try it for one session, no install

This repo is public. Give Claude a skill's `SKILL.md` URL, either paste it or ask Claude to fetch it, and ask it to follow those instructions for the conversation. This works in claude.ai chat and in Claude Code, as long as the surface can fetch the URL or you paste the file's contents directly.

This works well to kick the tires. Nothing persists between sessions, and it won't trigger automatically on a later message the way an installed skill does. Once you know you want a skill, install it with one of the options below.

### Option 1: Add the plugin marketplace (Claude Code)

```
/plugin marketplace add ToddE/claude-skills
/plugin install product-management
/plugin install clean-style
```

Installs straight from this repo; no download step, and updates whenever this repo does. Skills inside the `product-management` plugin are namespaced (e.g. `/product-management:working-backwards-prfaq`) but still trigger automatically from a matching request the same as any standalone skill.

**In VS Code or VSCodium**, plugin install is a graphical dialog (`/plugins` in the chat panel) rather than typed commands; see [product-management/README.md](product-management/README.md#in-vs-code-or-vscodium) for the exact steps, including VSCodium's Open VSX install path for the extension itself.

### Option 2: Install from file (any Claude Code host)

1. Download the `.skill` file for the skill you want. Clean Style's link is below; the six Product Management Pipeline skills' links are in [product-management/README.md](product-management/README.md). Both always point to the latest release.
2. Open Claude Code settings and go to **Skills**.
3. Click **Install from file** and select the `.skill` file, or drag and drop it.

### Option 3: Drop the folder into `.claude/skills`

These skills are all plain folders too: `SKILL.md`, a `references/` directory, and a `LICENSE` file. Skip the `.skill` packaging and use the folder directly. Clean Style lives at the repo root (`clean-style/`); the other six live under `product-management/skills/<skill-name>/`.

- **Project-level** (scoped to one repo): clone this repo, then copy the folder you want into `<your-project>/.claude/skills/<skill-name>/`.
- **User-level** (available in every Claude Code session on your machine): copy the folder into `~/.claude/skills/<skill-name>/`.

Claude Code picks up either location automatically. There's no install step and no restart. This is the fastest option if you plan to edit the skill for your own use, like custom actor names or a different export format, since you're working directly against the source folder.

After install, the skill activates automatically when your message matches its trigger conditions. No slash command needed. You can also invoke a skill directly by describing what you want in its own terms, like "let's do a PR/FAQ" or "write a use case for...".

### Option 4: Use the content as a rule instead of a skill

A skill is a triggered, multi-step workflow: interview, draft, handoff. A rule is a standing constraint with no trigger of its own; it loads every time. Not everything here needs the full skill treatment. The Clean Style skill below is a standing style constraint. Most people should install it as a rule instead.

To use content this way:
- **Project-level**: paste the relevant section into your project's `CLAUDE.md`.
- **User-level**: save it as its own file under `~/.claude/rules/`, like `~/.claude/rules/writing-style.md`. Any `.md` file there loads into every session automatically. The Clean Style skill's `references/rules.md` file is written to drop in as-is.

One question decides which fits: would you say "do this when I ask for X," or "always write like this"? The first is a skill. The second is a rule.

## Available Skills

### Clean Style

[Download (.skill)](https://github.com/ToddE/claude-skills/releases/latest/download/clean-style.skill)

A strict anti-AI-slop checklist applied to any external-facing prose, and the shared baseline every other skill's output defers to. Works as a triggered skill or, better for most people, as an always-on rule (see Option 4 above). Developed independently of, and before, [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop). The two converge on nearly the same guidance.

**Triggers when you mention:** drafting anything external-facing (emails, customer-facing docs, decks, blog posts), or ask to "clean this up," "make this sound less like AI wrote it," or "tighten this."

**What it does:**
- Applies the checklist while drafting, not as a bolted-on proofread pass
- Cuts em-dashes, hedging, contrastive constructions, filler transitions, and passive/inanimate-subject sentences
- Fixes violations directly rather than just flagging them
- Defers to another skill's own writing rules when that skill already governs the output (e.g. Working Backwards PR/FAQ, in the [Product Management Pipeline](product-management/README.md))

**Example prompts:**
- "Clean this email up so it doesn't sound like AI wrote it"
- "Tighten this customer-facing doc"
- "Rewrite this blog post draft to read naturally"

### Product Management Pipeline (plugin, 6 skills)

Working Backwards PR/FAQ &rarr; Use Case Discovery &rarr; Use Case UML &rarr; {Use Case Test Cases, Use Case Requirements} &rarr; Architect Review. Six skills covering an initiative's lifecycle from a rough idea through a structured architecture recommendation, bundled as one plugin since they hand off to each other. Each is also available as its own `.skill` file or folder if you only want one.

Full detail for each skill, triggers, example prompts, and the pipeline diagram: **[product-management/README.md](product-management/README.md)**. See it run end to end with real, saved example runs in [product-management/test/output/](product-management/test/output/), or watch one play back turn by turn on the [GitHub Pages site](https://todde.github.io/claude-skills/examples.html).

## License

This work is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

You are free to use, adapt, and redistribute these skills, including for commercial purposes, provided you give appropriate credit:

> Skills by Todd Emerson: [github.com/ToddE/claude-skills](https://github.com/ToddE/claude-skills)
