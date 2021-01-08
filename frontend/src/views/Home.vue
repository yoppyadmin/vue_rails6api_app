<template>
  <div>
    <p>posts#new, posts#create</p>
    <p>posts#index</p>

    <v-container>
      <div class="d-flex flex-column">
        <v-row id="posts-new-create">
          <v-col v-if="authUser.hasOwnProperty('id')" cols="12" sm="10" md="6" class="mx-auto">
            <PostNew
              v-bind="{ post: newPost }"
              v-on:index-posts="indexPosts = $event"
              v-on:create-post-errors="createPostErrors = $event"
            ></PostNew>
          </v-col>
        </v-row>

        <v-row id="posts-index">
          <v-col v-for="post in indexPosts" v-bind:key="post.id" cols="12" sm="12" md="6" class="my-auto">
            <PostItem
              v-bind="{ post: post, authUser: authUser, currentUserPostsId: currentUserPostsId, currentUserVotedPostsId: currentUserVotedPostsId }"
              v-on:index-posts="indexPosts = $event"
              v-on:current-user-posts-id="currentUserPostsId = $event"
              v-on:current-user-votedposts-id="currentUserVotedPostsId = $event"
              v-on:create-vote-errors="createVoteErrors = $event"
            >
            </PostItem>
          </v-col>
        </v-row>

        <infinite-loading spinner="bubbles" v-bind:distance="0" @infinite="infiniteHandler">
          <div slot="no-more">これ以上結果がありません</div>  <!--これ以上表示するデータがない時に表示されるメッセージ-->
          <div slot="no-results">結果がありません</div>  <!--検索結果がない時に表示されるメッセージ-->
        </infinite-loading>
      </div>
    </v-container>
  </div>
</template>

<script>
import axios from 'axios';
import InfiniteLoading from 'vue-infinite-loading';

export default {
  components: {
    InfiniteLoading
  },
  data: function() {
    return {
      authUser: {}, // '/posts'
      currentUserPostsId: [], // '/posts'
      currentUserVotedPostsId: [], // '/posts'
      newPost: {}, // '/posts/new'
      postsData: [], // infinite-loading
      indexPosts: [], // infinite-loading
      start: 0,
      end: 20,
      createPostErrors: {},
      createVoteErrors: {},
    }
  },
  methods: {
    infiniteHandler: function($state) {
      const self = this;
      axios
        .get('/api/v1/posts') // -> GET, posts#index
        .then(function(response) {
          self.postsData = response.data.posts;
          if (0 < self.postsData.length - self.end) {
            if (self.start === 0 && self.end === 20) {
              for (let i = self.start; i < self.end; i++) {
                self.indexPosts.push(self.postsData[i])
              }
              self.start = self.start + 20;
              self.end = self.end + 20;
              $state.loaded();
            } else {
              setTimeout(function() {
                for (let i = self.start; i < self.end; i++) {
                  self.indexPosts.push(self.postsData[i])
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
                self.indexPosts.push(self.postsData[i])
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
    mountedExcecute: async function() {
      const self = this;
      axios
        .get('/api/v1/posts') // -> GET, posts#index
        .then(function(res1) {
          if (res1.data.auth_user && res1.data.current_user_posts_id &&res1.data.current_user_voted_posts_id) {
            self.authUser = res1.data.auth_user;
            self.currentUserPostsId = res1.data.current_user_posts_id;
            self.currentUserVotedPostsId = res1.data.current_user_voted_posts_id;
          }
          console.log(res1);
          return(axios.get('/api/v1/posts/new'))
        })
        .then(function(res2) {
          self.newPost = res2.data.post;
          if (res2.data.auth_user) {
            self.authUser = res2.data.auth_user;
          }
          console.log(res2);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"});
          console.log(error);
        })
    }
  },
  created: function() {
    this.mountedExcecute();
  }
}
</script>

<style lang="scss" scoped>
</style>
