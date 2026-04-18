<template>
  <div>
    <p data-test="message">{{ message }}</p>
    <button data-test="button" @click="increment">Count: {{ count }}</button>
  </div>
</template>

<script setup>
  import { ref } from 'vue';

  const message = 'Hello Vue!';
  const count = ref(0);

  function increment() {
    count.value++;
  }
</script>
