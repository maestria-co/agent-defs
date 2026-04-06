# Global Task Tracking

Before processing any request, check for active tasks:

1. Read `~/.copilot/active-tasks.json` directly (load file and parse JSON)
2. Filter tasks where `repo` matches current repository root
3. If user mentioned a task ID (e.g., "mje0006") → auto-resume that task
4. If user said "show active" → list all active tasks for current repo
5. Otherwise → proceed normally

Active tasks are stored globally in `~/.copilot/active-tasks.json` and filtered by repository path.
Hooks automatically update timestamps and archive old tasks, but Manager makes all task selection decisions.
