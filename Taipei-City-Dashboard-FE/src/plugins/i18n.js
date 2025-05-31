import { t, $t, currentLanguage, setLanguage } from '../utils/i18n'

export default {
    install(app) {
        // Global properties
        app.config.globalProperties.$t = t
        app.config.globalProperties.$currentLanguage = currentLanguage
        app.config.globalProperties.$setLanguage = setLanguage

        // Provide for composition API
        app.provide('$t', t)
        app.provide('$currentLanguage', currentLanguage)
        app.provide('$setLanguage', setLanguage)
    }
}
