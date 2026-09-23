# Use Case Candidates: Kaiten IQ

**Initiative:** Kaiten IQ, Ebisu Kaiten-Zushi's RFID plate-tracking platform, now licensed to
other conveyor-belt sushi operators. Ties every plate to a chip-level "born on" timestamp,
enforces freshness automatically, and tallies checkout by plate color instead of a hand count.

**Goals:**
- Replace the colored-plate-and-paper-timer system with automatic, chip-level freshness
  tracking that doesn't depend on a staff member remembering to watch a clock.
- Give a licensee operator a real-time audit trail a health inspector can review directly.
- Replace hand-counted checkout with an automated per-plate tally by color/price tier.
- Keep the flow usable by kitchen and floor staff with minimal training (a single shift, per
  the PR/FAQ's External FAQ).

**Out of scope (for this pass):** payment processing itself (Kaiten IQ produces a tally, not
a payment rail), franchise/licensing contract terms, plate manufacturing and tag sourcing.

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Chef Input (Commissioning) | The chef commissions a freshly made menu item by associating its RFID-tagged plates with that item in Kaiten IQ. | Chef, Kaiten IQ | Chef has made the menu item and wishes to commission it for the belt and timer. |
| Automatic Freshness Pull | Kaiten IQ detects a circulating plate has reached its freshness threshold and has Floor Staff remove it from the belt. | Kaiten IQ, Floor Staff | Kaiten IQ determines a circulating plate's elapsed time has reached its category's freshness threshold. |
| Checkout Plate Tally | A guest requests the bill, and Kaiten IQ tallies their stacked plates by price tier instead of a hand count. | Guest, Cashier, Kaiten IQ | Guest signals they are ready to pay. |

Notes for review:
- "Chef Input (Commissioning)" and "Automatic Freshness Pull" share "Kaiten IQ" as the
  platform actor and are the two ends of the same plate's lifecycle (born on the belt, pulled
  from the belt); kept as two separate use cases rather than one, since each has its own
  distinct trigger and actor sequence (a chef's manual commissioning action vs. Kaiten IQ's
  own continuous, unattended monitoring), matching the granularity use-case-uml expects.
- "Checkout Plate Tally" reuses "Kaiten IQ" as the same actor across all three candidates
  (never "the system" or "the platform" inconsistently), confirmed before drafting.
- "Cashier" and "Floor Staff" are kept distinct even though the same person sometimes fills
  both roles at a small location: they're functionally different responsibilities in the
  flow (billing vs. belt maintenance), and a larger licensee location staffs them separately.
- Confirmed with the (simulated) founder: all three candidates approved for full drafting,
  in the order listed (a plate's lifecycle from commissioning through freshness pull through
  checkout is the natural sequence).
