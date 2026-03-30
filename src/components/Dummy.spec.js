import { describe, expect, it } from 'vitest';
import { mount } from '@vue/test-utils';
import DummyComponent from './Dummy-component.vue';

describe('DummyComponent', () => {
  it('mounts properly', () => {
    const wrapper = mount(DummyComponent);
    expect(wrapper.exists()).toBe(true);
  });

  it('renders the message', () => {
    const wrapper = mount(DummyComponent);
    expect(wrapper.text()).toContain('Hello ESLint!');
  });

  it('has the correct class', () => {
    const wrapper = mount(DummyComponent);
    expect(wrapper.classes()).toContain('dummy-component');
  });
});
