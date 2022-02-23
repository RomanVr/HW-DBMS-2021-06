Поднять сервис db_va можно командой:

`docker-compose up otusdb`

Для подключения к БД используйте команду:

`docker-compose exec otusdb mysql -u root -p 12345 orderManSys`

Для использования в клиентских приложениях можно использовать команду:

`mysql -u root -p 12345 --port=3309 --protocol=tcp orderManSys`