# Claude Skills

A collection of skills for [Claude AI](https://claude.ai). Skills extend Claude with specialized workflows that trigger automatically based on context.

## Available Skills

### [working-backwards-prfaq](working-backwards-prfaq/) | <span style="font-size: 0.8em; color: red;">[Download Skill File](/working-backwards-prfaq.skill)</span>

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

## How to Use These Skills with Claude Code

Skills are packaged as `.skill` files. To install a skill:

1. Open Claude Code settings
2. Navigate to **Skills**
3. Click **Install from file** and select the `.skill` file, or drag and drop it

Once installed, the skill activates automatically when your message matches its trigger conditions — no slash command needed.

You can also invoke a skill explicitly by describing what you want in terms the skill understands (e.g., "let's do a PR/FAQ").


## License

This work is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

You are free to use, adapt, and redistribute these skills — including commercially — provided you give appropriate credit:

> Skills by Todd Emerson — [github.com/toddemerson/claude-skills](https://github.com/toddemerson/claude-skills)

CC BY 4.0 is recommended for skills (which are primarily instructional prompts and documentation rather than executable code) because it has explicit, widely understood attribution requirements. If you incorporate a skill into a software project, MIT is also acceptable — just preserve the copyright notice.
