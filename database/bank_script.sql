/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2024/6/2 0:22:22                             */
/*==============================================================*/
DROP Database if exists bank;
CREATE Database bank;
use bank;

drop table if exists Branch;

drop table if exists account;

drop table if exists customer;

drop table if exists customer_and_account;

drop table if exists customer_and_loan;

drop table if exists loan;

drop table if exists payment;

drop table if exists account_log;

/*==============================================================*/
/* Table: Branch                                                */
/*==============================================================*/
create table Branch
(
   BranchName           varchar(30) not null,
   City                 varchar(30) not null,
   assets               decimal not null,
   primary key (BranchName)
);

/*==============================================================*/
/* Table: account                                               */
/*==============================================================*/
create table account
(
   account_id           varchar(30) not null,
   BranchName           varchar(30),
   account_money        decimal not null,
   account_date         date not null,
   account_active_date  date not null,
   is_cheque            boolean,
   overdraft            decimal,
   rate                 float,
   primary key (account_id)
);



/*==============================================================*/
/* Table: customer                                              */
/*==============================================================*/
create table customer
(
   customer¡¤_id         char(20) not null,
   customer_name        varchar(30) not null,
   customer_tel         char(20) not null,
   customer_add         varchar(30) not null,
   contact_name         varchar(30) not null,
   contact_tel          char(20) not null,
   contact_email        varchar(30) not null,
   contact_relation     varchar(30) not null,
   primary key (customer¡¤_id)
);

/*==============================================================*/
/* Table: customer_and_account                                  */
/*==============================================================*/
create table customer_and_account
(
   account_id           varchar(30) not null,
   customer¡¤_id         char(20) not null,
   primary key (account_id, customer¡¤_id)
);

/*==============================================================*/
/* Table: customer_and_loan                                     */
/*==============================================================*/
create table customer_and_loan
(
   customer¡¤_id         char(20) not null,
   loan_id              varchar(30) not null,
   primary key (customer¡¤_id, loan_id)
);


/*==============================================================*/
/* Table: loan                                                  */
/*==============================================================*/
create table loan
(
   loan_id              varchar(30) not null,
   loan_money           decimal not null,
   loan_date            date not null,
   primary key (loan_id)
);

/*==============================================================*/
/* Table: payment                                               */
/*==============================================================*/
create table payment
(
   payment_id           varchar(30) not null,
   loan_id              varchar(30),
   payment_date          date not null,
   payment_money        decimal not null,
   primary key (payment_id)
);
/*==============================================================*/
/* Table: account_log                                       */  
/*==============================================================*/
create table account_log
(
   log_id               BIGINT AUTO_INCREMENT,
   account_id           varchar(30) not null,
   log_date             date default (current_date),
   log_money            decimal not null,
   log_type             varchar(30) not null,
   primary key (log_id)
);

alter table account_log add constraint FK_account_and_log foreign key (account_id)
      references account (account_id) on delete restrict on update restrict;

alter table account add constraint FK_bank_and_account foreign key (BranchName)
      references Branch (BranchName) on delete restrict on update restrict;


alter table customer_and_account add constraint FK_7 foreign key (account_id)
      references account (account_id) on delete restrict on update restrict;

alter table customer_and_account add constraint FK_72 foreign key (customer¡¤_id)
      references customer (customer¡¤_id) on delete restrict on update restrict;

alter table customer_and_loan add constraint FK_8 foreign key (customer¡¤_id)
      references customer (customer¡¤_id) on delete restrict on update restrict;

alter table customer_and_loan add constraint FK_82 foreign key (loan_id)
      references loan (loan_id) on delete restrict on update restrict;


alter table payment add constraint FK_loan_and_payment foreign key (loan_id)
      references loan (loan_id) on delete restrict on update restrict;



