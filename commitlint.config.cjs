// ==========================================================
// CONFIG: Commit Message Linting
// TOOL: Commitlint
// VERSION: v17.x (extends @commitlint/config-conventional)
// # DOCUMENTATION: https://commitlint.js.org/
//
// PURPOSE:
//   Enforce Conventional Commits and structured commit messages.
//
// EXECUTION:
//   - Trigger: git commit (via Husky commit-msg hook)
//   - MODE: BLOCKING (rejects invalid commit messages)
//
// DEPENDENCIES:
//   - .husky/commit-msg → executes commitlint via pnpm script
//   - package.json#scripts.cm:check → CLI entry point
//
// USED BY:
//   - release workflow → semantic versioning
//   - changelog generation → automated release notes
//
// PATTERN:
//   - Conventional Commits: type(scope): subject
//
// NOTES:
//   - Custom prompt enforces structured commit body (Overview / Changes / Footer)
//   - Optimized for Vite + pnpm + Vue/React projects
//
// MAINTENANCE:
//   - Update scopes when adding new domains (e.g. auth)
//   - Review rules when changing commit conventions
//   - Owner: @gituser
// ==========================================================

const scopes = [
  'components',
  'views',
  'store',
  'hooks',
  'utils',
  'assets',
  'deps',
  'config',
  'api',
  'tests',
];

module.exports = {
  extends: ['@commitlint/config-conventional'],
  prompt: {
    useEmoji: false,
    skipQuestions: ['footerPrefix'],
    scopes,

    messages: {
      type: 'Select type:',
      scope: 'Select scope (optional):',
      subject: 'Short description (Title):',
      body: '1. Overview (high-level):',
      breaking: '2. Features / Breaking Changes:',
      footer: '3. Footer (Issues / Metadata):',
      confirmCommit: 'Confirm commit?',
    },

    formatMessageCB: ({ type, scope, subject, body, breaking, footer }) => {
      // 1. Build the Header: type(scope): subject
      const headerScope = scope ? `(${scope})` : '';
      const header = `${type}${headerScope}: ${subject}`;

      // 2. Assemble the Body Sections
      return `${header}

Overview:
${body || 'N/A'}

Changes:
${breaking || 'N/A'}

Footer:
${footer || 'N/A'}`;
    },
  },
  rules: {
    // Standard Conventional Types
    'type-enum': [
      2,
      'always',
      ['build', 'feat', 'fix', 'refactor', 'perf', 'docs', 'chore', 'ci', 'style', 'test'],
    ],
    'scope-enum': [2, 'always', [...scopes, 'root']],
    'subject-case': [0], // allow any casing
    'body-leading-blank': [2, 'always'], // Enforce readability
    'header-max-length': [0], // no length limit
    'body-max-line-length': [0], // allow long descriptions
    'footer-max-line-length': [0],
  },
};
