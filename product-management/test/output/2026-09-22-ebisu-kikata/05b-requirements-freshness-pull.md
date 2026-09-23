# Functional Requirements: Automatic Freshness Pull

Basic Path steps 1-4 all read as "Kaiten IQ doing something" back to back, but each is a
distinct effect with its own failure mode: reading tags, calculating elapsed time,
detecting a threshold crossing, and flagging/displaying are four different bugs a tester
would report separately ("didn't read the tag" is not the same defect as "read the tag but
calculated elapsed time wrong"). Exception Path A's steps 4 ("and logs the discrepancy")
split from the removal-marking step for the same reason the granularity rule calls out
directly: a step whose Detail needs "and" to describe two different effects is usually two
requirements. One record update serves Live Inventory's own state; the other serves a
different consumer (manager review) and can fail independently (the removal marks
correctly but the discrepancy never reaches a manager's review queue).

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-FreshnessPull-01 | Kaiten IQ shall read the RFID tags of plates passing each fixed belt antenna on a continuous cycle. | Kaiten IQ | Basic Path step 1. | Every belt antenna produces a read cycle at a fixed interval with no gap longer than [MAX_READ_INTERVAL]. | Must | Basic Path #1 |
| REQ-FreshnessPull-02 | Kaiten IQ shall calculate each read plate's elapsed time since its "born on" timestamp. | Kaiten IQ | Basic Path step 2. | Every plate read at an antenna has a calculated elapsed time equal to the current time minus its Live Inventory "born on" timestamp. | Must | Basic Path #2 |
| REQ-FreshnessPull-03 | Kaiten IQ shall detect when a plate's elapsed time reaches its menu item category's freshness threshold. | Kaiten IQ | Basic Path step 3. | A plate whose elapsed time meets or exceeds its category's configured threshold is detected within one read cycle of crossing it. | Must | Basic Path #3 |
| REQ-FreshnessPull-04 | Kaiten IQ shall flag a threshold-crossing plate and display its last-read antenna position on the Floor Staff Interface. | Kaiten IQ | Basic Path step 4. | Floor Staff see the flagged plate and a belt position on the Floor Staff Interface within one read cycle of the threshold being crossed. | Must | Basic Path #4 |
| REQ-FreshnessPull-05 | Kaiten IQ shall accept a Floor Staff scan as confirmation that a flagged plate has been physically removed. | Kaiten IQ | Basic Path step 6. | A Floor Staff scan of the retrieved plate at the Floor Staff Interface is recorded as a removal confirmation tied to that plate's RFID UID. | Must | Basic Path #6 |
| REQ-FreshnessPull-06 | Kaiten IQ shall mark a confirmed-removed plate's Live Inventory record with a "freshness" reason code and a removed-at timestamp. | Kaiten IQ | Basic Path step 7, Post-Condition (Basic Path exit). | Live Inventory shows the plate's status as "removed – freshness" with a removed-at timestamp immediately after Floor Staff confirms removal. | Must | Basic Path #7, Post-Condition (Basic Path exit) |
| REQ-FreshnessPull-07 | Kaiten IQ shall accept a Floor-Staff-initiated quality removal, independent of a freshness flag, and record it with a "quality" reason code. | Kaiten IQ | Alternate Path A, Post-Condition (Alternate Path exit). | A plate scanned with "Quality removal" selected shows a "removed – quality" status in Live Inventory, distinct from a freshness-triggered removal. | Should | Alternate Path A, Post-Condition (Alternate Path exit) |
| REQ-FreshnessPull-08 | Kaiten IQ shall mark a flagged plate's Live Inventory record as removed with an "uncollected" reason code and a removed-at timestamp equal to its last confirmed antenna read, when Floor Staff reports it not found. | Kaiten IQ | Exception Path A, step 7 (record marking). | A plate Floor Staff reports as not found shows a "removed – uncollected" status with a removed-at timestamp matching its last confirmed antenna read. | Must | Exception Path A |
| REQ-FreshnessPull-09 | Kaiten IQ shall log a discrepancy entry for manager review whenever a flagged plate is reported uncollected. | Kaiten IQ | Exception Path A, step 8 (logging). | Every "removed – uncollected" record has a corresponding discrepancy log entry visible in manager review. | Should | Exception Path A |
| REQ-FreshnessPull-10 | Kaiten IQ shall detect a mismatch between a belt antenna's observed plate count and the number of RFID tags it successfully reads at that antenna. | Kaiten IQ | Exception Path B, step 1. | A read-gap condition (camera count higher than RFID read count at the same antenna) is detected within one read cycle. | Must | Exception Path B |
| REQ-FreshnessPull-11 | Kaiten IQ shall flag a read-gap alert and notify Floor Staff to inspect the affected belt segment. | Kaiten IQ | Exception Path B, step 2. | Floor Staff see a read-gap alert naming the affected belt segment on the Floor Staff Interface. | Should | Exception Path B |
| REQ-FreshnessPull-12 | Kaiten IQ shall accept either a Floor-Staff-logged manual removal (with an estimated elapsed time) or an alert-clear action as the resolution to a read-gap inspection. | Kaiten IQ | Exception Path B, steps 3-4, Post-Condition (Exception Path B exit). | A read-gap alert ends in exactly one of two states: a manual removal record with an estimated elapsed time, or a cleared alert with no removal record change. | Should | Exception Path B, Post-Condition (Exception Path B exit) |

## Gaps flagged, not invented

- `[MAX_READ_INTERVAL]` (REQ-FreshnessPull-01's acceptance criterion) isn't specified
  anywhere in the use case or PR/FAQ; the Basic Path only says antennas read "on a
  continuous cycle." A licensee's actual read interval depends on antenna hardware Ebisu
  Kaiten-Zushi hasn't specified in this pipeline's artifacts yet.
- Whether a licensee operator can tighten a menu item category's freshness threshold below
  Ebisu Kaiten-Zushi's own default (flagged in `03b`'s Open Issues/Notes) isn't resolved; no
  requirement above assumes per-location threshold overrides exist.
