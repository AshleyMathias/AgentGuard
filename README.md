# AgentGuard

### Your coding agent should remember the rules of the project it's working on.

A lightweight, version-controlled compliance instruction framework for AI coding agents.

AgentGuard keeps project rules in files, loads them into agent sessions, and reminds agents to validate their changes against those rules.

No external services. No database. Just files, native agent instructions and lifecycle hooks.

[Get Started](#-getting-started) · [How It Works](#-how-it-works) · [Contribute](#-contributing)

---

## The problem

AI coding agents are great at following instructions. The problem is keeping those instructions relevant throughout a project.

You give an agent a security policy, coding standard or architectural guideline. It follows it initially.

Then:
- A new session starts.
- The conversation gets longer.
- Context gets compacted.
- Another developer starts working on the same project.

The instructions that mattered yesterday might not be present today.

**AgentGuard takes a different approach: keep important project rules outside the conversation, in version-controlled files that the agent can access whenever it works.**

## What AgentGuard does

| Capability | What it means |
|---|---|
| Persistent rules | Store project rules as files instead of relying on chat history. |
| Session context | Inject active rules when a supported agent session starts. |
| Change reminders | Remind the agent to validate file edits against applicable rules. |
| Version control | Maintain a version number for the active rulesets. |
| Rule history | Archive superseded rules and maintain a change log. |
| User-controlled updates | Rules change only when the user explicitly requests an update. |

## How it works

AgentGuard uses three main components:

**1. AGENTS.md — Instructions**

Defines how the coding agent should work with project rules.

It tells the agent when to save a new rules document, when to consult existing rules, and how to report its compliance checks.

**2. compliance/ — Rules and version history**

A dedicated location for active rules, archived rules, version information and change history.

**3. .vibe/ — Lifecycle hooks and skills**

Connects the rules folder to Mistral Vibe's lifecycle events.

The session-start hook loads the active rules into the agent's context. The post-tool hook reminds the agent to validate changes after file edits.

### The workflow

```text
       User provides a rules document
                    |
                    v
             AgentGuard saves it
                    |
                    v
             compliance/active/
                    |
                    v
           Rules version updated
                    |
                    v
          Agent session starts
                    |
                    v
          Active rules are loaded
                    |
                    v
          Agent works on the task
                    |
                    v
          File edit reminder fires
                    |
                    v
          Agent validates its work
                    |
                    v
           Compliance check reported
```

The goal is simple: make project rules available at the right points in the development workflow.

---

## Getting started

AgentGuard is designed to be added to an existing project.

### Requirements

For the included Vibe integration:

- [Mistral Vibe](https://github.com/mistralai/mistral-vibe)
- Bash available in your environment.
- A project folder trusted by Vibe so its project hooks can run.

On Windows, Git Bash can provide the Bash environment.

### 1. Get AgentGuard

Clone the repository:

```bash
git clone https://github.com/AshleyMathias/AgentGuard.git
```

### 2. Copy the required files

Copy these items from AgentGuard into your existing project's root directory:

```text
AGENTS.md
compliance/
.vibe/
```

Your project should look like:

```text
your-project/
│
├── AGENTS.md
│
├── compliance/
│   ├── active/
│   ├── superseded/
│   ├── VERSION
│   ├── CHANGELOG.md
│   └── README.md
│
└── .vibe/
    ├── hooks.toml
    ├── hooks/
    │   ├── compliance-context.sh
    │   └── edit-reminder.sh
    └── skills/
        └── compliance/
            └── SKILL.md
```

You can keep your existing project files and directories. AgentGuard does not require you to restructure your application.

### 3. Trust the project

Open the project in Vibe and accept its project trust prompt when asked.

Project hooks require a trusted folder. Without that trust, automatic hook execution will not happen.

### 4. Add your first ruleset

Provide your coding agent with a document containing your project rules and say:

```text
Follow this. Add it to the active compliance rules.
```

The agent should:

1. Save the document into `compliance/active/`.
2. Update `compliance/VERSION`.
3. Append an entry to `compliance/CHANGELOG.md`.

Your rules are now stored in the project rather than existing only in the conversation.

---

## Managing your rules

AgentGuard includes a `/compliance` skill for Mistral Vibe.

You can use:

| Command | Purpose |
|---|---|
| `/compliance show` | Display the current version and active rulesets. |
| `/compliance update` | Add or replace rules using a new document. |
| `/compliance history` | View the rules change history. |

### Example

Suppose your project has these rules:

```text
compliance/
├── active/
│   ├── security-policy.md
│   └── coding-standards.md
│
├── superseded/
│
├── VERSION
├── CHANGELOG.md
└── README.md
```

Later, your team updates its security policy.

Instead of overwriting the old document, AgentGuard's workflow archives the previous version, saves the new one, increments the version and records the change.

This gives you a traceable history of how your project rules evolve.

**Important:** The user decides when rules change. The agent must not silently rewrite, replace or retire existing rules.

---

## What happens when something goes wrong?

AgentGuard is designed to avoid silently treating a broken ruleset as a valid one.

The included Vibe hooks account for situations such as:

- No compliance folder: no rules are injected.
- Unreadable rules: a warning is provided.
- Partially readable rules: readable files are loaded and skipped files are identified.
- Oversized rulesets: file paths are provided so the agent can read the rules directly.
- Invalid characters: control characters are handled before JSON output.
- Hook failure: hooks fail open, allowing the session to continue.

The `AGENTS.md` instructions also act as a backstop, asking the agent to read and validate applicable rules before development output.

---

## Compatibility

AgentGuard separates its shared rules structure from tool-specific integrations.

The `AGENTS.md` and `compliance/` conventions can be adapted to different AI coding tools.

However, automatic loading and lifecycle hooks depend on each tool's supported mechanisms.

| Tool | Current integration status |
|---|---|
| Mistral Vibe | Included hooks and compliance skill |
| Claude Code | Adaptation required |
| Cursor | Instruction-based adaptation required |
| OpenCode | Plugin-based adaptation required |
| Antigravity | Instruction-based adaptation required |

The integrations above are not interchangeable. The included `.vibe/` configuration is specifically for Mistral Vibe.

Contributions for additional integrations are welcome.

---

## Important limitations

AgentGuard helps coding agents become aware of project rules. It does not independently guarantee that the resulting code is compliant.

Keep in mind:

- Agents can still misunderstand or ignore instructions.
- Lifecycle hooks are not a replacement for automated enforcement.
- Hooks require the relevant tool configuration and permissions.
- Instructions alone cannot prevent insecure code.
- Critical requirements should also be enforced through tests, linters, security scanners and CI/CD checks.

**Think of AgentGuard as an instruction-awareness layer, not a compliance certification system.**

---

## Project structure

```text
AgentGuard/
│
├── AGENTS.md
├── LICENSE
├── README.md
│
├── compliance/
│   ├── active/
│   ├── superseded/
│   ├── VERSION
│   ├── CHANGELOG.md
│   └── README.md
│
└── .vibe/
    ├── hooks.toml
    ├── hooks/
    │   ├── compliance-context.sh
    │   └── edit-reminder.sh
    └── skills/
        └── compliance/
            └── SKILL.md
```

---

## Contributing

AgentGuard is an open-source project, and contributions are welcome.

You can help by:

- Testing AgentGuard in different coding environments.
- Suggesting improvements to the existing workflow.
- Reporting bugs and unexpected behaviour.
- Building integrations for other AI coding tools.
- Improving documentation and examples.

If you find something that could be better, open an issue or submit a pull request.

The goal is to keep AgentGuard lightweight, practical and accessible to developers.

---

## License

AgentGuard is released under the [MIT License](LICENSE).

Free to use, modify and distribute.

---

**Built to make project instructions more persistent, traceable and practical for AI-assisted development.**

If you find AgentGuard useful, consider giving the repository a star and sharing it with other developers.

[GitHub Repository](https://github.com/AshleyMathias/AgentGuard)
