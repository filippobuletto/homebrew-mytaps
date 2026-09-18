# homebrew-mytaps

A personal [Homebrew](https://brew.sh) tap for macOS applications that Homebrew
itself will not ship in a usable state. Two kinds of cask live here:

- **Patched casks** — the upstream tap still uses deprecated Cask DSL, so every
  `brew update` prints a deprecation warning. The copy here is the same cask
  with the deprecated stanzas rewritten.
- **Re-enabled casks** — Homebrew disabled the cask rather than fixing it,
  usually because the app is not signed the way Gatekeeper wants. The copy here
  drops the `disable!` stanza.

## Install

```sh
brew tap filippobuletto/mytaps
brew install --cask filippobuletto/mytaps/<cask>
```

The tap name drops the `homebrew-` prefix that Homebrew requires on the
repository name: `filippobuletto/mytaps` is
`github.com/filippobuletto/homebrew-mytaps`.

Every token in this tap also exists in `homebrew/cask`, and a bare token
resolves there first. Always pass the fully qualified name on the command line.

## Contents

| Cask | Version | Why it is here |
| --- | --- | --- |
| `alacritty` | 0.17.0 | disabled upstream 2026-09-01, `:fails_gatekeeper_check` |
| `aria2d` | 1.4.2 | disabled upstream 2026-09-01, `:fails_gatekeeper_check` |
| `browserino` | 1.1.16 | `alexstrnik/browserino` uses a deprecated stanza |
| `freetube` | 0.25.3 | disabled upstream 2026-09-01, `:fails_gatekeeper_check` |
| `jd-gui` | 1.6.6 | disabled upstream 2026-09-01, `:fails_gatekeeper_check` |
| `mew-notch` | 2.2.2 | `monuk7735/tap` uses deprecated stanzas |

### What was changed

| Cask | Change |
| --- | --- |
| `alacritty` | `disable!` removed |
| `aria2d` | `disable!` removed. Release 1.4.2 dropped the build number from its tag, so the version is a plain `1.4.2` instead of the old `version,build` pair, and livecheck follows GitHub releases instead of the Sparkle appcast |
| `browserino` | `depends_on macos: ">= :ventura"` → `depends_on macos: :ventura`; `livecheck` added |
| `freetube` | `disable!` removed; the legacy `on_big_sur :or_older` branch dropped in favour of a single version with `depends_on macos: :monterey` |
| `jd-gui` | `disable!` removed |
| `mew-notch` | `verified:` dropped from `url`; `depends_on macos: ">= :sonoma"` → `depends_on macos: :sonoma`; `postflight` → `postflight_steps` |

FreeTube tags every release `-beta`, which GitHub reports as a pre-release and
`brew audit` rejects. `audit_exceptions/github_prerelease_allowlist.json` allows
it.

## Gatekeeper

`alacritty`, `aria2d`, `freetube` and `jd-gui` are here because they fail
`spctl -a`: Alacritty and FreeTube are ad-hoc signed, JD-GUI carries no usable
signature, and Aria2D is signed with a development certificate instead of a
Developer ID one.

Each of the four runs `xattr -dr com.apple.quarantine` on the installed app in a
`postflight_steps` block, so the app launches without a Gatekeeper prompt — and
without macOS verifying it, on this install or on any later upgrade. That is the
trade Homebrew declined to make on its users' behalf; it is made deliberately
here.

To get the checks back, delete the `postflight_steps` block from the cask and
reinstall it. macOS will then want a one-off approval per app under **System
Settings → Privacy & Security**.

## Switching an already installed cask over

```sh
brew uninstall --cask browserino mew-notch
brew untap alexstrnik/browserino monuk7735/tap
brew install --cask filippobuletto/mytaps/browserino filippobuletto/mytaps/mew-notch
```

`brew uninstall` does not run `zap`, so application settings survive. If
`brew untap` refuses because a cask token is still installed, remove the tap
directory under `$(brew --repository)/Library/Taps/` instead — `--force` would
uninstall the apps.

## Staying current

A cask here is a copy, so a new upstream release does not reach you until
`version` and `sha256` change in this repository.

`.github/workflows/bump-casks.yml` does that daily. It runs `brew livecheck`
over the tap and, for every outdated cask, runs `brew bump-cask-pr
--write-only --commit`: the stanzas are rewritten, the artifact is re-downloaded
to compute the new checksum, `brew audit` and `brew style` run, and the commit
is pushed to `main`. `brew update` then picks it up and `brew upgrade --cask`
installs it.

The workflow needs nothing beyond the default `GITHUB_TOKEN`, but the repository
must let Actions push: **Settings → Actions → General → Workflow permissions →
Read and write permissions**. It can also be run from the Actions tab, where the
`dry_run` input reports available versions without writing or pushing anything.

`.github/workflows/ci.yml` runs `brew style` and `brew audit --cask --strict
--online` on every change under `Casks/`.

Bumping by hand:

```sh
brew livecheck --cask --newer-only --tap filippobuletto/mytaps
brew bump-cask-pr --write-only --version=<new> filippobuletto/mytaps/<cask>
```

## Working on the tap locally

`brew tap filippobuletto/mytaps` clones this repository into
`$(brew --repository)/Library/Taps/filippobuletto/homebrew-mytaps`, so brew sees
pushed commits only. To test edits from a working copy, replace that directory
with a symlink to it:

```sh
ln -s /path/to/homebrew-mytaps \
  "$(brew --repository)/Library/Taps/filippobuletto/homebrew-mytaps"
```

Then validate before committing:

```sh
brew style filippobuletto/mytaps
brew audit --cask --strict --online filippobuletto/mytaps/<cask>
```

## Retiring a cask

When upstream fixes its own deprecations, or Homebrew re-enables a disabled
cask, drop the file from `Casks/` and reinstall from the upstream tap.
