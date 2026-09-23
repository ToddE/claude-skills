# Architect Debate: Continental Circuits Chip Sourcing & Production System

**Personas**: The Pragmatic Modulith Architect, The Assembler

**Grounding** (product-manager intake): Budget is tight, but for a specific reason unlike a typical pre-revenue software company: capital already went into the Zanesville facility, line tooling, and initial chip inventory, so software spend is the smaller line item, not the whole budget. The team is a founder, a VP of Supply Chain, and a small engineering group who are also occupied standing up the physical line; nobody wants to own a second full-time workload. Failure visibility today: if a qualification or allocation bug let an unqualified chip's lot ship, nobody would know until a customer's procurement office asked for documentation, potentially after units are already installed in a school district or municipal building. The team is more worried about a vendor mishandling export-control-sensitive supplier documentation (fab locations, ECCNs) than about being locked into that vendor technically. The system needs to be live and trustworthy before the Q2 2027 pilot with three integrator design partners starts, since pilot data is what the PR/FAQ's success metrics depend on.

## Opening Positions

**The Pragmatic Modulith Architect**: Build one owned system with append-only qualification and AVL records, because the risk the team named, an unqualified chip shipping unnoticed, is a data-integrity failure, not a workflow-convenience problem. A vendor's document-collection workflow doesn't answer "can we prove this record wasn't altered after the fact," and that's the exact question a procurement office will eventually ask.

**The Assembler**: Use a supplier-quality-management platform for qualification and the AVL, because the team is already stretched thin standing up a physical factory, and document-collection-and-approval workflows are a solved problem a vendor does well. The team's stated fear is a vendor mishandling sensitive documents, not the workflow itself failing, so the fix is picking a vendor with the right access controls and contract terms, not building the workflow from scratch to avoid the vendor question entirely.

## Challenge

**The Assembler, to the Pragmatic Modulith Architect**: You're treating "build it ourselves" as the way to guarantee the audit trail is trustworthy, but the team is stretched between commissioning the physical line and building software. An append-only schema built and tested by a small team under pilot-launch time pressure can have the same "was this record actually protected" gap a rushed vendor evaluation would, except now it's your own bug, with less scrutiny on it than a vendor's SOC 2 audit would apply.

**The Pragmatic Modulith Architect, to The Assembler**: You're calling the vendor risk "picking the right access controls and contract terms," but the team's own stated fear is a vendor mishandling export-control-sensitive documents, which is a legal and reputational risk this specific business can't fully diligence by reading a contract. Fab-location and ECCN data leaving Continental Circuits' own systems at all is the exposure, not just which vendor holds it.

## Response

**The Pragmatic Modulith Architect**: Fair, and it sharpens the recommendation: the append-only schema and its query layer need to be tested explicitly against a "prove this wasn't altered" scenario before the pilot, not just written and assumed correct, precisely because a small team under time pressure is exactly who makes that kind of mistake. That's a specific pilot-readiness checklist item, not a reason to hand the data to a vendor instead.

**The Assembler**: Also fair, and the fix isn't "trust the vendor's contract and move on," it's narrowing what leaves the building in the first place: use the SQM platform for the parts of qualification that aren't export-control-sensitive (documentation-request workflow, approval routing, notification), and keep the actual fab-location and ECCN values in a small owned store the platform only references by ID. That's still buying the workflow, not building it, without putting the sensitive data itself in a vendor's hands.

## Take This Approach If...

**The Pragmatic Modulith Architect's approach fits if**: the engineering group can carve out dedicated time to build and specifically test the append-only qualification and AVL logic before the Q2 2027 pilot, and the team decides that keeping every part of this data in-house is worth that time even while the physical line is also being commissioned.

**The Assembler's approach fits if**: the team adopts the hybrid the Response above lands on, buying the workflow while keeping sensitive fields in an owned store, rather than a full "documents live in the vendor" version of the original recommendation, and is willing to build and maintain that small owned store as the cost of getting the workflow off its own plate.
