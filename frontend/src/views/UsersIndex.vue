<template>
  <div>
    <p>users#index</p>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>
    <div id="users-index">
      <v-container>
        <v-row>
          <v-col cols="12" sm="10" md="8" class="mx-auto">
            <v-card flat>
              <div v-for="_user in users" v-bind:key="_user.id">
                <hr>
                <template v-if="_user.avatar && node_env !== 'production'">
                  <v-avatar>
                    <img v-bind:src="axiosDefaultsBaseURL + _user.avatar.url">
                  </v-avatar>
                </template>
                <template v-else-if="_user.avatar && node_env == 'production'">
                  <v-avatar>
                    <img v-bind:src="_user.avatar.url">
                  </v-avatar>
                </template>
                <router-link :to="'/users/' + _user.id" active-class="link--active" exact class="link">UsersShow_{{ _user.id }}</router-link>
                <p>{{ _user }}</p>
                <template v-if="user.admin === true && user.id !== _user.id">
                  <v-btn v-on:click="deleteUser(_user.id)" color="success">ユーザー{{ _user.id }}を削除する</v-btn>
                </template>
                <hr>
              </div>
              <infinite-loading spinner="bubbles" v-bind:distance="0" @infinite="infiniteHandler">
                <div slot="no-more">No more</div>       <!--これ以上表示するデータがない時に表示されるメッセージ-->
                <div slot="no-results">No results</div> <!--検索結果がない時に表示されるメッセージ-->
              </infinite-loading>
            </v-card>
          </v-col>
        </v-row>
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
      usersData: [],
      user: {},
      users: [],
      errorFlag: false,
      start: 0,
      end: 20,
      deleteUserMessage: '',
      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL
    }
  },
  beforeRouteEnter(to, from, next) { // -> GET, users#index
    axios
      .get('/api/v1/users')
      .then(function(response) {
        if (response.data.status === 401 && response.data.message === "Unauthorized") {
          store.commit('flashMessage', 'ログインしてください');
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
          if (0 < self.usersData.length - self.end) { // ユーザーの数が21以上の場合
            if (self.start === 0 && self.end === 20) { // start = 0, end = 20の場合
              for (let i = self.start; i < self.end; i++) {
                self.users.push(self.usersData[i]) // usersにusersData[0]~[20]を格納
              }
              self.start = self.start + 20;
              self.end = self.end + 20;
              $state.loaded();
            } else { // start != 0, end != 20の場合
              setTimeout(function() {
                for (let i = self.start; i < self.end; i++) {
                  self.users.push(self.usersData[i]) // usersにusersData[20]~ [39]を格納
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
                self.users.push(self.usersData[i]) // usersにusersData[0]~[1~19]を格納
              }
              $state.complete();
            }, 500)
          }
          console.log(response);
        })
        .catch(function(error) {
          self.errorFlag = true;
          console.log(error);
        })
    },
    deleteUser: function(userId) { // -> DELETE, users#destroy
      const self = this;
      axios
        .delete('/api/v1/users/' + userId)
        .then(function(response) {
          if ((response.data.message === "ユーザー" + userId + "を削除しました") && (self.deleteUserMessage = response.data.message)) {
            self.users = response.data.users;
            self.$store.commit('flashMessage', self.deleteUserMessage);
          }
          console.log(response);
        })
        .catch(function(error) {
          self.errorFlag = true;
          console.log(error);
        })
    }
  },
  mounted: function() { // -> GET, users#index
    const self = this;
    axios
      .get('/api/v1/users')
      .then(function(response) {
        self.usersData = response.data.users;
        self.user = response.data.user;
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
  }
</style>
