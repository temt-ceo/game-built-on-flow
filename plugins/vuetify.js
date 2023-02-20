import { defineNuxtPlugin } from '#app'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
export default defineNuxtPlugin((nuxtApp) => {
    const vuetify = createVuetify({
        components,
        directives,
        // theme: {
        //     themes: {
        //         light: {
        //             dark: false,
        //             colors: {
        //                 primary: colors.red.darken1, // #E53935
        //                 secondary: colors.red.lighten4, // #FFCDD2
        //             }
        //         },
        //     },
        // },
    })
    nuxtApp.vueApp.use(vuetify)
})


