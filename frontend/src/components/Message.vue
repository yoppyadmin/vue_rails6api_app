<template>
  <div>
    <transition name="fade">
      <v-alert
        v-if="alert"
        border="bottom"
        color="indigo darken-4 grey--text text--lighten-2"
        dense
      >
        {{ message }}
      </v-alert>
    </transition>
  </div>
</template>

<script>
export default {
  computed: {
    alert: function() {
      return this.$store.state.alert;
    },
    message: function() {
      return this.$store.state.message;
    }
  }
}
</script>

<style lang="scss" scoped>
.fade-enter-active, .fade-leave-active {
  transition: opacity .5s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
.fade-enter-to, .fade-leave {
  opacity: 1;
}
</style>
