# Obsidian note frontmatter schema

Every note carries exactly these four frontmatter keys:

| Key | Type | Purpose |
|---|---|---|
| `created` | `YYYY-MM-DD` | Creation date. Set once; do not change on edits. |
| `tags` | list | Topical tags for search/graph. Reuse existing vault tags; don't proliferate near-duplicates. |
| `category` | string | The note's bucket in the vault's taxonomy (e.g. `meeting`, `architecture`, `project`). Use the vault's existing vocabulary. |
| `status` | string | Lifecycle state (e.g. `draft`, `active`, `done`, `archived`). Use the vault's existing vocabulary. |

**Why these four and no more:** they cover *when*, *what about*, *what kind*, and *where in its
lifecycle* — enough to file and find any note without imposing a heavy schema. Anything more
specific belongs in the body, not the frontmatter.

**Fixed headings:** headings are consistent *per note type* (a meeting note always uses the same
section names, an architecture note always uses its own set). Consistency makes notes skimmable
and template-able. If `CONTEXT.md` defines the vault's `category`/`status` vocabulary, use it;
otherwise ask once and then stay consistent.
