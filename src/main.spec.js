import { createApp } from 'vue';
import App from '@/App.vue';

test('app mounts', () => {
  const div = document.createElement('div');
  div.id = 'app';
  document.body.appendChild(div);
  const app = createApp(App);
  expect(() => app.mount('#app')).not.toThrow();
});
