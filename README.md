# AgentGuard

### Your coding agent should remember the rules of the project it's working on.

AgentGuard is a lightweight, version-controlled compliance instruction framework for AI coding agents.

It helps keep important project rules available throughout development, even when conversations restart, context gets compacted, or multiple developers work on the same codebase.

Instead of relying entirely on an agent to remember instructions from previous conversations, AgentGuard stores them in files, loads them into agent sessions, and reminds agents to validate their changes.

**No external services. No database. No API keys. Just files, instructions and lifecycle hooks.**

[Getting Started](#getting-started) · [How It Works](#how-agentguard-works) · [Contributing](#contributing)

---

## The problem

AI coding agents are becoming increasingly capable, but keeping them consistent across an entire project is still challenging.

Imagine giving an agent these instructions:

- Never expose API keys or secrets.
- Follow the project's architectural conventions.
- Validate changes against security requirements.
- Don't modify protected configurations.
- Follow established coding standards.

The agent follows them initially.

Then:

- A new session starts.
- The conversation gets longer.
- Context gets compacted.
- Another developer starts working on the same project.

The instructions that mattered yesterday might not be present today.

**AgentGuard addresses this problem by keeping important project rules outside the conversation, in version-controlled files that can be loaded whenever the agent works.**

---

## How AgentGuard works

AgentGuard uses three main components:

**1. Persistent instructions**

`AGENTS.md` provides the agent with project-level instructions about how to work with compliance rules.

**2. Session-start hook**

A Mistral Vibe lifecycle hook loads the active compliance rules into the agent's context when a session starts.

**3. Post-edit reminder**

After relevant file-writing or editing operations, another hook reminds the agent to validate its changes against the applicable rules.

The intention is simple: make project rules available at the right moments in the development workflow.

## The workflow

```text
         Project Compliance Rules
                   |
                   v
           compliance/active/
                   |
                   v
          AgentGuard Instructions
                   |
                   v
           Agent Session Starts
                   |
                   v
          Active Rules Loaded
                   |
                   v
           Agent Works on Task
                   |
                   v
          File Edit / Write
                   |
                   v
          Compliance Reminder
                   |
                   v
          Agent Validates Changes
                   |
                   v
          Compliance Check Reported
```

---

## What's included?

| Component | Purpose |
|---|---|
| `AGENTS.md` | Persistent instructions for AI coding agents |
| `compliance/active/` | Stores currently applicable compliance rules |
| `compliance/superseded/` | Stores rules that are no longer active |
| `compliance/VERSION` | Tracks the compliance ruleset version |
| `compliance/CHANGELOG.md` | Records changes to compliance rules |
| `compliance/README.md` | Explains compliance rule management |
| `.vibe/hooks.toml` | Configures Mistral Vibe lifecycle hooks |
| `.vibe/hooks/` | Contains hook scripts |
| `.vibe/skills/compliance/` | Contains the compliance management skill |

The repository also includes `compliance-agent-writeup.txt`, which provides additional context about the framework.

---

## Getting started

You don't need to create a new project to use AgentGuard.

You can add it to an existing project.

### Prerequisites

- Git
- A code editor
- An AI coding agent
- Git Bash on Windows if using the included Bash hooks
- Mistral Vibe for the included lifecycle-hook and compliance-skill implementation

### 1. Clone the repository

```bash
git clone https://github.com/AshleyMathias/AgentGuard.git
```

### 2. Copy the framework into your project

Copy these items into your existing project's root directory:

```text
AGENTS.md
compliance/
.vibe/
```

If your project already contains any of these files or directories, merge the contents carefully rather than overwriting your existing configuration.

Pay particular attention to `.vibe/hooks.toml`. If your project already has hook configurations, merge the AgentGuard entries into the existing configuration instead of replacing it.

### 3. Open and trust your project

Open your destination project in Mistral Vibe.

Review the project's instructions and hook configuration. If Mistral Vibe asks you to trust the project before enabling its hooks, review the commands and approve only if you trust the project contents.

The included hooks execute local Bash scripts from the project directory.

### 4. Add your compliance rules

Navigate to:

```text
compliance/active/
```

Create a Markdown file for your project rules.

For example:

```text
compliance/
├── active/
│   ├── security.md
│   ├── coding-standards.md
│   └── architecture.md
├── superseded/
├── VERSION
├── CHANGELOG.md
└── README.md
```

Every Markdown file directly inside `compliance/active/` is treated as an active ruleset.

You can organize your rules according to your project's needs.

### 5. Start your coding agent

Open your project using Mistral Vibe.

The configured session-start hook loads the active compliance rules into the session context.

After relevant file edits, the configured post-tool hook provides a compliance reminder.

### 6. Verify the setup

Check that:

- Your project instructions are available.
- Active compliance rules are loaded at session start.
- The post-edit reminder runs after matching file operations.
- The agent can reference and validate the applicable rules.

---

## Understanding compliance rules

Compliance rules should be clear, specific and actionable.

Avoid vague instructions such as:

> Write secure code.

Instead, write rules that describe the expected behaviour.

For example:

**Rule: Secret Management**

```markdown
# Secret Management

## Requirements

- Never hardcode API keys, passwords or access tokens.
- Use environment variables for sensitive configuration.
- Never commit .env files containing real credentials.
- Do not expose secrets in logs or error messages.

## Validation

- Check modified files for accidentally exposed credentials.
- Verify that sensitive configuration is loaded securely.
```

This makes it easier for an agent to understand what is expected and how to validate its work.

You can create separate rule files for:

- Security
- Architecture
- Coding standards
- Data privacy
- API design
- Testing requirements
- Project-specific conventions

These are examples, not predefined policies shipped with AgentGuard.

---

## Versioning and rule management

Compliance rules change as projects evolve.

AgentGuard includes a simple structure for managing those changes.

**Active rules**

Rules currently applicable to the project belong in:

```text
compliance/active/
```

Only Markdown files directly inside this directory are treated as active rulesets.

**Superseded rules**

Rules that are no longer applicable are archived in:

```text
compliance/superseded/
```

Previous versions are retained rather than deleted.

**Version tracking**

The `VERSION` file tracks the compliance ruleset version.

**Change history**

`CHANGELOG.md` records changes to the ruleset. It serves as an append-only history of compliance updates.

### Managing compliance rules

The included `/compliance` skill provides three commands:

| Command | Purpose |
|---|---|
| `/compliance show` | Displays the current version and active rulesets |
| `/compliance update` | Imports or replaces user-provided compliance rules |
| `/compliance history` | Displays the compliance change history |

When you use `/compliance update`, the workflow:

1. Saves the new ruleset in `compliance/active/`.
2. Archives a replaced ruleset in `compliance/superseded/`.
3. Increments the compliance version.
4. Appends an entry to `compliance/CHANGELOG.md`.

Multiple documents provided in one update are handled as a single version change.

**Only the user decides when compliance rules should change.** The agent must not independently rewrite, replace or retire existing rulesets.

This helps developers understand which rules are currently applicable and how they have evolved.

---

## Compatibility

AgentGuard currently includes a working lifecycle-hook configuration and compliance management skill for **Mistral Vibe**.

The framework also uses `AGENTS.md` for persistent project instructions, which can be useful with coding agents that support this convention.

The different components have different compatibility requirements:

| Component | Compatibility |
|---|---|
| `AGENTS.md` | Coding agents that support this convention |
| Compliance directory | Tool-independent |
| Bash lifecycle hooks | Configured and tested for Mistral Vibe |
| Compliance management skill | Configured for Mistral Vibe |

Lifecycle hooks, configuration formats and instruction-loading behaviour differ between AI coding tools.

Using the same files does not automatically make the Mistral Vibe hooks compatible with other agents.

If you want to adapt AgentGuard to another coding agent, you will need to implement and test the equivalent lifecycle integration.

---

## Important limitations

AgentGuard helps make project instructions more persistent and accessible. It does not independently enforce security or guarantee compliance.

Keep the following in mind:

- An AI agent can still misunderstand or ignore instructions.
- A compliance reminder does not prove that a change is compliant.
- Hook execution depends on the configured environment.
- Rules must be written, maintained and reviewed by humans.
- Critical security requirements should also be enforced through automated tests, linters, CI/CD checks and appropriate security controls.

**AgentGuard is an instruction-management and workflow-support layer, not a replacement for security enforcement.**

---

## Contributing

AgentGuard is an open-source project, and contributions are welcome.

You can contribute by:

- Improving documentation.
- Suggesting better ways to manage persistent agent instructions.
- Adding integrations for other coding agents.
- Improving lifecycle hooks.
- Sharing real-world use cases.
- Reporting bugs and proposing enhancements.

If you have an idea that makes AI coding workflows more reliable, feel free to open an issue or submit a pull request.

The goal is to make better AI development practices accessible to everyone.

---

## License

AgentGuard is released under the [MIT License](LICENSE).

You are free to use, modify and distribute it according to the license terms.

---

**Built to make AI coding workflows more consistent, one project at a time.**
