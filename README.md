# AL-Go Subcontracting Dependency Reproduction

This branch prepares the initial failing scenario from [microsoft/AL-Go#2418](https://github.com/microsoft/AL-Go/issues/2418). It pins both projects and the workflow-specific artifact overrides to `sandbox/28.5.54151.56840/w1` and BcContainerHelper to `6.1.19`. BC 28 ships Microsoft Subcontracting published-only, unlike BC 29 and later.

## Reproduction flow

1. The first build level builds Aurora Retail from source. Aurora Commerce now depends on Microsoft Subcontracting (`1f32a50d-0057-4b95-b5df-cc04d7e89470`, version `28.5.0.0`). Preparing this source dependency is expected to succeed.
2. The second build level builds Evergreen Logistics in a fresh container. Evergreen Fulfillment depends on Aurora Commerce, so AL-Go downloads Aurora Retail's prebuilt app artifact and forwards it through `DownloadProjectDependencies.outputs.DownloadedApps` to the reusable workflow's `RunPipeline` action as `installAppsJson`, then to `Run-AlPipeline -installApps`.
3. The expected failure is synchronization of Aurora Commerce before its published-only Subcontracting dependency is synchronized/installed: `Cannot synchronize the extension because no synchronized extension could be found to satisfy the dependency definition for Subcontracting by Microsoft 28.5.0.0.`

`useProjectDependencies` is enabled and all five build workflows have two build levels. `generateDependencyArtifact` is deliberately disabled: otherwise the producer can export Subcontracting with its dependencies and mask the missing-dependency ordering failure. Do not copy Subcontracting into the consumer's input packages.

Normal test compilation/execution, BCPT execution, page scripting execution, separate test actions, code coverage, and upgrade validation are disabled. The test sources/recordings remain in place but inactive. Both projects explicitly retain container-based publishing, synchronization, and installation.

Use the **CI/CD** workflow for the initial reproduction after the branch has been explicitly committed and pushed. Do not use a source-only local development build as evidence of reproduction. No real container/pipeline run has been performed for this setup, and no `installApps` setting or container-creation workaround has been added.

The existing actions still use `spetersenms/AL-Go@spetersen/separateTestActionCodeCoverage`, not the report's AL-Go v9.2/v10. At preparation time that moving ref resolved to `f08b0b55101ac9079635b7e5b9e3822b78f99c13`; its `RunPipeline` action forwards downloaded prebuilt apps to `Run-AlPipeline -installApps`. The helper version is pinned to the report's `6.1.19` instead of the action branch's default `preview`. Record the resolved action SHA and helper version from the actual run; a source build succeeding is not confirmation of the failure.

## Original coverage fixture

This repository exercises AL-Go multi-project builds, separate test actions, and repository-level code coverage summaries.

## Project topology

The original Aurora Retail and Evergreen Logistics coverage fixtures were independent customer solutions. On this reproduction branch, Evergreen Fulfillment additionally references Aurora Commerce to exercise prebuilt dependency installation across projects.

| Project | Regular app | Test app | Intended coverage |
|---------|-------------|----------|-------------------|
| Aurora Retail | `Aurora Commerce` | `Aurora Commerce Tests` | Full coverage of all executable sample paths |
| Aurora Retail | `Aurora Customer Service` | `Aurora Customer Service Tests` | Partial coverage with priority branches and owner-label logic intentionally untested |
| Evergreen Logistics | `Evergreen Inventory` | `Evergreen Inventory Tests` | Full coverage of all executable sample paths |
| Evergreen Logistics | `Evergreen Fulfillment` | `Evergreen Fulfillment Tests` | Partial coverage with shipment branches, package edge cases, and route formatting intentionally untested |

Each regular app contains deterministic codeunit procedures with multiple statements and branches. The full-coverage tests call every path in their target apps. The partial-coverage tests call only representative happy paths, leaving valid executable lines uncovered so the repository summary receives clearly different coverage data from both projects.

Both projects skip upgrade validation for this reproduction. App publishing remains enabled instead of inheriting the organization-level compile-only setting.

Page scripting recordings remain configured independently for each project, but execution is disabled for this reproduction.
