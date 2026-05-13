<template>
  <div>
    <p data-test="message">{{ message }}</p>
    <p data-test="quote">{{ quote }}</p>
    <button data-test="button" @click="increment">Count: {{ count }}</button>
  </div>
</template>

<script setup>
  import { ref } from 'vue';

  const message = 'Hello Vue!';
  const quote = 'Lorem ipsum';
  const count = ref(0);

  function increment() {
    count.value++;
  }
</script>
