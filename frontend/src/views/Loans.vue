<template>
  <div class="loan-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>Loan Management</span>
      </div>
      <el-table :data="loans" style="width: 100%">
        <el-table-column prop="loan_id" label="Loan ID" width="150"></el-table-column>
        <el-table-column prop="loan_money" label="Loan Amount"></el-table-column>
        <el-table-column prop="loan_date" label="Loan Date"></el-table-column>
        <el-table-column label="Actions" width="180">
          <template slot-scope="scope">
            <el-button size="mini" @click="openDialog('edit', scope.row)">Edit</el-button>
            <el-button size="mini" type="danger" @click="deleteLoan(scope.row.loan_id)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- Form Input Fields -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Add Loan
      </div>
    <el-form :model="formData" label-width="150px">
      <el-form-item label="Loan ID" prop="loan_id">
        <el-input v-model="formData.loan_id"></el-input>
      </el-form-item>
      <el-form-item label="Loan Amount" prop="loan_money">
        <el-input v-model="formData.loan_money" type="number"></el-input>
      </el-form-item>
      <el-form-item label="Loan Date" prop="loan_date">
        <el-date-picker v-model="formData.loan_date" type="date" placeholder="Select date"></el-date-picker>
      </el-form-item>
      <el-form-item>
        <!-- Submit Button -->
        <el-button type="primary" @click="addLoan">Add Loan</el-button>
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
      loans: [],
      formData: {
        loan_id: '',
        loan_money: '',
        loan_date: ''
      }
    };
  },
  methods: {
    fetchLoans() {
      axios.get('http://localhost:8000/api/loans/')
        .then(response => {
          this.loans = response.data;
        })
        .catch(error => {
          console.error('Error fetching loans:', error);
        });
    },
    addLoan() {
      const formattedDate = this.formatDate(this.formData.loan_date);
      this.formData.loan_date = formattedDate;
      axios.post('http://localhost:8000/api/loans/', this.formData)
        .then(() => {
          this.fetchLoans(); // Update loan list
          this.formData = {}; // Clear form data
        })
        .catch(error => {
          console.error('Error adding loan:', error);
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
    deleteLoan(loanId) {
      axios.delete(`http://localhost:8000/api/loans/${loanId}/`)
        .then(() => {
          this.fetchLoans(); // Update loan list
        })
        .catch(error => {
          console.error('Error deleting loan:', error);
        });
    },
    goToHomePage() {
      this.$router.push('/');
    }
  },
  mounted() {
    this.fetchLoans();
  }
};
</script>

<style scoped>
.loan-container {
  padding: 20px;
}
</style>
