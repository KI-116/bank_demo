<template>
  <div class="account-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>Account Management</span>
      </div>
      <el-table :data="filteredAccounts" style="width: 100%">
        <el-table-column prop="account_id" label="Account ID" width="150"></el-table-column>
        <el-table-column prop="BranchName" label="Branch Name"></el-table-column>
        <el-table-column prop="account_money" label="Account Money"></el-table-column>
        <el-table-column prop="account_date" label="Account Date"></el-table-column>
        <el-table-column prop="account_active_date" label="Account Active Date"></el-table-column>
        <el-table-column prop="is_cheque" label="Is Cheque"></el-table-column>
        <el-table-column prop="overdraft" label="Overdraft"></el-table-column>
        <el-table-column prop="rate" label="Rate"></el-table-column>
        <el-table-column label="Actions" width="180">
          <template slot-scope="scope">
            <el-button size="mini" @click="openDialog('edit', scope.row)">Edit</el-button>
            <el-button size="mini" type="danger" @click="showDeleteConfirmation(scope.row)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- Search Input -->
      <el-input placeholder="Search by Account ID" v-model="searchQuery" @input="searchAccount"
        style="margin-top: 20px; width: 300px;"></el-input>
    </el-card>

    <!-- Add Account Form -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Add Account
      </div>
      <el-form :model="formData" label-width="150px">
        <el-form-item label="Account ID" prop="account_id">
          <el-input v-model="formData.account_id"></el-input>
        </el-form-item>
        <el-form-item label="Branch Name" prop="BranchName">
          <el-select v-model="formData.BranchName" placeholder="Select Branch">
            <el-option v-for="branch in branches" 
              :key="branch.BranchName" 
              :label="branch.BranchName"
              :value="branch.BranchName"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="Account Money" prop="account_money">
          <el-input v-model="formData.account_money"></el-input>
        </el-form-item>
        <el-form-item label="Account Date" prop="account_date">
          <el-date-picker v-model="formData.account_date" type="date" placeholder="Pick a date"></el-date-picker>
        </el-form-item>
        <el-form-item label="Account Active Date" prop="account_active_date">
          <el-date-picker v-model="formData.account_active_date" type="date" placeholder="Pick a date"></el-date-picker>
        </el-form-item>
        <el-form-item label="Is Cheque" prop="is_cheque">
          <el-switch v-model="formData.is_cheque"></el-switch>
        </el-form-item>
        <el-form-item label="Overdraft" prop="overdraft">
          <el-input v-model="formData.overdraft"></el-input>
        </el-form-item>
        <el-form-item label="Rate" prop="rate">
          <el-input v-model="formData.rate"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="addAccount">Add Account</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card style="margin-top: 20px;">
      <div slot="header">
        Update Account
      </div>
      <el-form :model="updateFormData" label-width="150px">
        <el-form-item label="Account ID" prop="account_id">
          <el-input v-model="updateFormData.account_id" disabled></el-input>
        </el-form-item>
        <el-form-item label="Branch Name" prop="BranchName">
          <el-select v-model="updateFormData.BranchName" placeholder="Select Branch" disabled>
            <el-option v-for="branch in branches" :key="branch.BranchName" :label="branch.BranchName"
              :value="branch.BranchName"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="Account Money" prop="account_money">
          <el-input v-model="updateFormData.account_money"></el-input>
        </el-form-item>
        <el-form-item label="Account Date" prop="account_date">
          <el-date-picker v-model="updateFormData.account_date" type="date" placeholder="Pick a date"
            disabled></el-date-picker>
        </el-form-item>
        <el-form-item label="Account Active Date" prop="account_active_date">
          <el-date-picker v-model="updateFormData.account_active_date" type="date" placeholder="Pick a date"
            disabled></el-date-picker>
        </el-form-item>
        <el-form-item label="Is Cheque" prop="is_cheque">
          <el-switch v-model="updateFormData.is_cheque" disabled></el-switch>
        </el-form-item>
        <el-form-item label="Overdraft" prop="overdraft">
          <el-input v-model="updateFormData.overdraft" disabled></el-input>
        </el-form-item>
        <el-form-item label="Rate" prop="rate">
          <el-input v-model="updateFormData.rate" disabled></el-input>
        </el-form-item>
        <!-- Deposit Input -->
        <el-form-item label="Deposit" prop="deposit">
          <el-input v-model="depositAmount" placeholder="Deposit Amount"></el-input>
          <el-button type="primary" @click="depositAccount">Deposit</el-button>
        </el-form-item>

        <!-- Withdraw Input -->
        <el-form-item label="Withdraw" prop="withdraw">
          <el-input v-model="withdrawAmount" placeholder="Withdraw Amount"></el-input>
          <el-button type="primary" @click="withdrawAccount">Withdraw</el-button>
        </el-form-item>


        <el-form-item>
          <!-- Update Button -->
          <el-button type="primary" @click="updateAccount">Update Account</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- Transfer Money Form -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Transfer Money
      </div>
      <el-form :model="transferFormData" label-width="150px">
        <el-form-item label="From Account ID" prop="from_account_id">
          <el-input v-model="transferFormData.from_account_id"></el-input>
        </el-form-item>
        <el-form-item label="To Account ID" prop="to_account_id">
          <el-input v-model="transferFormData.to_account_id"></el-input>
        </el-form-item>
        <el-form-item label="Transfer Amount" prop="transfer_amount">
          <el-input v-model="transferFormData.transfer_amount"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="transferMoney">Transfer</el-button>
        </el-form-item>
      </el-form>
    </el-card>


    <!-- Delete Account Form -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Delete Account
      </div>
      <el-form :model="deleteForm" label-width="150px">
        <el-form-item label="Account ID" prop="account_id">
          <el-input v-model="deleteForm.account_id"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="danger" @click="confirmDelete">Delete Account</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- Back to Home Button -->
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
      accounts: [],
      branches: [],
      formData: {
        account_id: '',
        BranchName: '',
        account_money: '',
        account_date: '',
        account_active_date: '',
        is_cheque: false,
        overdraft: '',
        rate: ''
      },
      searchQuery: '',
      deleteForm: {
        account_id: ''
      },
      updateFormData: {
        account_id: '',
        BranchName: '',
        account_money: '',
        account_date: '',
        account_active_date: '',
        is_cheque: false,
        overdraft: '',
        rate: ''
      },
      selectedBranch: '', // 选中的分支名称
      updateAssetsFormData: {
        assets: 0 // 初始化表单数据，后端返回的 assets 会填充到这里
      },
      depositAmount: '',
      withdrawAmount: '',
      transferFormData: {
        from_account_id: '',
        to_account_id: '',
        transfer_amount: ''
      }
    };
  },
  //props: ['branches'], // 从父组件传递分支列表
  computed: {
    filteredAccounts() {
      return this.accounts.filter(account =>
        account.account_id.includes(this.searchQuery)
      );
    }
  },
  methods: {
    fetchAccounts() {
      axios.get('http://localhost:8000/api/accounts/')
        .then(response => {
          this.accounts = response.data;
        })
        .catch(error => {
          console.error('Error fetching accounts:', error);
        });
    },
    fetchBranches() {
      axios.get('http://localhost:8000/api/branches/')
        .then(response => {
          this.branches = response.data;
        })
        .catch(error => {
          console.error('Error fetching branches:', error);
        });
    },
    addAccount() {
      const formattedAccountDate = this.formatDate(this.formData.account_date);
      const formattedActiveDate = this.formatDate(this.formData.account_active_date);
      this.formData.account_date = formattedAccountDate;
      this.formData.account_active_date = formattedActiveDate;

      axios.post('http://localhost:8000/api/accounts/', this.formData)
        .then(() => {
          this.fetchAccounts(); // Update account list
          this.formData = {
            account_id: '',
            BranchName: '',
            account_money: '',
            account_date: '',
            account_active_date: '',
            is_cheque: false,
            overdraft: '',
            rate: ''
          }; // Clear form data
          this.$message({
            message: 'Account added successfully',
            type: 'success'
          });
        })
        .catch(error => {
          console.error('Error adding account:', error);
          this.$message({
            message: 'Error adding account',
            type: 'error'
          });
        });
    },
    formatDate(date) {
      const year = date.getFullYear();
      let month = date.getMonth() + 1;
      let day = date.getDate();

      // Ensure month and day are two digits
      if (month < 10) {
        month = '0' + month;
      }
      if (day < 10) {
        day = '0' + day;
      }

      return `${year}-${month}-${day}`;
    },
    deleteAccount(accountId) {
      axios.delete(`http://localhost:8000/api/accounts/${accountId}/`)
        .then(() => {
          this.fetchAccounts(); // Update account list
          this.$message({
            message: 'Account deleted successfully',
            type: 'success'
          });
        })
        .catch(error => {
          console.error('Error deleting account:', error);
          this.$message({
            message: 'Error deleting account',
            type: 'error'
          });
        });
    },
    confirmDelete() {
      const accountId = this.deleteForm.account_id;
      if (accountId) {
        this.deleteAccount(accountId);
        this.deleteForm.account_id = ''; // Clear delete form input
        this.deleteForm.show = false; // Hide delete form after deletion
      } else {
        this.$message({
          message: 'Please enter an Account ID',
          type: 'warning'
        });
      }
    },
    searchAccount() {
      const accountId = this.searchQuery;
      axios.get(`http://localhost:8000/api/accounts/${accountId}/`)
        .then(response => {
          this.updateFormData = response.data; // Load account data into update form
        })
        .catch(error => {
          this.$message({
            message: 'Account ID does not exist',
            type: 'error'
          });
        });
    },
    updateAccount() {
      // 处理存款逻辑
      if (this.depositAmount) {
        this.updateFormData.account_money = parseFloat(this.updateFormData.account_money) + parseFloat(this.depositAmount);
      }

      axios.put(`http://localhost:8000/api/accounts/${this.updateFormData.account_id}/`, this.updateFormData)
        .then(() => {
          this.$message({
            message: 'Account updated successfully',
            type: 'success'
          });
          this.updateBranchAssets(this.updateFormData.BranchName);
          // 清空表单数据和存款金额
          this.updateFormData = {
            account_id: '',
            BranchName: '',
            account_money: '',
            account_date: '',
            account_active_date: '',
            is_cheque: false,
            overdraft: '',
            rate: ''
          };
          this.depositAmount = '';
        })
        .catch(error => {
          console.error('Error updating account:', error);
          //this.$message({
          //message: 'Error updating account',
          //type: 'error'
          //});
        });
    },
    withdrawAccount() {
      // 处理取款逻辑
      if (this.withdrawAmount) {
        this.updateFormData.account_money = parseFloat(this.updateFormData.account_money) - parseFloat(this.withdrawAmount);
      }
      if (this.updateFormData.account_money < 0) {
        this.$message({
          message: 'Insufficient funds',
          type: 'error'
        });
        return;
      }
      axios.put(`http://localhost:8000/api/accounts/${this.updateFormData.account_id}/`, this.updateFormData)
        .then(() => {
          this.$message({
            message: 'Account updated successfully',
            type: 'success'
          });
          this.withdrawBranchAssets(this.updateFormData.BranchName);
          // 清空表单数据和取款金额
          this.updateFormData = {
            account_id: '',
            BranchName: '',
            account_money: '',
            account_date: '',
            account_active_date: '',
            is_cheque: false,
            overdraft: '',
            rate: ''
          };
          this.withdrawAmount = '';
        })
        .catch(error => {
          console.error('Error updating account:', error);
          //this.$message({
          //message: 'Error updating account',
          //type: 'error'
          //});
        });
    },
    withdrawBranchAssets(branchName) {
      // Find the branch object by BranchName
      const branchToUpdate = this.branches.find(branch => branch.BranchName === branchName);

      if (!branchToUpdate) {
        console.error(`Branch with name ${branchName} not found.`);
        return;
      }

      // Calculate new assets based on current assets and deposit amount
      const newAssets = parseFloat(branchToUpdate.assets) - parseFloat(this.withdrawAmount);

      // Prepare data object to send to backend
      const dataToUpdate = {
        BranchName: branchToUpdate.BranchName,
        City: branchToUpdate.City,
        assets: newAssets
      };

      // Send PUT request to update branch assets
      axios.put(`http://localhost:8000/api/branches/${branchName}/`, dataToUpdate)
        .then(response => {
          // Handle successful update
          console.log('Updated branch assets:', response.data);
          this.$message({
            message: 'Branch assets updated successfully',
            type: 'success'
          });
        })
        .catch(error => {
          console.error('Error updating branch assets:', error);
          this.$message({
            message: 'Error updating branch assets',
            type: 'error'
          });
        });
    },

    updateBranchAssets(branchName) {
      // Find the branch object by BranchName
      const branchToUpdate = this.branches.find(branch => branch.BranchName === branchName);

      if (!branchToUpdate) {
        console.error(`Branch with name ${branchName} not found.`);
        return;
      }

      // Calculate new assets based on current assets and deposit amount
      const newAssets = parseFloat(branchToUpdate.assets) + parseFloat(this.depositAmount);

      // Prepare data object to send to backend
      const dataToUpdate = {
        BranchName: branchToUpdate.BranchName,
        City: branchToUpdate.City,
        assets: newAssets
      };

      // Send PUT request to update branch assets
      axios.put(`http://localhost:8000/api/branches/${branchName}/`, dataToUpdate)
        .then(response => {
          // Handle successful update
          console.log('Updated branch assets:', response.data);
          this.$message({
            message: 'Branch assets updated successfully',
            type: 'success'
          });
        })
        .catch(error => {
          console.error('Error updating branch assets:', error);
          this.$message({
            message: 'Error updating branch assets',
            type: 'error'
          });
        });
    },
    withdrawBranchAssets(branchName) {
      const branchToUpdate = this.branches.find(branch => branch.BranchName === branchName);

      if (!branchToUpdate) {
        console.error(`Branch with name ${branchName} not found.`);
        return;
      }

      const newAssets = parseFloat(branchToUpdate.assets) - parseFloat(this.withdrawAmount);

      const dataToUpdate = {
        BranchName: branchToUpdate.BranchName,
        City: branchToUpdate.City,
        assets: newAssets
      };

      axios.put(`http://localhost:8000/api/branches/${branchName}/`, dataToUpdate)
        .then(response => {
          console.log('Updated branch assets:', response.data);
          this.$message({
            message: 'Branch assets updated successfully',
            type: 'success'
          });
        })
        .catch(error => {
          console.error('Error updating branch assets:', error);
          this.$message({
            message: 'Error updating branch assets',
            type: 'error'
          });
        });
    },

    openEditDialog(account) {
      this.updateFormData = { ...account }; // Load customer data into update form
    },

    transferMoney() {
      const { from_account_id, to_account_id, transfer_amount } = this.transferFormData;
      if(!from_account_id || !to_account_id || !transfer_amount) {
        this.$message({
          message: 'Please fill in all fields',
          type: 'warning'
        });
        return;
      }
      const fromAccount = this.accounts.find(account => account.account_id === from_account_id);
      const toAccount = this.accounts.find(account => account.account_id === to_account_id);
      if(fromAccount.account_money < transfer_amount) {
        this.$message({
          message: 'Insufficient funds',
          type: 'error'
        });
        return;
      }
      const newfromAccountMoney = parseFloat(fromAccount.account_money) - parseFloat(transfer_amount);
      const newtoAccountMoney = parseFloat(toAccount.account_money) + parseFloat(transfer_amount);
      const updateFromAccount = {
        account_id: fromAccount.account_id,
        BranchName: fromAccount.BranchName,
        account_money: newfromAccountMoney,
        account_date: fromAccount.account_date,
        account_active_date: fromAccount.account_active_date,
        is_cheque: fromAccount.is_cheque,
        overdraft: fromAccount.overdraft,
        rate: fromAccount.rate
      };
      const updateToAccount = {
        account_id: toAccount.account_id,
        BranchName: toAccount.BranchName,
        account_money: newtoAccountMoney,
        account_date: toAccount.account_date,
        account_active_date: toAccount.account_active_date,
        is_cheque: toAccount.is_cheque,
        overdraft: toAccount.overdraft,
        rate: toAccount.rate
      };
      axios.put(`http://localhost:8000/api/accounts/${from_account_id}/`, updateFromAccount)
        .then(() => {
          axios.put(`http://localhost:8000/api/accounts/${to_account_id}/`, updateToAccount)
            .then(() => {
              this.$message({
                message: 'Transfer successful',
                type: 'success'
              });
              this.fetchAccounts();
            })
            .catch(error => {
              console.error('Error transferring money:', error);
              this.$message({
                message: 'Error transferring money',
                type: 'error'
              });
            });
        })
        .catch(error => {
          console.error('Error transferring money:', error);
          this.$message({
            message: 'Error transferring money',
            type: 'error'
          });
        });
    },
    goToHomePage() {
      this.$router.push('/');
    }
  },
  created() {
    this.fetchAccounts();
    this.fetchBranches();
  }
};
</script>

<style scoped>
.account-container {
  padding: 20px;
}

.el-select {
  width: 100%;
}
</style>
