# Repository Guidelines

## Project Structure & Module Organization
- `docs.json` configures site metadata, navigation tabs, theming, and logos. Adjust tabs/pages here before adding new content.
- Top-level `.mdx` pages such as `index.mdx`, `quickstart.mdx`, and `development.mdx` are entry guides. Place new guide content in `essentials/` or `plans/` when it fits those themes.
- API specs live in `api/openapi.yaml` (source), with supporting examples/schemas alongside. Published reference pages are in `api-reference/` (e.g., `api-reference/endpoint/*.mdx` and `api-reference/openapi.json`).
- Shared assets belong in `images/` and `logo/`; reusable text/code live in `snippets/`. Keep ad hoc notes in `notes.md` rather than mixing them into pages.

## Build, Test, and Development Commands
- Install the Mintlify CLI once: `npm i -g mint`.
- Local preview (hot reload): run `mint dev` from the repo root (where `docs.json` sits), then visit `http://localhost:3000`.
- Pre-flight production check: `mint build` to catch broken links, syntax issues, or invalid frontmatter before opening a PR.
- If the CLI misbehaves, run `mint update` to refresh the global tool.

## Coding Style & Naming Conventions
- Use Markdown/MDX with two-space indentation for component props, and keep JSX blocks compact. Start pages with frontmatter `title` and `description`.
- Name files and routes in kebab-case (e.g., `new-feature.mdx`). Prefer short, action-oriented headings.
- Keep code fences language-tagged (` ```ts `, ` ```bash `) and store repeated blocks in `snippets/` for reuse via `<Snippet>`.
- When touching API docs, update `api/openapi.yaml` first, then refresh `api-reference/openapi.json` to stay in sync.
- Provide descriptive alt text for images and keep asset filenames snake- or kebab-case.

## Testing Guidelines
- Before committing, ensure `mint dev` reports no console errors and that changed pages appear in navigation.
- Run `mint build` for structural validation; fail-fast on broken links or malformed MDX.
- For API changes, verify endpoints render correctly under `API reference` and that example payloads match `api/examples/` and `api/schemas/`.

## Commit & Pull Request Guidelines
- Follow a conventional commit flavor seen in history (`feat: initialize API infrastructure directories`): `type: short imperative summary` (`feat`, `fix`, `docs`, `chore`).
- PRs should include: a brief summary of scope, linked issue if available, and before/after screenshots or localhost URLs for visual changes. Note any navigation or OpenAPI updates explicitly.
- Keep diffs small and focused; batch unrelated edits into separate PRs. Remove stray personal notes before requesting review.
