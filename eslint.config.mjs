import eslintConfigPkg from "eslint/config";
import vue from "eslint-plugin-vue";
import unicorn from "eslint-plugin-unicorn";
import js from "@eslint/js";
import prettier from "eslint-config-prettier/flat";
import globals from "globals";

const { globalIgnores } = eslintConfigPkg;

export default [
  // 1. GLOBAL IGNORES
  globalIgnores([
    "node_modules/**",
    "dist/**",
    "build/**",
    "coverage/**",
    "test-results/**",
    "*.min.*",
    "*.map",
    ".DS_Store",
    ".eslintcache",
    "playwright-report/**",
    "blob-report/**",
    ".env",
    ".env.*",
    ".vscode",
    ".idea",
    "!.env.example",
  ]),

  // 2. BASE CONFIGS
  js.configs.recommended,
  ...vue.configs["flat/recommended"], // This loads the plugin and standard rules correctly

  // 3. VUE SPECIFIC OVERRIDES
  {
    files: ["**/*.vue"],
    plugins: { vue },
    rules: {
      "vue/component-name-in-template-casing": [
        "error",
        "PascalCase",
        { registeredComponentsOnly: true, ignores: [] },
      ],
      // FIX: This replaces the old 'name-property-casing'
      "vue/component-definition-name-casing": ["error", "PascalCase"],
    },
  },

  // 4. GENERAL JS + VUE RULES
  {
    files: ["**/*.{js,vue}"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.node,
        ...globals.vitest,
        window: "readonly",
        document: "readonly",
        navigator: "readonly",
        console: "readonly",
      },
    },
    plugins: { unicorn },
    rules: {
      "no-console": "off",
      "no-debugger": "warn",
      "sort-imports": [
        "warn",
        {
          ignoreCase: true,
          ignoreDeclarationSort: true,
          ignoreMemberSort: false,
        },
      ],
      "unicorn/filename-case": [
        "error",
        { case: "camelCase", ignore: [
      "^use[A-Z]", 
      "^.+\\.vue$", 
      "\\.spec\\.js$", 
      "\\.test\\.js$" 
    ]},
      ],
    },
  },

  // 5. FOLDER SPECIFIC RULES
  {
    files: ["src/utils/**/*.js"],
    rules: {
      "unicorn/filename-case": ["error", { case: "kebabCase" }],
    },
  },
  {
    files: ["src/composables/**/*.js"],
    rules: {
      "unicorn/filename-case": [
        "error",
        { case: "camelCase", ignore: ["^use[A-Z]"] },
      ],
    },
  },

  // 6. PRETTIER 
  prettier,
];