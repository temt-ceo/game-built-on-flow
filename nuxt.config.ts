// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    alias: {
        './runtimeConfig': './runtimeConfig.browser',
        util: 'rollup-plugin-node-polyfills/polyfills/util',
        stream: 'rollup-plugin-node-polyfills/polyfills/stream',
    },
    css: [
        'vuetify/lib/styles/main.sass',
        '@mdi/font/css/materialdesignicons.min.css',
    ],
    vite: {
        define: {
          'window.global': {}
        }
    },
    build: {
        transpile: ['vuetify']
    },
    builder: 'webpack',
})
