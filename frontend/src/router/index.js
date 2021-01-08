import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import About from '../views/About.vue'
import UsersIndex from '../views/UsersIndex.vue'
import UsersShow from '../views/UsersShow.vue'
import Signup from '../views/Signup.vue'
import UsersEdit from '../views/UsersEdit.vue'
import UsersEditAvatar from '../views/UsersEditAvatar.vue'
import PostsShow from '../views/PostsShow.vue'
import Login from '../views/Login.vue'

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
    component: UsersEditAvatar,
    props: true
  },
  {
    path: '/posts/:id',
    component: PostsShow,
    props: true
  },
  {
    path: '/login',
    component: Login
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
