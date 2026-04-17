import { describe, expect, it, vi } from 'vitest';
import { fireEvent, render } from '@testing-library/vue';
import AppButton from './AppButton.vue';

describe('Button', () => {
  it('renders default label', () => {
    const { getByTestId } = render(AppButton);

    const button = getByTestId('app-button');
    expect(button.textContent).toContain('Click me');
  });

  it('renders custom label', () => {
    const { getByText } = render(AppButton, {
      props: { label: 'Submit' },
    });

    expect(getByText(/Submit/)).toBeTruthy();
  });

  it('emits click event', async () => {
    const { getByTestId, emitted } = render(AppButton);

    const button = getByTestId('app-button');
    await fireEvent.click(button);

    expect(emitted().click).toBeTruthy();
    expect(emitted().click.length).toBe(1);
  });

  it('displays provided version prop', () => {
    const { getByText } = render(AppButton, {
      props: { version: '1.2.3' },
    });

    expect(getByText(/v1.2.3/)).toBeTruthy();
  });

  it('falls back to VITE_APP_VERSION env', () => {
    vi.stubEnv('VITE_APP_VERSION', '9.9.9');

    const { getByText } = render(AppButton);

    expect(getByText(/v9.9.9/)).toBeTruthy();

    vi.unstubAllEnvs();
  });

  it('should not use default version in CI', () => {
    const version = import.meta.env.VITE_APP_VERSION;
    expect(version).not.toBe('0.0.0');
  });
});
