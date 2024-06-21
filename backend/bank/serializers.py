from rest_framework import serializers
from .models import Branch, Account, Customer, CustomerAndAccount, CustomerAndLoan, Loan, Payment, AccountLog

class BranchSerializer(serializers.ModelSerializer):
    class Meta:
        model = Branch
        fields = '__all__'

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = '__all__'

class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = '__all__'

class CustomerAndAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomerAndAccount
        fields = '__all__'

class CustomerAndLoanSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomerAndLoan
        fields = '__all__'

class LoanSerializer(serializers.ModelSerializer):
    class Meta:
        model = Loan
        fields = '__all__'

class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = '__all__'

class AccountLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = AccountLog
        fields = '__all__'

class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

class TransferSerializer(serializers.Serializer):
    from_account_id = serializers.CharField()
    to_account_id = serializers.CharField()
    amount = serializers.DecimalField(max_digits=15, decimal_places=2)