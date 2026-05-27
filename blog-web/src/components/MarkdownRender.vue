<template>
  <MdPreview :modelValue="content" previewTheme="github" />
</template>

<script setup lang="ts">
import { MdPreview } from 'md-editor-v3'
import 'md-editor-v3/lib/preview.css'

defineProps<{
  content: string
}>()
</script>
