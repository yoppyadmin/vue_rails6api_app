<template>
  <v-app>
    <v-app-bar fixed height="64" class="grey darken-4">
      <v-toolbar-title>
        <router-link
          to="/"
          active-class="link--active"
          exact
          class="link"
        >Surbey</router-link>
      </v-toolbar-title>
      <v-spacer></v-spacer>
      <UnauthenticatedHeaderItems
        v-if="isAuthenticated === false"
      ></UnauthenticatedHeaderItems>
      <AuthenticatedHeaderItems
        v-bind="{ isAuthenticated: isAuthenticated, authUser: authUser }"
        v-if="isAuthenticated === true"
      ></AuthenticatedHeaderItems>
    </v-app-bar>

    <v-main>
      <Message id="message"></Message>
      <router-view
        :style="{'padding-top': mainPaddingTop}"
      ></router-view>
    </v-main>

    <v-footer app class="grey darken-4">
      <div class="text-subtitle-1 grey--text text--lighten-2">Surbey</div>
    </v-footer>
  </v-app>
</template>

<script>
import axios from 'axios';
import UnauthenticatedHeaderItems from '@/components/UnauthenticatedHeaderItems.vue'
import AuthenticatedHeaderItems from '@/components/AuthenticatedHeaderItems.vue'

export default {
  components: {
    UnauthenticatedHeaderItems: UnauthenticatedHeaderItems,
    AuthenticatedHeaderItems: AuthenticatedHeaderItems,
  },
  data(){
    return{
      isAuthenticated: '',
      authUser: {},
      mainPaddingTop: ''
    }
  },
  methods: {
    confirmPaddingTop: function() {
      if (this.$store.state.alert === true) {
        return this.mainPaddingTop = '104px'
      } else if (this.$store.state.alert === false) {
        return this.mainPaddingTop = '64px'
      }
    }
  },
  watch: { // -> GET, sessions#profile
    $route: function (to, from) {
      if (to.path !== from.path) {
        const self = this;
        axios
          .get('/api/v1/profile')
          .then(function(response) {
            self.isAuthenticated = response.data.authenticated;
            if (response.data.auth_user) {
              self.authUser = response.data.auth_user;
            }
            console.log(response);
          })
          .catch(function(error) {
            self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
            console.log(error);
        })
      }
    }
  },
  created: function() { // -> GET, sessions#profile
    const self = this;
    axios
      .get('/api/v1/profile')
      .then(function(response) {
        self.isAuthenticated = response.data.authenticated;
        if (response.data.auth_user) {
          self.authUser = response.data.auth_user;
        }
        self.confirmPaddingTop();
        console.log(response);
      })
      .catch(function(error) {
        self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
        console.log(error);
      })
  }
}
</script>

<style lang="scss" scoped>
  #message {
    position: fixed;
    width: 100%;
    z-index: 1;
    padding-top: 64px;
  }
  .link {
    text-decoration: none;
    color: #F5F5F5;
  }
  // .link--active {
  // }
</style>
