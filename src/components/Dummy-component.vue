<template>
  <div class="dummy-component">
    <p>{{ message }}</p>
  </div>
</template>

<script setup>
  import { ref } from 'vue';

  const message = ref('Hello ESLint!');
</script>

<style scoped>
  .dummy-component {
    color: red;
  }
</style>
