# Functional Requirements: Chef Input (Commissioning)

Basic Path steps 1-3 (Kaiten IQ presenting the menu list; the chef preparing the item and
placing it on plates) aren't their own requirements: step 1 has no independently nameable
failure mode worth tracking on its own, and steps 2-3 are physical chef actions outside
Kaiten IQ's own behavior. Steps 5 and 6 look like one requirement at first glance (both
"Kaiten IQ" acting on the same workspace scan), but they're two distinct effects with two
different ways to fail ("Kaiten IQ saw the wrong tags" vs. "Kaiten IQ associated the right
tags with the wrong item"), so they split. Steps 8 and 9 merge into one requirement about
gating the write on confirmation, since a confirmation prompt with no chef response has no
observable outcome on its own.

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-ChefInput-01 | Kaiten IQ shall detect which RFID tags are present in the chef's workspace when the chef selects a menu item at the Chef Interface. | Kaiten IQ | Basic Path steps 4-5. | The set of RFID UIDs Kaiten IQ detects matches the plates physically in the chef's workspace at the moment of selection. | Must | Basic Path #4-5 |
| REQ-ChefInput-02 | Kaiten IQ shall associate each detected RFID tag with the chef-selected menu item. | Kaiten IQ | Basic Path step 6. | Every detected RFID UID is tagged, in memory, with the menu item the chef touched, before any confirmation prompt is shown. | Must | Basic Path #6 |
| REQ-ChefInput-03 | Kaiten IQ shall display the count of associated RFID tags and the plate/menu description to the chef before committing the scan. | Kaiten IQ | Basic Path step 7. | The Chef Interface shows a count and description matching the association made in REQ-ChefInput-02, before Live Inventory is written. | Must | Basic Path #7 |
| REQ-ChefInput-04 | Kaiten IQ shall require explicit chef confirmation before committing a commissioning scan to Live Inventory. | Kaiten IQ | Basic Path steps 8-9. | No Live Inventory write occurs for a scan the chef hasn't confirmed. | Must | Basic Path #8-9 |
| REQ-ChefInput-05 | Kaiten IQ shall write the associated RFID UIDs, menu item, and a "born on" timestamp to Live Inventory upon chef confirmation. | Kaiten IQ | Basic Path step 10, Post-Condition. | Live Inventory contains a new record for each confirmed RFID UID, its menu item, and a "born on" timestamp immediately after confirmation. | Must | Basic Path #10, Post-Condition |
| REQ-ChefInput-06 | Kaiten IQ shall notify the chef and prompt corrective action when no RFID tags are detected in the workspace at scan time. | Kaiten IQ | Exception Path A. | When zero RFID tags are detected at scan time, the chef sees a corrective-action message instead of a silent failure or an empty commissioning record. | Must | Exception Path A |
| REQ-ChefInput-07 | Kaiten IQ shall let the chef reject a scan and suggest corrective action without committing that scan to Live Inventory. | Kaiten IQ | Exception Path B. | A rejected scan produces no Live Inventory write, and the chef sees a corrective-action suggestion before re-scanning. | Should | Exception Path B |

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"Kaiten IQ shall detect which RFID tags are present in the chef's workspace when the chef selects a menu item at the Chef Interface.","Basic Path steps 4-5.",Story,Must,ChefInput,,"The set of RFID UIDs Kaiten IQ detects matches the plates physically in the chef's workspace at the moment of selection.","Basic Path #4-5"
"Kaiten IQ shall associate each detected RFID tag with the chef-selected menu item.","Basic Path step 6.",Story,Must,ChefInput,,"Every detected RFID UID is tagged, in memory, with the menu item the chef touched, before any confirmation prompt is shown.","Basic Path #6"
"Kaiten IQ shall display the count of associated RFID tags and the plate/menu description to the chef before committing the scan.","Basic Path step 7.",Story,Must,ChefInput,,"The Chef Interface shows a count and description matching the association made in REQ-ChefInput-02, before Live Inventory is written.","Basic Path #7"
"Kaiten IQ shall require explicit chef confirmation before committing a commissioning scan to Live Inventory.","Basic Path steps 8-9.",Story,Must,ChefInput,,"No Live Inventory write occurs for a scan the chef hasn't confirmed.","Basic Path #8-9"
"Kaiten IQ shall write the associated RFID UIDs, menu item, and a ""born on"" timestamp to Live Inventory upon chef confirmation.","Basic Path step 10, Post-Condition.",Story,Must,ChefInput,,"Live Inventory contains a new record for each confirmed RFID UID, its menu item, and a ""born on"" timestamp immediately after confirmation.","Basic Path #10, Post-Condition"
"Kaiten IQ shall notify the chef and prompt corrective action when no RFID tags are detected in the workspace at scan time.","Exception Path A.",Story,Must,ChefInput,,"When zero RFID tags are detected at scan time, the chef sees a corrective-action message instead of a silent failure or an empty commissioning record.","Exception Path A"
"Kaiten IQ shall let the chef reject a scan and suggest corrective action without committing that scan to Live Inventory.","Exception Path B.",Story,Should,ChefInput,,"A rejected scan produces no Live Inventory write, and the chef sees a corrective-action suggestion before re-scanning.","Exception Path B"
```
