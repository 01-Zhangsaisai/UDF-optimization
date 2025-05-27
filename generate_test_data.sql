-- generate_test_data.sql
-- Скрипт для генерации тестовых данных

-- Удаляем старые данные (по необходимости)
DELETE FROM WorkItem;
DELETE FROM Works;
DELETE FROM Employee;
DELETE FROM Analiz;

-- Вставляем примеры сотрудников
INSERT INTO Employee (Login_Name, Name, Patronymic, Surname, Archived, IS_Role, Role)
VALUES 
('user1', 'John', 'Doe', 'Smith', 0, 1, 0),
('user2', 'Jane', 'A.', 'Doe', 0, 1, 0),
('user3', 'Emily', 'B.', 'White', 0, 1, 0);

-- Вставляем пример заказов
INSERT INTO Works (IS_Complit, CREATE_Date, MaterialNumber, Id_Employee, FIO, StatusId, Is_Del)
VALUES 
(0, GETDATE(), 10.00, 1, 'John Doe', 1, 0),
(1, GETDATE(), 20.00, 2, 'Jane Doe', 1, 0),
(0, GETDATE(), 30.00, 3, 'Emily White', 1, 0);

-- Вставляем пример элементов работы
INSERT INTO WorkItem (Create_Date, Is_Complit, Id_Employee, Id_Work)
VALUES 
(GETDATE(), 0, 1, 1),
(GETDATE(), 1, 1, 1),
(GETDATE(), 0, 2, 2);

-- Вставляем пример аналитических данных
INSERT INTO Analiz (IS_GROUP, MATERIAL_TYPE, CODE_NAME, FULL_NAME, ID_ILL, Price)
VALUES 
(0, 1, 'Analyze 1', 'Blood Test', NULL, 100.00),
(1, 2, 'Analyze 2', 'X-Ray', NULL, 200.00);

-- Вставляем заказ с удаленным статусом
INSERT INTO Works (IS_Complit, CREATE_Date, MaterialNumber, Id_Employee, FIO, StatusId, Is_Del)
VALUES 
(0, GETDATE(), 40.00, 1, 'John Doe', 1, 1);  -- Установлен статус удаления
