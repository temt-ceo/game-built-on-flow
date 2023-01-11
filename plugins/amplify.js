import { defineNuxtPlugin } from '#app'
import amplifyConfig from '../src/aws-exports'
import { Amplify, Auth } from 'aws-amplify'
export default defineNuxtPlugin(() => {
    Amplify.configure(amplifyConfig)
    return {
        provide: {
           auth: Auth
        }
    }
})


