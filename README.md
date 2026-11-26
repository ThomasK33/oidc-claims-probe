# oidc-claims-probe

Scratch repository that records the claims GitHub Actions puts in OIDC identity
tokens for each trigger, for an RFC review. Each job requests a token for the
audience `https://oidc-claims-probe.invalid`, which no service accepts, and
prints only the decoded payload.
