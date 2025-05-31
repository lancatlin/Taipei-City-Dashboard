<template>
  <div class="language-picker">
    <select
      :value="currentLanguage"
      @change="handleLanguageChange"
      class="language-select"
    >
      <option
        v-for="(label, code) in LANGUAGES"
        :key="code"
        :value="code"
      >
        {{ label }}
      </option>
    </select>
  </div>
</template>

<script setup>
 import { LANGUAGES, currentLanguage, setLanguage } from '../../../utils/i18n'

 function handleLanguageChange(event) {
   setLanguage(event.target.value)
 }
</script>

<style scoped>
 .language-picker {
     display: inline-block;
 }

 .language-select {
     padding: 0.5rem;
     border: 1px solid #ccc;
     border-radius: 4px;
     background: white;
     font-size: 0.9rem;
 }
</style>
