<template>
  <div>
    <p>posts#show</p>

    <v-container>
      <v-row>
        <v-col cols="12" class="mx-auto">
          <Loading v-show="loading"></Loading>
          <PostItem
            v-show="!loading"
            v-bind="{
              post: post,
              authUser: authUser,
              currentUserPostsId: currentUserPostsId ,
              currentUserVotedPostsId: currentUserVotedPostsId,
              voteDisable: voteDisable
            }"
            v-on:show-post="post = $event"
            v-on:current-user-votedposts-id="currentUserVotedPostsId = $event"
            v-on:create-vote-errors="createVoteErrors = $event"
            v-on:loading="loading = $event"
            v-on:vote-disable="voteDisable = $event"
          ></PostItem>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: ['id'],
  data: function() {
    return {
      authUser: {}, // '/posts/:id'
      post: {}, // '/posts/:id'
      currentUserPostsId: [], // '/posts/:id'
      currentUserVotedPostsId: [], // '/posts/:id'

      // errors
      createVoteErrors: {},

      // loading
      loading: true,

      // v-btn disabled
      voteDisable: false
    }
  },
  created: function() {
    const self = this;
    self.voteDisable = true;
    axios
      .get('/api/v1/posts/' + self.$route.params.id)
      .then(function(response) {
        self.authUser = response.data.auth_user;

        self.post = response.data.post;

        if (response.data.current_user_posts_id && response.data.current_user_voted_posts_id) {
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
