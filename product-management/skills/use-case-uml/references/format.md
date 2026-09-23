# Use Case Format

When writing an integration use case, follow this structure exactly.

## Title
`Use Case: <Short Name>`

Followed by one sentence describing what the actor is doing and why.

## Sections, in order

**Assumptions** — bullet list of preconditions that must be true before the flow starts.

**Actors** — bullet list, one per actor, formatted as:
`- <Actor Name>: <one-line description of their role>`

**Trigger(s)** *(optional, only when the flow starts from an external event rather than a
prior use case)* — bullet list of what kicks off the flow.

**Basic Path** — a table with columns `Step | Actor | Action`. Leave the Step column blank
unless a step is referenced later. Every row must have a distinct step number, and no two
consecutive rows may be the same actor performing the same action — if the same actor acts
twice in a row, the second action must be distinct enough to plausibly branch into its own
alternate or exception path (a decision, a check, a response), not a restatement of the
first. Final row is always:
`| | | END OF USE CASE |`

**Alternate Paths** — bullet list. Each item:
`- Alternate Path (from Basic Path #<N>): <what diverges>`
followed by a numbered list of the diverging steps, ending with either:
`Use case continues at Basic Path #<N>.` (the path rejoins the Basic Path), or
`End of use case.` (the path is itself a terminal exit; see the "Client Update on First
Launch" worked example's Exception Path A).

**Exception Paths** — same pattern as Alternate Paths, but for error or failure branches
instead of valid variations, and ending the same way: either a rejoin ("Use case continues
at Basic Path #<N>.") or a terminal exit ("End of use case."), whichever actually describes
where the path goes. Use `TBD` for steps not yet worked out rather than leaving the
item off.

**Post-Condition(s)** — bullet list of what is verifiably true once the use case ends
(successfully or via a terminal Alternate/Exception Path). These exist so a test case can be
written directly from them, so phrase each as a checkable state, not a narrative summary:
name the specific record, field, or system state that changed and what it changed to (e.g.
"Live Inventory contains a new record associating the RFID UIDs with the menu item and a
'born on' timestamp," not "the item is commissioned"). If a use case has multiple exit
points (Basic Path vs. a terminal Alternate/Exception Path), give the post-condition(s) for
each exit separately. Always include this section, even if it's a single bullet. If
genuinely nothing changes as a result of the use case, write "None." rather than omitting
the section.

**Open Issues/Notes** — bullet list of unresolved questions or follow-up items raised while
writing the use case.

## Conventions

- Bracket placeholders like `[PARTNER_NAME]` mark values that vary by partner/integration.
- Link to a related use case with `[Use Case: <Name>](#<anchor>)` rather than restating its
  steps.
- Keep Actor names consistent across use cases in the same document (e.g. always
  "HealthMesh," not "the platform").

---

## Worked Examples

### Use Case: Chef Input (Commissioning)

The chef commissions a freshly made menu item by associating its RFID-tagged plates with
that item in the system.

**Assumptions**
- All appropriate menu items are loaded
- RFID reader is connected and operational
- Each plate has a unique RFID
- Location Identity is set for each location/instance of the application when the
  application is setup
- System is running and displaying the Chef Interface
- System is actively scanning the chef workspace for RFID tags

**Actors**
- Chef: Kitchen staff member preparing menu items and commissioning them to the belt via
  the Chef Interface.
- System: The platform, including the RFID reader, Chef Interface, and Live Inventory.

**Trigger(s)**
- Chef has made the menu item and wishes to commission it for the belt and timer.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | System | Presents a list of menu items and active updates regarding Live Inventory (see Chef UI) |
| 2. | Chef | Creates menu item and places it on the appropriate colored plates |
| 3. | Chef | Places plates on workspace |
| 4. | Chef | Uses a touch screen to touch/click the picture and/or description of the menu item that is on the plates |
| 5. | System | Determines which RFID tags are in the Chef's workspace |
| 6. | System | Associates RFID tags in the Chef's workspace with the menu item that the Chef touched |
| 7. | System | Displays the number of RFID tags associated and the plate description and menu description (e.g. "8 purple plates scanned with Spider Roll") |
| 8. | System | Asks Chef to confirm scan |
| 9. | Chef | Confirms scan |
| 10. | System | Writes values (RFID UIDs with their menu item association and "born on" timestamp) to the Live Inventory |
| | | END OF USE CASE |

**Alternate Paths**

- No alternate paths identified for this use case.

**Exception Paths**

- Exception Path (from Basic Path #5): System does not see any RFID tags to associate
  5. System: Does not see any RFID tags and cannot associate any UIDs with menu item values.
  6. System: Notifies Chef and asks Chef to take corrective action (make certain plates are
     in workspace, make certain RFID antennas are working, etc).
  7. Chef: Acknowledges message.
  8. Use case continues at Basic Path #1.

- Exception Path (from Basic Path #9): Chef does not confirm scan
  9. Chef: Indicates that there is an error in the scan (number or type of plates does not
     match).
  10. System: Suggests corrective actions.
  11. Chef: Acknowledges system message.
  12. Chef: Makes any necessary changes.
  13. Use case continues at Basic Path #4.

**Post-Condition(s)**
- Live Inventory is updated with the newly commissioned menu item and its associated RFID
  UIDs.

**Open Issues/Notes**
- **Chef commissioning approach:** should plates be provisioned before or after the menu item
  is placed on them? Provisioning first requires logic for re-commissioning plates that go
  unpopulated; commissioning at time-of-use risks more scanning errors. 
  - **Proposed Resolution:** dedicated plate-holders at each station to prevent over-scanning, or having
  the interface reflect all scanned plates and letting the Chef pick a color (without
  picking a quantity) to associate with the menu item.

---

### Use Case: Client Update on First Launch

The client detects that it's out of date on first launch and walks the subscriber through
updating to the latest version.

**Assumptions**
- Subscriber has installed the search application (or it is pre-installed)
- Subscriber's device and SIM are recognized by the network
- Subscriber's device has reliable access to the network

**Actors**
- Subscriber: The end-user of the search application.
- Client Application: The search application running on the subscriber's device.
- Platform: The backend service the Client Application talks to for bundles, updates, and
  content.
- Device Browser: The device's native web browser, used to complete the update install.

**Trigger(s)**
- Subscriber launches the search application for the first time.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Subscriber | Launches the Client Application |
| 2. | Client Application | Runs and shows the startup/loading screen |
| 3. | Client Application | Asks Platform for bundles |
| 4. | Platform | Delivers bundles to the client stating that an upgrade is required, presenting an Upgrade button |
| 5. | Client Application | Displays the bundled page to the Subscriber |
| 6. | Subscriber | Clicks the upgrade link |
| 7. | Client Application | Follows the link to Platform |
| 8. | Platform | Looks up the location for the client download and sends a redirect to the Client Application |
| 9. | Client Application | Launches the Device Browser to the URL indicated by Platform |
| 10. | Device Browser | Launches install of the upgrade |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #6): Subscriber exits the client without updating
  6. Subscriber: Does not click the update link and exits the application.
  7. Use case continues at Basic Path #1 when the client re-launches.

**Exception Paths**

- Exception Path (from Basic Path #3): Platform does not respond, or the network is
  unavailable
  3. Platform: Does not respond, or the network is unavailable.
  4. Client Application: Returns a friendly message ("Unable to download latest version;
     please try again later") and shows a link to the [PARTNER_NAME] content site.
  5. Subscriber: Clicks the content site link.
  6. Client Application: Launches the Device Browser to the content site home page.
  7. End of use case.

**Post-Condition(s)**
- **Basic Path exit:** Client Application's installed version matches the version Platform most
  recently delivered in the bundle response.
- **Exception Path A exit (Platform unreachable):** Client Application's installed version is
  unchanged; Subscriber's device browser has loaded the [PARTNER_NAME] content site home
  page.

**Open Issues/Notes**
- None identified.
