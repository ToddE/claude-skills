# Dialogue: PlotShare

Idea generated for this test run, not supplied by whoever kicked it off. Chosen to stress
`working-backwards-prfaq`'s generalized framing (success measured outside revenue/profit),
added this session specifically to handle non-commercial announcements.

## working-backwards-prfaq intake

**Claude (Stage 1):** What are you announcing?

**User (simulated):** PlotShare, an app that helps community garden members coordinate who's using which plot and when, and lets people list surplus harvest so neighbors or a food bank can claim it before it goes to waste. Run by a city parks department, not a company.

**Claude (Stage 2):** Who is this for, specifically? "Community garden members" is a start, but who exactly deals with the problem today, and how?

**User (simulated):** Members of city-run community gardens, usually 20-60 plots per garden, coordinated today by a paper sign-up sheet pinned to a shed or a group text thread that half the members aren't in. Surplus produce mostly just rots on the vine because nobody's tracking who has extra or when a food bank pickup could work.

**Claude (Stage 3):** What makes this meaningfully better than the sign-up sheet and group text? And separately: how will you know this worked? What does success look like, and by when?

**User (simulated):** It's the difference between "maybe someone sees the text" and an actual schedule everyone can check from their phone, plus a surplus board that notifies a food bank contact automatically instead of relying on someone remembering to call. Success: within one growing season, at least 70% of a pilot garden's members actively using the schedule feature, and at least 200 lbs of surplus produce routed to a food bank that would otherwise have gone to waste. Also: fewer plot-scheduling disputes reported to the garden coordinator.

**Claude (Stage 4):** How many stakeholders should be quoted, and who?

**User (simulated):** Two: the city parks department's community gardens coordinator, and a garden member who's used it for a season.

**Claude (Stage 5):** What's the timeline, and anything else I should know?

**User (simulated):** Pilot launch next growing season, so aim the release date around then. Budget is city-department-sized, not venture-sized: this needs to run on close to nothing per garden. One more thing: some members don't have smartphones, so there needs to be a non-phone fallback, probably the same paper sheet, printed from the app.

**Claude:** Recap confirmed with user before generating (see `01-prfaq.md`).

## use-case-discovery

**Claude:** Derived goals and candidate use cases directly from the confirmed PR/FAQ brief above, per the skill's own "don't re-ask if already given" rule. Candidate list in `02-use-case-candidates.md`.

## use-case-uml

**Claude:** Initially drafted only "Claim a Surplus Listing," chosen because it's the use case with the most interesting Alternate/Exception path since surplus items can be claimed, expire, or get contested by two claimants. That single-use-case scope was flagged as unrealistic (see the run README's findings): real projects have multiple use cases, and this one already referenced a second use case ("Route Unclaimed Surplus to Food Bank") that didn't exist yet, a dangling cross-link. Went back and drafted the two use cases that "Claim a Surplus Listing" actually depends on, "List Surplus Produce" (its precondition) and "Route Unclaimed Surplus to Food Bank" (what happens when a listing expires unclaimed, which it references directly). Per `use-case-uml/SKILL.md` Step 1, having a confirmed candidate and PR/FAQ behind each one means drafting the flow directly instead of interviewing from scratch, but the draft still gets presented for confirmation rather than treated as final on its own.

**Claude:** Drafted "List Surplus Produce" from the confirmed candidate and PR/FAQ: a member opens the surplus board, enters what they're offering, the app validates and publishes it, starts its claim window, and notifies other members. One Exception Path for a listing missing a description or quantity. Does this match how a listing actually gets created, and is there anything before or after this flow I'm missing?

**User (simulated):** Matches it. One addition: members without a smartphone use the paper-sheet fallback mentioned in the PR/FAQ, but that's the parks coordinator transcribing it later, not a real-time actor in this flow, so it doesn't need its own path here.

**Claude:** Agreed, that's a separate offline process, not a branch of this use case. Keeping it out. See `03a-list-surplus-produce.md`.

**Claude:** Drafted "Claim a Surplus Listing," building on 03a: a member finds an open listing and claims it, the app checks the claim window and marks it claimed, notifies the original lister, and removes it from the board. Two branches: two members racing to claim the same listing, and a claim attempt after the window's already expired. Does the "who wins the race" behavior match what you'd want, and is the claim window itself a fixed duration or configurable per garden?

**User (simulated):** Whoever the app processes first wins, that's fine, no need for a tiebreaker rule beyond that. Claim window length isn't decided yet, that's a real open question, don't invent a number for it.

**Claude:** Left it as an explicit `[CLAIM_WINDOW]` placeholder and Open Issue rather than guessing a value. See `03b-claim-surplus-listing.md`.

**Claude:** Drafted "Route Unclaimed Surplus to Food Bank," triggered when 03b's claim window expires unclaimed: the app marks it unclaimed, sends it to the garden's food bank contact, and marks it routed once received, with an Exception Path for the notification failing to reach the contact. How many retry attempts before that failure needs a human to step in?

**User (simulated):** Also not decided yet. Leave it open the same way as the claim window.

**Claude:** Left `[RETRY_COUNT]` as an Open Issue rather than guessing. All three use cases now live as separate files, `03a-list-surplus-produce.md`, `03b-claim-surplus-listing.md`, `03c-route-unclaimed-surplus-to-food-bank.md`, cross-linked by file path and using the same actor names throughout, which is what actually exercises use-case-uml's actor-consistency rule across a set of use cases instead of trivially satisfying it with one use case in isolation.

## use-case-test-cases / use-case-requirements / architect-review

**Claude:** Ran directly off the completed use case (Mode A for requirements); no further user input needed beyond what use-case-uml already gathered, per each skill's own workflow.
