# 🔐 Android App Signing Setup Guide

This guide explains how to set up secure Android app signing for **Aqua Harmony** using GitHub Actions.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Privacy Statement](#privacy-statement)
3. [Prerequisites](#prerequisites)
4. [Step 1: Generate Keystore](#step-1-generate-keystore)
5. [Step 2: Add GitHub Secrets](#step-2-add-github-secrets)
6. [Step 3: Trigger the Workflow](#step-3-trigger-the-workflow)
7. [Troubleshooting](#troubleshooting)
8. [Security Best Practices](#security-best-practices)

---

## Overview

This project includes an automated CI/CD pipeline that:

- ✅ Builds **signed APK** and **AAB** files on every push
- ✅ Uses GitHub Secrets for all sensitive data
- ✅ Decodes the keystore from base64 at runtime
- ✅ **Deletes** the keystore after the build completes
- ✅ **Never** prints or exposes secrets in logs
- ✅ Uploads artifacts for easy download

---

## Privacy Statement

> ⚠️ **IMPORTANT: The keystore generation script does NOT collect any personal or system data.**

The `generate_keystore` script:

- ❌ Does **NOT** collect system information
- ❌ Does **NOT** collect IP addresses
- ❌ Does **NOT** collect location data
- ❌ Does **NOT** auto-fill any values
- ❌ Does **NOT** send data anywhere
- ✅ Only uses values **you manually enter**
- ✅ All inputs are provided interactively by the user

---

## Prerequisites

Before you begin, ensure you have:

- **Java JDK 17+** installed (for `keytool` command)
- **Git** repository with GitHub Actions enabled
- **Admin access** to your GitHub repository (to add secrets)

### Verify Java Installation

```bash
# Check if keytool is available
keytool -help

# Or check Java version
java -version
```

---

## Step 1: Generate Keystore

### On Windows (PowerShell)

```powershell
cd scripts
.\generate_keystore.ps1
```

### On macOS/Linux (Bash)

```bash
cd scripts
chmod +x generate_keystore.sh
./generate_keystore.sh
```

### Information You'll Need to Provide

The script will prompt you for **10 pieces of information**:

| # | Field | Example | Description |
|---|-------|---------|-------------|
| 1 | Common Name | `Aqua Harmony` | Your name or app name |
| 2 | Organizational Unit | `Mobile Development` | Department/team |
| 3 | Organization | `My Company Inc` | Company name |
| 4 | City | `San Francisco` | City/locality |
| 5 | State | `California` | State/province |
| 6 | Country Code | `US` | Two-letter country code |
| 7 | Email | `dev@example.com` | Contact email |
| 8 | Key Alias | `aqua-harmony-key` | Identifier for the key |
| 9 | Keystore Password | (your choice) | Min 6 characters |
| 10 | Key Password | (your choice) | Min 6 characters |

### Output Files

After running the script, you'll have:

- `release-keystore.jks` - The actual keystore file (keep secure!)
- `release-keystore.base64.txt` - Base64 encoded version for GitHub

---

## Step 2: Add GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add these **4 secrets**:

| Secret Name | Value |
|-------------|-------|
| `KEYSTORE_BASE64` | Entire content of `release-keystore.base64.txt` |
| `KEY_ALIAS` | The key alias you entered (e.g., `aqua-harmony-key`) |
| `KEYSTORE_PASSWORD` | Your keystore password |
| `KEY_PASSWORD` | Your key password |

### How to Copy Base64 Content

**Windows PowerShell:**
```powershell
Get-Content release-keystore.base64.txt | Set-Clipboard
```

**macOS:**
```bash
cat release-keystore.base64.txt | pbcopy
```

**Linux:**
```bash
cat release-keystore.base64.txt | xclip -selection clipboard
```

---

## Step 3: Trigger the Workflow

The workflow runs automatically on:

- ✅ Push to `main`, `master`, or `develop` branches
- ✅ Pull requests to `main` or `master`
- ✅ Any tag starting with `v` (e.g., `v1.0.0`)
- ✅ Manual trigger via GitHub Actions UI

### Manual Trigger

1. Go to **Actions** tab in your repository
2. Select **"Android Build & Sign"** workflow
3. Click **"Run workflow"**
4. Select branch and click **"Run workflow"**

### Download Artifacts

After a successful build:

1. Go to the **Actions** tab
2. Click on the completed workflow run
3. Scroll to **Artifacts** section
4. Download `aqua-harmony-release-apk` or `aqua-harmony-release-aab`

---

## Troubleshooting

### "Keystore was tampered with, or password was incorrect"

- Verify `KEYSTORE_PASSWORD` secret is correct
- Re-encode the keystore: `base64 -w 0 release-keystore.jks > release-keystore.base64.txt`
- Ensure no extra whitespace in the secret

### "keytool: command not found"

- Install Java JDK 17+
- Add Java to your PATH
- On Windows, set `JAVA_HOME` environment variable

### Build fails with signing error

1. Check all 4 secrets are configured correctly
2. Verify the key alias matches exactly (case-sensitive)
3. Ensure passwords don't contain special characters that need escaping

### Workflow not triggering

- Check branch name matches workflow trigger conditions
- Verify GitHub Actions is enabled for your repository

---

## Security Best Practices

### ✅ DO

- Store the original `.jks` file in a secure backup (password manager, encrypted drive)
- Use strong, unique passwords for keystore and key
- Rotate keys periodically for enhanced security
- Delete local keystore files after adding to GitHub Secrets

### ❌ DON'T

- Never commit `.jks`, `.keystore`, or `key.properties` files
- Never share your passwords via email, chat, or unencrypted channels
- Never print secrets in CI/CD logs
- Never use the same keystore for multiple apps in production

---

## File Structure

```
.github/
└── workflows/
    └── android-build.yml    # GitHub Actions workflow

android/
├── app/
│   ├── build.gradle.kts     # Signing configuration
│   └── proguard-rules.pro   # Code obfuscation rules
└── key.properties           # (Generated at build time, NOT committed)

scripts/
├── generate_keystore.sh     # Bash script for macOS/Linux
└── generate_keystore.ps1    # PowerShell script for Windows

docs/
└── SIGNING_SETUP.md         # This file
```

---

## Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review GitHub Actions logs for detailed error messages
3. Ensure all prerequisites are met

---

**🎮 Happy Building!**

