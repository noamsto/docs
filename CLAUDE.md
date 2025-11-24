# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Mintlify documentation site. Mintlify is a documentation platform that uses MDX (Markdown + JSX) for content authoring and provides a rich component library for creating interactive documentation.

## Development Commands

### Local Development
```bash
# Install Mintlify CLI (requires Node.js v19+)
npm i -g mint

# Start local development server at http://localhost:3000
mint dev

# Run on custom port
mint dev --port 3333

# Update to latest Mintlify version
npm mint update

# Validate all links in documentation
mint broken-links
```

### Prerequisites
- Node.js version 19 or higher
- Mintlify CLI installed globally

### Nix Development Environment (Optional)
If you have Nix with flakes enabled, you can use the provided development environment:
```bash
# Enter development shell (automatically installs Node.js v22 and Mintlify CLI)
nix develop

# Or use direnv for automatic environment loading
direnv allow
```

The flake provides:
- Node.js v22 (exceeds v19+ requirement)
- npm, pnpm, and yarn package managers
- Automatic Mintlify CLI installation
- Pre-configured environment variables

## Architecture

### Configuration (`docs.json`)
The central configuration file that defines:
- Site metadata (name, theme, colors, favicon)
- Navigation structure (tabs, groups, pages)
- Component behavior (contextual options)
- External links (navbar, footer, global anchors)

### Content Structure
All documentation content is written in MDX files (`.mdx`):
- **Root pages**: `index.mdx`, `quickstart.mdx`, `development.mdx`
- **Essentials**: Settings, navigation, markdown, code examples, images, reusable snippets
- **AI Tools**: Integration guides for Cursor, Claude Code, Windsurf
- **API Reference**: Introduction and endpoint documentation (GET, POST, DELETE, webhooks)
- **Snippets**: Reusable content fragments in `/snippets/`

### Page Registration
Every page MUST be registered in `docs.json` under the appropriate navigation group to appear in the site. Simply creating a `.mdx` file is not sufficient.

### Assets
- `/logo/`: Light and dark mode logos (SVG)
- `/images/`: Documentation images and screenshots
- `favicon.svg`: Site favicon

## Content Authoring

### MDX Features
- Standard Markdown syntax
- Mintlify components: `<Card>`, `<CardGroup>`, `<Accordion>`, `<AccordionGroup>`, `<Steps>`, `<Step>`, `<Frame>`, `<Columns>`, `<Info>`, `<Tip>`, `<Note>`, etc.
- Frontmatter for metadata: `title`, `description`
- Code blocks with syntax highlighting
- Images and media embeds

### Contextual Actions
The site has contextual menu options enabled for: copy, view, chatgpt, claude, perplexity, mcp, cursor, vscode

## Deployment

Changes are deployed automatically via GitHub App:
1. Push changes to the default branch (main)
2. Mintlify GitHub App automatically deploys to production
3. Monitor deployment status in the Mintlify dashboard

## Troubleshooting

### Preview Issues
- If `mint dev` fails, run `mint update` to ensure latest CLI version
- If page loads as 404, verify the page is registered in `docs.json`
- For "sharp" module errors on darwin-arm64, upgrade to Node v19+ and reinstall CLI

### Link Validation
Run `mint broken-links` before committing to catch broken internal/external links.

## IDE Recommendations
- VSCode: Use [MDX VSCode extension](https://marketplace.visualstudio.com/items?itemName=unifiedjs.vscode-mdx) for syntax highlighting
- VSCode: Use [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) for code formatting
- use mint openapi-check  command to test if openapi file is parseable by mint