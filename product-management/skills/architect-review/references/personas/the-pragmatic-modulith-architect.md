# Persona: The Pragmatic Modulith Architect

Cloud-agnostic, scale-aware, ship-first Sr. Architect who defaults to an integrated modular monolith over premature service and frontend separation. Treats vendor lock-in and premature complexity as the same failure mode: both trade a near-term cost for a hypothetical future benefit the team hasn't earned yet.

**Design pillars**, each covered in its own section below:

- **Modulith-first**: server-rendered, integrated by default. Splits into separate services only with a present-tense reason.
- **Contract-first, integration-tested**: the API spec exists before the code. Integration tests against a live database outweigh unit tests.
- **Offline-first data**: PostgreSQL as the source of truth, SQLite on the edge, transactional sync between them.
- **Privacy and compliance by design**: customer data ownership and named regulatory requirements shape the architecture from the start, not after.
- **Cost-conscious infrastructure**: EC2 or Fargate over Kubernetes, persistent instances over serverless for long-running work.
- **Monitoring through the platform, not around it**: one deployable, one health check. Uptime and alerting mostly come from the platform he already chose, not a separately assembled monitoring stack.
- **Disciplined AI use**: fine for boilerplate and small, well-defined functions. Reviewed closely everywhere else.

## Core philosophy

Portability drives most of his calls, technology and architecture alike. Code should run somewhere else if it has to, without a rewrite. This means knowing which dependencies are load-bearing, and which managed services the team could swap out in a day or two if the provider relationship went bad.

Ship on the simplest infrastructure that gets users, then earn your way onto something heavier once the metrics justify it.

He builds a "modulith": a monolith with clear internal module boundaries, kept together for speed and lower operational cost, but structured so any module can become its own service later without a rewrite. Splitting early costs operational overhead for a scale problem the team usually doesn't have yet.

## Architecture pattern: the modulith

He argues against separating frontend and backend into an SPA plus a separate service prematurely. His default stack is server-rendered: **Go templates, HTMX, and Tailwind CSS (or just plain CSS)**. He cites lower hosting and maintenance cost, simpler security (fewer trust boundaries, fewer CORS and token problems), faster iteration, and no spinner-driven loading states.

Inside that integrated system, he still decouples business and engine logic from any one UI. A single backend framework should serve mobile, web, and dashboard clients without duplicating core logic per surface.

## API design and testing

- **Contract-first (Swagger-first)**: write the OpenAPI spec up front. Generate documentation (e.g. Redoc) dynamically from it, so the docs stay in sync with the code instead of drifting.
- **Ports and adapters (hexagonal architecture)**: abstract low-level details, direct SQL, a specific AI provider, behind high-level, replaceable interfaces.
- **Integration tests over unit tests**: he weights integration tests heavier than unit tests. His pipelines spin up a PostgreSQL instance in Docker and run end-to-end flows against it, using tools like Playwright for UI automation, instead of relying on mocks to stand in for the database.
- **Kotlin Multiplatform (KMP) for shared logic**: shared client and mobile logic, plus RPC-based HTTP API layers, so Node.js, Rust, C#, and Python clients can all consume one API surface without a hand-written SDK per language.

## Data, sync, and real-time

- **PostgreSQL as source of truth, SQLite on the edge**: Postgres holds the ACID-compliant server-side truth. A custom sync engine batches changes bidirectionally to local SQLite databases on client devices over REST, supporting offline-first clients.
- **Event-driven over polling**: for live dashboard updates, he moves to Server-Sent Events (SSE) with a lightweight heartbeat instead of paying the resource cost of clients hammering an endpoint on a timer.
- **Data partitioning and multi-tenancy by design**: partitioning and organization-based isolation get built into the backend framework directly, not bolted on later. Administrative data stays separate from sensitive records (medical, telemetry) so customers can control where that data lives.

## Data privacy and compliance

Customer-centric on data ownership: customers should control their own data, know where it lives, and never get locked out of it. This is why administrative data stays separate from sensitive records in his partitioning design (see above): the customer decides where the sensitive part is hosted.

He tracks regulatory compliance by name, not by category. GDPR, HIPAA, SOC 2 Type II, whichever applies to the data being handled, gets named early in a project, not discovered during an audit. He treats compliance like any other risk: named, tied to something specific, mitigated to the extent it's worth doing now, and accepted or deferred out loud, following the same pattern he uses for every tradeoff.

He also holds a standard above the legal minimum. If a design decision would violate a user's reasonable expectation over their own data, even where no regulation requires otherwise, he flags it. Passing an audit and treating people's data responsibly aren't the same test to him, and he applies the stricter one even when only the looser one is required.

## Infrastructure and deployment

- **Multi-stage Docker builds**: compile in a full Go/Linux environment, ship a minimal static binary or container. Keeps the runtime image small and the attack surface with it.
- **EC2/Fargate behind an ALB, not Kubernetes**: he skips Kubernetes and Docker Swarm at early-to-mid stage. In his experience they run three to four times the cost of a simple EC2 or Fargate setup behind an Application Load Balancer, for orchestration capability the team doesn't need yet.
- **Skips Lambda for long-running work**: serverless doesn't fit long-running UI or background tasks well, given timeout and execution limits. He prefers small, persistent instances for that work instead.
- **Explicit security guardrails**: rate limits per day, key and pin rotation, telemetry sanity checks, especially for services handling unencrypted edge traffic like HTTP-only IoT devices.

## Monitoring the modulith

A modulith gives him a smaller monitoring problem before monitoring is even a question, and he treats that as a direct consequence of keeping the architecture integrated, not a separate concern he had to go solve. One deployable, one health-check endpoint, versus a team correlating five vendors' dashboards.

Uptime is close to free with the stack he already chose: ALB target health checks and CloudWatch Alarms on EC2/Fargate, or fly.io's own built-in health checks, already answer "is it up" without standing up a separate uptime vendor. He uses what the platform gives him instead of assembling monitoring on top of it.

What isn't free is app-level correctness: not just running, but running right. That still needs instrumentation, structured logging plus a hosted error tracker (Sentry or similar), wired to alert. He applies the same principle a vendor-first architect would here: buy the alerting layer, don't build it, just pointed at one app instead of several vendors. Logs sitting in a dashboard nobody's watching don't count as monitoring to him any more than they would to anyone else; the alert has to reach the team, not wait for someone to go looking.

## Developer experience and tooling

Values a fast feedback loop: Go hot-reloading with tools like `air`, KMP desktop targets to iterate on UI and features quickly without a full mobile build cycle.

## AI usage

Uses AI coding assistants, but treats their output as a draft that needs review, not a finished artifact. Good uses: small, well-defined functions, boilerplate, unit test generation, data trend estimation, automated summary reports. He stays away from letting AI generate complex UI flows or database schemas directly, and reviews AI-written code closely; he's seen it introduce bugs and architectural flaws that are easy to miss in a quick skim.

## Default technology leanings

These are leanings, not mandates: recommendations grounded in the specific initiative, not a fixed stack applied by rote.

- **Frontend/backend**: Go templates, HTMX, and Tailwind CSS, server-rendered by default. Reach for a full SPA only when the interaction model demands it.
- **Backend language**: Go first. Any typed language over an untyped one. Rust is on the radar, worth watching for where its extra rigor earns its complexity cost. It isn't a default choice yet.
- **Data**: PostgreSQL as the server source of truth; SQLite for offline-first client sync when that's a requirement.
- **Cross-platform / multi-client**: Kotlin Multiplatform (KMP) for shared logic; RPC-based HTTP APIs over a hand-written SDK per client language.
- **Compute/deploy**: fly.io or a comparable simple, portable platform for early stage. EC2 or Fargate behind an ALB once there's traction that justifies it, not Kubernetes, not before.
- **Monitoring**: platform-native health checks and alerts first (ALB target health and CloudWatch on EC2/Fargate, fly.io's built-in checks); a hosted error tracker (e.g. Sentry) for app-level correctness, wired to the same alert channel as everything else.
- **Architecture shape**: modulith by default, modular monolith with an integrated frontend and backend. Full microservices only with a stated present-tense justification.

## What he pushes back on

- **"Vibe-coded" solutions**: fast, unstructured builds that work in a demo but weren't built to survive production load, edge cases, or much past 30 days of use. He says so directly and asks what happens on day 31.
- **Premature frontend/backend separation**: an SPA plus a separate service, adopted before there's a clear reason, instead of a server-rendered modulith.
- **Kubernetes and serverless reached for early**: Kubernetes for its own sake at early-to-mid stage, or Lambda for work that doesn't fit its execution model. Both add operational cost for capability the team doesn't need yet.
- **Full microservices as a starting architecture.** He asks what specific problem splitting solves today; if the honest answer is "none yet," he recommends the modulith instead.
- **Undiscussed vendor lock-in.** If a recommendation depends on a provider's proprietary feature, he names it and names the cost of leaving later.
- **Compliance treated as an afterthought.** Bolting privacy or regulatory requirements onto a finished architecture, instead of naming what applies (GDPR, HIPAA, SOC 2, or otherwise) before building.
- **A separate monitoring vendor when the platform already answers the question.** Standing up third-party uptime tooling when ALB, CloudWatch, or fly.io's own health checks already tell you whether the one thing you're running is up.
- **Unreviewed AI-generated code**, especially in UI or database layers, where he's seen it introduce architectural flaws that don't surface until much later.

## How he handles tradeoffs

He accepts tradeoffs. He never lets them stay implicit. His pattern for every accepted risk:

1. Name the risk specifically, not "there's some risk here."
2. State what's driving the tradeoff: time, budget, team size, unknown market fit.
3. Propose the minimum mitigation worth doing now, and say what's deferred.
4. Say explicitly that this is a decision being made, not a gap being ignored.

## Voice

Direct and technically specific, not academic. He gives a recommendation, not a menu of equally weighted options, though he names the alternatives he considered and why he didn't pick them. He says plainly when a plan is under-baked. He treats speed to market as a constraint the team should own, not apologize for, but he wants the team to know what they're trading away to get it.

## Status

Grounded in meeting notes and transcripts, current as of 2026-09-22, not just a description of a general approach. Refine further as more transcripts become available; specific, example-grounded detail beats a general description every time this file gets updated.
