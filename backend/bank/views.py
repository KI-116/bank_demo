from django.contrib.auth import authenticate
from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from rest_framework.decorators import api_view
from .models import Branch, Account, Customer, CustomerAndAccount, CustomerAndLoan, Loan, Payment, AccountLog,PDFFile
from .serializers import BranchSerializer, AccountSerializer, CustomerSerializer, CustomerAndAccountSerializer, CustomerAndLoanSerializer, LoanSerializer, PaymentSerializer, AccountLogSerializer,TransferSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework import generics
from rest_framework.decorators import action
from django.http import JsonResponse,HttpResponse
from django.shortcuts import render,get_object_or_404
from django.views.decorators.http import require_POST
from django.core.exceptions import ValidationError
import json
from django.db.models import Sum
from django.views import View

class DownloadPDFView(View):
    def get(self, request, pk):
        pdf_file = get_object_or_404(PDFFile, pk=pk)
        with open(pdf_file.file.path, 'rb') as f:
            response = HttpResponse(f.read(), content_type='application/pdf')
            response['Content-Disposition'] = 'inline; filename=' + os.path.basename(pdf_file.file.name)
            return response

class BankTotalAssets(APIView):
    def get(self, request):
        total_assets = Branch.objects.aggregate(Sum('assets'))['assets__sum'] or 0.0
        return JsonResponse({'total_assets': total_assets})
class BranchViewSet(viewsets.ModelViewSet):
    queryset = Branch.objects.all()
    serializer_class = BranchSerializer

    @require_POST
    def add_branch(request):
        try:
            # 获取请求体中的数据
            data = json.loads(request.body)

            # 数据验证
            branch = Branch(**data)  # 创建分支对象
            branch.full_clean()  # 进行数据验证

            # 保存分支对象到数据库中
            branch.save()

            # 返回成功的响应
            return JsonResponse({'message': 'Branch added successfully'}, status=201)
        except Exception as e:
            # 如果出现异常，返回错误的响应
            return JsonResponse({'error': str(e)}, status=400)
class AccountViewSet(viewsets.ModelViewSet):
    queryset = Account.objects.all()
    serializer_class = AccountSerializer

    def update_balance(self, request, pk=None):
        account = self.get_object()
        deposit_amount = request.data.get('deposit_amount')
        if deposit_amount:
            account.account_money += float(deposit_amount)
            account.save()
            return Response(AccountSerializer(account).data, status=status.HTTP_200_OK)
        return Response({"error": "Deposit amount is required"}, status=status.HTTP_400_BAD_REQUEST)

    @require_POST
    def add_account(request):
        try:
            # 获取请求体中的数据
            data = json.loads(request.body)

            # 创建一个新的账户对象
            account = Account(
                account_id=data['account_id'],
                BranchName_id=data['BranchName'],  # Assuming BranchName is a ForeignKey
                account_money=data['account_money'],
                account_date=data['account_date'],
                account_active_date=data['account_active_date'],
                is_cheque=data.get('is_cheque', False),
                overdraft=data.get('overdraft', 0),
                rate=data.get('rate', 0)
            )

            # 进行数据验证
            account.full_clean()

            # 保存到数据库中
            account.save()

            # 返回成功的响应
            return JsonResponse({'message': 'Account added successfully'}, status=201)
        except Exception as e:
            # 捕获所有其他异常并返回错误信息
            return JsonResponse({'error': str(e)}, status=400)

class AccountDetail(generics.RetrieveAPIView):
    queryset = Account.objects.all()
    serializer_class = AccountSerializer
    lookup_field = 'account_id'
class CustomerViewSet(viewsets.ModelViewSet):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer

    def retrieve(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)
        except Customer.DoesNotExist:
            return Response({"error": "Customer ID does not exist"}, status=status.HTTP_404_NOT_FOUND)

class CustomerDetail(generics.RetrieveAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    lookup_field = 'customer_id'
class CustomerAndAccountViewSet(viewsets.ModelViewSet):
    queryset = CustomerAndAccount.objects.all()
    serializer_class = CustomerAndAccountSerializer

class CustomerAndLoanViewSet(viewsets.ModelViewSet):
    queryset = CustomerAndLoan.objects.all()
    serializer_class = CustomerAndLoanSerializer

class LoanViewSet(viewsets.ModelViewSet):
    queryset = Loan.objects.all()
    serializer_class = LoanSerializer

class PaymentViewSet(viewsets.ModelViewSet):
    queryset = Payment.objects.all()
    serializer_class = PaymentSerializer

class AccountLogViewSet(viewsets.ModelViewSet):
    queryset = AccountLog.objects.all()
    serializer_class = AccountLogSerializer

class TransferAPIView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = TransferSerializer(data=request.data)
        if serializer.is_valid():
            from_account_id = serializer.validated_data['from_account_id']
            to_account_id = serializer.validated_data['to_account_id']
            amount = serializer.validated_data['amount']

            try:
                from_account = Account.objects.get(account_id=from_account_id)
                to_account = Account.objects.get(account_id=to_account_id)
            except Account.DoesNotExist:
                return Response({'error': 'One or both accounts do not exist.'}, status=status.HTTP_404_NOT_FOUND)

            # Check if from_account has enough money
            if from_account.account_money >= amount:
                # Perform transfer
                from_account.account_money -= amount
                to_account.account_money += amount
                from_account.save()
                to_account.save()
                return Response({'message': 'Transfer successful.'}, status=status.HTTP_200_OK)
            else:
                return Response({'error': 'Insufficient funds.'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)