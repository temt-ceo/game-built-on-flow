// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    alias: {
        util: 'rollup-plugin-node-polyfills/polyfills/util',
        stream: 'rollup-plugin-node-polyfills/polyfills/stream',
        './runtimeConfig': './runtimeConfig.browser',
        // sys: 'util',
        // events: 'rollup-plugin-node-polyfills/polyfills/events',
        // path: 'rollup-plugin-node-polyfills/polyfills/path',
        // querystring: 'rollup-plugin-node-polyfills/polyfills/qs',
        // punycode: 'rollup-plugin-node-polyfills/polyfills/punycode',
        // url: 'rollup-plugin-node-polyfills/polyfills/url',
        // string_decoder:
        //     'rollup-plugin-node-polyfills/polyfills/string-decoder',
        // http: 'rollup-plugin-node-polyfills/polyfills/http',
        // https: 'rollup-plugin-node-polyfills/polyfills/http',
        // os: 'rollup-plugin-node-polyfills/polyfills/os',
        // assert: 'rollup-plugin-node-polyfills/polyfills/assert',
        // constants: 'rollup-plugin-node-polyfills/polyfills/constants',
        // _stream_duplex:
        //     'rollup-plugin-node-polyfills/polyfills/readable-stream/duplex',
        // _stream_passthrough:
        //     'rollup-plugin-node-polyfills/polyfills/readable-stream/passthrough',
        // _stream_readable:
        //     'rollup-plugin-node-polyfills/polyfills/readable-stream/readable',
        // _stream_writable:
        //     'rollup-plugin-node-polyfills/polyfills/readable-stream/writable',
        // _stream_transform:
        //     'rollup-plugin-node-polyfills/polyfills/readable-stream/transform',
        // timers: 'rollup-plugin-node-polyfills/polyfills/timers',
        // console: 'rollup-plugin-node-polyfills/polyfills/console',
        // vm: 'rollup-plugin-node-polyfills/polyfills/vm',
        // zlib: 'rollup-plugin-node-polyfills/polyfills/zlib',
        // tty: 'rollup-plugin-node-polyfills/polyfills/tty',
        // domain: 'rollup-plugin-node-polyfills/polyfills/domain'
    },
    vite: {
        define: {
          'window.global': {}
        }
    },
})
