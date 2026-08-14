# Retired workflows

Retirement is a declared state, not a silent deletion. Anything listed here was
removed from this repo's `<crate>.caixa.lisp` `:workflows` vector — the source
of truth — and its generated YAML removed to match. Nothing is lost: the
workflow implementation itself is untouched upstream, and re-adding the keyword
to `:workflows` and re-rendering brings it back.

## `auto-release` — retired 2026-07-30

**Why.** This repo is a vendored fork of an upstream bevy crate. It declares
upstream's package name and upstream's version (`0.19.0-dev`), and it carries
`publish = false`.

Two independent reasons the workflow cannot be correct here:

1. **It can never succeed.** The `bump` job runs `cargo set-version --bump
   patch`, which cannot parse the `-dev` pre-release string. Every run since
   this crate was absorbed has failed identically:

   ```
   INFO  bumping patch from 0.19.0-dev
   ERROR cargo set-version failed
   ```

   **Corrected 2026-08-14 — the `-dev` string is NOT the cause.** Measured:
   `cargo set-version --bump patch` handles `0.19.0-dev` fine and yields
   `0.19.0`. The real failure is further down this crate's `Cargo.toml`:

   ```toml
   [lints]
   workspace = true
   ```

   The vendored copy kept upstream's workspace-lints inheritance with no
   `[workspace]` root, so `cargo metadata` — which `set-version` runs first —
   dies with `error inheriting 'lints' from workspace root manifest`. Removing
   those two lines makes the bump succeed (verified on caixa-bevy-app).

   This matters because reason 1 as written sends the next reader to teach
   the bumper about pre-release strings, which would fix nothing. Reason 2
   is unaffected and is the one that actually decides this.

2. **It should not succeed.** A fork follows the version of the upstream it
   tracks; it does not mint its own. Bumping would actively diverge this
   vendored copy from upstream. And with `publish = false`, auto-release has
   nothing to publish even if the bump worked.

The fix is therefore not to teach the bumper about `-dev` — it is for the
workflow not to exist on a fork.

**Where the implementation still lives.** `pleme-io/substrate`,
`.github/workflows/cargo-auto-release.yml` — unchanged, still used by every
first-party crate.

**To restore.** Add `:auto-release` back to the `:workflows` vector in
`<crate>.caixa.lisp` and re-render via `pleme-io/actions/caixa-render`. Note
that these forks carry no render workflow, so the YAML was removed by hand in
the same commit as the declaration change.
