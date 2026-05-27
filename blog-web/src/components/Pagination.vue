<template>
  <el-pagination
    v-if="total > pageSize"
    background
    layout="prev, pager, next"
    :total="total"
    :page-size="pageSize"
    :current-page="currentPage"
    @current-change="$emit('page-change', $event)"
  />
</template>

<script setup lang="ts">
defineProps<{
  total: number
  pageSize: number
  currentPage: number
}>()

defineEmits<{
  'page-change': [page: number]
}>()
</script>
