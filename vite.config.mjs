import { defineConfig, loadEnv } from 'vite';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

// Import modular configs
import { getPlugins } from './vite.plugins.mjs';
import { getServerConfig } from './vite.server.mjs';
import { getBuildConfig } from './vite.build.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), 'VITE_');

  if (mode !== 'production') {
    console.log(`🚀 Mode: ${mode} | ENV: ${env.VITE_APP_ENV}`);
  }

  return {
    base: env.VITE_BASE_PATH || '/',

    plugins: getPlugins(mode),

    resolve: {
      alias: {
        '@': path.resolve(__dirname, 'src'),
      },
    },

    server: getServerConfig(env),

    build: getBuildConfig(mode),

    optimizeDeps: {
      include: ['vue'],
    },

    define: {
      __APP_ENV__: JSON.stringify(env.VITE_APP_ENV),
    },
  };
});
