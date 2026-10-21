# AL-Go Customer Solutions Coverage Demo

This repository exercises AL-Go multi-project builds, separate test actions, and repository-level code coverage summaries.

## Project topology

Aurora Retail and Evergreen Logistics are independent customer solutions. Regular apps and test apps only reference apps in the same project, and AL-Go project dependency discovery is disabled so the projects can build and test in parallel.

| Project | Regular app | Test app | Intended coverage |
|---------|-------------|----------|-------------------|
| Aurora Retail | `Aurora Commerce` | `Aurora Commerce Tests` | Full coverage of all executable sample paths |
| Aurora Retail | `Aurora Customer Service` | `Aurora Customer Service Tests` | Partial coverage with priority branches and owner-label logic intentionally untested |
| Evergreen Logistics | `Evergreen Inventory` | `Evergreen Inventory Tests` | Full coverage of all executable sample paths |
| Evergreen Logistics | `Evergreen Fulfillment` | `Evergreen Fulfillment Tests` | Partial coverage with shipment branches, package edge cases, and route formatting intentionally untested |

Each regular app contains deterministic codeunit procedures with multiple statements and branches. The full-coverage tests call every path in their target apps. The partial-coverage tests call only representative happy paths, leaving valid executable lines uncovered so the repository summary receives clearly different coverage data from both projects.

Aurora Retail skips upgrade validation because this synthetic fixture intentionally removed its historical cross-project dependency, making the old coupled release unsuitable as an upgrade baseline. Evergreen Logistics explicitly enables app publishing so AL-Go creates a test container and runs its discovered test apps instead of inheriting the organization-level compile-only setting.

Page scripting recordings remain configured independently for each project.
