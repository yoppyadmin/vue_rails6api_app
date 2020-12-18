<template>
  <div>
    <p>users#show</p>
    <p v-show="errorFlag">サーバとの通信にエラーが発生しています</p>
    <div id="users-show">
      <div>
        <p>{{ user.id }}</p>
        <p>{{ user.name }}</p>
        <p>{{ user.email }}</p>
        <template v-if="user.avatar && node_env !== 'production'">
          <v-avatar>
            <img v-bind:src="axiosDefaultsBaseURL + user.avatar.url">
          </v-avatar>
        </template>
        <template v-else-if="user.avatar && node_env == 'production'">
          <v-avatar>
            <img v-bind:src="user.avatar.url">
          </v-avatar>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: ['id'],
  data: function() {
    return {
      errorFlag: false,
      user: {},
      node_env: process.env.NODE_ENV,
      axiosDefaultsBaseURL: axios.defaults.baseURL
    }
  },
  mounted: function() { // -> GET, users#show
    const self = this;
    axios
      .get('/api/v1/users/' + self.$route.params.id)
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
