<template>
  <div>
    <v-card>
      <v-card-title>
        <v-text-field
          prepend-icon="mdi-pen"
          v-model="post.content"
          id="post_content"
          name="post[content]"
          filled
          label="テーマ"
          placeholder="例) iphone何使ってる?"
          color="deep-orange darken-1"
        ></v-text-field>
      </v-card-title>
      <v-card-text>
        <template>
          <v-text-field
            prepend-icon="mdi-checkbox-marked-outline"
            v-model="post.list_1"
            id="post_list_1"
            name="post[list_1]"
            dense
            rounded
            solo
            label="例) iphone12"
            color="deep-orange lighten-3"
          ></v-text-field>
        </template>
        <template>
          <v-text-field
            prepend-icon="mdi-checkbox-marked-outline"
            v-model="post.list_2"
            id="post_list_2"
            name="post[list_2]"
            dense
            rounded
            solo
            label="例) iphone11"
            color="deep-orange lighten-3"
          ></v-text-field>
          <v-btn v-on:click="toggleList_3()" v-show="!plusList_3" depressed small color="blue-grey lighten-4">リストを増やす</v-btn>
        </template>
        <template v-if="plusList_3">
          <v-text-field
            prepend-icon="mdi-checkbox-marked-outline"
            v-model="post.list_3"
            id="post_list_3"
            name="post[list_3]"
            dense
            rounded
            solo
            label="例) iphoneSE2"
            color="deep-orange lighten-3"
          ></v-text-field>
          <v-btn v-on:click="toggleList_4()" v-show="!plusList_4" depressed small color="blue-grey lighten-4">リストを増やす</v-btn>
          <v-btn v-on:click="toggleList_3()" v-show="!plusList_4" depressed small color="blue-grey lighten-4">リストを削除する</v-btn>
        </template>
        <template v-if="plusList_4">
          <v-text-field
            prepend-icon="mdi-checkbox-marked-outline"
            v-model="post.list_4"
            id="post_list_4"
            name="post[list_4]"
            dense
            rounded
            solo
            label="例) iphone8"
            color="deep-orange lighten-3"
          ></v-text-field>
          <v-btn v-on:click="toggleList_4()" depressed small color="blue-grey lighten-4">リストを削除する</v-btn>
        </template>
      </v-card-text>
      <v-card-actions>
        <v-btn v-on:click="createPost()" block dark color="indigo darken-2">投票内容をサーバーに送信する</v-btn>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: ['post'],
  data: function() {
    return {
      plusList_3: false,
      plusList_4: false,
      successCreatePostMessage: '',
      failureCreatePostMessage: ''
    }
  },
  methods: {
    toggleList_3: function() {
      this.plusList_3 = !this.plusList_3;
    },
    toggleList_4: function() {
      this.plusList_4 = !this.plusList_4;
    },
    createPost: function() { // -> POST, posts#create
      const self = this;
      axios
        .post('/api/v1/posts', {
          post: {
            content: self.post.content,
            list_1: self.post.list_1,
            list_2: self.post.list_2,
            list_3: self.post.list_3,
            list_4: self.post.list_4
          }
        })
        .then(function(response) {
          if ((response.data.message === "新規投稿作成に成功しました") && (self.successCreatePostMessage = response.data.message)) {
            self.$store.dispatch('flashMessage', { message: self.successCreatePostMessage, type: "success"});
            self.$emit("index-posts", response.data.posts);
            self.newPost = {};
          } else if((response.data.message === "新規投稿作成に失敗しました") && (self.failureCreatePostMessage = response.data.message)) {
            self.$store.dispatch('flashMessage', { message: self.failureCreatePostMessage, type: "success"});
            self.$emit("create-post-errors", response.data.errors);
          }
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"})
          console.log(error);
        })
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
