# Dialogue: DispatchIQ

Idea generated for this test run, not supplied by whoever kicked it off. Chosen to be a
genuine for-profit product, unlike the first two runs (one non-commercial/open-source, one
a city-department program), specifically to exercise the parts of the pipeline neither
prior run touched: `working-backwards-prfaq`'s revenue/TAM/unit-economics Internal FAQ
language, and the new opt-in debate feature in `architect-review`.

## working-backwards-prfaq intake

**Claude (Stage 1):** What are you announcing?

**User (simulated):** DispatchIQ, a scheduling and dispatch tool for small home-service businesses, plumbers, electricians, HVAC techs, that auto-routes jobs to the nearest available technician and automatically texts customers a reminder and a live "tech is on the way" ETA.

**Claude (Stage 2):** Who is this for, specifically?

**User (simulated):** Home-service businesses with 2-15 technicians. Today they run scheduling on a paper calendar, a shared Google Calendar, or a generic scheduling app not built for dispatch, and the office manager calls every customer by hand to confirm and update them, which doesn't scale past a handful of jobs a day and falls apart the moment someone's running late.

**Claude (Stage 3):** What makes this meaningfully better, and how will you know it worked?

**User (simulated):** It automates the two things costing them money today: no-shows from customers who forgot or weren't told a tech was on the way, and double-bookings from a calendar that doesn't account for drive time between jobs. Success: 500 paying accounts and $40K MRR within 12 months of general availability, average seats-per-account above 4 (meaning it's landing with real multi-tech shops, not solo operators), and monthly logo churn under 3%.

**Claude (Stage 4):** How many stakeholders should be quoted?

**User (simulated):** Two: the founder, and a dispatcher at a pilot customer's HVAC company.

**Claude (Stage 5):** Timeline and anything else?

**User (simulated):** General availability in Q2 2027, after a paid pilot with a handful of shops this quarter. One more thing: SMS costs money per message, so the business model has to survive customers who send a lot of updates, not just charge a flat seat price and hope average usage stays low.

**Claude:** Recap confirmed before generating (see `01-prfaq.md`). This is a genuine for-profit product with a revenue model, so the Internal FAQ uses TAM, unit economics, and path-to-profitability language directly, unlike the first two test runs (one had no revenue model at all, one was a city program measured by adoption).

## use-case-discovery

**Claude:** Derived goals and candidates directly from the confirmed PR/FAQ brief. Candidate list in `02-use-case-candidates.md`.

## use-case-uml

**Claude:** Drafting two use cases in full instead of one this time, continuing the fix from the PlotShare run: "Auto-Route a New Job" (the core dispatch logic, with a real branching decision when no technician is available) and "Notify Customer of Technician ETA" (the SMS flow the whole value proposition depends on, with a real failure mode when SMS delivery fails). Per `use-case-uml/SKILL.md` Step 1, since both trace back to a confirmed candidate and PR/FAQ, each gets drafted directly from that context rather than interviewed from scratch, then presented for confirmation.

**Claude:** Drafted "Auto-Route a New Job": dispatcher enters job details, DispatchIQ calculates drive time from every available technician, assigns whoever arrives soonest without exceeding their job load, and both the technician and dispatcher see the result. Branches: a tie on soonest arrival, and nobody able to make the requested window. Does "lighter current job load breaks a tie" match how you'd actually want that decided, and what should happen when nobody can make the window?

**User (simulated):** Tiebreaker's right. When nobody can make the window: flag it and let the dispatcher manually adjust, don't have the system guess or auto-push the window out on its own.

**Claude:** That's what's drafted: DispatchIQ flags it and notifies the Dispatcher, who manually adjusts the time window or reassigns another job to make room. One open question this surfaced: what counts as "too loaded" for a technician isn't defined yet, do you have a number, or should it stay a placeholder?

**User (simulated):** No number yet, leave it a placeholder, that's genuinely not decided.

**Claude:** Left `[JOB_LOAD_LIMIT]` as an Open Issue rather than guessing. See `03a-auto-route-a-new-job.md`.

**Claude:** Drafted "Notify Customer of Technician ETA," building on 03a: once a technician marks a job en route, DispatchIQ calculates the ETA and texts the customer, then logs the send. One Exception Path for SMS delivery failure. Given the PR/FAQ calls silent SMS failure the single biggest risk, I drafted the failure path to retry once, then alert the Dispatcher directly rather than just logging it. Does that match the severity you want, or should a failed send do more than alert the dispatcher?

**User (simulated):** That's right, alerting the dispatcher directly is exactly the point, a log entry nobody checks isn't enough for something this core.

**Claude:** Kept it as drafted. Retry delay before that one retry attempt isn't specified yet, want a number or should it stay open?

**User (simulated):** Leave it open too.

**Claude:** Left `[RETRY_DELAY]` as an Open Issue. See `03b-notify-customer-of-technician-eta.md`.

## use-case-test-cases / use-case-requirements

**Claude:** Ran Mode A against both use cases this time, not just one, closing the gap the PlotShare run's README flagged (downstream artifacts only ever covered one use case out of several). See `04a`/`04b` and `05a`/`05b`.

## architect-review

**Claude:** Ran both personas separately (`06a-pragmatic-modulith-architect.md`, `06b-assembler.md`), then, since this run exists partly to test it, asked for and ran the opt-in debate. The product-manager intake for the debate is captured in full below since that's the part most worth reviewing.

### Debate opt-in: product-manager intake

**Claude:** Want me to run a debate between the two architects on this one? It's opt-in, and if you say yes I'll ask a few grounding questions first, as the product manager, before drafting it.

**User (simulated):** Yes.

**Claude:** Budget sensitivity: how tight is it, and is that permanent or temporary?

**User (simulated):** Tight. Pre-revenue until the pilot converts, self-funded, maybe 6 months of runway. Loosens if the pilot hits the MRR target in the PR/FAQ.

**Claude:** Operational appetite: does the team want to run infrastructure themselves, or minimize that?

**User (simulated):** Minimize it. It's me and one contractor engineer right now. Neither of us wants to be woken up by a pager.

**Claude:** Failure visibility: if something breaks at 2am, who finds out today, and how fast?

**User (simulated):** Honestly, nobody, until a customer emails support in the morning. That's a real gap.

**Claude:** Risk tolerance: which hurts more, being locked into a vendor, or your own system breaking in a way only your team can fix?

**User (simulated):** Our own system breaking. If SMS notifications silently stop going out, that's the entire value proposition failing without anyone noticing, and that's worse than being stuck with a vendor.

**Claude:** Timeline pressure: how urgent is going live, and what's riding on it?

**User (simulated):** The paid pilot starts this quarter. If it's not solid by then, there's no pilot data to show the next round of funding conversations.

**Claude:** Recap confirmed, debate drafted. See `06c-architect-debate.md`.
