// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    alias: {
        './runtimeConfig': './runtimeConfig.browser' 
    },
    vite: {
        define: {
          'window.global': {}
        }
    },
})
