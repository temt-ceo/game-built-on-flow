<template>
<div v-if="dialog" style="z-index: 2400;" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true">
    <div class="v-overlay__content" style="width: 290px;">
        <v-card >
            <v-toolbar dark :color="options.color" dense flat>
                <v-toolbar-title class="white--text">{{ title }}</v-toolbar-title>
            </v-toolbar>
            <v-card-text v-show="!!message" class="pa-4">{{ message }}</v-card-text>
            <v-radio-group v-model="radio">
                <v-radio v-for="obj in targetGroup" :label="  obj.name" :value="obj.position" :key="obj.position"></v-radio>
            </v-radio-group>
            <v-card-actions class="pt-0">
                <v-spacer></v-spacer>
                <v-btn v-if="dialogType == 1" color="primary darken-1" text @click.native="agree">OK</v-btn>
                <v-btn v-if="dialogType == 2" color="primary darken-1" text @click.native="agree">YES</v-btn>
                <v-btn v-if="dialogType == 2" color="grey" text @click.native="cancel">No</v-btn>
                <v-btn v-if="dialogType == 3 && radio" color="primary darken-1" text @click.native="agree">Yes</v-btn>
            </v-card-actions>
        </v-card>
    </div>
</div>
</template>

<script>
  /**
   * Vuetify Confirm Dialog component
   *
   * Insert component where you want to use it:
   * <confirm ref="confirm"></confirm>
   *
   * Call it:
   * this.$refs.confirm.open('Delete', 'Are you sure?', { color: 'red' })
   * Or use await:
   * if (await this.$refs.confirm.open('Delete', 'Are you sure?', { color: 'red' })) {
   *   // yes
   * }
   * else {
   *   // cancel
   * }
   *
   * Alternatively you can place it in main App component and access it globally via this.$root.$confirm
   * <template>
   *   <v-app>
   *     ...
   *     <confirm ref="confirm"></confirm>
   *   </v-app>
   * </template>
   *
   * mounted() {
   *   this.$root.$confirm = this.$refs.confirm.open
   * }
   */
  export default {
    data: () => ({
      dialog: false,
      resolve: null,
      reject: null,
      message: null,
      title: null,
      radio: null,
      dialogType: null,
      targetGroup: [],
      options: {
        color: 'primary',
        width: 290,
        zIndex: 200
      }
    }),
    methods: {
      alert(title, message, options) {
        this.dialog = true
        this.dialogType = 1
        this.title = title
        this.message = message
        this.options = Object.assign(this.options, options)
        return new Promise((resolve, reject) => {
          this.resolve = resolve
          this.reject = reject
        })
      },
      confirm(title, message, options) {
        this.dialog = true
        this.dialogType = 2
        this.title = title
        this.message = message
        this.options = Object.assign(this.options, options)
        return new Promise((resolve, reject) => {
          this.resolve = resolve
          this.reject = reject
        })
      },
      prompt(title, targetGroup, options) {
        this.dialog = true
        this.dialogType = 3
        this.title = title
        this.message = ''
        this.targetGroup = targetGroup
        this.options = Object.assign(this.options, options)
        return new Promise((resolve, reject) => {
          this.resolve = resolve
          this.reject = reject
        })
      },
      agree() {
        if (this.dialogType === 3) {
            this.resolve(this.radio)
        } else {
            this.resolve(true)
        }
        this.dialog = false
      },
      cancel() {
        this.resolve(false)
        this.dialog = false
      }
    }
  }
  </script>