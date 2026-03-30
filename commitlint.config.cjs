module.exports = {
    extends: ["@commitlint/config-conventional"],
    prompt: {
        useEmoji: false,
        // REMOVED "breaking" and "footer" from this list
        skipQuestions: ["scope", "footerPrefix"],

        // 1. Define the custom labels
        messages: {
            type: "Select type:",
            subject: "Short description:",
            body: "Overview (high-level):",
            // breaking will now ask for Features
            breaking: "List the Features (use '-' for bullets):",

            footer: "3. Structure (Files added/modified):",

            issues: "4. Responsibilities (Who/What does this affect?):",
            confirmCommit: "Confirm commit?",
        },

        isIssueAffected: true,

        formatMessageCB: ({ type, subject, body, breaking, footer, issues }) => {
            return `${type}: ${subject}
Overview:
${body || "N/A"}

Features:
${breaking || "- N/A"}

Structure:
${footer || "- N/A"}

Responsibilities:
${issues || "- N/A"}`;
        },
    },
    rules: {
        "type-enum": [2, "always", ["feat", "fix", "refactor", "test", "chore"]],
        "subject-case": [0],
        "body-leading-blank": [1, "always"],
    },
};
