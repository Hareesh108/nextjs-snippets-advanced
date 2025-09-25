/*
 Simple local validator for the Next.js snippets extension.
 - Ensures package.json contributes to expected languages
 - Ensures snippets JSON is valid with unique prefixes and proper shapes
 - Ensures referenced snippet files exist
 */

const fs = require('fs');
const path = require('path');

function fail(message) {
  console.error(`\n[FAIL] ${message}`);
  process.exitCode = 1;
}

function readJson(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(content);
  } catch (err) {
    fail(`Unable to read/parse JSON: ${filePath} -> ${err.message}`);
    return null;
  }
}

(function main() {
  const repoRoot = path.resolve(__dirname, '..');
  const pkgPath = path.join(repoRoot, 'package.json');
  const pkg = readJson(pkgPath);
  if (!pkg) return;

  // Validate contributes.snippets
  const contributes = pkg.contributes;
  if (!contributes || !Array.isArray(contributes.snippets)) {
    fail('package.json missing contributes.snippets array');
    return;
  }

  const expectedLanguages = new Set(['javascriptreact', 'typescriptreact', 'javascript', 'typescript']);
  const declaredLanguages = new Set();

  for (const entry of contributes.snippets) {
    if (!entry || typeof entry.language !== 'string' || typeof entry.path !== 'string') {
      fail('Invalid contributes.snippets entry. Expected { language, path }');
      continue;
    }
    declaredLanguages.add(entry.language);
    const absSnippetPath = path.join(repoRoot, entry.path);
    if (!fs.existsSync(absSnippetPath)) {
      fail(`Snippet path does not exist: ${entry.path}`);
      continue;
    }
    // Parse the snippets file
    const snippetsJson = readJson(absSnippetPath);
    if (!snippetsJson) continue;

    // Validate each snippet
    const prefixes = new Set();
    for (const [name, value] of Object.entries(snippetsJson)) {
      if (typeof value !== 'object' || value == null) {
        fail(`Snippet "${name}" must be an object`);
        continue;
      }
      if (!value.prefix || typeof value.prefix !== 'string') {
        fail(`Snippet "${name}" is missing a string "prefix"`);
      } else {
        if (prefixes.has(value.prefix)) {
          fail(`Duplicate snippet prefix detected: ${value.prefix}`);
        }
        prefixes.add(value.prefix);
      }
      if (!Array.isArray(value.body) || value.body.some((line) => typeof line !== 'string')) {
        fail(`Snippet "${name}" must have a body: string[]`);
      }
      if (value.description !== undefined && typeof value.description !== 'string') {
        fail(`Snippet "${name}" description must be a string when provided`);
      }
    }
  }

  // Ensure all expected languages are declared
  for (const lang of expectedLanguages) {
    if (!declaredLanguages.has(lang)) {
      fail(`Missing language contribution for: ${lang}`);
    }
  }

  // Basic README presence check
  const readmePath = path.join(repoRoot, 'README.md');
  if (!fs.existsSync(readmePath)) {
    fail('README.md is missing');
  }

  if (process.exitCode) {
    console.error('\nValidation completed with errors.');
  } else {
    console.log('[OK] Validation passed.');
  }
})();


