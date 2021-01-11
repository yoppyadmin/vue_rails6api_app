<template>
  <div>
    <p>users#show</p>

    <v-container>
      <v-row>
        <v-col cols="12" sm="8" md="6" class="d-flex mx-auto">

          <template v-if="user.avatar && node_env !== 'production'">
            <v-avatar size="128" class="grey darken-3 mr-5">
              <v-img  v-bind:src="axiosDefaultsBaseURL + user.avatar.url" dark></v-img>
            </v-avatar>
          </template>
          <template v-else-if="user.avatar && node_env == 'production'">
            <v-avatar size="128" class="grey darken-3 mr-5">
              <v-img v-bind:src="user.avatar.url" dark></v-img>
            </v-avatar>
          </template>

          <div class="d-flex flex-column justify-space-between">
            <p class="ma-0">{{ user.id }}</p>
            <p class="ma-0">{{ user.name }}</p>
            <p class="ma-0">{{ user.email }}</p>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <v-tabs v-model="tab" slider-color="white" center-active background-color="teal darken-3" dark>
      <v-tab v-for="item in items" :key="item.tab">
        {{ item }}
      </v-tab>
    </v-tabs>
    <v-tabs-items v-model="tab">
      <v-tab-item>
        <v-container>
          <v-row>
            <v-col v-for="post in userPosts" v-bind:key="post.id" cols="12" sm="12" md="6" class="my-auto">
              <PostItem
                v-bind="{
                  post: post,
                  authUser: authUser,
                  currentUserPostsId: currentUserPostsId,
                  currentUserVotedPostsId: currentUserVotedPostsId,
                  voteDisable: voteDisable,
                  fetchedPosts: userPosts
                }"
                v-on:user-posts="userPosts = $event"
                v-on:current-user-posts-id="currentUserPostsId = $event"
                v-on:current-user-votedposts-id="currentUserVotedPostsId = $event"
                v-on:create-vote-errors="createVoteErrors = $event"
                v-on:vote-disable="voteDisable = $event"
                >
              </PostItem>
            </v-col>
          </v-row>
        </v-container>
        <infinite-loading spinner="bubbles" v-bind:distance="0" @infinite="infiniteHandler">
          <div slot="no-more">これ以上結果がありません</div>  <!--これ以上表示するデータがない時に表示されるメッセージ-->
          <div slot="no-results">結果がありません</div>  <!--検索結果がない時に表示されるメッセージ-->
        </infinite-loading>
      </v-tab-item>

      <v-tab-item>
        <v-card flat tile>
          <v-card-title>hogehoge</v-card-title>
        </v-card>
      </v-tab-item>

      <v-tab-item>
        <v-card flat tile>
          <v-card-title>hogehoge</v-card-title>
        </v-card>
      </v-tab-item>

      <v-tab-item>
        <v-card flat tile>
          <v-card-title>hogehoge</v-card-title>
        </v-card>
      </v-tab-item>
    </v-tabs-items>

  </div>
</template>

<script>
import axios from 'axios';
import InfiniteLoading from 'vue-infinite-loading';

export default {
  props: ['id'],
  components: {
    InfiniteLoading
  },
  data: function() {
    return {
      user: {}, // '/users/:id'
      authUser: {}, // '/users/:id'
      currentUserPostsId: [], // '/users/:id'
      currentUserVotedPostsId: [], // '/users/:id'
      postsData: [], // infinite-loading
      userPosts: [], // infinite-loading
      start: 0, // infinite-loading
      end: 20, // infinite-loading

      // errors
      createVoteErrors: {},

      // avatar
      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL,

      // tab
      items: [
        '投稿', 'いいね', 'フォロー', 'フォロワー'
      ],
      tab: null,

      // v-btn disabled
      voteDisable: false
    }
  },
  methods: {
    infiniteHandler: function($state) {
      const self = this;
      self.voteDisable = true;
      axios
        .get('/api/v1/users/' + self.$route.params.id) // -> GET, users#show
        .then(function(response) {
          self.postsData = response.data.posts;
          if (0 < self.postsData.length - self.end) {
            if (self.start === 0 && self.end === 20) {
              for (let i = self.start; i < self.end; i++) {
                self.userPosts.push(self.postsData[i])
              }
              self.start = self.start + 20;
              self.end = self.end + 20;
              $state.loaded();
            } else {
              setTimeout(function() {
                for (let i = self.start; i < self.end; i++) {
                  self.userPosts.push(self.postsData[i])
                }
                self.start = self.start + 20;
                self.end = self.end + 20;
                $state.loaded();
              }, 1500)
            }
          } else {
            setTimeout(function() {
              self.end = self.postsData.length;
              for (let i = self.start; i < self.end; i++) {
                self.userPosts.push(self.postsData[i])
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
    }
  },
  created: function() { // -> GET, users#show
    const self = this;
    axios
      .get('/api/v1/users/' + self.$route.params.id)
      .then(function(response) {
        self.user = response.data.user;
        if (response.data.auth_user && response.data.current_user_posts_id && response.data.current_user_voted_posts_id) {
          self.authUser = response.data.auth_user;
          self.currentUserPostsId = response.data.current_user_posts_id;
          self.currentUserVotedPostsId = response.data.current_user_voted_posts_id;
        }
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
</style>
