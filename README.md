# Claude Usage Systray

A lightweight macOS menu bar app that shows your [Claude.ai](https://claude.ai) plan usage in real time — current session and weekly limits — without opening a browser.

![Claude Usage Systray](claude-usage-systray/Resources/Assets.xcassets/Image.imageset/Image.png)

## What it shows

Mirrors the data on `claude.ai/settings/usage`:

| Metric | Description |
|--------|-------------|
| **5h** | Current session usage (resets every ~5 hours) |
| **7d** | Weekly all-models usage |
| **Sonnet** | Weekly Sonnet-only usage (shown in popover) |

Colors update based on your configured warning/critical thresholds.

## Features

- Real-time usage monitoring in the menu bar (configurable refresh interval)
- Compact or normal display mode
- Configurable warning/critical thresholds with color indicators
- macOS notifications when usage thresholds are crossed
- Progressive retry backoff on API errors (1m → 2m → 5m → 10m → 15m)
- Separate handling for auth errors vs rate limits
- Zero configuration — reads OAuth token from Claude Code's Keychain automatically

## Requirements

- macOS 13+
- Apple Silicon (arm64)
- [Claude Code](https://claude.ai/code) installed and logged in (the app reads its OAuth token from your Keychain — no separate credentials needed)

## Install

Download the latest `ClaudeUsageSystray.zip` from the [Releases page](https://github.com/CodeMasterChef/claude-usage-systray/releases), unzip, and move `ClaudeUsageSystray.app` to `/Applications`.

> **Note:** The app is not notarized. On first launch, right-click the app → Open, or run:
> ```bash
> xattr -cr /Applications/ClaudeUsageSystray.app
> ```

## Build from source

```bash
git clone https://github.com/CodeMasterChef/claude-usage-systray
cd claude-usage-systray/claude-usage-systray
xcodebuild -scheme ClaudeUsageSystray -configuration Release build
open ~/Library/Developer/Xcode/DerivedData/ClaudeUsageSystray-*/Build/Products/Release/ClaudeUsageSystray.app
```

Or open `ClaudeUsageSystray.xcodeproj` in Xcode and run with ⌘R.

## Display modes

Toggle **Compact display** in Settings to switch between:

- **Compact (default):** `35% · 71%` — both 5h and 7d inline, each colored by threshold
- **Normal:** icon + `71%` — weekly usage only

## How it works

The app reads your Claude Code OAuth token from the macOS Keychain (`Claude Code-credentials`) and calls the same internal endpoint that powers `claude.ai/settings/usage`:

```
GET https://api.anthropic.com/api/oauth/usage
Authorization: Bearer <oauth_token>
anthropic-beta: oauth-2025-04-20
```

The token is read once at startup and cached in memory. On errors, the cache is cleared so the next request picks up a refreshed token from the Keychain automatically.

> **Note:** This endpoint is undocumented and may change. It requires Claude Code to be installed and logged in.

## Settings

| Setting | Default | Description |
|---------|---------|-------------|
| Compact display | On | Show both 5h and 7d in menu bar |
| Refresh interval | 60s | How often to poll the API (30–300 seconds) |
| Warning threshold | 80% | Orange color above this |
| Critical threshold | 90% | Red color above this |
| Usage alerts | On | macOS notification when thresholds are crossed |

## Running tests

```bash
xcodebuild test -project ClaudeUsageSystray.xcodeproj \
  -scheme ClaudeUsageSystrayTests \
  -destination 'platform=macOS'
```

## License

MIT
