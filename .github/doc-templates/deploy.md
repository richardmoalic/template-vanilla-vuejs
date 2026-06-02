#deploy.md
Focused on the Gatekeeper concept—deployment should fail if verification fails.

# Deploy process

> Generated: {{DATE}}
> Version: {{VERSION}}
> Commit: {{COMMIT_REF}}

## Deploy flow

```mermaid
flowchart TD

A[Download Assets] --> B[Verify Signatures]
    B -- Fail --> C[Halt & Alert]
    B -- Pass --> D[Verify SBOM Policy]
    D --> E[Atomic Extract & Deploy]
```

Signed build
↓
Supply Chain Verification
↓
Deploy
