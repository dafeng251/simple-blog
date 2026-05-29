<template>
  <div class="icon-input">
    <el-input :model-value="modelValue" @update:model-value="$emit('update:modelValue', $event)" :placeholder="placeholder" clearable />
    <el-icon v-if="resolvedIcon" :size="20" class="icon-preview"><component :is="resolvedIcon" /></el-icon>
    <el-icon v-else :size="20" class="icon-placeholder"><QuestionFilled /></el-icon>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import * as icons from '@element-plus/icons-vue'
import { QuestionFilled } from '@element-plus/icons-vue'

const props = defineProps<{
  modelValue: string
  placeholder?: string
}>()

defineEmits<{ 'update:modelValue': [value: string] }>()

const resolvedIcon = computed(() => {
  if (!props.modelValue) return null
  return (icons as Record<string, any>)[props.modelValue] || null
})
</script>

<style scoped>
.icon-input {
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
}
.icon-input .el-input {
  flex: 1;
}
.icon-preview {
  flex-shrink: 0;
  color: var(--el-color-primary);
}
.icon-placeholder {
  flex-shrink: 0;
  color: var(--el-text-color-placeholder);
}
</style>
