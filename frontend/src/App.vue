<template>
  <v-app>
    <!-- <v-navigation-drawer temporary v-model="drawer">
    </v-navigation-drawer> -->

    <v-app-bar app class="grey darken-4">
      <v-app-bar-nav-icon v-on:click="drawer=!drawer" class="grey--text text--lighten-2"></v-app-bar-nav-icon>
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
        v-bind="{isAuthenticated: isAuthenticated, currentUser: user}"
        v-if="isAuthenticated === true"
      ></AuthenticatedHeaderItems>

      <!-- <v-toolbar-items class="d-flex d-sm-none">
        <v-menu offset-y>
          <template v-slot:activator="{on}">
            <v-btn v-on="on" text><v-icon>mdi-plus-box</v-icon></v-btn>
          </template>
          <v-list>
            <v-subheader>Button</v-subheader>
            <v-list-item v-for="hoge in hoges" :key="hoge.name">
              <v-list-item-icon>
                <v-icon>{{ hoge.icon }}</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title>{{ hoge.name }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-toolbar-items>

      <v-toolbar-items class="d-none d-sm-flex">
        <v-menu offset-y>
          <template v-slot:activator="{on}">
          <v-btn v-on="on" text>Button<v-icon>mdi-menu-down</v-icon></v-btn>
          </template>
          <v-list>
            <v-subheader>Button</v-subheader>
            <v-list-item v-for="hoge in hoges" :key="hoge.name">
              <v-list-item-icon>
                <v-icon>{{ hoge.icon }}</v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title>{{ hoge.name }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-toolbar-items> -->
    </v-app-bar>

    <v-main>
      <Message></Message>
      <router-view></router-view>
    </v-main>

    <v-footer dark app>
      Surbey
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
    AuthenticatedHeaderItems: AuthenticatedHeaderItems
  },
  data(){
    return{
      isAuthenticated: '',
      user: {},
      errorFlag: false,

      // drawer: null,
      hoges:[
        {name: 'hoge', icon: 'mdi-vuetify'},
        {name: 'hogehoge', icon: 'mdi-discord'},
        {name: 'hogehogehoge', icon: 'mdi-bug'},
        {name: 'hogehogehogehoge', icon: 'mdi-github'},
        {name: 'hogehogehogehogehoge', icon: 'mdi-stack-overflow'},
      ],
    }
  },
  computed: {
    getAlert: function() {
      return this.$store.getters.alert;
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
          if (response.data.logged_in_user) {
            self.user = response.data.logged_in_user;
          }
          console.log(response);
          })
          .catch(function(error) {
          self.errorFlag = true;
          console.log(error);
        })
      }
    },
    getAlert: function(val, oldVal) {
      if (val === true && oldVal === false) {
        this.$store.dispatch('deleteMessage', oldVal)
      }
    }
  },
  mounted: function() { // -> GET, sessions#profile
    const self = this;
    axios
      .get('/api/v1/profile')
      .then(function(response) {
        self.isAuthenticated = response.data.authenticated;
        if (response.data.logged_in_user) {
          self.user = response.data.logged_in_user;
        }
        console.log(response);
      })
      .catch(function(error) {
        self.errorFlag = true;
        console.log(error);
      })
  }
}
</script>

<style lang="scss" scoped>
  .link {
    text-decoration: none;
    color: #F5F5F5;
  }
  // .link--active {
  // }
</style>
