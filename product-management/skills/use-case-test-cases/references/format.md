# Test Case Format

Test cases are generated from a completed use case (see the use-case-uml skill's format).
Each test case verifies exactly one path from that use case: the Basic Path, or one
Alternate Path, or one Exception Path.

Test cases reference the source use case. They don't restate it. Assumptions, actor
actions, and post-conditions stay in the use case; a test case points to them by name and
step label and adds only what a tester needs to run the test: test data, how to set up the
path's trigger, and what to check.

## Fields, in order

- **Source** — once per set of test cases, a link to the use case:
  `**Source:** [Use Case: <Name>](<file or #anchor>)`.
- **Test Case ID** — `TC-<UseCaseShortName>-<NN>`, e.g. `TC-ClientUpdate-01`.
- **Title** — short scenario description.
- **Covers** — the exact path label from the source use case (`Basic Path`, `Alternate Path
  A6`, `Exception Path E3`, etc.).
- **Preconditions** — "Source use case Assumptions," plus only the extra state this path
  needs (e.g. "Platform is unreachable"). Don't copy the Assumptions list. A later test case
  can say "Same as TC-<...>-01" plus its own extra state.
- **Steps** — numbered tester actions and checks, each citing the use case step it exercises
  in parentheses, e.g. "Click the upgrade link (Basic Path #6)" or "Verify the error message
  and content site link (E3.2)." A run of steps with nothing to do or check can be one step:
  "Run Basic Path #1-5." Don't restate system actions the tester doesn't act on or check.
- **Expected Result** — the use case's Post-Condition(s) for this path's exit, labeled by
  exit, e.g. "Post-Condition (Exception Path E3 exit): ..." Copy the checkable state as
  written; never invent or paraphrase it.

## Table format

For short step lists, use one table per use case, under the Source line:

| Test Case ID | Title | Covers | Preconditions | Steps | Expected Result |
| --- | --- | --- | --- | --- | --- |

For longer step lists (roughly 4+ steps), use one block per test case instead, since a
single table cell with a long numbered list gets unreadable:

```
**Source:** [Use Case: <Name>](<file or #anchor>)

### TC-<UseCaseShortName>-<NN>: <Title>

**Covers:** <Path label>

**Preconditions:**
- Source use case Assumptions.
- <extra state for this path, if any>

**Steps:**
1. <tester action or check> (<use case step label>)

**Expected Result:**
- Post-Condition (<exit>): <checkable state, as written in the use case>
```

## Conventions

- Number test cases in the order the paths appear in the use case: Basic Path first, then
  Alternate Paths in their listed order, then Exception Paths in their listed order.
- If a use case gives separate Post-Condition(s) per exit point (see use-case-uml's
  convention for use cases with multiple terminal paths), match each test case's Expected
  Result to its own exit point, not the use case's first/only post-condition bullet.
- If a path's Expected Result would require inventing something the use case doesn't state,
  don't guess — write `NEEDS POST-CONDITION` and name what's missing, so it's visible that
  the source use case needs another pass rather than silently under-specifying the test.
- Never include the source use case itself, or a rewritten version of it, in the test case
  output.

---

## Worked Example

Source use case: "Client Update on First Launch" (see the use-case-uml skill's
`references/format.md` for the full use case this is built from — same Basic Path,
Alternate Path A6, and Exception Path E3, with Post-Condition(s) given per exit point).

**Source:** [Use Case: Client Update on First Launch](#use-case-client-update-on-first-launch)

### TC-ClientUpdate-01: Successful upgrade

**Covers:** Basic Path

**Preconditions:**
- Source use case Assumptions.
- Platform is configured to report that an upgrade is required.

**Steps:**
1. Launch the Client Application (Basic Path #1).
2. Verify the bundled page shows the Upgrade button (Basic Path #4-5).
3. Click the upgrade link (Basic Path #6).
4. Verify the Device Browser opens the URL Platform returned and starts the install (Basic
   Path #9-10).

**Expected Result:**
- Post-Condition (Basic Path exit): Client Application's installed version matches the
  version Platform most recently delivered in the bundle response.

### TC-ClientUpdate-02: Subscriber exits without updating

**Covers:** Alternate Path A6

**Preconditions:**
- Same as TC-ClientUpdate-01.

**Steps:**
1. Run Basic Path #1-5 (TC-ClientUpdate-01 steps 1-2).
2. Exit the application without clicking the upgrade link (A6.1).
3. Re-launch the Client Application and verify the bundled page appears again (A6.2, Basic
   Path #1-5).

**Expected Result:**
- `NEEDS POST-CONDITION`: the source use case has no Post-Condition(s) for Alternate Path
  A6. Expected: Client Application's installed version is unchanged, and no stored
  "declined" state blocks the next upgrade prompt. Confirm and add it to the use case.

### TC-ClientUpdate-03: Platform unreachable

**Covers:** Exception Path E3

**Preconditions:**
- Source use case Assumptions, except the device has no access to Platform.

**Steps:**
1. Launch the Client Application (Basic Path #1).
2. Verify the request for bundles fails or times out (E3.1).
3. Verify the friendly error message and the [PARTNER_NAME] content site link (E3.2).
4. Click the content site link and verify the Device Browser opens it (E3.3-E3.4).

**Expected Result:**
- Post-Condition (Exception Path E3 exit): Client Application's installed version is
  unchanged; Subscriber's device browser has loaded the [PARTNER_NAME] content site home
  page.
