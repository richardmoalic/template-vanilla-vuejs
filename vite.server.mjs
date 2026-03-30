export const getServerConfig = (env) => ({
    port: 5173,
    strictPort: true,
    open: true,
    proxy: {
        "/api": {
            target: env.VITE_API_URL || "http://localhost:3000",
            changeOrigin: true,
            rewrite: (path) => path.replace(/^\/api/, ""),
        },
    },
});
