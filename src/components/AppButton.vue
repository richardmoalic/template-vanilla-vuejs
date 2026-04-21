<script setup>
  import { computed } from 'vue';

  const props = defineProps({
    label: {
      type: String,
      default: 'Click me',
    },
    version: {
      type: String,
      default: null,
    },
  });

  const emit = defineEmits(['click']);

  const displayLabel = computed(() => {
    const versionValue = props.version || import.meta.env.VITE_APP_VERSION || '0.0.0';
    return `${props.label} (v${versionValue})`;
  });

  function handleClick(event) {
    emit('click', event);
  }
</script>

<template>
  <button class="btn" data-testid="app-button" @click="handleClick">
    {{ displayLabel }}
  </button>
</template>
