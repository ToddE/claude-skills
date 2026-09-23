# Architect Debate: DispatchIQ

**Personas**: The Pragmatic Modulith Architect, The Assembler

**Grounding** (product-manager intake): Budget is tight, pre-revenue, roughly six months of runway, loosening if the pilot hits the PR/FAQ's MRR target. The team is the founder plus one contractor engineer, who don't want to be paged. Failure visibility today is effectively zero, nobody finds out until a customer emails support the next morning. The team is more worried about their own system breaking silently than about being locked into a vendor. The paid pilot has to ship this quarter; the funding conversation depends on having pilot data to show.

## Opening Positions

**The Pragmatic Modulith Architect**: The team said their own system breaking silently hurts more than vendor lock-in, and today there's zero failure visibility. The priority is knowing immediately when SMS delivery fails, not minimizing how many vendors are involved. A modulith with one deployable, one error tracker, and an alert rule specifically for SMS failures gets that in place fastest, without taking on four separate vendor integrations for a two-person team already worried about being paged.

**The Assembler**: The team said they don't want to be paged and has a contractor engineer, not a full team, so minimizing what they have to build and operate matters as much as minimizing what breaks. An SMS provider's own delivery-status webhook is a faster, more reliable failure signal than anything a two-person team builds and maintains themselves against a six-month runway clock, and the pilot has to ship this quarter for the funding conversation, not after weeks on custom retry logic.

## Challenge

**The Assembler, to the Pragmatic Modulith Architect**: You're proposing custom SMS retry logic with a generic error tracker's alert rule attached for SMS specifically. But the team said their own system breaking silently is the worst outcome, and homegrown retry-and-alert logic is exactly what a two-person team can get subtly wrong under time pressure; a missed edge case in that alert rule is a second silent failure layered on top of the first one you're trying to fix.

**The Pragmatic Modulith Architect, to The Assembler**: You're calling four vendor dependencies, platform, backend-as-a-service, distance API, SMS provider, a way to reduce operational surface. But the team said they want to minimize what they have to run, and four integration points, each with its own webhook shape and failure mode, is more surface to reason about during an incident, not less, especially for a contractor engineer who didn't build all four personally.

## Response

**The Pragmatic Modulith Architect**: Fair, and it sharpens the recommendation: the SMS-failure alert rule needs to be tested explicitly during the pilot, not just written and assumed correct, precisely because a missed edge case would be the exact silent failure the team fears most. That's a specific pilot-readiness checklist item, not a reason to abandon owning the stack.

**The Assembler**: Also fair, and the fix isn't fewer vendors, it's fewer places the team has to look during an incident: wire all four vendors' alerts into the same Slack channel this approach already uses. The number of dependencies doesn't multiply the number of places someone checks at 2am, even though it does multiply the number of things that could individually fail.

## Take This Approach If...

**The Pragmatic Modulith Architect's approach fits if**: the founder and contractor engineer are willing to own and explicitly test the SMS failure-alerting logic themselves before the pilot starts, and value having one system to reason about over the build time four vendor integrations would cost them this quarter.

**The Assembler's approach fits if**: shipping the pilot this quarter matters more than owning the routing and notification logic outright, and the team is willing to take on four vendor dependencies as long as every one of them lands in the same Slack channel, so an incident is still one place to look, not four.
