
-- Проверка настройка паролей
SHOW VARIABLES LIKE 'validate_password%';

create user 'test_user'@'localhost' identified by 'Test12345!';

-- Перезагрузка прав
FLUSH PRIVILEGES;
