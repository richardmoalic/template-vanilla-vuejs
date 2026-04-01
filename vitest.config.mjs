import { defineConfig } from 'vitest/config';
import vue from '@vitejs/plugin-vue';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { getTestConfig } from './vitest.test.mjs';
import { getCoverageConfig } from './vitest.coverage.mjs';

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
  },

  optimizeDeps: {
    include: ['vue', 'vue-router'],
  },
});
