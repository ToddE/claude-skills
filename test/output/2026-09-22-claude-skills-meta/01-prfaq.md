# Press Release

**Claude Skills Turns One Conversation Into a Full Product Planning Pipeline**
Product teams write a PR/FAQ, use cases, test cases, and trackable requirements without leaving their Claude session, and without retyping any of it between stages.

[CITY, STATE] -- January 12, 2027 -- Claude Skills, a collection of skills for Claude AI, is now available as a complete product planning pipeline. An idea becomes a PR/FAQ, a PR/FAQ becomes a set of use cases, and use cases become test cases and trackable requirements ready for Jira or GitHub Issues, all inside the same conversation.

Product teams that plan with Claude typically start over at every stage. A PR/FAQ drafted in one chat gets retyped by hand into use case docs in another tool. Use cases get summarized by hand into a requirements spreadsheet. Each handoff introduces inconsistency: a different format, missing traceability, and requirements nobody can trace back to the decision that produced them.

Claude Skills packages each planning stage as its own skill, triggered by what the user asks for. Working Backwards PR/FAQ interviews the user and produces a press release and FAQ in Amazon's format. Use Case Discovery breaks the resulting idea into a list of candidate use cases. Use Case UML writes each one in a fixed structure with a basic path, alternate paths, and exception paths. Use Case Test Cases and Use Case Requirements read that structure directly and generate test cases and functional requirements, each one citing the exact step it came from. Architect Review closes the loop with a structured build recommendation from a named architect persona. Every skill also works as a plain folder dropped straight into a Claude Code project, with no packaging step required.

"I kept rewriting the same plan three times in three different formats," said Todd Emerson, creator of Claude Skills. "Now I write it once, and every later stage already knows what came before it."

"I used to lose half a day turning a PR/FAQ into tickets," said a product manager at an early-stage startup who tested the pipeline. "Now the tickets already have acceptance criteria, and they trace straight back to the use case."

Claude Skills is available now at github.com/ToddE/claude-skills. Install a single skill from a downloaded file, drop the plain folder into a project, or try one for a single session with no install at all.

---

# Additional Quotes

"The use case format is strict enough that alternate paths and exception paths aren't optional afterthoughts anymore," said an engineering lead who tested the pipeline. "It changed how thorough our specs are before anyone writes code."

---

# FAQ

## External FAQ

**What is Claude Skills?**
A collection of skills for Claude AI covering writing rules, PR/FAQ documents, a use-case-to-requirements pipeline, and architecture recommendations.

**How much does it cost?**
Nothing. Claude Skills is released under a CC BY 4.0 license. Use, adapt, and redistribute it, including commercially, with attribution.

**How do I install it?**
Download a `.skill` file and install it from your Claude Code settings, or copy the plain folder into a project's or user's `.claude/skills/` directory.

**Does it work outside Claude Code?**
Yes. Paste a skill's file into claude.ai chat and ask Claude to follow it for that conversation. Nothing persists between sessions that way; installing it is what makes it trigger automatically later.

**What if I only want one skill, not the whole pipeline?**
Each skill works on its own. The pipeline is a convenience when several stages are used together, not a requirement.

## Internal FAQ

**What does adoption look like, since this isn't a paid product?**
Success is measured by use, not revenue: skills installed, pipeline runs completed end to end, and issues or pull requests from people extending it with their own personas or formats.

**What's the competitive landscape?**
General-purpose AI chat can produce any one of these documents on request, but produces a new format every time and carries nothing forward to the next stage. Claude Skills's advantage is the fixed format per stage and the traceability between stages, not the ability to generate any single document.

**What are the technical dependencies?**
None beyond a Claude Code or claude.ai session capable of loading a skill's instructions. Two skills (Working Backwards PR/FAQ, Use Case Requirements in interview mode) also expect a form tool for structured choices; both degrade to plain text questions without it.

**What are the top risks?**
Skills drift out of sync with each other as they're edited independently (a renamed persona or a changed section order in one skill can break a downstream skill's assumptions about its input). Mitigation: cross-file references get checked by hand after any structural change, and `TODO.md` tracks known gaps.

**What needs to be true for this to succeed?**
People need to actually run more than one skill in sequence, not just the one that matches their immediate ask, for the traceability benefit to show up. That depends on each skill's own "offer the next step" prompts actually getting followed.

**Timeline and investment required.**
Already built and available. Ongoing investment is maintenance time: keeping the six skills' cross-references consistent as any one of them changes, and refining personas and formats as they get used on real work.
