# Contributing to AgentGuard

First off, thank you for considering contributing to AgentGuard!

AgentGuard is an open-source effort to make AI coding workflows more consistent, maintainable and reliable.

Whether you're improving documentation, reporting a bug, suggesting an integration or contributing code, every contribution is welcome.

You don't need to be an expert in AI agents to contribute.

## What can you contribute?

Here are some areas where contributions can make a difference.

### 1. Documentation
- Improve installation instructions.
- Add practical examples.
- Make existing explanations easier to understand.
- Document common issues and troubleshooting steps.

### 2. Agent integrations
- Explore compatibility with other AI coding agents.
- Develop equivalent lifecycle integrations.
- Test existing integrations across different environments.
- Document integration-specific limitations.

### 3. Compliance management
- Suggest improvements to compliance rule organization.
- Improve versioning and change-management practices.
- Share reusable rule templates.
- Suggest better validation workflows.

### 4. Reliability and testing
- Identify edge cases in hook execution.
- Improve error handling.
- Test fresh installations.
- Report unexpected behaviour.

## Before you start

1. Check existing issues to see whether someone has already reported the problem.
2. For significant changes, open an issue first to discuss the proposed approach.
3. Keep contributions focused and easy to review.
4. Avoid introducing unnecessary dependencies.

## Getting started

### 1. Fork the repository

Fork AgentGuard on GitHub:

https://github.com/AshleyMathias/AgentGuard

### 2. Clone your fork

```bash
git clone https://github.com/<your-username>/AgentGuard.git
```

### 3. Create a branch

```bash
git checkout -b feature/your-contribution
```

Use descriptive branch names, such as:

- `docs/improve-installation`
- `feature/claude-code-integration`
- `fix/hook-execution`

### 4. Make your changes

Keep changes focused on the issue or improvement you're addressing.

When working with compliance rules:

- Keep instructions clear and actionable.
- Avoid ambiguous requirements.
- Document significant changes.
- Do not silently remove existing rules.
- Preserve versioning and change-history conventions.

### 5. Test your changes

Before submitting:

- Verify that modified files work as expected.
- Test hook changes in the relevant environment.
- Check installation instructions if documentation changes.
- Document any limitations or untested behaviour.

Do not claim compatibility with an AI coding agent unless the integration has been tested.

### 6. Submit a pull request

Push your branch:

```bash
git push origin feature/your-contribution
```

Open a pull request against the `main` branch of AgentGuard.

Include:

- What you changed.
- Why the change is useful.
- How you tested it.
- Any known limitations.

## Reporting bugs

Found something that doesn't work?

Open a GitHub issue with:

- A clear description of the problem.
- Steps to reproduce it.
- Expected behaviour.
- Actual behaviour.
- Relevant environment and tool versions.
- Error messages, if available.

Avoid including API keys, passwords, access tokens or other sensitive information in issue reports.

## Suggesting new features

Have an idea that could improve AgentGuard?

We'd love to hear it.

Open an issue describing:

- The problem you're trying to solve.
- Your proposed approach.
- Why it would benefit other developers.
- Any compatibility considerations.

Ideas that make AgentGuard more portable, reliable and easier to adopt are especially welcome.

## Community principles

We want AgentGuard to remain accessible and useful to developers with different experience levels.

Please:

- Be respectful and constructive.
- Welcome different approaches.
- Explain technical decisions.
- Keep discussions focused on improving the project.
- Give credit where it's due.

## License

By contributing to AgentGuard, you agree that your contributions will be distributed under the project's MIT License.

---

**Thank you for helping make AI development workflows better for everyone.**
