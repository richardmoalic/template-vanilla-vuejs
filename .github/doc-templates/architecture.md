#architecture.md

# Project Architecture

> Generated: {{DATE}}
> Version: {{VERSION}}
> Commit: {{COMMIT_REF}}

## Tech Stack & Conventions

| Category    | Tool               | Strategy                                        |
| :---------- | :----------------- | :---------------------------------------------- |
| **Runtime** | Vanilla JS / Vue 3 | Modern SFCs without TS overhead where possible. |
| **Build**   | Vite               | ESM-based bundling.                             |
| **Commits** | czg + cz-git       | Strictly enforced Conventional Commits.         |
| **Docs**    | VitePress          | Documentation-as-Code (DaC).                    |

## CI/CD Overview

```mermaid
flowchart TD

A[Lint/Check] --> B[Unit Tests]
    end
    subgraph "Security"
    C[Secrets] --> D[Signatures]
    end
    Validation & Security --> E[Release/Deploy]
```

## Documentation Strategy

### Hand Written

- README.md
- docs/security.md
- docs/release.md

### Generated

- CLI references
- VEX records
- SBOM

## Script Structure

```
.github/scripts/
├── security.sh
├── audit-signatures.sh
├── audit-vulnerability.sh
├── sign-artifacts.sh
├── generate-checksums.sh
└── generate-docs.sh
```
