# AL-Go Multi-Project Coverage Fixture

This repository exercises AL-Go multi-project builds, separate test actions, and repository-level code coverage summaries.

## Project topology

Project1 and Project2 are independent. Regular apps and test apps only reference apps in the same project, and AL-Go project dependency discovery is disabled so the projects can build and test in parallel.

| Project | Regular app | Test app | Intended coverage |
|---------|-------------|----------|-------------------|
| Project1 | `app1` | `app1.Test` | Full coverage of all executable sample paths |
| Project1 | `app1.partial` | `app1.partial.Test` | Partial coverage with priority branches and owner-label logic intentionally untested |
| Project2 | `app2` | `app2.Test` | Full coverage of all executable sample paths |
| Project2 | `app2.partial` | `app2.partial.Test` | Partial coverage with shipment branches, package edge cases, and route formatting intentionally untested |

Each regular app contains deterministic codeunit procedures with multiple statements and branches. The full-coverage tests call every path in their target apps. The partial-coverage tests call only representative happy paths, leaving valid executable lines uncovered so the repository summary receives clearly different coverage data from both projects.

Project1 skips upgrade validation because this synthetic fixture intentionally removed its historical dependency on Project2, making the old coupled release unsuitable as an upgrade baseline. Project2 explicitly enables app publishing so AL-Go creates a test container and runs its discovered test apps instead of inheriting the organization-level compile-only setting.

Page scripting recordings remain configured independently for each project.
