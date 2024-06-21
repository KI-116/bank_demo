<template>
  <div class="customer-container">
    <el-card>
      <div slot="header" class="clearfix">
        <span>Customer Management</span>
      </div>
      <el-table :data="filteredCustomers" style="width: 100%">
        <el-table-column prop="customer_id" label="Customer ID" width="150"></el-table-column>
        <el-table-column prop="customer_name" label="Customer Name"></el-table-column>
        <el-table-column prop="customer_tel" label="Customer Tel"></el-table-column>
        <el-table-column prop="customer_add" label="Customer Address"></el-table-column>
        <el-table-column prop="contact_name" label="Contact Name"></el-table-column>
        <el-table-column prop="contact_tel" label="Contact Tel"></el-table-column>
        <el-table-column prop="contact_email" label="Contact Email"></el-table-column>
        <el-table-column prop="contact_relation" label="Contact Relation"></el-table-column>
        <el-table-column label="Actions" width="180">
          <template slot-scope="scope">
            <el-button size="mini" @click="openEditDialog(scope.row)">Edit</el-button>
            <el-button size="mini" type="danger" @click="deleteCustomer(scope.row.customer_id)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- Search Input -->
      <el-input placeholder="Search by Customer ID" v-model="searchQuery" @input="searchCustomer" style="margin-top: 20px; width: 300px;"></el-input>
    </el-card>

    <!-- Form Input Fields -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Add Customer
      </div>
      <el-form :model="formData" label-width="150px">
        <el-form-item label="Customer ID" prop="customer_id">
          <el-input v-model="formData.customer_id"></el-input>
        </el-form-item>
        <el-form-item label="Customer Name" prop="customer_name">
          <el-input v-model="formData.customer_name"></el-input>
        </el-form-item>
        <el-form-item label="Customer Tel" prop="customer_tel">
          <el-input v-model="formData.customer_tel"></el-input>
        </el-form-item>
        <el-form-item label="Customer Address" prop="customer_add">
          <el-input v-model="formData.customer_add"></el-input>
        </el-form-item>
        <el-form-item label="Contact Name" prop="contact_name">
          <el-input v-model="formData.contact_name"></el-input>
        </el-form-item>
        <el-form-item label="Contact Tel" prop="contact_tel">
          <el-input v-model="formData.contact_tel"></el-input>
        </el-form-item>
        <el-form-item label="Contact Email" prop="contact_email">
          <el-input v-model="formData.contact_email"></el-input>
        </el-form-item>
        <el-form-item label="Contact Relation" prop="contact_relation">
          <el-input v-model="formData.contact_relation"></el-input>
        </el-form-item>
        <el-form-item>
          <!-- Submit Button -->
          <el-button type="primary" @click="addCustomer">Add Customer</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- Update Customer Form -->
    <el-card style="margin-top: 20px;">
      <div slot="header">
        Update Customer
      </div>
      <el-form :model="updateFormData" label-width="150px">
        <el-form-item label="Customer ID" prop="customer_id">
          <el-input v-model="updateFormData.customer_id" disabled></el-input>
        </el-form-item>
        <el-form-item label="Customer Name" prop="customer_name">
          <el-input v-model="updateFormData.customer_name"></el-input>
        </el-form-item>
        <el-form-item label="Customer Tel" prop="customer_tel">
          <el-input v-model="updateFormData.customer_tel"></el-input>
        </el-form-item>
        <el-form-item label="Customer Address" prop="customer_add">
          <el-input v-model="updateFormData.customer_add"></el-input>
        </el-form-item>
        <el-form-item label="Contact Name" prop="contact_name">
          <el-input v-model="updateFormData.contact_name"></el-input>
        </el-form-item>
        <el-form-item label="Contact Tel" prop="contact_tel">
          <el-input v-model="updateFormData.contact_tel"></el-input>
        </el-form-item>
        <el-form-item label="Contact Email" prop="contact_email">
          <el-input v-model="updateFormData.contact_email"></el-input>
        </el-form-item>
        <el-form-item label="Contact Relation" prop="contact_relation">
          <el-input v-model="updateFormData.contact_relation"></el-input>
        </el-form-item>
        <el-form-item>
          <!-- Update Button -->
          <el-button type="primary" @click="updateCustomer">Update Customer</el-button>
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
      customers: [],
      formData: {
        customer_id: '',
        customer_name: '',
        customer_tel: '',
        customer_add: '',
        contact_name: '',
        contact_tel: '',
        contact_email: '',
        contact_relation: ''
      },
      updateFormData: {
        customer_id: '',
        customer_name: '',
        customer_tel: '',
        customer_add: '',
        contact_name: '',
        contact_tel: '',
        contact_email: '',
        contact_relation: ''
      },
      searchQuery: '', // 搜索查询字符串
    };
  },
  computed: {
    filteredCustomers() {
      return this.customers.filter(customer =>
        customer.customer_id.includes(this.searchQuery)
      );
    }
  },
  methods: {
    fetchCustomers() {
      axios.get('http://localhost:8000/api/customers/')
        .then(response => {
          this.customers = response.data;
        })
        .catch(error => {
          console.error('Error fetching customers:', error);
        });
    },
    addCustomer() {
      axios.post('http://localhost:8000/api/customers/', this.formData)
        .then(() => {
          this.fetchCustomers(); // Update customer list
          this.formData = {
            customer_id: '',
            customer_name: '',
            customer_tel: '',
            customer_add: '',
            contact_name: '',
            contact_tel: '',
            contact_email: '',
            contact_relation: ''
          }; // Clear form data
        })
        .catch(error => {
          console.error('Error adding customer:', error);
        });
    },
    deleteCustomer(customerId) {
      axios.delete(`http://localhost:8000/api/customers/${customerId}/`)
        .then(() => {
          this.fetchCustomers(); // Update customer list
        })
        .catch(error => {
          console.error('Error deleting customer:', error);
        });
    },
    updateCustomer() {
      const customerId = this.updateFormData.customer_id;
      axios.put(`http://localhost:8000/api/customers/${customerId}/`, this.updateFormData)
        .then(() => {
          this.fetchCustomers(); // Update customer list
          this.updateFormData = {
            customer_id: '',
            customer_name: '',
            customer_tel: '',
            customer_add: '',
            contact_name: '',
            contact_tel: '',
            contact_email: '',
            contact_relation: ''
          }; // Clear form data
        })
        .catch(error => {
          console.error('Error updating customer:', error);
        });
    },
    searchCustomer() {
      const customerId = this.searchQuery;
      axios.get(`http://localhost:8000/api/customers/${customerId}/`)
        .then(response => {
          this.updateFormData = response.data; // Load customer data into update form
        })
        .catch(error => {
          this.$message({
            message: 'Customer ID does not exist',
            type: 'error'
          });
        });
    },
    openEditDialog(customer) {
      this.updateFormData = { ...customer }; // Load customer data into update form
    },
    goToHomePage() {
      this.$router.push('/');
    }
  },
  mounted() {
    this.fetchCustomers();
  }
};
</script>

<style scoped>
.customer-container {
  padding: 20px;
}
</style>
