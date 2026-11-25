---
name: compliance
description: Manage the versioned compliance rulesets - set a new rule version, update or replace rules, show the current version and active rulesets, or print the audit history. Use when the user asks to version, bump, archive, update, show, or audit compliance rules.
user-invocable: true
---

# Compliance rules manager

This project keeps versioned compliance rulesets in `compliance/`.

State (read these before acting):

- `compliance/VERSION` — current rules version, one line (e.g. `v3`)
- `compliance/active/` — current rulesets; every *.md is active
- `compliance/superseded/` — archived old versions, never deleted
- `compliance/CHANGELOG.md` — append-only audit log

Subcommands (match on the user's words; a bare `/compliance` behaves as
`show`):

## `/compliance update` (user attaches or names a rules document)

1. Read the user's document completely.
2. For each file of the same name already in `compliance/active/`: move it to
   `compliance/superseded/<name>.v<N>.md` where `<N>` is the version last
   current for it (from the CHANGELOG entry that imported/replaced it, else
   the current VERSION).
3. Save the new document verbatim into `compliance/active/<descriptive-name>.md`.
4. Bump `compliance/VERSION` to the next version (v1, v2, ... — always +1,
   based on the current VERSION file; if absent, start at v1).
5. Append (never rewrite) a CHANGELOG.md section:

   ```
   ## vN - <today's date>
   - Replaced data-handling.md (was vM) with new version.
   - <one-line summary of what materially changed, or "user-provided update">
   ```

6. Reply: new version, files now active, files archived, summary of change.

If the user gives several documents, treat them as one atomic version bump:
archive all replaced files, save all new ones, bump once, one CHANGELOG entry.

## `/compliance show`

Report the current version, the list of active rulesets (first heading or
first line of each file), and the date of the last CHANGELOG entry.

## `/compliance history`

Print `compliance/CHANGELOG.md` verbatim, with the contents of
`compliance/VERSION` as a header line.

## Hard rules (apply to every subcommand)

- Only the user can decide when rules change. Never archive, replace, retire
  or rewrite a ruleset on your own initiative.
- CHANGELOG.md is append-only. Past entries are never edited or removed.
- Superseded files are never deleted, only moved to superseded/.
- Version numbers only ever increase.
- If `compliance/VERSION` or `CHANGELOG.md` is missing or unreadable, report
  that to the user and proceed conservatively (create VERSION at v1 only with
  the user's confirmation; do not invent audit history).
