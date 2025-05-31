import { ref, computed } from 'vue'

// Available languages
export const LANGUAGES = {
	'zh-tw': '繁體中文',
	'en': 'English',
	'ja': '日本語'
}

// Current language state
export const currentLanguage = ref(localStorage.getItem('dashboard-language') || 'zh-tw')

// Translation dictionaries
const translations = {
	'zh-tw': {},
	'en': {},
	'ja': {}
};

// Load translation files
async function loadTranslations() {
	try {
		const zhtw = await import('../locales/zh-tw.js');
		const en = await import('../locales/en.js');
		const ja = await import('../locales/ja.js');

		translations['zh-tw'] = zhtw.default;
		translations.en = en.default;
		translations.ja = ja.default;
	} catch (error) {
		console.warn('Failed to load some translations:', error);
	}
}

// Initialize translations
loadTranslations();

// Translation function
export function t(key) {
	if (!key) return key;
	const transformedKey = key.trim();
	let value = translations[currentLanguage.value][transformedKey];
	return value || key;
}

// Reactive translation function for use in templates
export const $t = computed(() => t);

// Language switcher
export function setLanguage(lang) {
	if (LANGUAGES[lang]) {
		currentLanguage.value = lang;
		localStorage.setItem('dashboard-language', lang);
		document.documentElement.lang = lang;
	}
}

// Get current language
export const getCurrentLanguage = () => currentLanguage.value;
