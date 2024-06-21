import { createRouter, createWebHistory } from 'vue-router'
import { routes } from "@/router/router";
//import Branches from "@/views/Branches/Branches.vue";
import NProgress from "nprogress";
import "nprogress/nprogress.css";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [...routes]
})
/*const routes = [
  {
    path: "/branches",
    name: "Branches",
    component: Branches
  }
];*/
/*router.beforeEach((to, from, next) => {
  NProgress.start();
  const jwt = sessionStorage.getItem('jwt')
  const islogin = !!jwt
  if (islogin) {
    if (to.name === 'login') {
      next({ name: 'Layout' })
    } else if (to.meta.hasOwnProperty("roles")) {
      let roles = to.meta.roles || [];
      let { role } = JSON.parse(jwt);
      if (roles.includes(role)) {
        next()
      } else {
        next({ name: 'Layout' })
      }
    } else {
      next()
    }
  } else {
    if (to.name === 'login') {
      next()
    } else {
      next({ name: 'login' })
    }
  }
})
*/
router.afterEach(() => {
  NProgress.done();
});

export default router
