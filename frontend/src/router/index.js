import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import About from '../views/About.vue'
import UsersIndex from '../views/UsersIndex.vue'
import UsersShow from '../views/UsersShow.vue'
import Signup from '../views/Signup.vue'
import UsersEdit from '../views/UsersEdit.vue'
import UsersAvatarEdit from '../views/UsersAvatarEdit.vue'
import Login from '../views/Login.vue'

import Example from '../views/Example.vue'


Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    component: Home
  },
  {
    path: '/about',
    component: About
  },
  {
    path: '/users',
    component: UsersIndex
  },
  {
    path: '/users/:id',
    component: UsersShow,
    props: true
  },
  {
    path: '/signup',
    component: Signup
  },
  {
    path: '/users/:id/edit',
    component: UsersEdit,
    props: true
  },
  {
    path: '/users/:id/edit/avatar',
    component: UsersAvatarEdit,
    props: true
  },
  {
    path: '/login',
    component: Login
  },

  {
    path: '/example',
    component: Example
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
