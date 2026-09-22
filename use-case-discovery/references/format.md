# Candidate Use Case List Format

This is a scoping artifact, not a use case. It exists to agree on what set of use cases an
initiative needs before spending time writing each one out in full with use-case-uml.

## Table format

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| `<Use Case Name>` | One sentence. | Comma-separated, 2-4 actors. | Blank if it continues from another candidate. |

## Conventions

- **Name** must be short enough to become the eventual `Use Case: <Short Name>` title
  as-is — don't write a sentence here.
- **Summary** is one sentence: what the actor is doing and why, same shape use-case-uml
  expects as the use case's opening line.
- **Rough Actors** should reuse the same name for the same real-world thing across every
  row in the table. If two rows both involve "the backend platform," decide on one name for
  it now (e.g. "Platform") — use-case-uml will enforce this consistency later, so fixing it
  here avoids rework.
- **Rough Trigger** is left blank when a candidate is really a continuation of another
  candidate's flow rather than its own externally-triggered entry point. A blank Rough
  Trigger is a signal the two candidates might actually be one use case with an Alternate
  Path, not two — flag it for the user to confirm during review.
- Order the table in a rough natural sequence when one exists (setup/onboarding first,
  primary flow next, then supporting/error-recovery flows) — this ordering becomes the
  suggested drafting order when handing off to use-case-uml.

## Worked Example

**Initiative:** T-Mobile Rich Client — a search client application that lets subscribers
browse and purchase mobile content (ringtones, wallpapers), backed by a search platform and
integrated with T-Mobile's account and entitlement systems.

**Goals:**
- Let subscribers search and purchase content from within the client.
- Respect each subscriber's class-of-service (COS) entitlements.
- Surface T-Mobile account information inside the client.
- Keep the client itself up to date without requiring an app-store-style update flow.

**Out of scope (for this pass):** payment processing details, content DRM.

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Client Update on First Launch | The client detects it's out of date on first launch and walks the subscriber through updating. | Subscriber, Client Application, Platform, Device Browser | Subscriber launches the client for the first time. |
| Subscriber Session | The client establishes a subscriber's class-of-service for the session so the platform can gate content correctly. | Subscriber, Client Application, Platform, Tmo Platform (PPI) | |
| Client Search & Purchase | The subscriber searches for content, previews it, and purchases it from within the client. | Subscriber, Client Application, Platform, Entitlement Platform | Subscriber enters a search term. |
| My Account Integration | The subscriber views their T-Mobile account information from within the client. | Subscriber, Client Application, Platform, Tmo Platform (My Account) | Subscriber chooses to view "My Account." |

Notes for review with the user:
- "Subscriber Session" has no Rough Trigger because it's really invoked mid-flow by
  whichever use case first needs a COS lookup (e.g. Client Search & Purchase) — confirm
  whether this should stay a standalone use case that others link to (recommended, since
  multiple flows need the same COS lookup), or get folded into each caller as a shared
  step.
- "Platform" and "Tmo Platform" are kept as separate actors deliberately: the client always
  talks to one search/content platform, which in turn calls out to different T-Mobile-owned
  systems depending on the use case (PPI for COS, My Account for account data). Confirm this
  matches the real system boundaries before drafting.
