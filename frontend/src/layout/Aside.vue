<template>
    <el-aside :width="isCollapse ? `64px` : `200px`">
      <div class="logo">
        <img :src="avatar" alt="logo" draggable="false" />
      </div>
      <el-menu
        background-color="#001529"
        text-color="#eee"
        active-text-color="#fff"
        router
        unique-opened
        :default-active="route.path"
        :collapse="isCollapse"
      >
        <template v-for="item in routers" :key="item.name">
          <template v-if="!item.hidden">
            <el-sub-menu
              v-if="item.children && item.children.length"
              :index="concatPath(item.path)"
            >
              <template #title>
                <Icons v-if="item.meta.icon" :name="item.meta.icon" />
                <span>{{ item.meta.title }}</span>
              </template>
              <template v-for="sub in item.children" :key="sub.name">
                <el-menu-item :index="concatPath(item.path, sub.path)">
                  <Icons v-if="sub.meta.icon" :name="sub.meta.icon" />
                  <template #title>{{ sub.meta.title }}</template>
                </el-menu-item>
              </template>
            </el-sub-menu>
            <el-menu-item v-else :index="concatPath(item.path)">
              <Icons v-if="item.meta.icon" :name="item.meta.icon" />
              <template #title>{{ item.meta.title }}</template>
            </el-menu-item>
          </template>
        </template>
      </el-menu>
      <div class="fold" @click="changeCollapse">
        <Icons v-if="!isCollapse" name="d-arrow-left" />
        <Icons v-else name="d-arrow-right" />
      </div>
    </el-aside>
  </template>
  
  <script>
  import { computed, reactive, toRefs } from "vue";
  import { useRoute } from "vue-router";
  import adminAvatar from "@/assets/img/admin.png";
  import userAvatar from "@/assets/img/user.png";
  
  export default {
    setup() {
      const route = useRoute();
  
      const routers = reactive([
      {
        path: 'banksystem',
        meta: { title: 'BankSystem', icon: 'banksystem' },
        children: [
          {
            path: 'overview',
            meta: { title: 'Overview', icon: 'overview' },
          },
          {
            path: 'manual',
            meta: { title: 'Manual', icon: 'manual' },
          }
        ]
      },
      {
        path: 'accounts',
        meta: { title: 'Accounts', icon: 'accounts' },
        component: () => import("@/views/Account.vue")
      },
      {
        path: 'branches',
        meta: { title: 'Branches', icon: 'branches' },
        component: () => import("@/views/Branch.vue")
      },
      {
        path: 'loans',
        meta: { title: 'Loans', icon: 'loans' }
      },
      {
        path: 'customers',
        meta: { title: 'Customers', icon: 'customers' },
        component: () => import("@/views/Customer.vue")
      }
    ]);
  
      // 假设你有一个机制来确定用户角色
      //const userRole = JSON.parse(sessionStorage.getItem('jwt')).role;
      const avatar = adminAvatar;
  
      const state = reactive({ isCollapse: false });
  
      const concatPath = (p_path, c_path = "") => {
        return `${p_path !== "" ? "/" + p_path : "/"}${c_path !== "" ? "/" + c_path : ""}`;
      };
  
      const changeCollapse = () => {
        state.isCollapse = !state.isCollapse;
      };
  
      return {
        avatar,
        route,
        routers,
        concatPath,
        changeCollapse,
        ...toRefs(state),
      };
    },
  };
  </script>
  
  <style lang="scss" scoped>
  @mixin noScrollBar {
    overflow: hidden;
    overflow-y: scroll;
    -ms-overflow-style: none;
    overflow: -moz-scrollbars-none;
    scrollbar-width: none;
  
    &::-webkit-scrollbar {
      width: 0 !important;
    }
  }
  
  @mixin noSelect {
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    user-select: none;
  }
  
  @mixin line($n) {
    height: $n + px;
    line-height: $n + px;
  }
  
  .el-aside {
    box-sizing: border-box;
    height: 100vh;
    display: flex;
    display: -webkit-flex;
    flex-direction: column;
    background-color: #001529;
    overflow: hidden;
    transition: width 0.3s ease-in-out;
    -moz-transition: width 0.3s ease-in-out;
    -webkit-transition: width 0.3s ease-in-out;
    @include noSelect;
  
    .logo {
      @include line(56);
      display: flex;
      display: -webkit-flex;
      align-items: center;
      justify-content: center;
      background-color: #002140;
  
      img {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #fff;
      }
  
      p {
        flex: 1;
        padding-left: 10px;
        height: 56px;
        font-size: 20px;
        color: #fff;
        overflow: hidden;
      }
    }
  
    .el-menu {
      flex: 1;
      border-right: none;
      @include noScrollBar;
  
      &:not(.el-menu--collapse) {
        width: 200px;
      }
    }
  
    .fold {
      @include line(48);
      color: #fff;
      font-size: 24px;
      font-weight: bold;
      text-align: center;
      background-color: #002140;
  
      &:hover {
        cursor: pointer;
      }
    }
  }
  
  /* 激活选中菜单 */
  .el-menu-item.is-active,
  .el-menu--popup .el-menu-item.is-active {
    background-color: #1890ff !important;
  }
  </style>
  