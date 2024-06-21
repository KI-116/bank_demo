from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (BranchViewSet, AccountViewSet, CustomerViewSet, CustomerAndAccountViewSet,
                    CustomerAndLoanViewSet, LoanViewSet, PaymentViewSet, AccountLogViewSet,
                    CustomerDetail,AccountDetail,TransferAPIView,DownloadPDFView)

router = DefaultRouter()
router.register(r'branches', BranchViewSet)
router.register(r'accounts', AccountViewSet)
router.register(r'customers', CustomerViewSet)
router.register(r'customer_accounts', CustomerAndAccountViewSet)
router.register(r'customer_loans', CustomerAndLoanViewSet)
router.register(r'loans', LoanViewSet)
router.register(r'payments', PaymentViewSet)
router.register(r'account_logs', AccountLogViewSet)
#router.register(r'', AccountLogViewSet)

urlpatterns = [
    path('', include(router.urls)),
    #path('api/transfer/', AccountViewSet.as_view({'post': 'transfer'})),
    #path('api/deposit/', AccountViewSet.as_view({'post': 'deposit'})),
    #path('api/withdraw/', AccountViewSet.as_view({'post': 'withdraw'})),
    #path('api/search_customer/', CustomerViewSet.as_view({'post': 'search'})),
    path('customers/<str:customer_id>/', CustomerDetail.as_view(), name='customer-detail'),
    path('accounts/<str:account_id>/', AccountDetail.as_view(), name='account-detail'),
    #path('api/accounts/<str:account_id>/deposit/', deposit_money, name='deposit-money'),
    path('accounts/<str:account_id>/update_balance/', AccountViewSet.as_view({'post': 'update_balance'})),
    path('accounts/transfer/', TransferAPIView.as_view(), name='account-transfer'),
    path('download-pdf/<int:pk>/', DownloadPDFView.as_view(), name='download_pdf'),

]
