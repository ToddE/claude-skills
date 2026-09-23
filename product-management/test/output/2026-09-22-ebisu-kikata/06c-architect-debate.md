**Personas**: The Pragmatic Modulith Architect, The Assembler

**Grounding** (product-manager intake for Kaiten IQ, see `dialogue.md` for the full
exchange): Budget is tight and structural, not a temporary pre-revenue phase. Ebisu
Kaiten-Zushi is a restaurant company funding a software spinout out of its own operating
margin, not a funded software startup with a runway clock. The team standing this up is two
engineers Ebisu Kaiten-Zushi hired away from a restaurant-tech vendor, with no one else
free to run infrastructure; they want to minimize what they operate directly. If a
freshness detection stalls at a licensee location, today nobody finds out until a manager
notices a stale plate on the belt or, worse, a health inspector does; there's no monitoring
at all yet, only a support phone line. What worries the team most isn't vendor lock-in on
a small piece of infrastructure, it's a silent failure at a restaurant they don't staff and
can't walk into on a bad day. The pilot with three licensee locations needs to be reliable
before Ebisu Kaiten-Zushi opens general licensing, since the PR/FAQ's own success metric
depends on those three locations proving tag durability and checkout time reduction.

### Opening Positions

**The Pragmatic Modulith Architect**: Build the Location Edge Service in-house. A silent
failure at a restaurant the team doesn't staff is the specific fear stated in the intake,
and an in-house binary that heartbeats to a central alert the team owns closes that gap
directly, rather than trusting a vendor's own device-health signal to surface a failure
mode this specific to Kaiten IQ's freshness use case.

**The Assembler**: Use the managed IoT platform. A two-engineer team funded out of a
restaurant company's operating margin, not investor runway, is exactly the team that
shouldn't be building and operating a device fleet management practice from scratch. The
platform's device-health monitoring is a starting point for the alerting the team needs,
not a replacement for it, but it gets there with two engineers' time spent on Kaiten IQ's
actual logic instead of on device provisioning tooling.

### Challenge

**The Assembler, to the Pragmatic Modulith Architect**: You're proposing a heartbeat "the
team owns," but the intake says there's no monitoring at all today, only a support phone
line. Building a custom heartbeat system is itself a new thing for a two-engineer team to
build and operate, on top of the edge binary itself. That's two new systems this team owns
instead of one, when the team explicitly said it wants to minimize what it operates
directly.

**The Pragmatic Modulith Architect, to The Assembler**: You're calling the IoT platform's
device-health signal "a starting point for the alerting the team needs," but the intake's
specific fear isn't "is the device online," it's a silent failure in Kaiten IQ's own
freshness-detection logic at a location nobody's watching. A managed platform can tell you
a device is connected and still miss that its freshness-threshold calculation stopped
firing correctly. Buying device connectivity monitoring doesn't buy the application-level
correctness monitoring this specific fear requires.

### Response

**The Pragmatic Modulith Architect**: Fair, and it sharpens the mitigation rather than
changing the recommendation: the heartbeat shouldn't be "device is online," it should be a
one-line addition to the edge binary that reports its last successful freshness-threshold
evaluation timestamp, wired to the same hosted error tracker this persona already defaults
to for app-level correctness. That's a small addition to a binary the team is already
maintaining, not a second new system.

**The Assembler**: Also fair, and the same fix applies to my recommendation: the IoT
platform's device-connectivity signal isn't sufficient on its own, so the serverless
threshold-detection function needs its own explicit heartbeat, not device-online status,
wired into the same alerting the observability note in `06b` already calls for. That's
consistent with treating the IoT platform as solving device connectivity, not application
correctness, and buying the alerting layer on top of it deliberately rather than assuming
the platform's dashboard covers a failure mode it was never built to catch.

### Take This Approach If...

**The Pragmatic Modulith Architect's approach fits if**: Ebisu Kaiten-Zushi expects to keep
adding location-level logic to the edge binary as licensing grows (new sensor types, new
freshness rules per cuisine style if Kaiten IQ ever licenses beyond kaiten-zushi), and the
two-engineer team is willing to spend the small, one-time cost of owning device fleet
updates in exchange for full control over exactly what the heartbeat monitors.

**The Assembler's approach fits if**: the licensee location count is expected to grow
faster than the two-engineer team's capacity to maintain a custom fleet, and the team would
rather spend its limited time on Kaiten IQ's own freshness and checkout logic than on
device provisioning and update tooling, provided the application-level heartbeat both
sides agreed on gets built before general licensing availability either way.
