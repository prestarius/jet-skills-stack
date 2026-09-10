# Personal defaults (Jet)

One person's locale and output preferences. Installed only with `./install.sh --personal`;
not part of the plugin. Fork this file if you use the stack.

## Output & locale
- Respond in the language the user is writing in (PL or EN). Don't switch unprompted.
- Code samples default to **Python** unless asked otherwise.
- Technical/setup instructions default to **macOS** unless asked otherwise.
- Deliverables default to **Markdown**. Do not produce `.docx` unless explicitly requested.
- Notes generated from a Markdown source must be **full and exhaustive**, never shortened summaries.
- Hardware/electronics/accessory product links come from **botland.com.pl** or **amazon.pl**.
- Default package registries: PyPI for Python, NuGet for .NET, npm for JavaScript.
- Compliance lens: call out EU data residency / GDPR and self-hosting posture in tool evaluations, tradeoff tables, design docs, and architecture reviews when `CONTEXT.md` does not say otherwise.

## Obsidian
- Frontmatter schema for notes: `created`, `tags`, `category`, `status`. Use fixed section headings.
- Add Obsidian elements (templates, scripts, plugins) **one at a time**. Never propose a ready-made starter vault.
