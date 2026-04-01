export const getTestConfig = () => ({
  globals: true,
  environment: 'jsdom',
  setupFiles: ['./tests/setup.js'],
  include: ['src/**/*.{test,spec}.{js,ts,vue}', 'tests/**/*.{test,spec}.{js,ts,vue}'],
  exclude: ['node_modules/', 'tests/__snapshots__'],
});
