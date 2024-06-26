import Layout from "@/layout/Index.vue";
import RouteView from "@/components/RouteView.vue";
import Branch from "@/views/Branch.vue";
import Account from "@/views/Account.vue";
import Customer from "@/views/Customer.vue";
import Loans from "@/views/Loans.vue";
import Manual from "@/views/Manual.vue";
import path from "path";

const layoutMap = [
    {
        path: "user",
        name: "User",
        meta: { title: "用户列表", icon: "User", roles: ["admin"] },
        component: () => import("@/views/Admin/User.vue")
    },
    {
        path: "branch",
        name: "Sub_bank",
        meta: { title: "支行", icon: "CreditCard", roles: ["admin"] },
        component: () => import("@/views/Admin/Sub_bank.vue")
    },
    {
        path: "department",
        name: "Department",
        component: RouteView,
        meta: { title: "部门管理", icon: "Document" },
        children: [
            {
                path: "department",
                name: "Department",
                meta: { title: "部门" },
                component: () => import("@/views/Department/Department.vue")
            },
            {
                path: "member",
                name: "Member",
                meta: { title: "员工" },
                component: () => import("@/views/Department/Member.vue")
            },
        ]
    },
    {
        path: "client",
        name: "Client",
        component: RouteView,
        meta: { title: "客户管理", icon: "DataLine" },
        children: [
            {
                path: "client",
                name: "Client",
                meta: { title: "客户" },
                component: () => import("@/views/Client/Client.vue")
            },
            {
                path: "credit_account",
                name: "Credit_account",
                meta: { title: "信用账户" },
                component: () => import("@/views/Client/Credit_account.vue")
            },
            {
                path: "saving_account",
                name: "Saving_account",
                meta: { title: "储蓄账户" },
                component: () => import("@/views/Client/Saving_account.vue")
            }
        ]
    },
    {
        path: "loan",
        name: "Loan",
        component: RouteView,
        meta: { title: "贷款管理", icon: "Coin" },
        children: [
            {
                path: "loan",
                name: "Loan",
                meta: { title: "贷款" },
                component: () => import("@/views/Loan/Loan.vue")
            },
            {
                path: "pay_status",
                name: "Pay_status",
                meta: { title: "支付情况" },
                component: () => import("@/views/Loan/Pay_status.vue")
            }
        ]
    }
];

const routes = [
    /*{
        path: '/Login',
        name: 'login',
        component: () => import('@/views/Login/Login.vue')
    },*/
    {
        path: "/",
        name: "Layout",
        //name:"api",
        component: Layout,
        children: [...layoutMap]
    },
    {
        path: '/branches',
        name: 'Branches',
        component: Branch
    },
    {
        path: '/accounts',
        name: 'Accounts',
        component: Account
    },
    {
        path: '/customers',
        name: 'Customers',
        component: Customer
    },
    {
        path: '/Loans',
        name: 'Loans',
        component: Loans
    },
    {
        path: "/banksystem/manual",
        name: "DownloadPdf",
        component: Manual
    },
];

export { routes, layoutMap };
