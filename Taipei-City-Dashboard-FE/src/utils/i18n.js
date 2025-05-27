import { ref, computed } from 'vue'

// Available languages
export const LANGUAGES = {
  'zh-TW': '繁體中文',
  'en': 'English',
  'ja': '日本語'
}

// Current language state
export const currentLanguage = ref(localStorage.getItem('dashboard-language') || 'zh-TW')

// Translation dictionaries
const translations = {
  'zh-TW': {},
  'en': {},
  'ja': {}
}

// Load translation files
async function loadTranslations() {
  try {
    const zhTW = await import('../locales/zh-TW.js')
    const en = await import('../locales/en.js')
    const ja = await import('../locales/ja.js')

    translations['zh-TW'] = zhTW.default
    translations.en = en.default
    translations.ja = ja.default
  } catch (error) {
    console.warn('Failed to load some translations:', error)
  }
}

// Initialize translations
loadTranslations()

// Translation function
export function t(key, params = {}) {
  const keys = key.split('.')
  let value = translations[currentLanguage.value]

  for (const k of keys) {
    value = value?.[k]
  }

  if (!value) {
    console.warn(`Translation missing for key: ${key}`)
    return key
  }

  // Simple parameter replacement
  return Object.keys(params).reduce((str, param) => {
    return str.replace(new RegExp(`{${param}}`, 'g'), params[param])
  }, value)
}

// Reactive translation function for use in templates
export const $t = computed(() => t)

// Language switcher
export function setLanguage(lang) {
  if (LANGUAGES[lang]) {
    currentLanguage.value = lang
    localStorage.setItem('dashboard-language', lang)
    document.documentElement.lang = lang
  }
}

// Get current language
export const getCurrentLanguage = () => currentLanguage.value