# Architect Review: DispatchIQ

**Persona**: The Assembler

**Inputs considered**: same as `06a-pragmatic-modulith-architect.md`.

## Recommended Approach

Build the dispatcher dashboard and technician view on a managed platform (Next.js on Vercel or similar) with a backend-as-a-service (Supabase) for the database, auth, and a scheduled function for drive-time recalculation. Use a dedicated SMS API (Twilio or a notification platform like Courier) instead of building send-and-retry logic from scratch; these vendors already expose delivery-status webhooks, which is exactly the signal DispatchIQ needs to know a message failed. For a two-person, pre-revenue team with six months of runway, engineering time is the scarcest resource. Auto-routing is close to the product's value proposition, but it's still a solvable problem with an existing distance-matrix API, not something that needs custom drive-time modeling built in-house for a pilot this small.

The PR/FAQ names SMS failure as the top risk, and the team has zero failure visibility today. This recommendation treats that as the most important thing to get right, and as a vendor-native problem: use the SMS provider's own delivery-status webhook to detect failures close to real time, rather than polling or guessing, and wire that webhook into a hosted alerting platform with a Slack notification, so the alert reaches the team the moment delivery fails.

## Key Tradeoffs

1. **Name the dependency**: a managed platform, a backend-as-a-service, a distance-matrix API, and an SMS provider, four vendor dependencies instead of one owned stack.
2. **Switching cost today**: low for the platform, the backend-as-a-service, and the distance API; higher for the SMS provider once delivery-status handling is built against its specific webhook shape, but still a bounded rewrite, not a system redesign.
3. **What buying saves**: engineering time the two-person team doesn't have to spend on drive-time calculation or SMS retry and delivery-status polling, both solved problems elsewhere. Netted against the added observability surface: four vendors' worth of failure modes to watch instead of one, which is exactly why the SMS provider's native delivery-status webhook, not a custom retry loop, is the recommendation. It's the vendor detecting the failure, not homegrown code guessing at it.
4. **Revisit trigger**: if the pilot converts and SMS volume or distance-matrix API cost becomes a meaningful share of per-account revenue, revisit each dependency on its own economics, not all at once.

## Risks / Open Questions

- `[JOB_LOAD_LIMIT]` and `[RETRY_DELAY]`: same gaps as `06a`; a distance-matrix API and a vendor SMS provider still need these business rules configured on top of them, they don't come pre-decided.
- Whether the chosen SMS provider's delivery-status webhook fires fast enough to catch a failure before the customer notices isn't verified by the input artifacts; needs confirming against the specific vendor's SLA, not assumed here.

## Alternatives Considered

- **Custom drive-time calculation**: rejected for now. A distance-matrix API is a mature, solved problem; building this in-house spends scarce engineering time on something not yet proven to need customization.
- **Custom SMS retry and failure-detection logic**: rejected. A vendor's delivery-status webhook is a faster, more reliable signal than a client-side retry-and-guess loop, and it's the vendor's job to say a message failed, not something to reimplement.
