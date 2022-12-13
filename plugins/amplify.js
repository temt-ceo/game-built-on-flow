import { defineNuxtPlugin } from '#app'
// import { useRuntimeConfig } from '#app'
import amplifyConfig from '../src/aws-exports'
import { Amplify, Auth } from 'aws-amplify'
export default defineNuxtPlugin(() => {
    // const config = useRuntimeConfig();

    // const amplifyConfig = {
        // Auth: {
        //     region: config.APP_REGION,
        // },
        // Storage: {
        //     AWSS3: {
        //     bucket: config.S3_BUCKET,
        //     region: config.APP_REGION,
        //     },
        // },
    // }

    Amplify.configure(amplifyConfig)
    return {
        provide: {
           auth: Auth
        }
    }
})