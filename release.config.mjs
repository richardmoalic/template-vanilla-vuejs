// ==========================================================
// CONFIG: Automated Release Pipeline
// TOOL: semantic-release
// VERSION: v21.x (plugin-based)
//
// DOCS: https://semantic-release.gitbook.io/
//
// PURPOSE:
//   Fully automate versioning, changelog generation, and GitHub releases
//   based on commit messages (Conventional Commits).
//
// EXECUTION:
//   - Trigger: CI (usually on push to main/develop)
//   - MODE: NON-INTERACTIVE (fully automated)
//
// DEPENDENCIES:
//   - commitlint.config.cjs → enforces commit format
//   - Conventional Commits → drives versioning logic
//   - CI workflow (release.yml) → executes semantic-release
//
// USED BY:
//   - GitHub Releases → publishes release notes + assets
//   - CHANGELOG.md → auto-generated history
//   - npm (optional) → package publishing (disabled here)
//
// VERSIONING STRATEGY:
//   - feat → minor
//   - fix → patch
//   - perf → minor
//   - others → patch or ignored
//
// BRANCH STRATEGY:
//   - main → stable releases
//   - develop → prereleases (beta)
//
// MAINTENANCE:
//   - Keep plugins updated
//   - Align rules with commitlint config
//   - Owner: @gituser
// ==========================================================

export default {
  branches: ['main', { name: 'develop', prerelease: 'beta' }],
  plugins: [
    // Analyze commits
    [
      '@semantic-release/commit-analyzer',
      {
        preset: 'conventionalcommits',
        // Release rules
        releaseRules: [
          { type: 'docs', scope: 'README', release: 'patch' },
          { type: 'feat', release: 'minor' },
          { type: 'fix', release: 'patch' },
          { type: 'perf', release: 'minor' },
          { type: 'style', release: 'patch' },
          { type: 'refactor', release: 'patch' },
        ],
      },
    ],
    // Generate release notes with your custom sections
    [
      '@semantic-release/release-notes-generator',
      {
        preset: 'conventionalcommits',
        // Custom sections for changelog
        presetConfig: {
          types: [
            { type: 'feat', section: 'Features' },
            { type: 'fix', section: 'Bug Fixes' },
            { type: 'perf', section: 'Performance' },
            { type: 'refactor', section: 'Refactoring' },
            { type: 'docs', section: 'Documentation' },
            // Hidden types
            { type: 'chore', hidden: true },
            { type: 'style', hidden: true },
            { type: 'build', hidden: true },
            { type: 'ci', hidden: true },
            { type: 'test', hidden: true },
          ],
        },
      },
    ],

    [
      '@semantic-release/npm',
      {
        npmPublish: false, // prevents publishing to npm registry
      },
    ],

    // Create GitHub Release
    [
      '@semantic-release/github',
      {
      },
    ],
  ],
};
