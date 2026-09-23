# Test Case Format

Test cases are generated from a completed use case (see the use-case-uml skill's format).
Each test case verifies exactly one path from that use case: the Basic Path, or one
Alternate Path, or one Exception Path.

## Fields, in order

- **Test Case ID** — `TC-<UseCaseShortName>-<NN>`, e.g. `TC-ClientUpdate-01`.
- **Title** — short scenario description.
- **Covers** — the exact path label from the source use case (`Basic Path`, `Alternate Path
  A`, `Exception Path B`, etc.).
- **Preconditions** — the use case's Assumptions, plus any state needed to trigger this
  specific path.
- **Steps** — numbered actions a tester (or automation) performs and observes.
- **Expected Result** — copied from the use case's Post-Condition(s) for this path's exit
  point. Never invented or paraphrased from the flow itself.

## Table format

For short step lists, use one table per use case:

| Test Case ID | Title | Covers | Preconditions | Steps | Expected Result |
| --- | --- | --- | --- | --- | --- |

For longer step lists (roughly 4+ steps), use one block per test case instead, since a
single table cell with a long numbered list gets unreadable:

```
### TC-<UseCaseShortName>-<NN>: <Title>

**Covers:** <Path label>

**Preconditions:**
- ...

**Steps:**
1. ...

**Expected Result:**
- ...
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

---

## Worked Example

Source use case: "Client Update on First Launch" (see the use-case-uml skill's
`references/format.md` for the full use case this is built from — same Basic Path,
Alternate Path A, and Exception Path A, with Post-Condition(s) given per exit point).

### TC-ClientUpdate-01: Successful upgrade

**Covers:** Basic Path

**Preconditions:**
- Subscriber has installed the search application (or it is pre-installed).
- Subscriber's device and SIM are recognized by the network.
- Subscriber's device has reliable access to the network.
- Platform is configured to report that an upgrade is required.

**Steps:**
1. Launch the Client Application.
2. Observe the startup/loading screen, then the bundled page indicating an upgrade is
   required.
3. Click the upgrade link.
4. Observe the Device Browser launch to the URL Platform returned.
5. Allow the install to run.

**Expected Result:**
- Client Application's installed version matches the version Platform most recently
  delivered in the bundle response.

### TC-ClientUpdate-02: Subscriber exits without updating

**Covers:** Alternate Path A

**Preconditions:**
- Same as TC-ClientUpdate-01, through the bundled page being displayed.

**Steps:**
1. Launch the Client Application and reach the bundled page indicating an upgrade is
   required.
2. Exit the application without clicking the upgrade link.
3. Re-launch the Client Application.

**Expected Result:**
- Client Application's installed version is unchanged from before the attempt.
- Use case re-enters at Basic Path #1 on re-launch (no persisted "declined" state blocks the
  next prompt).

### TC-ClientUpdate-03: Platform unreachable

**Covers:** Exception Path A

**Preconditions:**
- Subscriber has installed the search application (or it is pre-installed).
- Subscriber's device and SIM are recognized by the network.
- Platform is unreachable or the device has no network connectivity.

**Steps:**
1. Launch the Client Application.
2. Observe the Client Application's request to Platform for bundles fail or time out.
3. Observe the friendly error message and the link to the [PARTNER_NAME] content site.
4. Click the content site link.

**Expected Result:**
- Client Application's installed version is unchanged.
- Subscriber's device browser has loaded the [PARTNER_NAME] content site home page.
