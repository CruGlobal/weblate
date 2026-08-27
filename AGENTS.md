# Working in this repo (for coding agents)

This repo is **packaging, not application code**. It is a thin Dockerfile over
the upstream `weblate/weblate` image, plus the workflows that build and ship it.
Application behaviour belongs upstream; what belongs here is the base-image tag,
the environment-independent `ENV` defaults, and the build/deploy wiring.

> 🔴 **The deploy model changed.** This app used to build and deploy on every
> push to `main` and to `staging`. It no longer does: **merging deploys
> nothing**, and production moves only when a person promotes an image that has
> already been running in the release-candidate environment. Distrust any other
> document or branch in this repo that describes pushes driving deploys.

## The loop

1. Work on a branch off `main` and open a pull request back to `main`. Never
   push to `main` directly.
2. **Write the PR title as a Conventional Commit** (`deps(docker): …`,
   `fix: …`). `.github/workflows/conventional-commits.yml` enforces it via the
   `Validate PR Title` check, which is the required status check on `main`. The
   repo squash-merges and the title becomes the commit subject, so the title is
   the durable record of the change.
3. There is no test suite and no CI beyond that check — this repo has nothing to
   run. Do not invent a test job and do not add a required check that no
   workflow reports; a required check that never arrives makes every PR
   unmergeable.

## How this app ships

One **environment-agnostic** image is built from `main`, deployed to the
release-candidate environment, and — if it looks good there — promoted
**byte-for-byte, by digest** to production. A promote re-points production at an
image that already exists; it never rebuilds.

- **Builds do not run on push.** `.github/workflows/pipeline-v2.yml` is a
  daily schedule plus `workflow_dispatch`, with no `push:` trigger. The nightly
  run builds whatever `main` holds and reuses the existing candidate when `main`
  has not moved. Need a build sooner? Dispatch *Pipeline v2* by hand — that is
  also the hotfix path.
- **A build produces a candidate, not a release.** It pushes candidate tags and
  deploys them to release-candidate only. Production is a separate, human
  action, run from the deploy repository.
- **The image is environment-agnostic.** The one build-baked value is the
  `ARG VERSION` / `ENV DD_VERSION` pair at the very end of the `Dockerfile`.
  Everything that differs between environments — hostnames, database and cache
  endpoints, credentials, SAML parameters, site title — arrives at runtime from
  infrastructure configuration, not from this repo. **Do not add a second
  build-baked value that depends on the environment**, and do not put anything
  secret in the `Dockerfile`; it is a public repo.
- **Schema changes are the upstream image's job.** Weblate migrates its own
  database at container start, so the pipeline's separate pre-deploy migration
  step stays switched off for this app. Do not add a migration step here; if the
  upstream boot behaviour ever changes, say so rather than working around it.
- **`build.sh` is used by both build paths** — it is `docker buildx build
  $DOCKER_ARGS .`, and that `$DOCKER_ARGS` is how the version build arg reaches
  the image. Leave it alone.
- **`.github/workflows/build-deploy-ecs.yml` is the old path, parked — not
  removed.** It is `workflow_dispatch`-only. **Do not re-add its `push:`
  triggers**: that would double-build every merge and push environment-specific
  tags alongside the new pipeline's candidates. Its build leg also has a hard
  expiry once the companion infrastructure change is applied — the header of
  that file explains it.
- **Dependencies are Dependabot's job.** `.github/dependabot.yml` watches the
  `FROM` line and the workflow actions, one grouped weekly PR each for
  minor+patch, majors ungrouped; `.github/workflows/dependabot-auto-merge.yml`
  approves and auto-merges patch/minor/security. An upstream bump that
  auto-merges lands on `main` and reaches the **release-candidate** environment
  on the next nightly — never production, which still needs a person. Do not
  bump the base image by hand when Dependabot will do it.

## Leftovers you can ignore

Everything here is pre-existing residue. It is inert — do not build on it, and
do not "fix" it in passing. The one deliberate exception is the parked workflow
above.

- **The `staging` branch and the fifteen `updatedTo*` / `smtp*` branches.**
  `staging` was part of the old push-to-deploy flow and has been pinned to a
  much older upstream version since April; the rest are abandoned upstream-bump
  attempts. **Nothing builds from any of them.** `main` is the only live branch.
  They are safe to delete and are scheduled for deletion once the migration is
  finished; until then, do not merge from them and do not treat `staging` as a
  stage environment.
- **`Dockerfile.orig`** was a dead file containing unresolved merge-conflict
  markers, and has been deleted. If you find it referenced anywhere, the
  reference is stale.

## If you're not sure what to do

- **Keep changes small and on a branch.** Open a PR; don't push to `main`.
- **Never commit secrets.** This repository is public. Credentials, tokens and
  per-environment values live in infrastructure configuration, never here.
- **Don't invent infrastructure.** Anything that needs a database, a parameter,
  a DNS record or a permission is an infrastructure change in
  [`cru-terraform`](https://github.com/CruGlobal/cru-terraform), not a change
  here.
- **Bump the base image, don't fork it.** Behaviour changes belong upstream in
  [WeblateOrg/weblate](https://github.com/WeblateOrg/weblate) or in runtime
  configuration.
- **Confirm before anything outward-facing or hard to undo** — pushing, opening
  PRs, deleting branches, dispatching a build, and above all promoting to
  production.
