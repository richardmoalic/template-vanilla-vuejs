export default {
    extends: [
        "stylelint-config-standard", // Standard CSS rules
        "stylelint-config-standard-vue", // Specific rules for Vue SFCs
    ],
    // 2. Plugins for advanced features
    plugins: ["stylelint-order"],
    rules: {
        // Enforce a specific order
        "order/properties-order": [
            "position",
            "top",
            "right",
            "bottom",
            "left",
            "z-index",
            "display",
            "flex",
            "justify-content",
            "align-items",
            "float",
            "width",
            "height",
            "margin",
            "padding",
            "background",
            "color",
            "font-size",
            "border",
        ],

        "selector-pseudo-class-no-unknown": [
            true,
            {
                ignorePseudoClasses: ["deep", "global"],
            },
        ],

        "no-empty-source": null,
        "at-rule-no-unknown": [
            true,
            {
                ignoreAtRules: ["tailwind", "apply", "variants", "responsive", "screen"],
            },
        ],
    },
    // 3. Define which files to ignore
    ignoreFiles: ["dist/**/*", "node_modules/**/*"],
};
