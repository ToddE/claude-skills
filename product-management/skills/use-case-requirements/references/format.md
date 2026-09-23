# Functional Requirements Format

Requirements are derived one of two ways: from a completed use case (Mode A; see the
use-case-uml skill's format), or from a short interview when no use case exists yet (Mode
B; see use-case-requirements/SKILL.md). Every requirement traces back to a specific
source, either a part of the use case or a specific interview answer, the same
traceability discipline use-case-test-cases applies to Expected Results, applied here to
requirements instead.

## Requirement fields, in order

- **Requirement ID**: `REQ-<ShortName>-<NN>`, e.g. `REQ-ClientUpdate-01` (Mode A) or
  `REQ-LoyaltyNudge-01` (Mode B). `ShortName` is the use case's short name in Mode A, or a
  short name for the initiative agreed in Stage 1 of the interview in Mode B.
- **Requirement**: short imperative statement: "System shall...", "Client Application
  shall...".
- **Component**: the actor/system that owns this behavior.
- **Detail**: the specifics, pulled from the use case's Basic/Alternate/Exception Path
  steps (Mode A) or from the interview answers (Mode B).
- **Acceptance Criteria**: a checkable statement. In Mode A, reuse a Post-Condition's
  wording directly when the requirement maps to one. In Mode B, ask the user for it rather
  than inventing it, unless it's directly stated in their answer already.
- **Priority**: ask the user; never guess silently. Use whatever scale they use (MoSCoW,
  High/Medium/Low, P0-P3); don't impose one.
- **Source**: in Mode A, the exact Basic Path step number(s), Alternate/Exception Path
  label, or Post-Condition bullet. In Mode B, `Interview: Stage <N>, <topic>`.

## Table format

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |

## Export: Generic CSV (Jira-importable)

Columns, in this order, one row per requirement:

```
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
```

- **Summary** = the Requirement statement.
- **Description** = the Detail field.
- **Issue Type** = "Story" unless the user specifies otherwise.
- **Priority** = the Priority field, as given by the user.
- **Labels** = the use case's short name (e.g. `ClientUpdate`), so all requirements from one
  use case can be filtered together after import.
- **Epic Link** = left blank unless the user gives an epic key — don't invent one.
- **Acceptance Criteria** = the Acceptance Criteria field, semicolon-separated if there are
  multiple statements (commas inside a CSV field must stay inside the quoted value).
- **Source** = the traceability field, kept for reference even though most trackers won't
  have a matching column for it — better to carry it through unmapped than drop it.

Standard CSV quoting rules apply: quote any field containing a comma.

## Export: GitHub Issues markdown

One block per requirement:

```
### <Requirement statement>

**Labels:** <use-case-short-name>, <priority-if-set>

<Detail>

**Acceptance Criteria**
- <criterion>

**Source:** <use case name>, <Basic/Alternate/Exception Path reference>
```

Each block is ready to paste into the GitHub UI, or to save as its own file and create with
`gh issue create --title "<Requirement statement>" --body-file <file>`.

## Worked Examples

### Mode A: From a use case

Source use case: "Client Update on First Launch" (same use case used in
`use-case-uml/references/format.md` and `use-case-test-cases/references/format.md`).

### Requirements table

Basic Path steps 1-2 (Subscriber launches, Client Application shows the loading screen)
aren't their own requirements: step 1 is the trigger, and step 2 has no independently
nameable failure mode worth tracking on its own. Steps 3 and 4 look like one requirement at
first glance, but they're owned by two different components with two different ways to
fail ("Client Application never asked" vs. "Platform never responded with the right
decision"), so they split. Steps 6-10 cross three components (Subscriber, Client
Application, Platform, Device Browser) but describe one atomic handoff with a single
externally observable outcome, "clicking the link starts the browser install," that nobody
would test in parts, so they merge into one requirement instead of four.

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-ClientUpdate-01 | Client Application shall request bundle/version info from Platform on every launch. | Client Application | Basic Path steps 2-3: Client Application shows the loading screen while it asks Platform for bundles. | Platform receives exactly one bundle request per launch. | Must | Basic Path #2-3 |
| REQ-ClientUpdate-02 | Platform shall indicate to Client Application whether an update is required and, if so, supply an Upgrade prompt. | Platform | Basic Path step 4: Platform's bundle response includes an update-required flag and Upgrade button content when applicable. | Client Application's bundle response includes the update-required flag matching Platform's actual latest version. | Must | Basic Path #4 |
| REQ-ClientUpdate-03 | Client Application shall display Platform's required-update page to the Subscriber, including a working Upgrade link. | Client Application | Basic Path step 5. | The Subscriber sees the bundled page with a functioning Upgrade link when Platform's response flagged a required update. | Must | Basic Path #5 |
| REQ-ClientUpdate-04 | Client Application shall let the subscriber decline an update without blocking future retries. | Client Application | Exiting without clicking the upgrade link must not persist a "declined" state. | Client Application's installed version is unchanged after decline; use case re-enters at Basic Path #1 on re-launch. | Should | Alternate Path A |
| REQ-ClientUpdate-05 | Client Application shall complete the platform-guided install handoff when the Subscriber clicks the upgrade link. | Client Application | Basic Path steps 6-10: follows the link to Platform, launches the Device Browser to the URL Platform provides, and the browser starts the install. | Clicking the upgrade link results in the Device Browser starting the update install, matching the version Platform most recently delivered. | Must | Basic Path #6-10, Post-Condition (Basic Path exit) |
| REQ-ClientUpdate-06 | Client Application shall degrade gracefully when Platform is unreachable. | Client Application | Show a friendly error message with a fallback link to the content site rather than failing silently. | Client Application's installed version is unchanged; subscriber's device browser has loaded the [PARTNER_NAME] content site home page. | Must | Exception Path A, Post-Condition (Exception Path A exit) |

### CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"Client Application shall request bundle/version info from Platform on every launch.","Basic Path steps 2-3: Client Application shows the loading screen while it asks Platform for bundles.",Story,Must,ClientUpdate,,"Platform receives exactly one bundle request per launch.","Basic Path #2-3"
"Platform shall indicate to Client Application whether an update is required and, if so, supply an Upgrade prompt.","Basic Path step 4: Platform's bundle response includes an update-required flag and Upgrade button content when applicable.",Story,Must,ClientUpdate,,"Client Application's bundle response includes the update-required flag matching Platform's actual latest version.","Basic Path #4"
"Client Application shall display Platform's required-update page to the Subscriber, including a working Upgrade link.","Basic Path step 5.",Story,Must,ClientUpdate,,"The Subscriber sees the bundled page with a functioning Upgrade link when Platform's response flagged a required update.","Basic Path #5"
"Client Application shall let the subscriber decline an update without blocking future retries.","Exiting without clicking the upgrade link must not persist a ""declined"" state.",Story,Should,ClientUpdate,,"Client Application's installed version is unchanged after decline; use case re-enters at Basic Path #1 on re-launch.","Alternate Path A"
"Client Application shall complete the platform-guided install handoff when the Subscriber clicks the upgrade link.","Basic Path steps 6-10: follows the link to Platform, launches the Device Browser to the URL Platform provides, and the browser starts the install.",Story,Must,ClientUpdate,,"Clicking the upgrade link results in the Device Browser starting the update install, matching the version Platform most recently delivered.","Basic Path #6-10, Post-Condition (Basic Path exit)"
"Client Application shall degrade gracefully when Platform is unreachable.","Show a friendly error message with a fallback link to the content site rather than failing silently.",Story,Must,ClientUpdate,,"Client Application's installed version is unchanged; subscriber's device browser has loaded the [PARTNER_NAME] content site home page.","Exception Path A, Post-Condition (Exception Path A exit)"
```

### GitHub Issues markdown (one requirement shown)

```
### Platform shall indicate to Client Application whether an update is required and, if so, supply an Upgrade prompt.

**Labels:** ClientUpdate, Must

Basic Path step 4: Platform's bundle response includes an update-required flag and Upgrade
button content when applicable.

**Acceptance Criteria**
- Client Application's bundle response includes the update-required flag matching
  Platform's actual latest version.

**Source:** Client Update on First Launch, Basic Path #4
```

### Mode B: From an interview

No use case exists yet. The interview surfaced this:

- **Stage 1** (what is it): a notification that alerts subscribers when they're close to
  earning a loyalty reward.
- **Stage 2** (who/problem): subscribers enrolled in the loyalty program don't know when
  they're close to a reward, so they under-redeem and disengage from the program.
- **Stage 3** (what it needs to do): trigger a push notification when a subscriber crosses
  [THRESHOLD]% progress toward their next reward; respect each subscriber's notification
  preferences; cap it at one per subscriber per day; skip and log rather than retry
  indefinitely if the subscriber's push token is invalid.

#### Requirements table

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-LoyaltyNudge-01 | Notification Service shall notify a subscriber by push when they cross [THRESHOLD]% progress toward their next loyalty reward. | Notification Service | Trigger condition from the interview. | Subscriber receives exactly one push notification within [TIME_WINDOW] of crossing the threshold. | Must | Interview: Stage 3, trigger condition |
| REQ-LoyaltyNudge-02 | Notification Service shall respect each subscriber's notification preferences before sending. | Notification Service | From the interview's notification-preferences constraint. | No notification is sent to a subscriber who has disabled loyalty notifications. | Must | Interview: Stage 3, notification preferences |
| REQ-LoyaltyNudge-03 | Notification Service shall cap loyalty notifications at one per subscriber per day. | Notification Service | From the interview's frequency-cap constraint. | No subscriber receives more than one loyalty notification within a rolling 24-hour period. | Should | Interview: Stage 3, frequency cap |
| REQ-LoyaltyNudge-04 | Notification Service shall skip and log, rather than retry indefinitely, when a subscriber's push token is invalid. | Notification Service | From the interview's failure-handling answer. | An invalid-token send attempt produces exactly one log entry and no retry-queue entry. | Must | Interview: Stage 3, failure handling |

Note what Mode B does *not* do: it doesn't invent a threshold percentage, a time window, or
a retry policy detail the interview didn't give. `[THRESHOLD]` and `[TIME_WINDOW]` stay as
bracket placeholders until the user supplies them, the same convention use-case-uml uses
for `[PARTNER_NAME]`.
