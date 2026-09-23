# Functional Requirements: 2FA Reminder Banner (Mode B, interview only)

Produced standalone by `use-case-requirements`, Mode B (no use case, no PR/FAQ existed). See
`dialogue.md` for the full three-stage interview this was derived from.

**Interview summary:**
- **Stage 1:** A dismissible dashboard banner reminding logged-in users who haven't enabled
  two-factor authentication (2FA) to do so, linking to 2FA setup.
- **Stage 2:** Existing paid-tier customers who signed up before 2FA existed and never
  enabled it; security team traces a meaningful share of account-takeover tickets to
  accounts without 2FA, which otherwise get no ongoing prompt beyond a buried settings page.
- **Stage 3:** Shows on dashboard load for any logged-in, non-2FA user; stops permanently the
  moment 2FA is enabled; on dismissal, snoozes 14 days then resumes, restarting the snooze on
  each subsequent dismissal (including after an abandoned setup attempt); SSO-provisioned
  accounts are excluded entirely, since their IdP handles the 2FA-equivalent outside this
  system; no escalation behavior; no durable per-dismissal logging beyond the snooze-until
  state; the 2FA setup flow itself is out of scope.

## Requirements table

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-TwoFABanner-01 | Dashboard shall show the 2FA reminder banner on load for any logged-in user without 2FA enabled. | Dashboard | Show condition from the interview. | Banner is visible on every dashboard load for a non-2FA user not currently in a snooze window. | High | Interview: Stage 3, show condition |
| REQ-TwoFABanner-02 | Dashboard shall stop showing the banner permanently once the user enables 2FA. | Dashboard | Permanent-stop condition from the interview; enabling 2FA is the real success condition, not dismissal. | No banner appears for a user on any dashboard load after their account shows 2FA enabled. | High | Interview: Stage 3, permanent-stop condition |
| REQ-TwoFABanner-03 | Dashboard shall snooze the banner for 14 days after a dismissal, and shall resume showing it on the normal schedule after the snooze expires if 2FA is still not enabled. | Dashboard | Snooze/resume behavior, including the case where the user abandoned 2FA setup after clicking through the banner: the interview confirmed that case has no special handling and just follows the normal resume rule. | Banner does not appear for 14 days after a dismissal; on day 15+, banner reappears on dashboard load if 2FA is still not enabled, whether or not the user attempted and abandoned setup during the snoozed period. | High | Interview: Stage 3, snooze/resume behavior |
| REQ-TwoFABanner-04 | Dashboard shall restart the 14-day snooze on each subsequent dismissal. | Dashboard | Restart-on-redismiss rule from the interview. | Each dismissal sets a new snooze-until date 14 days out, replacing any prior snooze-until value. | Medium | Interview: Stage 3, snooze/resume behavior |
| REQ-TwoFABanner-05 | Dashboard shall never show the 2FA banner to accounts provisioned through the enterprise SSO integration. | Dashboard | SSO exclusion from the interview: SSO accounts' identity provider handles the 2FA-equivalent outside this system, so showing the banner would be actively wrong. | No SSO-provisioned account is ever shown the banner, regardless of its 2FA-enabled status. | High | Interview: Stage 3, SSO exclusion |
| REQ-TwoFABanner-06 | Dashboard shall not escalate the banner's presentation (tone, frequency, or urgency) beyond the standard snooze/resume schedule. | Dashboard | No-escalation constraint, stated directly to keep this from growing scope beyond what was asked. | The banner's copy and presentation are identical on every occurrence; no variant appears based on how many times it has been dismissed. | Medium | Interview: Stage 3, no-escalation constraint |

## Export: Generic CSV (Jira-importable)

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"Dashboard shall show the 2FA reminder banner on load for any logged-in user without 2FA enabled.","Show condition from the interview.",Story,High,TwoFABanner,,"Banner is visible on every dashboard load for a non-2FA user not currently in a snooze window.","Interview: Stage 3, show condition"
"Dashboard shall stop showing the banner permanently once the user enables 2FA.","Permanent-stop condition from the interview; enabling 2FA is the real success condition, not dismissal.",Story,High,TwoFABanner,,"No banner appears for a user on any dashboard load after their account shows 2FA enabled.","Interview: Stage 3, permanent-stop condition"
"Dashboard shall snooze the banner for 14 days after a dismissal, and shall resume showing it on the normal schedule after the snooze expires if 2FA is still not enabled.","Snooze/resume behavior, including the case where the user abandoned 2FA setup after clicking through the banner: the interview confirmed that case has no special handling and just follows the normal resume rule.",Story,High,TwoFABanner,,"Banner does not appear for 14 days after a dismissal; on day 15+, banner reappears on dashboard load if 2FA is still not enabled, whether or not the user attempted and abandoned setup during the snoozed period.","Interview: Stage 3, snooze/resume behavior"
"Dashboard shall restart the 14-day snooze on each subsequent dismissal.","Restart-on-redismiss rule from the interview.",Story,Medium,TwoFABanner,,"Each dismissal sets a new snooze-until date 14 days out, replacing any prior snooze-until value.","Interview: Stage 3, snooze/resume behavior"
"Dashboard shall never show the 2FA banner to accounts provisioned through the enterprise SSO integration.","SSO exclusion from the interview: SSO accounts' identity provider handles the 2FA-equivalent outside this system, so showing the banner would be actively wrong.",Story,High,TwoFABanner,,"No SSO-provisioned account is ever shown the banner, regardless of its 2FA-enabled status.","Interview: Stage 3, SSO exclusion"
"Dashboard shall not escalate the banner's presentation (tone, frequency, or urgency) beyond the standard snooze/resume schedule.","No-escalation constraint, stated directly to keep this from growing scope beyond what was asked.",Story,Medium,TwoFABanner,,"The banner's copy and presentation are identical on every occurrence; no variant appears based on how many times it has been dismissed.","Interview: Stage 3, no-escalation constraint"
```

## Export: GitHub Issues markdown

```
### Dashboard shall show the 2FA reminder banner on load for any logged-in user without 2FA enabled.

**Labels:** TwoFABanner, High

Show condition from the interview.

**Acceptance Criteria**
- Banner is visible on every dashboard load for a non-2FA user not currently in a snooze window.

**Source:** 2FA Reminder Banner (interview), Stage 3, show condition
```

```
### Dashboard shall stop showing the banner permanently once the user enables 2FA.

**Labels:** TwoFABanner, High

Permanent-stop condition from the interview; enabling 2FA is the real success condition, not dismissal.

**Acceptance Criteria**
- No banner appears for a user on any dashboard load after their account shows 2FA enabled.

**Source:** 2FA Reminder Banner (interview), Stage 3, permanent-stop condition
```

```
### Dashboard shall snooze the banner for 14 days after a dismissal, and shall resume showing it on the normal schedule after the snooze expires if 2FA is still not enabled.

**Labels:** TwoFABanner, High

Snooze/resume behavior, including the case where the user abandoned 2FA setup after clicking through the banner: the interview confirmed that case has no special handling and just follows the normal resume rule.

**Acceptance Criteria**
- Banner does not appear for 14 days after a dismissal; on day 15+, banner reappears on dashboard load if 2FA is still not enabled, whether or not the user attempted and abandoned setup during the snoozed period.

**Source:** 2FA Reminder Banner (interview), Stage 3, snooze/resume behavior
```

```
### Dashboard shall restart the 14-day snooze on each subsequent dismissal.

**Labels:** TwoFABanner, Medium

Restart-on-redismiss rule from the interview.

**Acceptance Criteria**
- Each dismissal sets a new snooze-until date 14 days out, replacing any prior snooze-until value.

**Source:** 2FA Reminder Banner (interview), Stage 3, snooze/resume behavior
```

```
### Dashboard shall never show the 2FA banner to accounts provisioned through the enterprise SSO integration.

**Labels:** TwoFABanner, High

SSO exclusion from the interview: SSO accounts' identity provider handles the 2FA-equivalent outside this system, so showing the banner would be actively wrong.

**Acceptance Criteria**
- No SSO-provisioned account is ever shown the banner, regardless of its 2FA-enabled status.

**Source:** 2FA Reminder Banner (interview), Stage 3, SSO exclusion
```

```
### Dashboard shall not escalate the banner's presentation (tone, frequency, or urgency) beyond the standard snooze/resume schedule.

**Labels:** TwoFABanner, Medium

No-escalation constraint, stated directly to keep this from growing scope beyond what was asked.

**Acceptance Criteria**
- The banner's copy and presentation are identical on every occurrence; no variant appears based on how many times it has been dismissed.

**Source:** 2FA Reminder Banner (interview), Stage 3, no-escalation constraint
```

---

**Self-check (run before presenting):** every Source cites a specific interview stage/topic
(Mode B, never a use case reference); every distinct Stage 3 answer produced at least one
requirement, nothing dropped; the abandoned-setup case was folded into REQ-TwoFABanner-03
rather than written as a near-duplicate row, since it's the same underlying rule applied to
a different cause; Acceptance Criteria came directly from numbers and rules the user stated,
no bracket placeholders needed; Priority was asked for directly (High/Medium/Low) rather
than guessed.
