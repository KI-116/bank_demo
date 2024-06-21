from django.db import models

# Create your models here.
from django.db import models
from django.core.exceptions import ValidationError

class PDFFile(models.Model):
    file = models.FileField(upload_to='pdfs/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
class Branch(models.Model):
    BranchName = models.CharField(max_length=30, primary_key=True)
    City = models.CharField(max_length=30)
    assets = models.DecimalField(max_digits=15, decimal_places=2)

class Account(models.Model):
    account_id = models.CharField(max_length=30, primary_key=True)
    BranchName = models.ForeignKey(Branch, on_delete=models.RESTRICT)
    account_money = models.DecimalField(max_digits=15, decimal_places=2)
    account_date = models.DateField()
    account_active_date = models.DateField()
    is_cheque = models.BooleanField()
    overdraft = models.DecimalField(max_digits=15, decimal_places=2, null=True, blank=True)
    rate = models.FloatField()
    #transfer_to_account_id = models.CharField(max_length=30, null=True, blank=True)

    def clean(self):
        # Ensure account_money is non-negative
        if self.account_money < 0:
            raise ValidationError('Balance must be non-negative.')

        # Ensure overdraft is non-negative
        if self.overdraft < 0:
            raise ValidationError('Overdraft must be non-negative.')

        # Ensure rate is non-negative and does not exceed 100%
        if self.rate < 0 or self.rate > 100:
            raise ValidationError('Rate must be between 0 and 100.')

        # Ensure account_active_date is not before account_date
        if self.account_active_date < self.account_date:
            raise ValidationError('Active Date cannot be before Account Date.')
class Customer(models.Model):
    customer_id = models.CharField(max_length=20, primary_key=True)
    customer_name = models.CharField(max_length=30)
    customer_tel = models.CharField(max_length=20)
    customer_add = models.CharField(max_length=30)
    contact_name = models.CharField(max_length=30)
    contact_tel = models.CharField(max_length=20)
    contact_email = models.CharField(max_length=30)
    contact_relation = models.CharField(max_length=30)

class CustomerAndAccount(models.Model):
    account_id = models.ForeignKey(Account, on_delete=models.RESTRICT)
    customer_id = models.ForeignKey(Customer, on_delete=models.RESTRICT)

    class Meta:
        unique_together = (('account_id', 'customer_id'),)

class CustomerAndLoan(models.Model):
    customer_id = models.ForeignKey(Customer, on_delete=models.RESTRICT)
    loan_id = models.CharField(max_length=30)

    class Meta:
        unique_together = (('customer_id', 'loan_id'),)

class Loan(models.Model):
    loan_id = models.CharField(max_length=30, primary_key=True)
    loan_money = models.DecimalField(max_digits=15, decimal_places=2)
    loan_date = models.DateField()

class Payment(models.Model):
    payment_id = models.CharField(max_length=30, primary_key=True)
    loan_id = models.ForeignKey(Loan, on_delete=models.RESTRICT)
    payment_date = models.DateField()
    payment_money = models.DecimalField(max_digits=15, decimal_places=2)

class AccountLog(models.Model):
    log_id = models.BigAutoField(primary_key=True)
    account_id = models.ForeignKey(Account, on_delete=models.RESTRICT)
    log_date = models.DateField(auto_now_add=True)
    log_money = models.DecimalField(max_digits=15, decimal_places=2)
    log_type = models.CharField(max_length=30)
