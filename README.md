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

## Shared-host cleanup isolation test

This branch selects only `AuroraRetail` and builds it twice in a single manually
dispatched **CI/CD** workflow. `SharedHostContainer` builds and publishes apps and
runs the existing test folders in a Windows container. `SharedHostCompiler` uses
the compiler folder with publishing and tests disabled. Mode-specific settings
protect these three flags from the project's normal container-build settings.
Evergreen Logistics and the existing app dependencies are unchanged.

Register two Windows X64 runners for this repository on the same host, with
separate installation/work directories and access to the same Windows Docker
daemon. Give one the custom label `al-go-shared-host-primary` and the other
`al-go-shared-host-peer`, in addition to `self-hosted`, `Windows`, and `X64`.
Only build jobs use these labels; initialization and postprocessing still use
GitHub-hosted Windows runners. CI/CD has no `max-parallel` or concurrency limit
serializing the matrix, and project dependency discovery remains disabled.

The test needs artifact access for `bcinsider//30/us/latest` and any required
`licenseFileUrl` secret, plus access to the selected dev AL-Go action ref.
Check organization/repository settings variables for protected runner, project,
mode, or build settings that could override this file. Runner, secret-name, and
settings-variable metadata could not be verified with the current token
(HTTP 403). No runner registrations or secrets were changed.

After updating AL-Go system files to the deployed dev branch, preserve these
settings and verify that the generated build workflow still forwards
`inputs.buildMode` to the build actions and uses the matrix runner labels.
The checked-in workflows and action/template refs were deliberately not updated.
Commit and push the test branch yourself before dispatching it.

To establish overlap without relying on matrix ordering:

1. Leave the peer runner stopped and the primary runner online. Dispatch CI/CD
   once on this branch. Confirm both Aurora Retail modes appear in that run.
2. Wait until the primary job creates its container, then start the peer runner.
   The compiler job cannot take the primary runner's label. The container-mode
   test `P1 Calculation Tests.CalculatesTotal` includes a five-minute `Sleep`
   under `SHARED_HOST_CLEANUP_TEST`, which only the container modes define.
   Start the peer promptly; do not wait until that test has finished.
3. Confirm the compiler job reaches `Pipeline Cleanup` while the primary
   container is still running. Correlate timestamps from both jobs and the
   read-only Docker inventory below. If cleanup happens after the container
   exits, the run is inconclusive, not a pass; repeat with warm artifacts or a
   longer fixture delay.
4. With the fix, the compiler job must not remove the primary container, and
   the container job must finish its tests successfully. Confirm distinct
   persisted `_ALGoBuildId` values in the job logs and a 15-character `bc`-prefixed
   container name whose `al-go.build-id` label matches its owning build.

Run this read-only command on the shared host while the primary container is
alive and again immediately after the peer's cleanup:

```powershell
Get-Date -Format o
docker ps --filter "label=creator=AL-Go" --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Label "al-go.build-id"}}'
```

Match the container to the current job's logged identity; unrelated AL-Go
containers are not test evidence and must not be changed.

For the two-container variant, replace `SharedHostCompiler` in `buildModes` with
`SharedHostContainer2`. That mode already selects the peer runner, disables the
compiler folder, publishes apps, and runs the same delayed tests. Start the peer
as soon as the primary container exists and verify two distinct, correctly
labeled containers coexist in the same workflow run. Each job's cleanup must
remove only its own container, with the other job's tests remaining successful.
Two separate workflow runs do not reproduce the original same-run naming defect.

`cacheKeepDays` remains `3`. `cacheImageName` is explicitly empty for the initial
isolation test so shared image creation/maintenance does not confound container
ownership. To cover cache-enabled maintenance separately, prewarm a dedicated
image prefix in a non-overlapping run, then set `cacheImageName` to that prefix
and repeat the same-run test with `cacheKeepDays: 3`. Do not use zero-day cache
flushing, prune shared Docker state, or remove unrelated containers.

The delay does not affect modes without `SHARED_HOST_CLEANUP_TEST`. No workflow,
Docker workload, or runner installation was started while preparing this branch.
