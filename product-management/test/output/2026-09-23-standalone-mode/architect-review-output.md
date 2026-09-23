# Architecture Review: SplitBalance (two-person shared budgeting app)

Produced standalone by `architect-review`, cold, starting from a one-line idea with nothing
else — no PR/FAQ, no use case, no functional requirements. See `dialogue.md` for the
clarifying exchange this is grounded in.

---

**Persona:** The Pragmatic Modulith Architect

**Inputs considered:** A one-line idea plus a short clarifying exchange only (two partners
tracking shared bank/card balances, bank-linked plus manual entry, a few-times-a-day sync
tolerance, solo builder with no team, targeting iOS and Android). No PR/FAQ, use case, or
functional requirements exist yet, so this recommendation is less grounded than one built on
real requirements would be, and should be revisited once those exist.

### Recommended Approach

Build this as a single Go modulith: one backend serving both a thin API layer for the
mobile clients and, if a web view ever gets added, server-rendered pages from the same
codebase. There's no present-tense reason to split balance-sync logic, bank-linking logic,
and notification logic into separate services for a two-user feature set with a
few-times-a-day sync tolerance — that's a scale and team-boundary problem this product
doesn't have yet.

Use Kotlin Multiplatform for the shared client-side logic between the iOS and Android apps
(balance display formatting, budget-category math, local caching) so that logic isn't
written and maintained twice. The backend exposes one RPC-based HTTP API surface both
clients consume.

Store balances and transactions in PostgreSQL as the source of truth. Given the sync
tolerance you described (a few times a day, not sub-minute), a full offline-first
SQLite-on-the-edge sync engine is more than this needs right now; a straightforward
poll-on-app-open plus periodic background refresh against the API is enough, with the
sync-engine pattern kept in reserve if a future requirement (real-time notification on a
shared-card charge, for instance) actually shows up.

Deploy on fly.io: a solo builder gets a working, portable deployment live fastest there,
without taking on AWS's operational overhead for a product with no scale requirements yet.

### Key Tradeoffs

- **Risk:** relying on a third-party bank-data provider (a Plaid-style connection) for the
  bank-linked side of balances means an outage or API change on their end directly breaks a
  core feature.
  **Driver:** building your own bank-data ingestion (screen-scraping or direct bank
  integrations) is a multi-year undertaking no solo builder should take on for this product.
  **Mitigation:** treat the bank-data provider as a named, load-bearing dependency behind its
  own internal interface in the modulith, not called directly from scattered call sites, so
  swapping providers later touches one module, not the whole codebase.
  **Accepted:** yes. This is the right tradeoff at this stage; revisit only if the specific
  provider's reliability or pricing becomes a real, demonstrated problem.

- **Risk:** manual entry for cash and non-linkable accounts means the two partners' balances
  can silently drift out of sync with reality if one person forgets to log a cash purchase.
  **Driver:** not every account can be bank-linked, and building a workaround for that
  (e.g. receipt-photo parsing) is out of scope for a first version.
  **Mitigation:** make the manually-entered vs. bank-linked distinction visible in the UI
  per line item, so drift is visible rather than silently assumed away.
  **Accepted:** yes, deferring the harder fix (automated cash tracking) until real usage
  shows it's actually a problem worth solving.

### Risks / Open Questions

- `[COMPLIANCE_REQUIREMENT]`: neither PR/FAQ nor requirements exist yet to say whether this
  product needs to meet any specific financial-data handling standard beyond what the
  bank-data provider itself already requires of integrators. Worth naming explicitly before
  storing real bank credentials or balances at any scale beyond two users.
- Authentication and account-sharing model between the two partners isn't specified yet:
  do they share one login, or does each partner have their own login against one shared
  household record? This changes the data model, not just a UI detail, and should get
  resolved via a proper use case before building the sync logic.

### Alternatives Considered

- **Separate microservice per concern (bank sync, notifications, budget calculation):**
  rejected. No present-tense scale or team-ownership reason justifies the operational cost
  of multiple deployables for a two-user feature, built and operated by one person.
  Standalone reasons this fits: none identified yet.
- **A full offline-first SQLite-sync engine on day one:** rejected for now, given the stated
  few-times-a-day sync tolerance. Revisit if a future requirement calls for near-real-time
  updates on shared-card charges.

---

**Persona:** The Assembler

**Inputs considered:** Same one-line idea and clarifying exchange as above (two partners,
bank-linked plus manual balances, a few-times-a-day sync tolerance, solo builder, no team).
No PR/FAQ, use case, or functional requirements exist yet; this recommendation is
correspondingly less grounded and should be revisited once those exist.

### Recommended Approach

Use a backend-as-a-service platform (Supabase or Firebase) for the database, auth, and
realtime layer rather than hand-rolling any of those for a solo builder's side project.
Store balances, transactions, and budget categories in the platform's Postgres database
directly, and use its built-in row-level security to scope each household's data instead of
building a custom multi-tenancy layer.

For the bank-linked side of balances, integrate directly against a bank-data provider's SDK
(Plaid or a comparable one) rather than building an abstraction layer over it "in case we
switch providers someday" — that cost only gets paid if a specific switch is actually on the
table.

Ship the mobile apps on whatever cross-platform framework gets a solo builder to two working
apps fastest (React Native or Flutter, either is fine here), talking directly to the
backend-as-a-service platform's client SDK rather than a hand-rolled API layer in front of
it. Given the stated sync tolerance (a few times a day), the platform's native realtime
feature is more than enough if used at all; polling on app-open covers the requirement
without needing it.

### Key Tradeoffs

1. **Name the dependency:** the backend-as-a-service platform (auth, database, realtime) and
   the bank-data provider (balance data itself) are both load-bearing.
2. **Switching cost today:** low on the backend-as-a-service side — it's early, the schema is
   small, and migrating off it now would be a modest rewrite, not a migration project.
   Higher on the bank-data provider side, since re-linking every user's bank connections
   through a different provider is disruptive to the two actual users, not just an
   engineering cost.
3. **What buying saves:** a solo builder skips building auth, realtime infrastructure, and
   row-level multi-tenancy from scratch, all mature, well-solved problems, and gets to
   spend the limited available time on the budgeting logic that's actually the product.
   Netted against the cost of one more system to watch: for two users, that cost is small
   right now, but it doesn't disappear just because the user count is low — it still needs
   the same alerting discipline named below.
4. **Revisit trigger:** if this grows beyond a household-level product (more users, more
   households, a real go-to-market), reassess both the backend-as-a-service pricing model at
   that scale and whether the bank-data provider's terms still fit.

### Risks / Open Questions

- `[COMPLIANCE_REQUIREMENT]`: same gap as above — no stated requirement yet. A vendor's own
  compliance posture (SOC 2, a signed BAA if ever relevant) can be inherited rather than
  built in-house, but that only helps once it's known which regime, if any, actually applies.
- Even at two users, a log aggregator alone isn't observability: if the bank-data sync job
  fails silently, "nobody knows the balances are stale" is a real, near-term risk for a
  budgeting product specifically, since a wrong balance is worse than no balance. Active
  alerting (even something as simple as a webhook into a personal Slack or phone
  notification) should exist before this ships to real users, not be deferred as a "we'll
  add monitoring later" plan.

### Alternatives Considered

- **A custom backend with a hand-rolled auth and multi-tenancy layer:** rejected. This is
  exactly the kind of solved-problem infrastructure a solo builder shouldn't spend limited
  time re-building before there's a demonstrated reason the platform's native version
  doesn't fit.
- **Building an abstraction layer over the bank-data provider's SDK:** rejected for now. Pays
  a cost today for a provider switch that isn't currently on the table.

---

**Note on the debate:** the (simulated) user was asked whether to run the opt-in Step 7
debate between these two personas, grounded in a short product-manager intake, and declined
for this test, wanting two independent takes rather than a forced disagreement. Per the
skill's own instructions, the debate is opt-in and was correctly not run automatically.
