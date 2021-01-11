<template>
  <div>
    <v-row>
      <v-col cols="12" class="pa-0">
        <transition name="fade">
          <v-card v-if="alert" flat >
            <v-alert
              v-bind:type="style"
              dense
              class="mb-0"
            >
              {{ message }}
            </v-alert>
          </v-card>
        </transition>
      </v-col>
    </v-row>
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
