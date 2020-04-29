# Docker java alpine with hardening
### Hardening scope
- use user id 1000 instead root
- use group id 1000 instead root group
- remote un-necessary binary except bash, sh, curl for health-check
### Environment injection
- JAVA_OPTS
- VM_OPTS
