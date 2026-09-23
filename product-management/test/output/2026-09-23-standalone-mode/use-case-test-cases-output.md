# Test Cases: Library Book Hold Pickup

Produced standalone by `use-case-test-cases`, from a fully-written use case pasted cold into
the conversation (see `dialogue.md` for the full pasted use case and the exchange). This use
case was written fresh for this test and does not appear anywhere else in this repo.

### TC-LibraryHoldPickup-01: Successful pickup

**Covers:** Basic Path

**Preconditions:**
- Patron placed the hold online and received a "ready for pickup" notification.
- The book has physically arrived at the branch and been shelved on the hold shelf.

**Steps:**
1. Approach the hold shelf desk and give name or library card.
2. Observe Library Staff search Catalog System for ready holds.
3. Observe Catalog System display the ready-for-pickup hold.
4. Observe Library Staff retrieve the book from the hold shelf.
5. Observe Library Staff scan the book's barcode to check it out.
6. Receive the book from Library Staff.

**Expected Result:**
- Catalog System shows the item checked out to the patron and the original hold marked
  fulfilled.

### TC-LibraryHoldPickup-02: Hold expired past pickup window

**Covers:** Alternate Path A

**Preconditions:**
- Patron placed a hold online that has since passed its pickup window without being
  collected.

**Steps:**
1. Approach the hold shelf desk and give name or library card.
2. Observe Library Staff search Catalog System and find the hold status "expired."
3. Be informed by Library Staff that the hold expired, and be offered a re-place.
4. Request a new hold.
5. Observe Catalog System create a new hold record.

**Expected Result:**
- Catalog System shows a new hold record for the patron in queue; the original hold record
  shows status "expired."

### TC-LibraryHoldPickup-03: Book missing from shelf despite system showing it ready

**Covers:** Exception Path A

**Preconditions:**
- Patron placed the hold online and received a "ready for pickup" notification; Catalog
  System shows the item as shelved and ready, but the physical book is not on the shelf.

**Steps:**
1. Approach the hold shelf desk and give name or library card.
2. Observe Library Staff search Catalog System and confirm the hold shows ready.
3. Observe Library Staff search the hold shelf and fail to locate the book.
4. Observe Library Staff mark the item "missing" in Catalog System.
5. Be informed of the issue and offered a branch-network search or a wait for follow-up.

**Expected Result:**
- Catalog System shows the item status as "missing"; the original hold remains active and
  flagged for staff follow-up.

---

**Step 4 self-check (run before presenting):** each of the three paths (Basic, Alternate
Path A, Exception Path A) has exactly one test case; every Expected Result is copied
verbatim from the matching Post-Condition(s) bullet in the source use case, not paraphrased;
Test Case IDs are unique and sequential; no test case invents a system behavior the use case
doesn't state (TC-03 does not assume the missing book is ever found, since the source use
case's Exception Path A is a genuine terminal exit, not a rejoin).
