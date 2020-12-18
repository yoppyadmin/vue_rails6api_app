<template>
  <div>
    <p>users#edit, users#update</p>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>

    <div id="users-avatar-edit">
      <v-container>
        <v-row>
          <v-col cols="12" sm="10" md="6" class="mx-auto">
            <v-card>
              <v-card-title>
                <p>ユーザーのアバターを変更</p>
              </v-card-title>
              <v-card-subtitle>
                <p>画像を選択してください</p>
              </v-card-subtitle>
              <v-list-item class="d-flex flex-column justify-center">
                <template v-if="user.avatar && node_env !== 'production'">
                  <v-list-item-avatar size="128">
                    <img v-bind:src="axiosDefaultsBaseURL + user.avatar.url" id="preview" name="preview">
                  </v-list-item-avatar>
                </template>
                <template v-else-if="user.avatar && node_env == 'production'">
                  <v-list-item-avatar size="128">
                    <img v-bind:src="user.avatar.url" id="preview" name="preview">
                  </v-list-item-avatar>
                </template>
                <input
                  style="display: none"
                  type="file"
                  accept="image/jpeg, image/jpg, image/png"
                  id="user_avatar"
                  name="user[avatar]"
                  v-on:change="selectedFile()"
                  ref="input"
                >
                <v-btn
                  v-on:click="inputClick()"
                  color="blue-grey lighten-3"
                >画像を選択</v-btn>
              </v-list-item>
              <v-card-actions>
                <v-btn
                  v-on:click="updateUserAvatar()"
                  color="blue-grey darken-3"
                  block
                  dark
                >送信</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import store from '../store';

export default {
  props: ['id'],
  data: function() {
    return {
      user: {},
      errorFlag: false,
      successUpdateUserAvatarMessage: '',
      failureUpdateUserAvatarMessage: '',
      userUpdateAvatarErrors: {},
      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL
    }
  },
  beforeRouteEnter(to, from, next) { // -> GET, users#edit
    axios
      .get('/api/v1/users/' + to.params.id + '/edit')
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
    inputClick: function() {
      this.$refs.input.click();
    },
    selectedFile: function() {
      const previewElement = document.getElementById('preview');
      this.user.avatar = this.$refs.input.files[0];
      const reader = new FileReader();
      reader.addEventListener('load', function() {
        previewElement.src = reader.result;
      });
      reader.readAsDataURL(this.user.avatar);
    },
    updateUserAvatar: function() {
      const self = this;
      const formData = new FormData();
      formData.append("user[avatar]", self.user.avatar);
      const config = {
        headers: {
          'content-type': 'multipart/form-data'
        }
      };
      axios
        .patch('/api/v1/users/' + self.user.id, formData, { config })
        .then(function(response) {
          if ((response.data.message === "ユーザー情報の編集に成功しました") && (self.successUpdateUserAvatarMessage = response.data.message)) {
            self.user = response.data.user;
            self.$store.commit('flashMessage', self.successUpdateUserAvatarMessage);
            self.$router.push('/users/' + self.user.id)
          } else if ((response.data.message === "ユーザー情報の編集に失敗しました") && (self.failureUpdateUserAvatarMessage = response.data.message)) {
            self.user = response.data.user;
            self.userUpdateErrors = response.data.errors;
            self.$store.commit('flashMessage', self.failureUpdateUserAvatarMessage);
          }
          console.log(response);
        })
        .catch(function(error) {
          self.errorFlag = true;
          console.log(error);
        })
    }
  },
  mounted: function() { // -> GET, users#edit
    const self = this;
    axios
      .get('/api/v1/users/' + self.$route.params.id + '/edit')
      .then(function(response) {
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
</style>
