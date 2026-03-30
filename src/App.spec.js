import { mount } from '@vue/test-utils';
import App from '@/App.vue';

test('renders App.vue', () => {
  const wrapper = mount(App);
  expect(wrapper.exists()).toBe(true);
});
