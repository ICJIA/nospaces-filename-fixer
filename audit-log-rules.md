# Audit Log Rules Template

When creating an audit log for a new project, include the following sections and follow these guidelines:

## Distinction from CHANGELOG
An audit log is distinct from a CHANGELOG in several important ways:
- **Purpose**: The audit log is primarily for external review and audit purposes, not for end-users or developers tracking version changes
- **Detail Level**: Audit logs contain more granular details about specific files changed and exact modifications made
- **Structure**: While CHANGELOGs are typically organized by version numbers, audit logs are strictly chronological
- **Audience**: Audit logs are designed for auditors, compliance officers, and external reviewers who need to verify exactly what changed and when
- **Completeness**: Audit logs must document ALL changes, not just significant features or fixes that would appear in a CHANGELOG

## Purpose
The audit log should:
- Document all significant changes to the project for external review purposes
- Provide a chronological history of modifications with specific file-level details
- Create an auditable trail of changes that can be verified by third parties
- Serve as a reference for external audits, compliance requirements, or regulatory reviews
- Enable reconstruction of the project's state at any point in time

## Structure
Each audit log entry must include:
- Date of change (YYYY-MM-DD format)
- Brief descriptive title in parentheses
- 1-2 sentence summary of the change
- List of all files modified with brief descriptions of changes
- Entries in reverse chronological order (newest at top)

## Content Requirements
When updating the audit log:
- Document all changes between the last update and the current state
- Be specific about what was changed and why
- Include any relevant version numbers or references
- Note any breaking changes or backward compatibility issues
- Document any new dependencies introduced

## Maintenance Guidelines
- Update the audit log with each significant commit or pull request
- Keep entries concise but informative
- Group related changes under a single date when appropriate
- Ensure the log remains readable and well-formatted
- Link to relevant issue numbers or pull requests when applicable

## Example Audit Log Entry

```
### 2023-04-15 (Security Enhancement and Bug Fix)
- Implemented enhanced password hashing and fixed user authentication bypass vulnerability.
- Files modified:
  - `src/auth/password.js`: Updated password hashing algorithm from MD5 to bcrypt with 12 rounds of salting
  - `src/auth/login.js`: Fixed authentication bypass vulnerability in the login verification process
  - `src/config/security.js`: Added new configuration parameters for bcrypt implementation
  - `tests/auth/password.test.js`: Updated tests to verify new hashing implementation
  - `docs/security.md`: Updated documentation to reflect new password security measures
```

This template provides clear guidelines for maintaining a consistent and useful audit log across projects. You can adjust the specific requirements based on your team's needs or regulatory requirements. Remember that the primary audience for this document is external reviewers who need to understand exactly what changed, when it changed, and how it was implemented.
