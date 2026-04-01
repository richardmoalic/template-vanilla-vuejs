module.exports = {
  extends: ['@commitlint/config-conventional'],
  prompt: {
    useEmoji: false,
    // We include 'scope' now, but keep footerPrefix skipped to simplify
    skipQuestions: ['footerPrefix'],

    scopes: [
      'components', // UI components
      'views', // Page/Route components
      'store', // Pinia/Vuex modules
      'hooks', // Composables
      'utils', // Helper functions
      'assets', // Images, global CSS
      'deps', // Package.json updates
      'config', // Vite/TS/Lint configs
      'api', // Axios/Fetch services
      'tests', // Vitest/Playwright
    ],

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
    'scope-enum': [
      2,
      'always',
      [
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
        'root',
      ],
    ],
    'subject-case': [0],
    'body-leading-blank': [2, 'always'],
    'header-max-length': [0],
    'body-max-line-length': [0],
    'footer-max-line-length': [0],
  },
};
