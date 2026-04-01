import fs from 'node:fs';
import path from 'node:path';

const BASE_THRESHOLD = {
  lines: 50,
  functions: 50,
  branches: 50,
  statements: 50,
};

const CRITICAL_PATH_THRESHOLD = {
  lines: 80,
  functions: 90,
  branches: 80,
  statements: 80,
};

const CRITICAL_FOLDERS = ['utils', 'stores'];

/**
 * Generate per-folder thresholds automatically
 */
function generateFolderThresholds() {
  const srcPath = path.resolve('src');
  if (!fs.existsSync(srcPath)) return {};

  const folders = fs
    .readdirSync(srcPath, { withFileTypes: true })
    .filter((f) => f.isDirectory())
    .map((f) => f.name);

  const thresholds = {};

  folders.forEach((folder) => {
    thresholds[`src/${folder}`] = CRITICAL_FOLDERS.includes(folder)
      ? CRITICAL_PATH_THRESHOLD
      : BASE_THRESHOLD;
  });

  // Add a catch-all for files directly under src/ not in a folder
  thresholds['src/*'] = BASE_THRESHOLD;

  return thresholds;
}

export const getCoverageConfig = () => ({
  enabled: true,
  provider: 'v8',
  reporter: ['text', 'html', 'lcov'],
  include: ['src/**/*.{js,ts,vue}'],
  exclude: [
    'node_modules/',
    'tests/',
    'src/main.{js,ts}', // Entry point (untestable side effects)
    'src/**/*.spec.{js,ts}',
    'src/**/*.d.ts', // TypeScript definitions
    'src/assets/**', // Static assets
    'src/style.css',
  ],

  // global baseline
  thresholds: BASE_THRESHOLD,
  all: true,
  clean: true,
  reportsDirectory: 'coverage',
  folderThresholds: generateFolderThresholds(),
});
