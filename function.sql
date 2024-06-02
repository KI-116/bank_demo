USE bank;

DELIMETER //
CREATE PROCEDURE createBranch(in branchName varchar(30), in branchCity varchar(30), in branchAssets decimal, out result int)
BEGIN
    declare branchExists int;
    select count(*) into branchExists from Branch where BranchName = branchName;
    if branchExists = 0 then
        insert into Branch values(branchName, branchCity, branchAssets);
        set result = 1;
    else
        set result = 0;
    end if;
END //