**Persona**: The Pragmatic Modulith Architect

**Inputs considered**: `01-prfaq.md`; all three use cases (`03a-chef-input-commissioning.md`,
`03b-automatic-freshness-pull.md`, `03c-checkout-plate-tally.md`); all three requirements
sets (`05a`, `05b`, `05c`). Scoped to the software and edge-connectivity system behind
commissioning, freshness monitoring, and checkout, not the physical belt, antenna hardware
manufacturing, or plate/tag sourcing, none of which this persona's file has anything to say
about.

### Recommended Approach

Build one modulith backend covering Live Inventory, licensing/tenant management, and
checkout, deployed centrally. Pair it with a small, single-binary "Location Edge Service"
running on-site at every licensee restaurant: it talks directly to the belt antennas, the
Chef Interface, the Floor Staff Interface, and the checkout reader, and does freshness
threshold detection (`REQ-FreshnessPull-01` through `-04`) locally rather than round-
tripping every antenna read to the cloud.

This isn't optional given what the requirements actually state: `REQ-FreshnessPull-01`
requires belt antennas to read on a continuous cycle with no gap longer than
`[MAX_READ_INTERVAL]`, and a plate exceeding its freshness threshold is a food-safety
event (`01-prfaq.md`'s Internal FAQ names health-code citations as the exact failure mode
Kaiten IQ replaces). A restaurant's internet connection dropping for ten minutes during a
dinner rush can't mean freshness enforcement pauses for ten minutes. The edge service
keeps a local SQLite copy of that location's Live Inventory slice (commissioned plates,
open freshness clocks) and syncs transactionally to the central PostgreSQL instance,
exactly this persona's offline-first data pattern, applied here to a restaurant's spotty
back-office WiFi instead of a mobile client.

Central backend: Go, server-rendered Chef/Floor Staff/Checkout Interfaces (Go templates,
HTMX, Tailwind), one deployable, running on Fargate behind an ALB once licensing moves past
the pilot's three locations. Multi-tenancy (one licensee per restaurant location, per
`02-use-case-candidates.md`'s scope) is partitioned by location ID from day one, since
retrofitting isolation after several licensees are live is far more expensive than building
it in from the first schema.

### Key Tradeoffs

- **Risk**: running a second deployable (the edge service) per restaurant location adds a
  fleet of small, physically remote systems to keep updated and healthy, instead of one
  central system.
  **Driver**: `REQ-FreshnessPull-01`'s continuous-read requirement and the food-safety
  stakes named in the PR/FAQ's Internal FAQ risk section; a cloud-only design can't
  guarantee that continuity when a location's internet connection is the single point of
  failure.
  **Mitigation**: ship the edge service as a self-updating single static binary (this
  persona's usual multi-stage-build pattern), with a heartbeat to the central backend so a
  location going silent triggers an alert instead of getting discovered when a manager
  calls asking why freshness pulls stopped.
  **Accepted**: yes. Food-safety continuity outweighs the added fleet-management cost;
  revisit if a future antenna platform ships its own reliable offline buffering, at which
  point the custom edge binary might be replaced by that vendor's local agent instead.

- **Risk**: partitioning multi-tenancy by location ID before there are more than three
  pilot licensees means carrying schema complexity the pilot alone doesn't need yet.
  **Driver**: `01-prfaq.md`'s stated intent to license to other operators beyond Ebisu
  Kaiten-Zushi's own 18 restaurants, not just run this internally.
  **Mitigation**: build the partition key into every table now (cheap while the schema is
  still small), but don't build a self-service licensee-onboarding flow until licensing
  volume justifies it.
  **Accepted**: yes. Retrofitting tenant isolation into a live system handling food-safety
  records is a much worse position than paying this cost early.

### Risks / Open Questions

- `[MAX_READ_INTERVAL]` and `[SCALE_TARGET]` (how many locations at general licensing
  availability) aren't specified in any input artifact; the edge service's local buffering
  window and the central backend's expected concurrent-location count both depend on them.
- The Basic Path's antenna hardware isn't named. If a specific RFID antenna vendor's SDK
  only supports a cloud-first integration model, the edge-service recommendation needs to
  be revisited against what that hardware actually allows.
- `REQ-CheckoutTally-01`'s reader dependency and the belt antennas are almost certainly
  different hardware from different vendors; whether one edge binary should own both or
  they're separate integrations isn't resolved by the requirements as written.

### Alternatives Considered

- **Cloud-only, no edge component**: rejected. Every belt antenna read round-tripping to a
  central service over each restaurant's own internet connection makes freshness detection
  dependent on connectivity quality this system has no control over, directly against the
  food-safety stakes the PR/FAQ names as the top reason this product exists.
- **A separate microservice per use case (commissioning, freshness, checkout)**: rejected
  for now. All three share the same Live Inventory data and the same location-partitioned
  tenancy model; splitting them into separate services buys no present-tense scaling
  benefit and adds three deployables to operate instead of one modulith plus one edge
  binary type.
