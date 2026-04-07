Build, package, commit, push, and create a GitHub Release for ClaudeUsageSystray.

## Steps

When the user invokes `/release`, follow these steps exactly:

### 1. Determine version

- Check the latest git tag: `git describe --tags --abbrev=0 2>/dev/null`
- If the user provided a version (e.g., `/release 1.2.0`), use it. Otherwise, bump the patch version from the latest tag (e.g., `v1.1.0` → `v1.2.0`).
- Confirm the version with the user before proceeding.

### 2. Run tests

```bash
xcodebuild -project claude-usage-systray/ClaudeUsageSystray.xcodeproj \
  -scheme ClaudeUsageSystray test
```

If tests fail, stop and report.

### 3. Build Release binary

```bash
xcodebuild -project claude-usage-systray/ClaudeUsageSystray.xcodeproj \
  -scheme ClaudeUsageSystray \
  -configuration Release \
  clean build \
  CONFIGURATION_BUILD_DIR=/tmp/ClaudeUsageBuild \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_ALLOWED=NO
```

### 4. Package as zip

```bash
cd /tmp/ClaudeUsageBuild && \
  zip -r /Volumes/CORSAIR/Disk/ForFun/claude-usage-systray/ClaudeUsageSystray.zip ClaudeUsageSystray.app
```

### 5. Commit and push

- Stage all modified source files (do NOT stage `ClaudeUsageSystray.zip` — it's in .gitignore)
- Commit with message: `release: vX.Y.Z`
- Push to `origin main`

### 6. Create git tag and GitHub Release

```bash
git tag vX.Y.Z
git push origin vX.Y.Z

gh release create vX.Y.Z \
  --title "vX.Y.Z" \
  --generate-notes \
  ClaudeUsageSystray.zip
```

### 7. Report

Print a summary:
- Version released
- GitHub Release URL
- Zip file size

## Important notes

- Always run tests before building
- Never commit the zip file to git
- If any step fails, stop and report the error — do not continue
- The zip is arm64 only and not notarized — mention this in the release notes
