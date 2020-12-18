<template>
  <div>
    <p>users#edit, users#update</p>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>

    <div id="users-edit">
      <v-container>
        <v-row>
          <v-col cols="12" sm="10" md="6" class="mx-auto">
            <v-card>
              <v-card-title>
                <div class="grey--text text--darken-3">ユーザー情報更新</div>
              </v-card-title>
              <v-card-text>
                <ValidationObserver v-slot="{ invalid }">
                  <template>

                    <ValidationProvider name="ユーザー名" rules="required|userName" v-slot="{ errors }">
                      <v-text-field
                        prepend-icon="mdi-account-circle"
                        v-model="user.name"
                        :error-messages="errors"
                        id="user_name"
                        name="user[name]"
                        outlined
                        dense
                        counter="20"
                        label="ユーザー名"
                        color="teal lighten-2"
                      ></v-text-field>
                    </ValidationProvider>
                    <ValidationProvider name="メールアドレス" rules="required|userMailAddress" v-slot="{ errors }">
                      <v-text-field
                        prepend-icon="mdi-email"
                        v-model="user.email"
                        :error-messages="errors"
                        id="user_email"
                        name="user[email]"
                        outlined
                        dense
                        label="メールアドレス"
                        color="teal lighten-2"
                      ></v-text-field>
                    </ValidationProvider>
                    <ValidationProvider name="パスワード" rules="required|userPassword|confirmed:passwordConfirmation" v-slot="{ errors }" vid="password">
                      <v-text-field
                        prepend-icon="mdi-lock"
                        v-bind:append-icon="showUserPassword ? 'mdi-eye' : 'mdi-eye-off'"
                        v-model="user.password"
                        :error-messages="errors"
                        id="user_password"
                        name="user[password]"
                        outlined
                        dense
                        counter="32"
                        label="パスワード"
                        v-bind:type="showUserPassword ? 'text' : 'password'"
                        @click:append="showUserPassword = !showUserPassword"
                        color="teal lighten-2"
                      ></v-text-field>
                    </ValidationProvider>
                    <ValidationProvider name="パスワード(確認用)" rules="required|userPasswordConfirmation|confirmed:password" v-slot="{ errors }" vid="passwordConfirmation">
                      <v-text-field
                        prepend-icon="mdi-lock-check"
                        v-bind:append-icon="showUserPasswordConfirmation ? 'mdi-eye' : 'mdi-eye-off'"
                        v-model="user.password_confirmation"
                        :error-messages="errors"
                        id="user_password_confirmation"
                        name="user[password_confirmation]"
                        outlined
                        dense
                        counter="32"
                        label="パスワード(確認用)"
                        v-bind:type="showUserPasswordConfirmation ? 'text' : 'password'"
                        @click:append="showUserPasswordConfirmation = !showUserPasswordConfirmation"
                        color="teal lighten-2"
                      ></v-text-field>
                    </ValidationProvider>

                    <v-card-actions>
                      <v-btn
                        :disabled="invalid"
                        v-on:click="updateUser()"
                      >送信</v-btn>
                    </v-card-actions>
                  </template>
                </ValidationObserver>
              </v-card-text>
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

import {
  extend,
  localize,
  ValidationObserver,
  ValidationProvider
} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja'
localize("ja", ja);

import {
  required,
  confirmed,
} from 'vee-validate/dist/rules';
extend('required', {
  ...required,
  message: '入力内容は必須項目です'
});
extend('confirmed', {
  ...confirmed,
  message: 'パスワードとパスワード(確認用)が一致しません'
});

extend('userName', function(value) {
  return /^[a-zA-Z0-9\-_]{6,20}$/.test(value) || '{_field_}は半角英数字とハイフン(-)もしくはアンダーバー(_)で6~20文字で入力してください';
});
extend('userMailAddress', function(value) {
  return /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]{1,}\.[A-Za-z0-9]{1,}$/.test(value) || '{_field_}は正しくありません';
});
extend('userPassword', function(value) {
  return /^[a-zA-Z0-9!#%&,:;<=>@_`~$*+-./?\\^|]{8,32}$/.test(value) || '{_field_}は半角英数字記号で8~32文字で入力してください';
});
extend('userPasswordConfirmation', function(value) {
  return /^[a-zA-Z0-9!#%&,:;<=>@_`~$*+-./?\\^|]{8,32}$/.test(value) || '{_field_}は半角英数字記号で8~32文字で入力してください';
});


export default {
  props: ['id'],
  components: {
    ValidationObserver,
    ValidationProvider
  },
  data: function() {
    return {
      user: {},
      errorFlag: false,
      showUserPassword: false,
      showUserPasswordConfirmation: false,
      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL,
      successUpdateUserMessage: '',
      failureUpdateUserMessage: '',
      userUpdateErrors: {},
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
    updateUser: function() { // -> PATCH, users#update
      const self = this;
      axios
        .patch('/api/v1/users/' + self.user.id, {
          user: {
            name: self.user.name,
            email: self.user.email,
            password: self.user.password,
            password_confirmation: self.user.password_confirmation,
          }
        })
        .then(function(response) {
          if ((response.data.message === "ユーザー情報の編集に成功しました") && (self.successUpdateUserMessage = response.data.message)) {
            self.user = response.data.user;
            self.$store.commit('flashMessage', self.successUpdateUserMessage);
            self.$router.push('/users/' + self.user.id)
          } else if ((response.data.message === "ユーザー情報の編集に失敗しました") && (self.failureUpdateUserMessage = response.data.message)) {
            self.user = response.data.user;
            self.userUpdateErrors = response.data.errors;
            self.$store.commit('flashMessage', self.failureUpdateUserMessage);
            // self.user.name = '';
            // self.user.email = '';
            // self.user.password = '';
            // self.user.password_confirmation = '';
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
