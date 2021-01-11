<template>
  <div>
    <!-- xs sm -->
    <v-toolbar-items class="d-md-none d-lg-none d-xl-none">
      <v-card class="grey darken-4" flat>
        <v-menu offset-y>
          <template v-slot:activator="{on}">
            <v-btn v-on="on" text><v-icon class="grey--text text--lighten-2">mdi-dots-horizontal</v-icon></v-btn>
          </template>
          <v-list class="mt-1">
            <v-subheader>menu</v-subheader>
            <v-list-item v-for="toolbar_list in toolbar_lists" :key="toolbar_list.name" :to="toolbar_list.link" exact>
              <v-list-item-icon>
                <v-icon v-text="toolbar_list.icon"></v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title v-text="toolbar_list.name"></v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item v-on:click="logoutUser()" exact>
              <v-list-item-icon>
                <v-icon v-text="toolbar_list_logout.icon"></v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title v-text="toolbar_list_logout.name"></v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-card>
      <v-card class="grey darken-4" flat>
        <v-menu offset-y>
          <template v-slot:activator="{on}">
            <div>
              <template v-if="authUser.avatar && node_env !== 'production'">
                <v-avatar size="36" class="blue-grey lighten-1">
                  <v-img v-on="on" v-bind:src="axiosDefaultsBaseURL + authUser.avatar.url" style="cursor: pointer;"></v-img>
                </v-avatar>
              </template>
              <template  v-else-if="authUser.avatar && node_env == 'production'" style="cursor: pointer;">
                <v-avatar size="36" class="blue-grey lighten-1">
                  <v-img v-on="on" v-bind:src="authUser.avatar.url"></v-img>
                </v-avatar>
              </template>
            </div>
          </template>
          <v-list nav class="mt-1">
            <v-subheader>menu</v-subheader>
            <v-list-item v-for="nav_list in nav_lists" :key="nav_list.name" :to="nav_list.link" exact>
              <v-list-item-icon>
                <v-icon v-text="nav_list.icon"></v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title v-text="nav_list.name"></v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-card>
    </v-toolbar-items>

    <!-- md lg xl -->
    <v-toolbar-items class="d-none d-sm-none d-md-flex">
      <v-card class="grey darken-4" flat>
        <router-link
          to="/users"
          active-class="link--active"
          exact
          class="link"
        ><v-btn class="grey darken-4" depressed><span class="grey--text text--lighten-5">ユーザー一覧画面</span></v-btn></router-link>
      </v-card>
      <v-card class="grey darken-4" flat>
        <router-link
          v-bind:to="'/users/' + authUser.id"
          active-class="link--active"
          exact
          class="link"
        ><v-btn class="grey darken-4" depressed><span class="grey--text text--lighten-5">ユーザー詳細画面</span></v-btn></router-link>
      </v-card>
      <v-card class="grey darken-4" flat>
        <router-link
          v-bind:to="'/users/' + authUser.id + '/edit'"
          active-class="link--active"
          exact
          class="link"
        ><v-btn class="grey darken-4" depressed><span class="grey--text text--lighten-5">ユーザー編集画面</span></v-btn></router-link>
      </v-card>
      <v-card class="grey darken-4" flat>
        <v-btn v-on:click="logoutUser()" class="grey darken-4" depressed>
          <span class="grey--text text--lighten-5">ログアウト | {{ authUser.name }}</span>
        </v-btn>
      </v-card>
      <v-card class="grey darken-4" flat>
        <v-menu offset-y>
          <template v-slot:activator="{on}">
            <div>
              <template v-if="authUser.avatar && node_env !== 'production'">
                <v-avatar size="36" class="blue-grey lighten-1">
                  <v-img v-on="on" v-bind:src="axiosDefaultsBaseURL + authUser.avatar.url" style="cursor: pointer;"></v-img>
                </v-avatar>
              </template>
              <template  v-else-if="authUser.avatar && node_env == 'production'" style="cursor: pointer;">
                <v-avatar size="36" class="blue-grey lighten-1">
                  <v-img v-on="on" v-bind:src="authUser.avatar.url"></v-img>
                </v-avatar>
              </template>
            </div>
          </template>
          <v-list nav class="mt-1">
            <v-subheader>menu</v-subheader>
            <v-list-item v-for="nav_list in nav_lists" :key="nav_list.name" :to="nav_list.link" exact color="primary">
              <v-list-item-icon>
                <v-icon v-text="nav_list.icon"></v-icon>
              </v-list-item-icon>
              <v-list-item-content>
                <v-list-item-title v-text="nav_list.name"></v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-card>
    </v-toolbar-items>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: ['isAuthenticated', 'authUser'],
  data: function() {
    return {
      lououtUserMessage: '',
      errorFlag: false,
      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL,
      toolbar_lists: [
        { name: 'ユーザー一覧画面', link: '/users', icon: 'mdi-format-list-bulleted' },
        { name: 'ユーザー詳細画面', link: '/users/' + this.authUser.id, icon: 'mdi-account' },
        { name: 'ユーザー編集画面', link: '/users/' + this.authUser.id + '/edit', icon: 'mdi-account-edit' }
      ],
      toolbar_list_logout: { name: 'ログアウト | ' + this.authUser.name, icon: 'mdi-logout' },
      nav_lists: [
        { name: 'ユーザー情報画面', link: '/users/' + this.authUser.id, icon: 'mdi-account' },
        { name: 'ユーザー情報編集', link: '/users/' + this.authUser.id + '/edit', icon: 'mdi-account-edit'},
        { name: 'アイコン画像編集', link: '/users/' + this.authUser.id + '/edit/avatar', icon: 'mdi-account-circle'}
      ]
    }
  },
  methods: {
    logoutUser: function() { // -> DELETE, sessions#destroy
      const self = this;
      axios
        .delete('/api/v1/logout')
        .then(function(response) {
          self.lououtUserMessage = response.data.message;
          self.$store.dispatch('flashMessage', { message: self.lououtUserMessage, type: "success"});
          self.$router.push('/login');
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"})
          console.log(error);
        })
    }
  },
}
</script>

<style lang="scss" scoped>
  .link {
    text-decoration: none;
  }
</style>
