import vue from '@vitejs/plugin-vue';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitest/config';

import { getCoverageConfig } from './vitest.coverage.mjs';
import { getTestConfig } from './vitest.test.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  plugins: [vue()],

  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  },

  test: {
    ...getTestConfig(),
    coverage: getCoverageConfig(),
    cache: {
      dir: process.env.VITEST_CACHE_DIR || 'node_modules/.vitest',
    },
  },

  optimizeDeps: {
    include: ['vue', 'vue-router'],
  },
});
