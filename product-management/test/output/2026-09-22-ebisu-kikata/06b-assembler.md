**Persona**: The Assembler

**Inputs considered**: same as `06a`: `01-prfaq.md`; all three use cases (`03a`, `03b`,
`03c`); all three requirements sets (`05a`, `05b`, `05c`).

### Recommended Approach

Use a managed IoT device platform (a comparable vendor to AWS IoT Core or Particle) to
handle antenna-to-cloud connectivity and local read buffering, instead of building and
maintaining a custom edge binary for every licensee restaurant. These platforms exist
specifically to solve "a physically remote device needs to buffer data during a
connectivity gap and sync when it's back," which is exactly `REQ-FreshnessPull-01`'s
continuous-read requirement, and they're used by thousands of IoT deployments already,
which is a stronger reliability track record than a first-version custom binary a small
team just wrote.

Put Live Inventory in Supabase (Postgres underneath, so this isn't a fundamentally
different data model than a build-first approach, just who operates it). Use its
row-level security for per-location tenant isolation instead of building a custom
partitioning layer: `05a` through `05c`'s requirements never describe cross-location data
sharing, so RLS keyed by location ID covers every stated requirement. Threshold-detection
logic (`REQ-FreshnessPull-02` through `-04`) and checkout tally calculation
(`REQ-CheckoutTally-01` through `-05`) run as serverless functions triggered by the IoT
platform's own event stream and Supabase's realtime subscriptions, not a persistent backend
service the team has to keep running.

Chef, Floor Staff, and Checkout Interfaces ship as a single Next.js app on Vercel, since
none of the three use cases describe an interaction model demanding anything more than a
CRUD-and-realtime-updates UI.

### Key Tradeoffs

1. **Name the dependency**: a managed IoT device platform for every restaurant location's
   antenna connectivity and offline buffering, plus Supabase for the data layer and
   realtime updates.
2. **Switching cost today**: low on the data layer, since it's Postgres underneath; higher
   on the IoT platform, since each location's antenna configuration and device
   provisioning would need to move to a new vendor's device model. Worth naming plainly
   rather than treating as free.
3. **What buying saves**: standing up and operating a fleet-management practice for a
   custom edge binary across every licensee restaurant, most of which have no IT staff of
   their own (per `01-prfaq.md`'s External FAQ, installation is meant to run in a single
   after-close visit with a single-shift staff training, not an ongoing IT relationship).
   That operational cost is exactly what a restaurant company licensing software to other
   restaurant companies shouldn't be building for itself. Netted against the observability
   cost of one more vendor to watch: still worth it, provided the mitigation below is
   followed.
4. **Revisit trigger**: if the IoT platform's offline-buffering window turns out to fall
   short of what a real service disruption requires during the pilot, or once licensed
   location count crosses a threshold where the platform's per-device pricing changes the
   unit economics named in `01-prfaq.md`'s Internal FAQ.

### Risks / Open Questions

- `[SCALE_TARGET]` (expected number of licensed locations) isn't specified; the IoT
  platform's per-device pricing and the IoT-vs-custom-binary tradeoff both depend on it.
- The managed IoT platform's offline-buffering guarantee needs to be verified against the
  pilot's actual worst-case connectivity gap, not assumed adequate; a food-safety-relevant
  freshness detection running behind a vendor's buffering window it hasn't demonstrated
  under real restaurant WiFi conditions is a real, not hypothetical, risk this
  recommendation depends on closing during the pilot.
- Whether a specific RFID antenna hardware line has a certified integration with the
  proposed IoT platform isn't confirmed by any input artifact.

### Alternatives Considered

- **A custom edge binary maintained in-house**: rejected. Adds a fleet-management
  discipline (build, ship, monitor, and support updates to a binary running on hardware in
  restaurants Ebisu Kaiten-Zushi doesn't operate) that a company whose core business is
  running restaurants, not software infrastructure, shouldn't be taking on if a mature
  vendor already solves the underlying problem.
- **A fully custom multi-tenant partitioning scheme**: rejected. Supabase's row-level
  security already satisfies every isolation requirement the use cases state; building a
  bespoke layer on top of a solved problem is effort spent in the wrong direction.

### Observability note

Per this persona's own standing rule: piping the IoT platform's device logs and Supabase's
logs into one aggregator is collection, not observability. Before the pilot goes live with
its three licensee locations, wire active alerts, at minimum a location-offline alert and a
freshness-detection-stalled alert, into one Slack channel or equivalent the team actually
watches. A location's antennas going silent for an hour during dinner service and nobody
finding out until a health inspector does is the exact blind spot this persona treats as
predictable and preventable, not bad luck.
