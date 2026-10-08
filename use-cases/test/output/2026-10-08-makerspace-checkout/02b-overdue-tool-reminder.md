### Use Case: Overdue Tool Reminder

Inventory reminds a member to return a tool that has passed its due time, and alerts shop
staff if it stays overdue.

**Assumptions**
- A checkout record exists with a due time (see [Use Case: Member Tool Checkout](#use-case-member-tool-checkout))
- Notification Service has each member's email, phone, and contact preference, synced from
  Member Database
- Notification Service has the Shop Staff alert list

**Actors**
- Inventory: The system of record for tools, their status, and checkout records.
- Notification Service: The service that sends email and SMS messages for Foundry.
- Member: The Foundry Makerspace member who has the overdue tool.
- Shop Staff: A staff member who follows up on tools that stay overdue.

**Trigger(s)**
- A checkout passes its due time with no return recorded.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Inventory | Detects a checkout record past its due time with no return recorded |
| 2. | Inventory | Sets the checkout status to Overdue |
| 3. | Inventory | Requests a reminder from Notification Service with the member ID, tool name, and due time |
| 4. | Notification Service | Sends Member a reminder email with the tool name, due time, and return instructions |
| 5. | Member | Returns the tool (see [Use Case: Tool Return](#use-case-tool-return)) |
| 6. | Inventory | Records the return time and sets the checkout status to Returned |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path A4 (from Basic Path #4): Member prefers SMS
  - A4.1 **Notification Service:** Sends **Member** the reminder by SMS to the phone number
    on file.
  - A4.2 Use case continues at Basic Path #5.

**Exception Paths**

- Exception Path E4 (from Basic Path #4): Reminder email bounces
  - E4.1 **Notification Service:** Receives a bounce for the Member's email address.
  - E4.2 TBD

- Exception Path E5 (from Basic Path #5): Tool stays overdue
  - E5.1 **Inventory:** Detects the checkout is still Overdue [ESCALATION_HOURS] after the
    due time.
  - E5.2 **Inventory:** Requests an escalation alert from **Notification Service**.
  - E5.3 **Notification Service:** Sends **Shop Staff** an alert with the member name, tool
    name, and hours overdue.
  - E5.4 **Shop Staff:** Contacts **Member** directly.
  - E5.5 Use case continues at Basic Path #5.

**Post-Condition(s)**
- **Basic Path exit:** The checkout record's status is Returned with a return time, and
  Notification Service's message log holds one reminder to Member for this checkout. If E5
  ran, the log also holds one escalation alert to Shop Staff for this checkout.

**Open Issues/Notes**
- E4: should a bounced email fall back to SMS, alert Shop Staff, or both?
- Should a member get a second reminder before escalation, and at what interval?
- Tool Return hasn't been drafted yet; step 5 links to it as a placeholder.
