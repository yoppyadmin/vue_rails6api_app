<template>
  <div>
    <!-- xs -->
    <v-toolbar-items class="d-flex d-sm-none">
      <v-menu offset-y>
        <template v-slot:activator="{on}">
          <v-btn v-on="on" text><v-icon class="grey--text text--lighten-2">mdi-dots-horizontal</v-icon></v-btn>
        </template>
        <v-list nav class="mt-1">
          <v-subheader>menu</v-subheader>
          <v-list-item v-for="toolbar_list in toolbar_lists" :key="toolbar_list.name" :to="toolbar_list.link" exact>
            <v-list-item-icon>
              <v-icon v-text="toolbar_list.icon"></v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title v-text="toolbar_list.name"></v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-toolbar-items>

    <!-- sm md lg xl -->
    <v-toolbar-items class="d-none d-sm-flex">
      <v-card class="grey darken-4" flat>
        <router-link
          to="/about"
          active-class="link--active"
          exact
          class="link"
        ><v-btn class="grey darken-4"><span class="grey--text text--lighten-5">About</span></v-btn></router-link>
      </v-card>
      <v-card class="grey darken-4" flat>
        <router-link
          to="/signup"
          active-class="link--active"
          exact
          class="link"
        ><v-btn class="grey darken-4"><span class="grey--text text--lighten-5">Signup</span></v-btn></router-link>
      </v-card>
      <v-card class="grey darken-4" flat>
        <router-link
          to="/login"
          active-class="link--active"
          exact
          class="link"
        ><v-btn class="grey darken-4"><span class="grey--text text--lighten-5">Login</span></v-btn></router-link>
      </v-card>
    </v-toolbar-items>
  </div>
</template>

<script>
export default {
  data: function() {
    return {
      toolbar_lists:[
        { name: 'Surveyとは', link: '/about', icon: 'mdi-message-alert' },
        { name: 'サインアップ', link: '/signup', icon: 'mdi-account-plus'},
        { name: 'ログイン', link: '/login', icon: 'mdi-login'}
      ]
    }
  }
}
</script>

<style lang="scss" scoped>
  .link {
    text-decoration: none;
  }
</style>
