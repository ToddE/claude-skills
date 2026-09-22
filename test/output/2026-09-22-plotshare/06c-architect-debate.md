# Architect Debate: PlotShare

**Personas**: The Pragmatic Modulith Architect, The Assembler

**Grounding** (product-manager intake): Budget is city-department-sized, close to nothing per garden, and permanent. There's no dedicated engineering headcount; whoever maintains this after launch is a department staffer without engineering background. Failure visibility today is zero for the food bank notification specifically, nobody at the department would know a claim-expiration email failed to send unless the food bank called to ask why nothing arrived. The department is more worried about needing a developer to fix something later than about being tied to one vendor. There's no hard launch date tied to funding, but the pilot needs to run through one full growing season to be worth evaluating.

## Opening Positions

**The Pragmatic Modulith Architect**: The team has no engineering headcount past launch, which means the thing that ships has to be simple enough for the person maintaining it to reason about without being a developer. One Go service with the notification logic behind its own tested module boundary keeps the moving parts whoever inherits this has to explain to a minimum, even though it means the department owns the code instead of a vendor.

**The Assembler**: The team said they're more worried about needing a developer later than about vendor lock-in, which is exactly the scenario a managed platform is built for: Supabase's scheduled function and the platform's built-in email sending don't need a developer to keep running. A department staffer without engineering background can watch a dashboard; they can't debug a Go service's expiration-checking module.

## Challenge

**The Assembler, to the Pragmatic Modulith Architect**: You're proposing the department own the notification code, tests and all, but the intake says there's no engineering headcount after launch. If that module ever needs a fix, who touches it? A tested module boundary only helps the next developer who reads it, and the intake says there won't be one.

**The Pragmatic Modulith Architect, to The Assembler**: You're calling a managed platform's dashboard something a non-developer can operate, but someone still has to notice the dashboard shows a failure, decide what it means, and know who to call. That's still operational burden, layered on top of an unfamiliar vendor's UI, for a department that already has zero failure visibility today and wouldn't know what a Supabase alert even indicates.

## Response

**The Pragmatic Modulith Architect**: Fair, and it means the module boundary isn't enough on its own: the notification failure alert has to go somewhere a human already checks, department email or a shared inbox someone on staff reads. The simplicity argument holds only when the failure surfaces where the department already looks; short code by itself doesn't satisfy it.

**The Assembler**: Also fair, and it cuts the other way too: a Supabase dashboard alert is worthless if nobody at the department knows to check it either. The actual fix is the same for both approaches: route the failure alert to the department's existing email or phone tree.

## Take This Approach If...

**The Pragmatic Modulith Architect's approach fits if**: the department can find even occasional access to a developer (a parks-department contractor, a city IT generalist, a volunteer) for the rare fix, and values staying independent of a vendor's pricing or feature changes over a full growing season and beyond.

**The Assembler's approach fits if**: the department has no path to developer help after launch, ever, and is willing to accept a vendor's platform as the permanent home for this, as long as its failure alerts are routed to a channel the department already watches.
