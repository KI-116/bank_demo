<template>
    <el-card shadow="never" class="index">
        <template #header>
            <div class="card_header">
                <b>贷款</b>
                <div>
                    <el-button color="#056DE8" @click="searchDialogFormVisible = true">搜索</el-button>
                    <el-button color="#87CEEB" @click="addDialogFormVisible = true">借贷</el-button>
                </div>
            </div>
        </template>
        <!-- <el-empty description="暂无数据"></el-empty> -->

        <el-table :data="tableData" stripe style="width: 100%">
            <el-table-column prop="loan_id" label="贷款ID"></el-table-column>
            <el-table-column prop="client_id"  label="客户身份证号" width="200"></el-table-column>
            <el-table-column prop="bank_name" label="支行名称"></el-table-column>
            <el-table-column prop="loan_total" label="本金"></el-table-column>
            <el-table-column prop="remain_loan" label="剩余贷款"></el-table-column>
            <el-table-column prop="loan_date" label="借贷时间"></el-table-column>
            <el-table-column prop="loan_rate" label="利率"></el-table-column>
        </el-table>

        <div style="padding: 10px 0">
            <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" :page-sizes="[2, 4, 10, 20]"
                layout="total, sizes, prev, pager, next, jumper" :total="count" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" />
        </div>

        <el-dialog v-model="addDialogFormVisible" title="借贷">
            <el-form :model="addForm">
                <el-form-item label="客户身份证号" label-width=100px>
                    <el-input v-model="addForm.client_id" autocomplete="off" />
                </el-form-item>
                <el-form-item label="支行名称" label-width=100px>
                    <el-input v-model="addForm.bank_name" autocomplete="off" />
                </el-form-item>
                <el-form-item label="本金" label-width=100px>
                    <el-input v-model="addForm.loan_total" autocomplete="off" />
                </el-form-item>
                <el-form-item label="利率" label-width=100px>
                    <el-input v-model="addForm.loan_rate" autocomplete="off" />
                </el-form-item>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="addDialogFormVisible = false">取消</el-button>
                    <el-button type="primary" @click="handleAdd()">确定</el-button>
                </span>
            </template>
        </el-dialog>

        <el-dialog v-model="searchDialogFormVisible" title="搜索">
            <el-form :model="searchForm">
                <el-form-item label="贷款ID" label-width=100px>
                    <el-input v-model="searchForm.loan_id" autocomplete="off" />
                </el-form-item>
                <el-form-item label="客户身份证号" label-width=100px>
                    <el-input v-model="searchForm.client_id" autocomplete="off" />
                </el-form-item>
                <el-form-item label="支行名称" label-width=100px>
                    <el-input v-model="searchForm.bank_name" autocomplete="off" />
                </el-form-item>
                <el-form-item label="本金" label-width=100px>
                    <el-input v-model="searchForm.loan_total" autocomplete="off" />
                </el-form-item>
                <el-form-item label="剩余贷款" label-width=100px>
                    <el-input v-model="searchForm.remain_loan" autocomplete="off" />
                </el-form-item>
                <el-form-item label="借贷时间" label-width=100px>
                    <el-input v-model="searchForm.loan_date" autocomplete="off" />
                </el-form-item>
                <el-form-item label="利率" label-width=100px>
                    <el-input v-model="searchForm.loan_rate" autocomplete="off" />
                </el-form-item>
            </el-form>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="searchDialogFormVisible = false">取消</el-button>
                    <el-button type="primary" @click="handleSearch()">确定</el-button>
                </span>
            </template>
        </el-dialog>
    </el-card>
</template>

<script>
import { ref, onMounted } from "vue";
import request from "@/utils/axios";
import { reactive } from "vue";
import { ElMessage } from "element-plus";

export default {
    setup() {
        const tableData = ref([])
        const addDialogFormVisible = ref(false);
        const searchDialogFormVisible = ref(false);
        const addForm = reactive({
            loan_id: "",
            client_id: "",
            bank_name: "",
            loan_total: "",
            remain_loan: "",
            loan_date: "",
            loan_rate: "",
        });
        const searchForm = reactive({
            loan_id: "",
            client_id: "",
            bank_name: "",
            loan_total: "",
            remain_loan: "",
            loan_date: "",
            loan_rate: "",
        });
        const currentPage = ref(1);
        const pageSize = ref(2);
        const count = ref(0);
        const baseurl = "/api";

        const load = () => {
            request({ url: baseurl + "/loans", method: "post", params: { page: currentPage.value, size: pageSize.value }, data: searchForm }).then(res => {
                if (res.data.code == 200) {
                    tableData.value = res.data.data.data;
                    count.value = res.data.data.count;
                } else {
                    ElMessage.error(res.data.code + "：" + res.data.message);
                }
            }).catch(err => {
                ElMessage.error(err);
            });
        };

        onMounted(() => {
            load();
        });

        const handleSizeChange = (number) => {
            pageSize.value = number;
            load();
        };

        const handleCurrentChange = (number) => {
            currentPage.value = number;
            load();
        };

        const handleAdd = () => {
            request.post(baseurl + "/add", addForm).then(res => {
                load();
                if (res.data.code == 200) {
                    ElMessage.success(res.data.message);
                } else {
                    ElMessage.error(res.data.code + "：" + res.data.message);
                }
            }).catch(err => {
                ElMessage.error(err);
            });
            addDialogFormVisible.value = false;
            Object.keys(addForm).forEach(key => {
                addForm[key] = "";
            });
        };

        const handleSearch = () => {
            load();
            searchDialogFormVisible.value = false;
            Object.keys(searchForm).forEach(key => {
                searchForm[key] = "";
            });
        };
        return {
            tableData,
            addDialogFormVisible,
            searchDialogFormVisible,
            addForm,
            searchForm,
            currentPage,
            pageSize,
            count,
            handleSizeChange,
            handleCurrentChange,
            handleAdd,
            handleSearch,
        };
    }
}
</script>

<style lang="scss" scoped>
.card_header {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
</style>
