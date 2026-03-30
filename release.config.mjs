//release.config.mjs
export default {
    branches: ["main", { name: "develop", prerelease: true }, { name: "staging", prerelease: "rc" }],
    plugins: [
        // 1. Analyze commits
        [
            "@semantic-release/commit-analyzer",
            {
                preset: "conventionalcommits",
                releaseRules: [
                    { type: "feat", release: "minor" },
                    { type: "fix", release: "patch" },
                    { type: "perf", release: "patch" },
                    { type: "refactor", release: "patch" },
                ],
            },
        ],
        // 2. Generate release notes with your custom sections
        [
            "@semantic-release/release-notes-generator",
            {
                preset: "conventionalcommits",
                presetConfig: {
                    types: [
                        { type: "feat", section: "Features" },
                        { type: "fix", section: "Bug Fixes" },
                        { type: "perf", section: "Performance" },
                        { type: "refactor", section: "Refactoring" },
                        { type: "docs", section: "Documentation" },
                        { type: "chore", hidden: true },
                    ],
                },
            },
        ],
        // 3. Update CHANGELOG.md
        [
            "@semantic-release/changelog",
            {
                changelogFile: "CHANGELOG.md",
            },
        ],
        // 4. Update package.json version & Commit changes
        [
            "@semantic-release/git",
            {
                assets: ["CHANGELOG.md", "package.json"],
                message: "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}",
            },
        ],
        // 5. Create GitHub Release
        [
            "@semantic-release/github",
            {
                assets: [{ path: "build.zip", label: "Build" }],
            },
        ],
    ],
};
