# Architecture — OpenClaw Bootstrap Template

## What This Repository Is

An **OpenClaw bootstrap template** — guided onboarding scripts that walk non-technical users through setting up an OpenClaw AI assistant on a Windows VPS. There is no application code to build, test, or lint.

## Repository Structure

- **BOOTSTRAP.md** — Primary onboarding wizard. Configures: Claude API key, user profile, Whisper (voice), browser extension, Telegram bot, agent email, memory system, Titanium Software keys, and morning/evening greeting cron jobs. Self-deletes after completion.
- **LETTERMAN-AUTOMATION-BOOTSTRAP.md** — Secondary bootstrap for Letterman (newsletter platform) article automation. Installs a `skills/letterman/` skill, connects the API, discovers publications, and schedules cron jobs for content bank searches and article creation.
- **installer.ps1** — PowerShell script that installs Node.js v24.13.0, Git, and OpenClaw on a fresh Windows machine, then downloads BOOTSTRAP.md.

## Key Concepts

- **OpenClaw Gateway** — The platform runtime. Configuration is done via `gateway config.patch` commands with JSON payloads (not file edits). This sets API keys, channel configs, skill entries, hooks, and agent defaults.
- **Skills** — Installed under `skills/<name>/SKILL.md` with optional `references/` subdirectories. Skills teach the AI how to interact with external APIs (e.g., Letterman).
- **Cron jobs** — Scheduled via `cron add` with JSON payloads containing name, schedule (cron expr + timezone), and a systemEvent payload. Used for greetings and automated workflows.
- **Progress tracking** — Each bootstrap uses a `*-progress.json` file to track onboarding state and support resume-after-interruption.
- **Pairing** — Telegram setup requires a two-phase flow: configure bot token via config.patch, then approve a pairing code via `openclaw pairing approve telegram [CODE]`.

## Working on Bootstrap Scripts

- The audience is **non-technical users**. Tone must be friendly, patient, and simple.
- Bootstrap scripts are instruction sets for the AI, not user-facing documentation. They contain exact commands to execute, what to say to the user, and how to handle errors.
- Every bootstrap must handle off-script questions gracefully (answer, then resume), support progress tracking for resume, and never leave the user stuck.
- Articles created via Letterman API must always be DRAFT — never auto-publish.
- Credentials go in `credentials/` directory or gateway config, never in code.
