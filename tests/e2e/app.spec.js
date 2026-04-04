import { expect, test } from '@playwright/test';

test.describe('App CI Dummy Test', () => {
  test('should render the dummy component with correct message', async ({ page }) => {
    // 1. Go to the local dev server (Playwright config usually handles the base URL)
    await page.goto('/');

    // 2. Locate the paragraph inside the dummy component
    const message = page.locator('.dummy-component p');

    // 3. Assert the text matches your Vue ref
    await expect(message).toBeVisible();
    await expect(message).toHaveText('Hello ESLint!');
  });
});
