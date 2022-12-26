// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    alias: {
        './runtimeConfig': './runtimeConfig.browser',
        util: 'rollup-plugin-node-polyfills/polyfills/util',
        stream: 'rollup-plugin-node-polyfills/polyfills/stream',
    },
    vite: {
        define: {
          'window.global': {}
        }
    },
})
