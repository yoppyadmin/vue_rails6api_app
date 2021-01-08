<template>
  <div>
    <transition name="fade">
      <v-card class="d-flex justify-end px-0 py-0 mx-0 my-0" v-if="alert" style="z-index: 1;">
        <v-alert
          class="my-1 mx-1 "
          v-bind:type="style"
          dense
          style="position: fixed;"
        >
          {{ message }}
        </v-alert>
      </v-card>
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
    },
    style: function() {
      return this.$store.state.style;
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
