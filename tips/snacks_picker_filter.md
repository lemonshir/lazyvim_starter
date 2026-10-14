# Snacks Picker Filtering & Grep Guide

This document summarizes how to effectively filter search results and pass custom flags when using **Snacks Picker** (`snacks.nvim`) via `LazyVim.pick("grep")` (typically triggered by `<leader>/`).

---

## 1. Real-Time Filtering & Sub-Matching

* **Sub-Filtering via Spaces:** Type a space after your initial search term to refine current matches.
  * Example: `getUser auth` matches lines containing *both* `getUser` and `auth`.
* **Path & Extension Filters:** Append file wildcards or folder paths directly in the input bar.
  * Example: `getUser *.ts` (filters results to TypeScript files).
  * Example: `getUser src/controllers/` (filters results to a specific directory).
* **Export to Quickfix List:** Press **`<C-q>`** inside the Snacks search window to send all current matches to Neovim's Quickfix list for further iteration (`:cnext` / `:cprev`).

---

## 2. Passing `ripgrep` (`rg`) Flags On-the-Fly

You can pass CLI arguments directly to `ripgrep` by typing `-- ` (space, two dashes, space) after your search query:

```text
<search_term> -- <rg_flags>
```

### Common Flag Examples:
* **Case Sensitive:** `getUser -- -s`
* **Filter by Language/Type:** `getUser -- -t python`
* **Match Whole Words Only:** `getUser -- -w`
* **Include Hidden/Ignored Files:** `getUser -- -uu`

---

## 3. Correct Syntax for Glob Exclusions (`-g`)

### The Issue
Typing space-separated or quoted globs like `-g "!*test*"` inside the prompt can lead to 0 results due to shell argument splitting or path anchoring issues.

### Working Solutions in the Search Prompt
To exclude test files or directories while retaining valid code results, use one of the following formats:

1. **Explicit Glob Format (No spaces, recursive wildcards):**
   ```text
   uid.obj.comp.package -- -t python -g!**/test*
   ```
2. **Explicit `--glob=` Flag Format:**
   ```text
   uid.obj.comp.package -- -t python --glob=!*test*
   ```
