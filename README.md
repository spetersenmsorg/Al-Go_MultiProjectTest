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

## Multiple-codeunit separate-test reproduction

`AuroraRetail\AuroraCommerce.Test` contains test codeunits 50000, 50001, and 50002 in the same app (ID `be11fd2f-8f16-40b7-bd82-47a87db3534b`). They exercise the same calculation, classification, and formatting paths as before. Aurora Retail explicitly selects `powershell`, and the reusable build workflow forwards that shell to the separate `Run Tests` action. Keep `useSeparateTestAction.enabled` enabled in `.github\AL-Go-Settings.json`. PowerShell 7 (`pwsh`) can mask the array-enumeration bug in microsoft/AL-Go#2454.

To prepare a local fixture, use Windows PowerShell 5.1 on a Windows machine with Docker running Windows containers and access to the configured BC insider artifacts. From the repository root:

```powershell
powershell.exe -NoProfile
$credential = Get-Credential
Push-Location .\AuroraRetail
.\.AL-Go\localDevEnv.ps1 -containerName aurora-repro -auth UserPassword -credential $credential -licenseFileUrl none -accept_insiderEula
Pop-Location
```

The existing setup script downloads the configured AL-Go helpers, creates the container, and compiles/publishes the apps and test apps. It does not by itself exercise the separate `RunTests` action. Use the resulting container to debug the per-app discovery and execution loop in your local AL-Go checkout's `Actions\RunTests` implementation, selecting the Aurora Commerce Tests app ID above.

In the unfixed implementation, `$codeunits = Get-TestsFromBcContainer @getTestsParams` can capture the non-enumerated array as a single element under Windows PowerShell 5.1. The subsequent test run then receives a combined codeunit ID such as `50000 50001 50002` (order can vary), rather than individual integers. In the fixed implementation, use:

```powershell
$codeunits = @(Get-TestsFromBcContainer @getTestsParams | ForEach-Object { $_ })
```

Confirm that discovery yields three individual codeunits and that the loop runs each separately. For the end-to-end separate-action path, run CI/CD with Aurora Retail selected and `powershell` as its runner shell; use an unfixed AL-Go action ref to reproduce and the fixed ref to verify the correction. The configured remote action ref does not include uncommitted changes from a local AL-Go checkout. AL-Go system-file updates can overwrite the workflow shell forwarding, so check the `Run Tests` step after updating.

No Business Central container run has been verified for this fixture change.
