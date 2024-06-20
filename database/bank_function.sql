-- 创建新账户
DELIMITER //

CREATE PROCEDURE createAccount (
    IN p_account_id VARCHAR(30),
    IN p_branch_name VARCHAR(30),
    IN p_account_money DECIMAL,
    IN p_account_date DATE,
    IN p_account_active_date DATE,
    IN p_is_cheque BOOLEAN,
    IN p_overdraft DECIMAL,
    IN p_rate FLOAT,
    OUT result VARCHAR(30)
)
BEGIN
    IF EXISTS (SELECT * FROM account WHERE account_id = p_account_id) THEN
        SET result = 'Account already exists';
    ELSE
        INSERT INTO account (account_id, BranchName, account_money, account_date, account_active_date, is_cheque, overdraft, rate) 
        VALUES (p_account_id, p_branch_name, p_account_money, p_account_date, p_account_active_date, p_is_cheque, p_overdraft, p_rate);
        SET result = 'Account created successfully';
    END IF;
END //
DELIMITER ;

-- 处理存款
-- DELIMITER //
-- CREATE PROCEDURE deposit (
--    IN p_account_id VARCHAR(30),
--    IN p_deposit DECIMAL,
--    OUT result VARCHAR(30)
-- )
-- BEGIN
--    DECLARE currency DECIMAL;
--    SELECT account_money INTO currency FROM account WHERE account_id = p_account_id;
--    IF currency IS NULL THEN
--        SET result = 'Account does not exist';
--    ELSE
--        SET currency = currency + p_deposit;
--        UPDATE account SET account_money = currency WHERE account_id = p_account_id;
--        SET result = 'Deposit successful';
--    END IF;
-- END //
-- DELIMITER ;

-- 用事务处理存款
DELIMITER //
CREATE PROCEDURE deposit (
    IN p_account_id VARCHAR(30),
    IN p_deposit DECIMAL,
    OUT result VARCHAR(30)
)
BEGIN
    DECLARE currency DECIMAL;
    DECLARE deposit_error BOOLEAN DEFAULT FALSE;
    DECLARE continue HANDLER FOR SQLEXCEPTION
    START TRANSACTION;
    SELECT account_money INTO currency FROM account WHERE account_id = p_account_id;
    IF currency IS NULL THEN
        SET result = 'Account does not exist';
        SET deposit_error = TRUE;
    ELSE
        SET currency = currency + p_deposit;
        UPDATE account SET account_money = currency WHERE account_id = p_account_id;
        SET result = 'Deposit successful';
    END IF;
    IF deposit_error THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //



-- 处理取款
-- DELIMITER //

-- CREATE PROCEDURE withdraw (
--    IN p_account_id VARCHAR(30),
--    IN p_withdraw DECIMAL,
--    OUT result VARCHAR(30)
-- )
-- BEGIN
--    DECLARE currency DECIMAL;
--    SELECT account_money INTO currency FROM account WHERE account_id = p_account_id;
--    IF currency IS NULL THEN
--        SET result = 'Account does not exist';
--    ELSE
--        IF currency < p_withdraw THEN
--            SET result = 'Insufficient funds';
--        ELSE
--            SET currency = currency - p_withdraw;
--            UPDATE account SET account_money = currency WHERE account_id = p_account_id;
--            SET result = 'Withdrawal successful';
--        END IF;
--    END IF;
-- END //
-- DELIMITER ;

-- 用事务处理取款
DELIMITER //
CREATE PROCEDURE withdraw (
    IN p_account_id VARCHAR(30),
    IN p_withdraw DECIMAL,
    OUT result VARCHAR(30)
)
BEGIN
    DECLARE currency DECIMAL;
    DECLARE withdraw_error BOOLEAN DEFAULT FALSE;
    DECLARE continue HANDLER FOR SQLEXCEPTION
    START TRANSACTION;
    SELECT account_money INTO currency FROM account WHERE account_id = p_account_id;
    IF currency IS NULL THEN
        SET result = 'Account does not exist';
        SET withdraw_error = TRUE;
    ELSE
        IF currency < p_withdraw THEN
            SET result = 'Insufficient funds';
            SET withdraw_error = TRUE;
        ELSE
            SET currency = currency - p_withdraw;
            UPDATE account SET account_money = currency WHERE account_id = p_account_id;
            SET result = 'Withdrawal successful';
        END IF;
    END IF;
    IF withdraw_error THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //

-- 事务：转账
DELIMITER //

CREATE PROCEDURE transferMoney (
    IN p_from_account VARCHAR(30),
    IN p_to_account VARCHAR(30),
    IN p_amount DECIMAL,
    OUT result VARCHAR(30)
)
BEGIN
    DECLARE trans_error BOOLEAN DEFAULT FALSE;
    DECLARE continue HANDLER FOR SQLEXCEPTION
    START TRANSACTION;
    IF NOT EXISTS (SELECT * FROM account WHERE account_id = p_from_account) THEN
        SET result = 'From account does not exist';
        SET trans_error = TRUE;
    ELSEIF NOT EXISTS (SELECT * FROM account WHERE account_id = p_to_account) THEN
        SET result = 'To account does not exist';
    ELSEIF (SELECT account_money FROM account WHERE account_id = p_from_account) < p_amount THEN
        SET result = 'Insufficient funds';
    ELSE
        UPDATE account SET account_money = account_money - p_amount WHERE account_id = p_from_account;
        UPDATE account SET account_money = account_money + p_amount WHERE account_id = p_to_account;
        SET result = 'Transfer successful';
    END IF;
    IF trans_error THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //
DELIMITER ;

-- 触发器：账户余额更新后更新账户状态
DELIMITER //
CREATE TRIGGER updateAccountStatus
AFTER UPDATE ON account
FOR EACH ROW
BEGIN
    UPDATE account SET account_active_date = CURRENT_TIMESTAMP WHERE account_id = NEW.account_id;
END //
DELIMITER ;
-- 函数：查询账户余额
DELIMITER //
CREATE FUNCTION getBalance (p_account_id VARCHAR(30)) RETURNS DECIMAL
READS SQL DATA
BEGIN
    DECLARE currency DECIMAL;
    SELECT account_money INTO currency FROM account WHERE account_id = p_account_id;
    RETURN currency;
END //
DELIMITER ;

-- 函数：查询账户是否支持透支
DELIMITER //
CREATE FUNCTION isOverdraft (p_account_id VARCHAR(30)) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE is_cheque BOOLEAN;
    SELECT is_cheque INTO is_cheque FROM account WHERE account_id = p_account_id;
    RETURN is_cheque;
END //
DELIMITER ;

-- 函数：查询账户透支额度
DELIMITER //
CREATE FUNCTION getOverdraft (p_account_id VARCHAR(30)) RETURNS DECIMAL
READS SQL DATA
BEGIN
    DECLARE overdraft DECIMAL;
    SELECT overdraft INTO overdraft FROM account WHERE account_id = p_account_id;
    RETURN overdraft;
END //
DELIMITER ;

-- 函数：查询账户利率
DELIMITER //
CREATE FUNCTION getRate (p_account_id VARCHAR(30)) RETURNS FLOAT
READS SQL DATA
BEGIN
    DECLARE rate FLOAT;
    SELECT rate INTO rate FROM account WHERE account_id = p_account_id;
    RETURN rate;
END //
DELIMITER ;

-- 删除账户
DELIMITER //
CREATE PROCEDURE deleteAccount (
    IN p_account_id VARCHAR(30),
    OUT result VARCHAR(30)
)
BEGIN
    IF NOT EXISTS (SELECT * FROM account WHERE account_id = p_account_id) THEN
        SET result = 'Account does not exist';
    ELSEIF (SELECT account_money FROM account WHERE account_id = p_account_id) > 0 THEN
        SET result = 'Account balance is not 0';
    ELSE
        DELETE FROM account WHERE account_id = p_account_id;
        DELETE FROM customer_and_account WHERE account_id = p_account_id;
        SET result = 'Account deleted successfully';
    END IF;
END //
DELIMITER ;

-- 添加客户
DELIMITER //
CREATE PROCEDURE addCustomer (
    IN p_customer_id CHAR(20),
    IN p_customer_name VARCHAR(30),
    IN p_customer_tel CHAR(20),
    IN p_customer_add VARCHAR(30),
    IN p_contact_name VARCHAR(30),
    IN p_contact_tel CHAR(20),
    IN p_contact_email VARCHAR(30),
    IN p_contact_relation VARCHAR(30),
    OUT result VARCHAR(30)
)
BEGIN
    IF EXISTS (SELECT * FROM customer WHERE customer_id = p_customer_id) THEN
        SET result = 'Customer already exists';
    ELSE
        INSERT INTO customer (customer_id, customer_name, customer_tel, customer_add, contact_name, contact_tel, contact_email, contact_relation) 
        VALUES (p_customer_id, p_customer_name, p_customer_tel, p_customer_add, p_contact_name, p_contact_tel, p_contact_email, p_contact_relation);
        SET result = 'Customer added successfully';
    END IF;
END //
DELIMITER ;

-- 贷款
DELIMITER //
CREATE PROCEDURE applyLoan (
    IN p_customer_id CHAR(20),
    IN p_loan_id CHAR(20),
    IN p_loan_amount DECIMAL,
    IN p_loan_date DATE,
    IN p_loan_rate FLOAT,
    OUT result VARCHAR(30)
)
BEGIN
    IF EXISTS (SELECT * FROM loan WHERE loan_id = p_loan_id) THEN
        SET result = 'Loan already exists';
    ELSE
        INSERT INTO loan (loan_id, customer_id, loan_amount, loan_date, loan_rate) 
        VALUES (p_loan_id, p_customer_id, p_loan_amount, p_loan_date, p_loan_rate);
        SET result = 'Loan applied successfully';
    END IF;
END //
DELIMITER ;

-- 贷款支付
DELIMITER //
CREATE PROCEDURE payLoan (
    IN p_customer_id CHAR(20),
    IN p_loan_id CHAR(20),
    IN p_payment DECIMAL,
    OUT result VARCHAR(30)
)
BEGIN
    DECLARE loan_amount DECIMAL;
    DECLARE paid_amount DECIMAL;
    SELECT loan_amount INTO loan_amount FROM loan WHERE loan_id = p_loan_id;
    SELECT SUM(payment_amount) INTO paid_amount FROM payment WHERE loan_id = p_loan_id;
    IF loan_amount IS NULL THEN
        SET result = 'Loan does not exist';
    ELSE
        IF loan_amount - paid_amount < p_payment THEN
            SET result = 'Payment exceeds loan amount';
        ELSE
            INSERT INTO payment (loan_id, payment_amount, payment_date) 
            VALUES (p_loan_id, p_payment, CURRENT_TIMESTAMP);
            SET result = 'Payment successful';
        END IF;
    END IF;
END //
DELIMITER ;

-- 账户日志
DELIMITER //

CREATE TRIGGER account_update_trigger
AFTER UPDATE ON account
FOR EACH ROW
BEGIN
    DECLARE action_type VARCHAR(30);
    DECLARE action_description TEXT;

    -- Determine the action type and description based on the update
    IF NEW.account_money < OLD.account_money THEN
        SET action_type = 'WITHDRAW';
        SET action_description = CONCAT('Withdrawn amount: ', OLD.account_money - NEW.account_money);
    ELSEIF NEW.account_money > OLD.account_money THEN
        SET action_type = 'DEPOSIT';
        SET action_description = CONCAT('Deposited amount: ', NEW.account_money - OLD.account_money);
    ELSE
        SET action_type = 'UPDATE';
        SET action_description = 'Account details updated without changing balance';
    END IF;

    -- Insert log into account_log table
    INSERT INTO account_log (account_id, log_money, log_type, description)
    VALUES (NEW.account_id, NEW.account_money, action_type, action_description);
END //

DELIMITER ;

-- Test
Insert into Branch values('branch1','city1',10000000);
Insert into account values('123456','branch1',1000,'2021-01-01','2021-01-01',1,100,0.01);
Insert into account values('123457','branch1',1000,'2021-01-01','2021-01-01',1,100,0.01);
Insert into account values('123458','branch1',1000,'2021-01-01','2021-01-01',1,100,0.01);
Call createAccount('123459','branch1',1000,'2021-01-01','2021-01-01',1,100,0.01,@result);
Call deposit('123456',100,@result);
Call withdraw('123456',100,@result);
Call transferMoney('123456','123457',100,@result);

