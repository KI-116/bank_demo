<template>
  <div class="branch-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>Branch Management</span>
      </div>
      <el-table :data="branches" style="width: 100%">
        <el-table-column prop="BranchName" label="Branch Name" width="150"></el-table-column>
        <el-table-column prop="City" label="City"></el-table-column>
        <el-table-column prop="assets" label="Assets"></el-table-column>
        <el-table-column label="Actions" width="180">
          <template slot-scope="scope">
            <el-button size="mini" @click="openDialog('edit', scope.row)">Edit</el-button>
            <el-button size="mini" type="danger" @click="deleteBranch(scope.row.BranchName)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 表单输入框 -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Add Branch
      </div>
    <el-form :model="formData" label-width="100px">
      <el-form-item label="Branch Name" prop="BranchName">
        <el-input v-model="formData.BranchName"></el-input>
      </el-form-item>
      <el-form-item label="City" prop="City">
        <el-input v-model="formData.City"></el-input>
      </el-form-item>
      <el-form-item label="Assets" prop="assets">
        <el-input v-model="formData.assets" type="number"></el-input>
      </el-form-item>
      <el-form-item>
        <!-- 提交按钮 -->
        <el-button type="primary" @click="addBranch">Add Branch</el-button>
      </el-form-item>
    </el-form>
  </el-card>

    <el-button type="primary" @click="goToHomePage" style="margin-top: 20px;">
      Back to Home
    </el-button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      branches: [],
      formData: {
        BranchName: '',
        City: '',
        assets: ''
      }
    };
  },
  methods: {
    fetchBranches() {
      axios.get('http://localhost:8000/api/branches/')
        .then(response => {
          this.branches = response.data;
        })
        .catch(error => {
          console.error('Error fetching branches:', error);
        });
    },
    addBranch() {
      axios.post('http://localhost:8000/api/branches/', this.formData)
        .then(() => {
          this.fetchBranches(); // 更新分支列表
          this.formData = {}; // 清空表单数据
        })
        .catch(error => {
          console.error('Error adding branch:', error);
        });
    },
    deleteBranch(branchName) {
      axios.delete(`http://localhost:8000/api/branches/${branchName}/`)
        .then(() => {
          this.fetchBranches(); // 更新分支列表
        })
        .catch(error => {
          console.error('Error deleting branch:', error);
        });
    },
    goToHomePage() {
      this.$router.push('/');
    }
  },
  mounted() {
    this.fetchBranches();
  }
};
</script>

<style scoped>
.branch-container {
  padding: 20px;
}
</style>
