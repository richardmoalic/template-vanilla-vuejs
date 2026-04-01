//release.config.mjs
export default {
    branches: ["main", { name: "develop", prerelease: "beta" }, { name: "staging", prerelease: "rc" }],
    plugins: [
        // 1. Analyze commits
        [
            "@semantic-release/commit-analyzer",
            {
                preset: "conventionalcommits",
                releaseRules: [
                    { type: 'docs', scope: 'README', release: 'patch' },
                    { type: "feat", release: "minor" },
                    { type: "fix", release: "patch" },
                    { type: "perf", release: "minor" },
                    { type: 'style', release: 'patch' },
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
                        { type: "style", hidden: true  },
                        { type: "build", hidden: true  },
                        { type: "ci", hidden: true  },
                        { type: "test", hidden: true  },
                    ],
                },
            },
        ],

        ['@semantic-release/npm', {
      npmPublish: false,
    }],

        // 3. Update CHANGELOG.md
        [
            "@semantic-release/changelog",
            {
                changelogFile: "CHANGELOG.md",
            },
        ],

        // 5. Create GitHub Release
        [
            "@semantic-release/github", 
            {
               assets: 
               [
                { path: "build-v*.zip", label: "Build" }
                ]
            }
        ]
    ],
};
