

export const getBuildConfig = (mode) => ({
    outDir: "dist",
    target: "esnext",
    minify: "esbuild",
    esbuild: {
        drop: mode === "production" ? ["console", "debugger"] : [],
        legalComments: "none",
    },
    sourcemap: mode !== "production",
    rollupOptions: {
        output: {
            chunkFileNames: "assets/js/[name]-[hash].js",
            entryFileNames: "assets/js/[name]-[hash].js",
            assetFileNames: "assets/[ext]/[name]-[hash].[ext]",
        },
    },
});
