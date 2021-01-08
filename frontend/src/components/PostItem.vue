<template>
  <div>
    <v-card class="py-2" flat color="grey lighten-3">

      <template v-if="currentUserVotedPostsId.indexOf(post.id) != -1">

        <v-container class="px-5 py-1">
          <v-row>
            <v-col class="pa-0">
              <div class="d-flex flex-row align-center">
              <!-- 開発環境 -->
                <template v-if="post.avatar && node_env !== 'production'">
                  <router-link
                    :to="'/users/' + post.user_id"
                    active-class="link--active"
                    exact
                    class="link"
                  >
                    <v-avatar size="48" class="grey darken-3 mr-5">
                      <v-img v-bind:src="axiosDefaultsBaseURL + '/uploads_development/user/avatar/'+ post.user_id + '/' + post.avatar" dark></v-img>
                    </v-avatar>
                  </router-link>
                </template>
              <!-- 本番環境 -->
                <!-- <template v-else-if="post.avatar && node_env == 'production'">
                  <v-avatar size="48" class="grey darken-3">
                    <v-img v-bind:src="post.avatar" dark></v-img>
                  </v-avatar>
                </template> -->
                <div class="font-weight-bold">{{ post.user_id }}</div>
                <v-menu offset-y v-if="currentUserPostsId.indexOf(post.id) != -1">
                  <template v-slot:activator="{on}">
                    <v-btn v-on="on" class="ml-auto" text><v-icon>mdi-dots-vertical</v-icon></v-btn>
                  </template>
                  <v-list class="mt-1">
                    <v-list-item v-on:click="deletePost(post.id)" exact>
                      <v-list-item-content>
                        <v-list-item-title>投稿を削除する</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-menu>
              </div>
            </v-col>
          </v-row>
        </v-container>

        <BarChart :chartData="datacollection" :options="options" :height="height" :width="width"></BarChart>

        <router-link :to="'/posts/' + post.id">{{ post.id }}</router-link>
        <v-card-subtitle>投票内容: {{ post.content }}</v-card-subtitle>
        <v-card-text class="d-flex flex-column py-0">
          選択肢1: <h3>{{ post.list_1 }} | {{ post.quantity_list_1 }}</h3>
        </v-card-text>
        <v-card-text class="d-flex flex-column py-0" >
          選択肢2: <h3>{{ post.list_2 }} | {{ post.quantity_list_2 }}</h3>
        </v-card-text>
        <template v-if="post.list_3 !== null">
          <v-card-text class="d-flex flex-column py-0">
            選択肢3: <h3>{{ post.list_3 }} | {{ post.quantity_list_3 }}</h3>
          </v-card-text>
        </template>
        <template v-if="post.list_4 !== null">
          <v-card-text class="d-flex flex-column py-0">
            選択肢4: <h3>{{ post.list_4 }} | {{ post.quantity_list_4 }}</h3>
          </v-card-text>
        </template>
      </template>

      <template v-else>
        <v-container class="px-5 py-1">
          <v-row>
            <v-col class="pa-0">
              <div class="d-flex flex-row align-center">
                <template v-if="post.avatar && node_env !== 'production'">
                <!-- 開発環境 -->
                  <router-link
                    :to="'/users/' + post.user_id"
                    active-class="link--active"
                    exact
                    class="link"
                  >
                    <v-avatar size="48" class="grey darken-3 mr-5">
                      <v-img  v-bind:src="axiosDefaultsBaseURL + '/uploads_development/user/avatar/'+ post.user_id + '/' + post.avatar" dark></v-img>
                    </v-avatar>
                  </router-link>
                </template>
              <!-- 本番環境 -->
                <!-- <template v-else="post.avatar && node_env == 'production'">
                  <v-avatar size="48" class="grey darken-3">
                    <v-img v-bind:src="post.avatar" dark></v-img>
                  </v-avatar>
                </template> -->
                <div class="font-weight-bold">{{ post.user_id }}</div>
                <v-menu offset-y v-if="currentUserPostsId.indexOf(post.id) != -1">
                  <template v-slot:activator="{on}">
                    <v-btn v-on="on" class="ml-auto" text><v-icon>mdi-dots-vertical</v-icon></v-btn>
                  </template>
                  <v-list class="mt-1">
                    <v-list-item v-on:click="deletePost(post.id)" exact>
                      <v-list-item-content>
                        <v-list-item-title>投稿を削除する</v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-menu>
              </div>
            </v-col>
          </v-row>
        </v-container>
        <router-link :to="'/posts/' + post.id">{{ post.id }}</router-link>
        <v-card-subtitle>投票内容: {{ post.content }}</v-card-subtitle>
        <v-card-text class="d-flex flex-column py-0">
          選択肢1: <v-btn v-on:click="createVote(post.id, 'list_1')" small color="teal lighten-1">{{ post.list_1 }}</v-btn>
        </v-card-text>
        <v-card-text class="d-flex flex-column py-0">
          選択肢2: <v-btn v-on:click="createVote(post.id, 'list_2')" small color="teal lighten-1">{{ post.list_2 }}</v-btn>
        </v-card-text>
        <template v-if="post.list_3 !== null">
          <v-card-text class="d-flex flex-column py-0">
            選択肢3: <v-btn v-on:click="createVote(post.id, 'list_3')" small color="teal lighten-1">{{ post.list_3 }}</v-btn>
          </v-card-text>
        </template>
        <template v-if="post.list_4 !== null">
          <v-card-text class="d-flex flex-column py-0">
            選択肢4: <v-btn v-on:click="createVote(post.id, 'list_4')" small color="teal lighten-1">{{ post.list_4 }}</v-btn>
          </v-card-text>
        </template>
      </template>

    </v-card>
  </div>
</template>

<script>
import Vue from 'vue';
import axios from 'axios';
import BarChart from '../components/BarChart.vue';

export default {
  props: ['post', 'authUser', 'currentUserPostsId', 'currentUserVotedPostsId'],
  components: {
    BarChart,
  },
  data: function() {
    return {
      deletePostMessage: '',
      successCreateVoteMessage: '',
      failureCreateVoteMessage: '',

      // chart
      datacollection: { labels: [], datasets: [] },
      width: null,
      height: null,
      options: { lagend: {}, scales: {}, tooltips: {} },

      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL,
    }
  },
  watch: {
    post: function() {
      // console.log(newValue, oldValue);
      this.fillData(this.post);
      this.$emit("loading", false);
    }
  },
  methods: {
    deletePost: function(postId) {
      const self = this;
      axios
        .delete('/api/v1/posts/' + postId, { // -> DELETE, posts#destroy
          data: {
            vue_router_path: self.$route.path,
            vue_router_params_id: self.$route.params.id
          }
        })
        .then(function(response) {
          if ((response.data.message === "投稿を削除しました") && (self.deletePostMessage = response.data.message)) {
            self.$store.dispatch('flashMessage', { message: self.deletePostMessage, type: "success"});
            self.$emit("current-user-posts-id", response.data.current_user_posts_id);
            if (response.data.posts_joins_quantities) {
              self.$emit("index-posts", response.data.posts_joins_quantities); // '/'
            } else if (response.data.user_posts_join_quantities) {
              self.$emit("user-posts", response.data.user_posts_join_quantities); // '/users/:id'
            } else {
              self.$router.push('/users/' + self.authUser.id) // '/posts/:id'
            }
          }
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"})
          console.log(error);
        })
    },
    createVote: function(postId, listNumber) {
      const self = this;
      axios
        .post('/api/v1/votes', { // -> POST, votes#create
          vote: {
            user_id: self.authUser.id,
            post_id: postId
          },
          list_number: listNumber,
          vue_router_path: self.$route.path,
          vue_router_params_id: self.$route.params.id
        })
        .then(function(response) {
          switch (response.data.message) {
            case "投票に成功しました": {
              self.successCreateVoteMessage = response.data.message;
              self.$store.dispatch('flashMessage', { message: self.successCreateVoteMessage, type: "success"});
              self.$emit("current-user-votedposts-id", response.data.current_user_voted_posts_id);
              if (response.data.index_posts) {
                self.$emit("index-posts", response.data.index_posts); // '/'
              } else if (response.data.user_posts) {
                self.$emit("user-posts", response.data.user_posts); // '/users/:id'
              } else {
                self.$emit("show-post", response.data.post); // '/posts/:id'
              }
              const allQuantities = response.data.post.quantity_list_1 + response.data.post.quantity_list_2 + response.data.post.quantity_list_3 + response.data.post.quantity_list_4
              const updateQuantityList1 = response.data.post.quantity_list_1 / allQuantities * 100
              const updateQuantityList2 = response.data.post.quantity_list_2 / allQuantities * 100
              const updateQuantityList3 = response.data.post.quantity_list_3 / allQuantities * 100
              const updateQuantityList4 = response.data.post.quantity_list_4 / allQuantities * 100
              Vue.set(self.datacollection.datasets[0].data, 0, updateQuantityList1);
              Vue.set(self.datacollection.datasets[0].data, 1, updateQuantityList2);
              Vue.set(self.datacollection.datasets[0].data, 2, updateQuantityList3);
              Vue.set(self.datacollection.datasets[0].data, 3, updateQuantityList4);
              break;
            }
            case "投票に失敗しました": {
              self.failureCreateVoteMessage = response.data.message;
              self.$store.dispatch('flashMessage', { message: self.failureCreateVoteMessage, type: "error"});
              self.$emit("create-vote-errors", response.data.errors);
              break;
            }
            case "既に投票しています": {
              self.failureCreateVoteMessage = response.data.message;
              self.$store.dispatch('flashMessage', { message: self.failureCreateVoteMessage, type: "error"});
              break;
            }
            case "Unauthorized": {
              self.$store.dispatch('flashMessage', { message: "投票をするためにはログインしてください", type: "error"});
            }
          }
          console.log(response);
        })
        .catch(function(error) {
          self.$store.dispatch('flashMessage', { message: "サーバーとの通信にエラーが発生しています", type: "warning"})
          console.log(error);
        })
    },
    fillData: function(post) {
      this.datacollection = {
        labels: this.getLabels(post),
        datasets: [
          {
            data: this.getDatas(post),
            backgroundColor: this.getBackGroundColors(post),
            borderColor: this.getBorderColors(post)
          }
        ]
      }
      this.options = {
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              display: true,
              beginAtZero: true,
              stepSize: 100,
              callback: function(label) {
                return label + '%';
              },
              max: 100,
              min: 0,
            },
            gridLines: {
              display: false,
            }
          }],
          yAxes: [{
            ticks: {
              display: true,
            },
            gridLines: {
              display: false,
            }
          }],
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem, data) {
              switch (tooltipItem.index) {
                case 0:
                  return post.list_1
                  + ": "
                  + Math.floor(data.datasets[0].data[0])
                  + " %";
                case 1:
                  return post.list_2
                  + ": "
                  + Math.floor(data.datasets[0].data[1])
                  + " %";
                case 2:
                  return post.list_3
                  + ": "
                  + Math.floor(data.datasets[0].data[2])
                  + " %";
                case 3:
                  return post.list_4
                  + ": "
                  + Math.floor(data.datasets[0].data[3])
                  + " %";
              }
            }
          }
        }
      }
      this.getHeight();
    },
    getLabels: function(post) {
      if (post.list_3 === null) {
        return Array('選択肢1', '選択肢2')
      } else if (post.list_4 === null) {
        return Array('選択肢1', '選択肢2', '選択肢3')
      } else {
        return Array('選択肢1', '選択肢2', '選択肢3', '選択肢4')
      }

    },
    getDatas: function(post) {
      if (post.list_3 === null) {
        return Array(
          post.quantity_list_1 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
          post.quantity_list_2 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100
        )
      } else if (post.list_4 === null) {
        return Array(
          post.quantity_list_1 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
          post.quantity_list_2 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
          post.quantity_list_3 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
        )
      } else {
        return Array(
          post.quantity_list_1 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
          post.quantity_list_2 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
          post.quantity_list_3 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
          post.quantity_list_4 / (post.quantity_list_1 + post.quantity_list_2 + post.quantity_list_3 + post.quantity_list_4) * 100,
        )
      }
    },
    getBackGroundColors: function(post) {
      if (post.list_3 === null) {
        return Array (
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)"
        )
      } else if (post.list_4 === null) {
        return Array (
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)"
        )
      } else {
        return Array (
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
        )
      }
    },
    getBorderColors: function(post) {
      if (post.list_3 === null) {
        return Array (
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
        )
      } else if (post.list_4 === null) {
        return Array (
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
        )
      } else {
        return Array (
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
          "rgba(53, 78, 89, 0.8)",
        )
      }
    },
    getHeight: function() {
      if (window.innerWidth < 600) {
        this.width = window.innerWidth / 1
        this.height = window.innerWidth / 2
      } else if (window.innerWidth >= 600) {
        this.width = window.innerWidth / 1
        this.height = window.innerWidth / 4
      }
    }
  },
  created: function() {
    this.fillData(this.post);
  }
}
</script>

<style lang="scss" scoped>
</style>
