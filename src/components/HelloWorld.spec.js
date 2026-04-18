import { describe, expect, it } from 'vitest';
import { mount } from '@vue/test-utils';
import HelloWorld from './HelloWorld.vue';

describe('HelloWorld.vue', () => {
  it('renders message', () => {
    const wrapper = mount(HelloWorld);
    expect(wrapper.get('[data-test="message"]').text()).toBe('Hello Vue!');
  });

  it('increments count when button is clicked', async () => {
    const wrapper = mount(HelloWorld);

    const button = wrapper.get('[data-test="button"]');

    expect(button.text()).toContain('0');

    await button.trigger('click');
    expect(button.text()).toContain('1');

    await button.trigger('click');
    expect(button.text()).toContain('2');
  });
});
