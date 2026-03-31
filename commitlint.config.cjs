module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "type-enum": [2, "always", ["feat", "fix", "refactor", "perf", "docs", "chore"]],
    "subject-case": [0],
    "body-leading-blank": [2, "always"],
    "header-max-length": [0], 
    "body-max-line-length": [0],
    "footer-max-line-length": [0],
  },
};