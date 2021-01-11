<template>
  <div>
    <p>users#index</p>
    <div id="users-index">
      <v-container>
        <v-row>
          <v-col v-for="user in indexUsers" v-bind:key="user.id" cols="12" class="mx-auto">
            <v-card>
              <hr>
              <template v-if="user.avatar && node_env !== 'production'">
                <v-avatar class="blue-grey lighten-1 mr-5">
                  <v-img v-bind:src="axiosDefaultsBaseURL + user.avatar.url"></v-img>
                </v-avatar>
              </template>
              <template v-else-if="user.avatar && node_env == 'production'">
                <v-avatar class="blue-grey lighten-1 mr-5">
                  <v-img v-bind:src="user.avatar.url"></v-img>
                </v-avatar>
              </template>
              <router-link :to="'/users/' + user.id" active-class="link--active" exact class="link">UsersShow_{{ user.id }}</router-link>
              <p>{{ user }}</p>
              <template v-if="user.admin !== true && authUser.id !== user.id">
                <v-btn v-on:click="deleteUser(user.id)" color="success">ユーザー{{ user.id }}を削除する</v-btn>
              </template>
              <hr>
            </v-card>
          </v-col>
        </v-row>
        <infinite-loading spinner="bubbles" v-bind:distance="0" @infinite="infiniteHandler">
          <div slot="no-more">No more</div>       <!--これ以上表示するデータがない時に表示されるメッセージ-->
          <div slot="no-results">No results</div> <!--検索結果がない時に表示されるメッセージ-->
        </infinite-loading>
      </v-container>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import InfiniteLoading from 'vue-infinite-loading';
import store from '../store';

export default {
  components: {
    InfiniteLoading
  },
  data: function() {
    return {
      authUser: {}, // '/users'
      usersData: [], // '/users'
      indexUsers: [], // infinite-loading
      start: 0,
      end: 20,
      deleteUserMessage: '',

      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL
    }
  },
  beforeRouteEnter(to, from, next) {
    axios
      .get('/api/v1/users') // -> GET, users#index
      .then(function(response) {
        if (response.data.status === 401 && response.data.message === "Unauthorized") {
          store.dispatch('flashMessage', { message: 'ログインしてください', type: "error"});
          next('/login');
        } else if (response.data.status !== 401 && response.data.message !== "Unauthorized") {
          next();
        }
        console.log(response);
      })
      .catch(function(error) {
        console.log(error);
      })
  },
  methods: {
    infiniteHandler: function($state) {
      const self = this;
      axios
        .get('/api/v1/users') // -> GET, users#index
        .then(function(response) {
          self.usersData = response.data.users;
          // console.log("infiniteHandler " + self.usersData.length)
          if (0 < self.usersData.length - self.end) { // ユーザーの数が21以上の場合
            if (self.start === 0 && self.end === 20) { // start = 0, end = 20の場合
              for (let i = self.start; i < self.end; i++) {
                self.indexUsers.push(self.usersData[i]) // usersにusersData[0]~[20]を格納
              }
              self.start = self.start + 20;
              self.end = self.end + 20;
              $state.loaded();
            } else { // start != 0, end != 20の場合
              setTimeout(function() {
                for (let i = self.start; i < self.end; i++) {
                  self.indexUsers.push(self.usersData[i]) // usersにusersData[20]~ [39]を格納
                }
                self.start = self.start + 20;
                self.end = self.end + 20;
                $state.loaded();
              }, 1500)
            }
          } else { // ユーザーの数が20以下の場合
            setTimeout(function() {
              self.end = self.usersData.length;
              for (let i = self.start; i < self.end; i++) {
                self.indexUsers.push(self.usersData[i]) // usersにusersData[0]~[1~19]を格納
              }
              $state.complete();
            }, 500)
          }
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
          console.log(error);
        })
    },
    deleteUser: function(userId) {
      const self = this;
      axios
        .delete('/api/v1/users/' + userId) // -> DELETE, users#destroy
        .then(function(response) {
          if ((response.data.message === "ユーザー" + userId + "を削除しました") && (self.deleteUserMessage = response.data.message)) {
            self.$store.dispatch('flashMessage', { message: self.deleteUserMessage, type: "success"});
            self.indexUsers = response.data.users;
          }
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
          console.log(error);
        })
    }
  },
  created: function() {
    const self = this;
    axios
      .get('/api/v1/users') // -> GET, users#index
      .then(function(response) {
        // self.usersData = response.data.users;
        // console.log("created "+ self.usersData.length)
        self.authUser = response.data.auth_user;
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
  .link {
    text-decoration: none;
  }
</style>
