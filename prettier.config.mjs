export default {
  // ----------------------------------
  // Core formatting
  // ----------------------------------
  semi: true,
  singleQuote: true,
  trailingComma: 'es5',
  printWidth: 100,
  tabWidth: 2,
  useTabs: false,

  // ----------------------------------
  // Vue / HTML
  // ----------------------------------
  vueIndentScriptAndStyle: true,
  htmlWhitespaceSensitivity: 'ignore',

  // ----------------------------------
  // Formatting behavior
  // ----------------------------------
  bracketSpacing: true,
  bracketSameLine: false,
  arrowParens: 'always',
  endOfLine: 'lf',

  // ----------------------------------
  // Overrides
  // ----------------------------------
  overrides: [
    {
      files: '*.vue',
      options: {
        parser: 'vue',
      },
    },
  ],
};
