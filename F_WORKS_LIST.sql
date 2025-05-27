-- F_WORKS_LIST.sql
CREATE FUNCTION [dbo].[F_WORKS_LIST] ()
RETURNS @RESULT TABLE
(
    ID_WORK INT,
    CREATE_Date DATETIME,
    MaterialNumber DECIMAL(8,2),
    IS_Complit BIT,
    FIO VARCHAR(255),
    D_DATE varchar(10),
    WorkItemsNotComplit int,
    WorkItemsComplit int,
    FULL_NAME VARCHAR(101),
    StatusId SMALLINT,
    StatusName VARCHAR(255),
    Is_Print BIT
)
AS
BEGIN
    WITH WorkItemsCount AS (
        SELECT 
            id_work, 
            SUM(CASE WHEN is_complit = 0 THEN 1 ELSE 0 END) AS WorkItemsNotComplit,
            SUM(CASE WHEN is_complit = 1 THEN 1 ELSE 0 END) AS WorkItemsComplit
        FROM workitem
        GROUP BY id_work
    ),
    EmployeeFullName AS (
        SELECT 
            id_employee, 
            SURNAME + ' ' + UPPER(SUBSTRING(NAME, 1, 1)) + '. ' +
            UPPER(SUBSTRING(PATRONYMIC, 1, 1)) + '.' AS FullName
        FROM Employee
    )
    INSERT INTO @RESULT
    SELECT 
        Works.Id_Work,
        Works.CREATE_Date,
        Works.MaterialNumber,
        Works.IS_Complit,
        Works.FIO,
        CONVERT(VARCHAR(10), Works.CREATE_Date, 104) AS D_DATE,
        COALESCE(WorkItemsCount.WorkItemsNotComplit, 0) AS WorkItemsNotComplit,
        COALESCE(WorkItemsCount.WorkItemsComplit, 0) AS WorkItemsComplit,
        COALESCE(EmployeeFullName.FullName, '') AS EmployeeFullName,
        Works.StatusId,
        WorkStatus.StatusName,
        CASE
            WHEN (Works.Print_Date IS NOT NULL) OR
                 (Works.SendToClientDate IS NOT NULL) OR
                 (Works.SendToDoctorDate IS NOT NULL) OR
                 (Works.SendToOrgDate IS NOT NULL) OR
                 (Works.SendToFax IS NOT NULL)
            THEN 1
            ELSE 0
        END AS Is_Print
    FROM Works
    LEFT JOIN WorkStatus ON Works.StatusId = WorkStatus.StatusID
    LEFT JOIN WorkItemsCount ON Works.Id_Work = WorkItemsCount.id_work
    LEFT JOIN EmployeeFullName ON Works.Id_Employee = EmployeeFullName.id_employee
    WHERE Works.IS_DEL <> 1
    ORDER BY Works.id_work DESC;
    
    RETURN;
END
GO
