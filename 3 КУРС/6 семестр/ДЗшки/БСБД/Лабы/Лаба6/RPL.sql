/*
Порядок подсчета очков у команды:
За 1 матч команда может получить 3, 1 или 0 очков.
Победившая команда получает 3 очка, проигравшая 0 очков.
В случае ничьей каждая команда получает по 1 очку.

Для каждой команды вычисляется количество набранных очков за все сыгранные матчи в рамках чемпионата.
Победившая команда определяется по максимальному количеству очков.
*/

/*
use master
IF DB_ID (N'rpl') IS NOT NULL
DROP DATABASE rpl;

--ALTER DATABASE [rpl] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
*/

/*
CREATE DATABASE rpl;
ALTER AUTHORIZATION ON DATABASE::rpl TO [sa];
GO
*/

USE rpl;

/*
Типы событий
*/
CREATE TABLE event(
	event_id INTEGER IDENTITY NOT NULL PRIMARY KEY,
	description NVARCHAR(50),
)
;

/*
Места игры (города, стадионы)
*/
CREATE TABLE place(
	place_id INTEGER IDENTITY NOT NULL PRIMARY KEY,
	name NVARCHAR(50),
)
;

/*
Команды (название, домашний стадион)
*/
CREATE TABLE team(
	team_id INTEGER IDENTITY NOT NULL PRIMARY KEY,
	name NVARCHAR(50),
	home_place_id INTEGER NOT NULL,
	CONSTRAINT unique_team_name UNIQUE (name, home_place_id),
	CONSTRAINT foreign_place FOREIGN KEY(home_place_id) REFERENCES place(place_id)
)
;

/*
Матч (команды, дата и место проведения)
*/
CREATE TABLE game(
	game_id INTEGER IDENTITY NOT NULL PRIMARY KEY,
	team_id_1 INTEGER NOT NULL,
	team_id_2 INTEGER NOT NULL,
	place_id INTEGER NULL,
	game_date DATE NOT NULL,
	CONSTRAINT foreign_team_1 FOREIGN KEY(team_id_1) REFERENCES team(team_id),
	CONSTRAINT foreign_team_2 FOREIGN KEY(team_id_2) REFERENCES team(team_id),
	CONSTRAINT foreign_place_game FOREIGN KEY(place_id) REFERENCES place(place_id)
)
;

/*
Игровые события
Какое событие произошло, на какой игре, в отношении какой команды событие
*/
CREATE TABLE game_event(
	game_event_id INTEGER IDENTITY NOT NULL PRIMARY KEY,
	game_id INTEGER NOT NULL,
	team_id INTEGER NOT NULL,
	event_id INTEGER NOT NULL,
	CONSTRAINT foreign_game FOREIGN KEY(game_id) REFERENCES game(game_id),
	CONSTRAINT foreign_team_game_event FOREIGN KEY(team_id) REFERENCES team(team_id),
	CONSTRAINT foreign_event FOREIGN KEY(event_id) REFERENCES event(event_id)
)
;

SET IDENTITY_INSERT event ON;
insert into event (event_id, description) values (1, 'Свободный');
insert into event (event_id, description) values (2, 'Аут');
insert into event (event_id, description) values (3, 'Желтая карточка');
insert into event (event_id, description) values (4, 'Красная карточка');
insert into event (event_id, description) values (5, 'Пенальти');
insert into event (event_id, description) values (6, 'Гол');
SET IDENTITY_INSERT event OFF;

SET IDENTITY_INSERT place ON;
insert into place (place_id, name) values (1, 'Санкт-Петербург');
insert into place (place_id, name) values (2, 'Сочи');
insert into place (place_id, name) values (3, 'Динамо Москва');
insert into place (place_id, name) values (4, 'Краснодар');
insert into place (place_id, name) values (5, 'ПФК ЦСКА Москва');
insert into place (place_id, name) values (6, 'Локомотив Москва');
insert into place (place_id, name) values (7, 'Грозный');
insert into place (place_id, name) values (8, 'Крылья Советов');
insert into place (place_id, name) values (9, 'Ростов');
insert into place (place_id, name) values (10, 'Спартак Москва');
insert into place (place_id, name) values (11, 'Нижний Новгород');
insert into place (place_id, name) values (12, 'Урал');
insert into place (place_id, name) values (13, 'Химки');
insert into place (place_id, name) values (14, 'Уфа');
insert into place (place_id, name) values (15, 'Рубин Казань');
insert into place (place_id, name) values (16, 'Арсенал Тула');
SET IDENTITY_INSERT place OFF;

SET IDENTITY_INSERT team ON;
insert into team (team_id, name, home_place_id) values (1, 'Зенит', 1);
insert into team (team_id, name, home_place_id) values (2, 'Сочи', 2);
insert into team (team_id, name, home_place_id) values (3, 'Динамо', 3);
insert into team (team_id, name, home_place_id) values (4, 'Краснодар', 4);
insert into team (team_id, name, home_place_id) values (5, 'ПФК ЦСКА', 5);
insert into team (team_id, name, home_place_id) values (6, 'Локомотив Москва', 6);
insert into team (team_id, name, home_place_id) values (7, 'Ахмат', 7);
insert into team (team_id, name, home_place_id) values (8, 'Крылья Советов',8);
insert into team (team_id, name, home_place_id) values (9, 'ФК Ростов',9);
insert into team (team_id, name, home_place_id) values (10, 'Спартак Москва',10);
insert into team (team_id, name, home_place_id) values (11, 'Нижний Новгород',11);
insert into team (team_id, name, home_place_id) values (12, 'ФК Урал',12);
insert into team (team_id, name, home_place_id) values (13, 'Химки',13);
insert into team (team_id, name, home_place_id) values (14, 'Уфа',14);
insert into team (team_id, name, home_place_id) values (15, 'Рубин',15);
insert into team (team_id, name, home_place_id) values (16, 'Арсенал Тула',16);
SET IDENTITY_INSERT team OFF;

SET IDENTITY_INSERT game ON;
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (240, 16, 12, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (239, 3, 2, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (238, 4, 7, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (237, 8, 6, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (236, 11, 1, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (235, 15, 14, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (234, 13, 10, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (233, 5, 9, NULL, convert (date, '21.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (232, 4, 5, NULL, convert (date, '15.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (231, 10, 1, NULL, convert (date, '15.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (230, 12, 15, NULL, convert (date, '15.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (229, 7, 8, NULL, convert (date, '14.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (228, 6, 3, NULL, convert (date, '14.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (227, 9, 13, NULL, convert (date, '14.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (226, 14, 16, NULL, convert (date, '14.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (225, 2, 11, NULL, convert (date, '13.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (224, 6, 15, NULL, convert (date, '08.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (223, 16, 4, NULL, convert (date, '08.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (222, 14, 9, NULL, convert (date, '08.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (221, 5, 2, NULL, convert (date, '07.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (220, 1, 13, NULL, convert (date, '07.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (219, 11, 7, NULL, convert (date, '07.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (218, 12, 10, NULL, convert (date, '07.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (217, 8, 3, NULL, convert (date, '06.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (216, 4, 6, NULL, convert (date, '04.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (215, 16, 11, NULL, convert (date, '02.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (214, 7, 5, NULL, convert (date, '01.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (213, 13, 14, NULL, convert (date, '01.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (212, 10, 8, NULL, convert (date, '01.05.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (211, 1, 6, NULL, convert (date, '30.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (210, 4, 9, NULL, convert (date, '30.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (209, 3, 12, NULL, convert (date, '30.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (208, 15, 2, NULL, convert (date, '30.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (207, 4, 1, NULL, convert (date, '25.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (206, 5, 3, NULL, convert (date, '24.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (205, 9, 10, NULL, convert (date, '24.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (204, 15, 16, NULL, convert (date, '24.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (203, 13, 8, NULL, convert (date, '24.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (202, 2, 7, NULL, convert (date, '23.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (201, 6, 11, NULL, convert (date, '23.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (200, 12, 14, NULL, convert (date, '23.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (199, 11, 13, NULL, convert (date, '17.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (198, 8, 4, NULL, convert (date, '17.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (197, 2, 6, NULL, convert (date, '17.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (196, 16, 9, NULL, convert (date, '17.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (195, 10, 15, NULL, convert (date, '16.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (194, 1, 12, NULL, convert (date, '16.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (193, 14, 5, NULL, convert (date, '16.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (192, 3, 7, NULL, convert (date, '15.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (191, 9, 6, NULL, convert (date, '10.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (190, 10, 16, NULL, convert (date, '10.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (189, 14, 2, NULL, convert (date, '10.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (188, 12, 8, NULL, convert (date, '10.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (187, 7, 1, NULL, convert (date, '09.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (186, 15, 4, NULL, convert (date, '09.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (185, 11, 3, NULL, convert (date, '09.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (184, 13, 5, NULL, convert (date, '09.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (183, 9, 8, NULL, convert (date, '06.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (182, 2, 1, NULL, convert (date, '03.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (181, 5, 12, NULL, convert (date, '03.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (180, 4, 3, NULL, convert (date, '03.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (179, 6, 10, NULL, convert (date, '02.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (178, 9, 11, NULL, convert (date, '02.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (177, 16, 7, NULL, convert (date, '02.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (176, 8, 14, NULL, convert (date, '02.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (175, 15, 13, NULL, convert (date, '01.04.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (174, 3, 9, NULL, convert (date, '20.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (173, 2, 8, NULL, convert (date, '20.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (172, 14, 4, NULL, convert (date, '20.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (171, 5, 15, NULL, convert (date, '20.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (170, 1, 16, NULL, convert (date, '19.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (169, 7, 6, NULL, convert (date, '19.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (168, 11, 10, NULL, convert (date, '19.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (167, 12, 13, NULL, convert (date, '19.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (166, 15, 9, NULL, convert (date, '14.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (165, 10, 4, NULL, convert (date, '13.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (164, 8, 1, NULL, convert (date, '13.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (163, 13, 2, NULL, convert (date, '13.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (162, 12, 7, NULL, convert (date, '13.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (161, 6, 5, NULL, convert (date, '12.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (160, 16, 3, NULL, convert (date, '12.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (159, 14, 11, NULL, convert (date, '12.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (158, 7, 15, NULL, convert (date, '07.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (157, 1, 14, NULL, convert (date, '07.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (156, 9, 2, NULL, convert (date, '07.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (155, 4, 12, NULL, convert (date, '07.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (154, 3, 10, NULL, convert (date, '06.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (153, 8, 16, NULL, convert (date, '06.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (152, 6, 13, NULL, convert (date, '06.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (151, 5, 11, NULL, convert (date, '05.03.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (150, 1, 15, NULL, convert (date, '28.02.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (149, 7, 14, NULL, convert (date, '27.02.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (148, 10, 5, NULL, convert (date, '26.02.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (147, 2, 16, NULL, convert (date, '26.02.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (146, 11, 12, NULL, convert (date, '26.02.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (145, 13, 3, NULL, convert (date, '26.02.2022', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (144, 2, 10, NULL, convert (date, '13.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (143, 4, 11, NULL, convert (date, '12.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (142, 6, 14, NULL, convert (date, '12.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (141, 7, 13, NULL, convert (date, '12.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (140, 3, 1, NULL, convert (date, '12.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (139, 9, 12, NULL, convert (date, '11.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (138, 5, 16, NULL, convert (date, '11.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (137, 8, 15, NULL, convert (date, '11.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (136, 2, 4, NULL, convert (date, '05.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (135, 3, 14, NULL, convert (date, '05.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (134, 11, 15, NULL, convert (date, '05.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (133, 13, 16, NULL, convert (date, '05.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (132, 6, 12, NULL, convert (date, '04.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (131, 10, 7, NULL, convert (date, '04.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (130, 8, 5, NULL, convert (date, '04.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (129, 1, 9, NULL, convert (date, '03.12.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (128, 16, 6, NULL, convert (date, '29.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (127, 14, 10, NULL, convert (date, '29.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (126, 5, 1, NULL, convert (date, '28.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (125, 15, 3, NULL, convert (date, '28.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (124, 11, 8, NULL, convert (date, '28.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (123, 13, 4, NULL, convert (date, '27.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (122, 7, 9, NULL, convert (date, '27.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (121, 12, 2, NULL, convert (date, '27.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (120, 2, 15, NULL, convert (date, '21.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (119, 3, 16, NULL, convert (date, '21.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (118, 9, 14, NULL, convert (date, '21.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (117, 5, 13, NULL, convert (date, '21.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (116, 4, 10, NULL, convert (date, '20.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (115, 6, 7, NULL, convert (date, '20.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (114, 8, 12, NULL, convert (date, '20.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (113, 1, 11, NULL, convert (date, '19.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (112, 7, 11, NULL, convert (date, '07.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (111, 10, 6, NULL, convert (date, '07.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (110, 9, 15, NULL, convert (date, '07.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (109, 12, 1, NULL, convert (date, '07.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (108, 2, 5, NULL, convert (date, '06.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (107, 3, 4, NULL, convert (date, '06.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (106, 8, 13, NULL, convert (date, '06.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (105, 16, 14, NULL, convert (date, '06.11.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (104, 13, 12, NULL, convert (date, '31.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (103, 16, 2, NULL, convert (date, '31.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (102, 14, 7, NULL, convert (date, '31.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (101, 4, 8, NULL, convert (date, '30.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (100, 11, 6, NULL, convert (date, '30.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (99, 10, 9, NULL, convert (date, '30.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (98, 15, 5, NULL, convert (date, '30.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (97, 1, 3, NULL, convert (date, '29.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (96, 6, 2, NULL, convert (date, '25.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (95, 1, 10, NULL, convert (date, '24.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (94, 7, 12, NULL, convert (date, '24.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (93, 14, 15, NULL, convert (date, '24.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (92, 5, 8, NULL, convert (date, '23.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (91, 9, 16, NULL, convert (date, '23.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (90, 11, 4, NULL, convert (date, '23.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (89, 3, 13, NULL, convert (date, '22.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (88, 4, 14, NULL, convert (date, '17.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (87, 8, 11, NULL, convert (date, '17.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (86, 13, 7, NULL, convert (date, '17.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (85, 12, 5, NULL, convert (date, '17.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (84, 2, 9, NULL, convert (date, '16.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (83, 10, 3, NULL, convert (date, '16.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (82, 15, 6, NULL, convert (date, '16.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (81, 16, 1, NULL, convert (date, '16.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (80, 7, 10, NULL, convert (date, '03.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (79, 6, 9, NULL, convert (date, '03.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (78, 1, 2, NULL, convert (date, '03.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (77, 14, 12, NULL, convert (date, '03.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (76, 16, 13, NULL, convert (date, '02.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (75, 5, 4, NULL, convert (date, '02.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (74, 3, 8, NULL, convert (date, '02.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (73, 15, 11, NULL, convert (date, '02.10.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (72, 11, 5, NULL, convert (date, '27.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (71, 12, 16, NULL, convert (date, '27.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (70, 4, 2, NULL, convert (date, '26.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (69, 9, 7, NULL, convert (date, '26.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (68, 3, 15, NULL, convert (date, '26.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (67, 10, 14, NULL, convert (date, '25.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (66, 1, 8, NULL, convert (date, '25.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (65, 13, 6, NULL, convert (date, '25.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (64, 5, 10, NULL, convert (date, '20.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (63, 15, 1, NULL, convert (date, '20.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (62, 12, 6, NULL, convert (date, '20.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (61, 2, 3, NULL, convert (date, '19.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (60, 11, 16, NULL, convert (date, '19.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (59, 7, 4, NULL, convert (date, '18.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (58, 8, 9, NULL, convert (date, '18.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (57, 14, 13, NULL, convert (date, '18.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (56, 9, 4, NULL, convert (date, '13.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (55, 15, 12, NULL, convert (date, '13.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (54, 3, 11, NULL, convert (date, '12.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (53, 2, 14, NULL, convert (date, '12.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (52, 16, 5, NULL, convert (date, '12.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (51, 10, 13, NULL, convert (date, '11.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (50, 1, 7, NULL, convert (date, '11.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (49, 6, 8, NULL, convert (date, '11.09.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (48, 4, 15, NULL, convert (date, '27.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (47, 3, 6, NULL, convert (date, '27.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (46, 13, 11, NULL, convert (date, '27.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (45, 12, 9, NULL, convert (date, '27.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (44, 1, 5, NULL, convert (date, '26.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (43, 7, 16, NULL, convert (date, '26.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (42, 10, 2, NULL, convert (date, '26.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (41, 14, 8, NULL, convert (date, '26.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (40, 13, 15, NULL, convert (date, '22.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (39, 11, 9, NULL, convert (date, '22.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (38, 6, 4, NULL, convert (date, '22.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (37, 8, 2, NULL, convert (date, '21.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (36, 12, 3, NULL, convert (date, '21.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (35, 14, 1, NULL, convert (date, '21.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (34, 16, 10, NULL, convert (date, '21.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (33, 5, 7, NULL, convert (date, '21.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (32, 2, 13, NULL, convert (date, '16.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (31, 4, 16, NULL, convert (date, '15.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (30, 15, 8, NULL, convert (date, '15.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (29, 6, 1, NULL, convert (date, '15.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (28, 7, 3, NULL, convert (date, '14.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (27, 9, 5, NULL, convert (date, '14.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (26, 11, 14, NULL, convert (date, '14.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (25, 10, 12, NULL, convert (date, '14.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (24, 2, 12, NULL, convert (date, '09.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (23, 3, 5, NULL, convert (date, '08.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (22, 15, 7, NULL, convert (date, '08.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (21, 13, 9, NULL, convert (date, '08.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (20, 10, 11, NULL, convert (date, '07.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (19, 16, 8, NULL, convert (date, '07.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (18, 1, 4, NULL, convert (date, '07.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (17, 14, 6, NULL, convert (date, '06.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (16, 7, 2, NULL, convert (date, '02.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (15, 4, 13, NULL, convert (date, '01.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (14, 9, 1, NULL, convert (date, '01.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (13, 12, 11, NULL, convert (date, '01.08.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (12, 5, 6, NULL, convert (date, '31.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (11, 14, 3, NULL, convert (date, '31.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (10, 16, 15, NULL, convert (date, '30.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (9, 8, 10, NULL, convert (date, '30.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (8, 11, 2, NULL, convert (date, '26.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (7, 5, 14, NULL, convert (date, '25.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (6, 8, 7, NULL, convert (date, '25.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (5, 12, 4, NULL, convert (date, '25.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (4, 6, 16, NULL, convert (date, '24.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (3, 15, 10, NULL, convert (date, '24.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (2, 13, 1, NULL, convert (date, '24.07.2021', 104));
insert into game (game_id, team_id_1, team_id_2, place_id, game_date) values (1, 9, 3, NULL, convert (date, '23.07.2021', 104));
SET IDENTITY_INSERT game OFF;


insert into game_event (game_id, team_id, event_id) values (240, 16, 6);	insert into game_event (game_id, team_id, event_id) values (240, 12, 6), (240, 12, 6);
insert into game_event (game_id, team_id, event_id) values (239, 3, 6);	insert into game_event (game_id, team_id, event_id) values (239, 2, 6), (239, 2, 6), (239, 2, 6), (239, 2, 6), (239, 2, 6);
insert into game_event (game_id, team_id, event_id) values (238, 4, 6);	insert into game_event (game_id, team_id, event_id) values (238, 7, 6);
	insert into game_event (game_id, team_id, event_id) values (237, 6, 6);
insert into game_event (game_id, team_id, event_id) values (236, 11, 6);	
insert into game_event (game_id, team_id, event_id) values (235, 15, 6);	insert into game_event (game_id, team_id, event_id) values (235, 14, 6), (235, 14, 6);
insert into game_event (game_id, team_id, event_id) values (234, 13, 6), (234, 13, 6);	insert into game_event (game_id, team_id, event_id) values (234, 10, 6);
insert into game_event (game_id, team_id, event_id) values (233, 5, 6), (233, 5, 6), (233, 5, 6), (233, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (232, 4, 6);	
insert into game_event (game_id, team_id, event_id) values (231, 10, 6);	insert into game_event (game_id, team_id, event_id) values (231, 1, 6);
insert into game_event (game_id, team_id, event_id) values (230, 12, 6), (230, 12, 6), (230, 12, 6);	
insert into game_event (game_id, team_id, event_id) values (229, 7, 6);	
insert into game_event (game_id, team_id, event_id) values (228, 6, 6), (228, 6, 6), (228, 6, 6);	insert into game_event (game_id, team_id, event_id) values (228, 3, 6), (228, 3, 6), (228, 3, 6);
insert into game_event (game_id, team_id, event_id) values (227, 9, 6), (227, 9, 6);	insert into game_event (game_id, team_id, event_id) values (227, 13, 6);
insert into game_event (game_id, team_id, event_id) values (226, 14, 6), (226, 14, 6);	insert into game_event (game_id, team_id, event_id) values (226, 16, 6);
	
insert into game_event (game_id, team_id, event_id) values (224, 6, 6);	
insert into game_event (game_id, team_id, event_id) values (223, 16, 6);	insert into game_event (game_id, team_id, event_id) values (223, 4, 6);
	
	insert into game_event (game_id, team_id, event_id) values (221, 2, 6);
insert into game_event (game_id, team_id, event_id) values (220, 1, 6);	
	insert into game_event (game_id, team_id, event_id) values (219, 7, 6);
insert into game_event (game_id, team_id, event_id) values (218, 12, 6);	insert into game_event (game_id, team_id, event_id) values (218, 10, 6), (218, 10, 6), (218, 10, 6);
insert into game_event (game_id, team_id, event_id) values (217, 8, 6), (217, 8, 6), (217, 8, 6), (217, 8, 6), (217, 8, 6);	insert into game_event (game_id, team_id, event_id) values (217, 3, 6), (217, 3, 6);
insert into game_event (game_id, team_id, event_id) values (216, 4, 6);	
insert into game_event (game_id, team_id, event_id) values (215, 16, 6), (215, 16, 6);	insert into game_event (game_id, team_id, event_id) values (215, 11, 6), (215, 11, 6);
insert into game_event (game_id, team_id, event_id) values (214, 7, 6), (214, 7, 6);	
insert into game_event (game_id, team_id, event_id) values (213, 13, 6);	insert into game_event (game_id, team_id, event_id) values (213, 14, 6);
insert into game_event (game_id, team_id, event_id) values (212, 10, 6), (212, 10, 6);	insert into game_event (game_id, team_id, event_id) values (212, 8, 6);
insert into game_event (game_id, team_id, event_id) values (211, 1, 6), (211, 1, 6), (211, 1, 6);	insert into game_event (game_id, team_id, event_id) values (211, 6, 6);
insert into game_event (game_id, team_id, event_id) values (210, 4, 6), (210, 4, 6);	insert into game_event (game_id, team_id, event_id) values (210, 9, 6);
insert into game_event (game_id, team_id, event_id) values (209, 3, 6), (209, 3, 6);	insert into game_event (game_id, team_id, event_id) values (209, 12, 6), (209, 12, 6), (209, 12, 6);
	insert into game_event (game_id, team_id, event_id) values (208, 2, 6), (208, 2, 6), (208, 2, 6), (208, 2, 6), (208, 2, 6), (208, 2, 6);
insert into game_event (game_id, team_id, event_id) values (207, 4, 6);	insert into game_event (game_id, team_id, event_id) values (207, 1, 6), (207, 1, 6), (207, 1, 6);
insert into game_event (game_id, team_id, event_id) values (206, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (205, 9, 6), (205, 9, 6), (205, 9, 6);	insert into game_event (game_id, team_id, event_id) values (205, 10, 6), (205, 10, 6);
insert into game_event (game_id, team_id, event_id) values (204, 15, 6);	
insert into game_event (game_id, team_id, event_id) values (203, 13, 6), (203, 13, 6), (203, 13, 6), (203, 13, 6);	insert into game_event (game_id, team_id, event_id) values (203, 8, 6);
insert into game_event (game_id, team_id, event_id) values (202, 2, 6), (202, 2, 6), (202, 2, 6);	insert into game_event (game_id, team_id, event_id) values (202, 7, 6), (202, 7, 6);
insert into game_event (game_id, team_id, event_id) values (201, 6, 6), (201, 6, 6);	insert into game_event (game_id, team_id, event_id) values (201, 11, 6);
insert into game_event (game_id, team_id, event_id) values (200, 12, 6), (200, 12, 6);	insert into game_event (game_id, team_id, event_id) values (200, 14, 6);
	
insert into game_event (game_id, team_id, event_id) values (198, 8, 6), (198, 8, 6);	
insert into game_event (game_id, team_id, event_id) values (197, 2, 6), (197, 2, 6);	insert into game_event (game_id, team_id, event_id) values (197, 6, 6), (197, 6, 6);
insert into game_event (game_id, team_id, event_id) values (196, 16, 6);	insert into game_event (game_id, team_id, event_id) values (196, 9, 6), (196, 9, 6);
insert into game_event (game_id, team_id, event_id) values (195, 10, 6);	insert into game_event (game_id, team_id, event_id) values (195, 15, 6);
insert into game_event (game_id, team_id, event_id) values (194, 1, 6), (194, 1, 6), (194, 1, 6);	insert into game_event (game_id, team_id, event_id) values (194, 12, 6);
insert into game_event (game_id, team_id, event_id) values (193, 14, 6);	insert into game_event (game_id, team_id, event_id) values (193, 5, 6);
insert into game_event (game_id, team_id, event_id) values (192, 3, 6), (192, 3, 6);	
insert into game_event (game_id, team_id, event_id) values (191, 9, 6), (191, 9, 6), (191, 9, 6), (191, 9, 6);	insert into game_event (game_id, team_id, event_id) values (191, 6, 6);
insert into game_event (game_id, team_id, event_id) values (190, 10, 6), (190, 10, 6), (190, 10, 6);	
insert into game_event (game_id, team_id, event_id) values (189, 14, 6);	insert into game_event (game_id, team_id, event_id) values (189, 2, 6), (189, 2, 6);
	insert into game_event (game_id, team_id, event_id) values (188, 8, 6);
	insert into game_event (game_id, team_id, event_id) values (187, 1, 6), (187, 1, 6);
	insert into game_event (game_id, team_id, event_id) values (186, 4, 6);
	insert into game_event (game_id, team_id, event_id) values (185, 3, 6);
insert into game_event (game_id, team_id, event_id) values (184, 13, 6), (184, 13, 6), (184, 13, 6), (184, 13, 6);	insert into game_event (game_id, team_id, event_id) values (184, 5, 6), (184, 5, 6);
insert into game_event (game_id, team_id, event_id) values (183, 9, 6);	
	
insert into game_event (game_id, team_id, event_id) values (181, 5, 6), (181, 5, 6);	insert into game_event (game_id, team_id, event_id) values (181, 12, 6), (181, 12, 6);
	insert into game_event (game_id, team_id, event_id) values (180, 3, 6);
insert into game_event (game_id, team_id, event_id) values (179, 6, 6);	
insert into game_event (game_id, team_id, event_id) values (178, 9, 6);	insert into game_event (game_id, team_id, event_id) values (178, 11, 6), (178, 11, 6);
	
insert into game_event (game_id, team_id, event_id) values (176, 8, 6);	insert into game_event (game_id, team_id, event_id) values (176, 14, 6), (176, 14, 6);
insert into game_event (game_id, team_id, event_id) values (175, 15, 6), (175, 15, 6);	insert into game_event (game_id, team_id, event_id) values (175, 13, 6), (175, 13, 6), (175, 13, 6);
insert into game_event (game_id, team_id, event_id) values (174, 3, 6);	insert into game_event (game_id, team_id, event_id) values (174, 9, 6);
insert into game_event (game_id, team_id, event_id) values (173, 2, 6), (173, 2, 6);	insert into game_event (game_id, team_id, event_id) values (173, 8, 6), (173, 8, 6), (173, 8, 6);
insert into game_event (game_id, team_id, event_id) values (172, 14, 6);	insert into game_event (game_id, team_id, event_id) values (172, 4, 6);
insert into game_event (game_id, team_id, event_id) values (171, 5, 6), (171, 5, 6), (171, 5, 6), (171, 5, 6), (171, 5, 6), (171, 5, 6);	insert into game_event (game_id, team_id, event_id) values (171, 15, 6);
insert into game_event (game_id, team_id, event_id) values (170, 1, 6), (170, 1, 6), (170, 1, 6);	
insert into game_event (game_id, team_id, event_id) values (169, 7, 6), (169, 7, 6);	insert into game_event (game_id, team_id, event_id) values (169, 6, 6), (169, 6, 6), (169, 6, 6);
insert into game_event (game_id, team_id, event_id) values (168, 11, 6);	insert into game_event (game_id, team_id, event_id) values (168, 10, 6);
	insert into game_event (game_id, team_id, event_id) values (167, 13, 6);
insert into game_event (game_id, team_id, event_id) values (166, 15, 6);	insert into game_event (game_id, team_id, event_id) values (166, 9, 6), (166, 9, 6);
insert into game_event (game_id, team_id, event_id) values (165, 10, 6);	insert into game_event (game_id, team_id, event_id) values (165, 4, 6), (165, 4, 6);
insert into game_event (game_id, team_id, event_id) values (164, 8, 6);	insert into game_event (game_id, team_id, event_id) values (164, 1, 6);
	
	
insert into game_event (game_id, team_id, event_id) values (161, 6, 6);	insert into game_event (game_id, team_id, event_id) values (161, 5, 6), (161, 5, 6);
insert into game_event (game_id, team_id, event_id) values (160, 16, 6);	insert into game_event (game_id, team_id, event_id) values (160, 3, 6), (160, 3, 6), (160, 3, 6), (160, 3, 6);
	
insert into game_event (game_id, team_id, event_id) values (158, 7, 6);	insert into game_event (game_id, team_id, event_id) values (158, 15, 6), (158, 15, 6);
insert into game_event (game_id, team_id, event_id) values (157, 1, 6), (157, 1, 6);	
	insert into game_event (game_id, team_id, event_id) values (156, 2, 6);
insert into game_event (game_id, team_id, event_id) values (155, 4, 6), (155, 4, 6);	insert into game_event (game_id, team_id, event_id) values (155, 12, 6);
	insert into game_event (game_id, team_id, event_id) values (154, 10, 6), (154, 10, 6);
insert into game_event (game_id, team_id, event_id) values (153, 8, 6), (153, 8, 6);	insert into game_event (game_id, team_id, event_id) values (153, 16, 6), (153, 16, 6);
insert into game_event (game_id, team_id, event_id) values (152, 6, 6), (152, 6, 6), (152, 6, 6);	insert into game_event (game_id, team_id, event_id) values (152, 13, 6), (152, 13, 6);
insert into game_event (game_id, team_id, event_id) values (151, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (150, 1, 6), (150, 1, 6), (150, 1, 6);	insert into game_event (game_id, team_id, event_id) values (150, 15, 6), (150, 15, 6);
insert into game_event (game_id, team_id, event_id) values (149, 7, 6), (149, 7, 6);	insert into game_event (game_id, team_id, event_id) values (149, 14, 6);
	insert into game_event (game_id, team_id, event_id) values (148, 5, 6), (148, 5, 6);
insert into game_event (game_id, team_id, event_id) values (147, 2, 6), (147, 2, 6);	
insert into game_event (game_id, team_id, event_id) values (146, 11, 6);	
	insert into game_event (game_id, team_id, event_id) values (145, 3, 6), (145, 3, 6), (145, 3, 6);
insert into game_event (game_id, team_id, event_id) values (144, 2, 6), (144, 2, 6), (144, 2, 6);	
	
insert into game_event (game_id, team_id, event_id) values (142, 6, 6), (142, 6, 6);	
insert into game_event (game_id, team_id, event_id) values (141, 7, 6), (141, 7, 6), (141, 7, 6), (141, 7, 6);	insert into game_event (game_id, team_id, event_id) values (141, 13, 6);
insert into game_event (game_id, team_id, event_id) values (140, 3, 6);	insert into game_event (game_id, team_id, event_id) values (140, 1, 6);
insert into game_event (game_id, team_id, event_id) values (139, 9, 6);	insert into game_event (game_id, team_id, event_id) values (139, 12, 6), (139, 12, 6), (139, 12, 6), (139, 12, 6);
insert into game_event (game_id, team_id, event_id) values (138, 5, 6), (138, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (137, 8, 6), (137, 8, 6);	
insert into game_event (game_id, team_id, event_id) values (136, 2, 6);	insert into game_event (game_id, team_id, event_id) values (136, 4, 6), (136, 4, 6);
insert into game_event (game_id, team_id, event_id) values (135, 3, 6), (135, 3, 6);	
insert into game_event (game_id, team_id, event_id) values (134, 11, 6), (134, 11, 6);	insert into game_event (game_id, team_id, event_id) values (134, 15, 6);
insert into game_event (game_id, team_id, event_id) values (133, 13, 6);	insert into game_event (game_id, team_id, event_id) values (133, 16, 6), (133, 16, 6);
	insert into game_event (game_id, team_id, event_id) values (132, 12, 6);
insert into game_event (game_id, team_id, event_id) values (131, 10, 6), (131, 10, 6);	insert into game_event (game_id, team_id, event_id) values (131, 7, 6);
	insert into game_event (game_id, team_id, event_id) values (130, 5, 6);
insert into game_event (game_id, team_id, event_id) values (129, 1, 6), (129, 1, 6);	insert into game_event (game_id, team_id, event_id) values (129, 9, 6), (129, 9, 6);
insert into game_event (game_id, team_id, event_id) values (128, 16, 6), (128, 16, 6), (128, 16, 6);	insert into game_event (game_id, team_id, event_id) values (128, 6, 6);
insert into game_event (game_id, team_id, event_id) values (127, 14, 6);	insert into game_event (game_id, team_id, event_id) values (127, 10, 6);
	insert into game_event (game_id, team_id, event_id) values (126, 1, 6), (126, 1, 6);
insert into game_event (game_id, team_id, event_id) values (125, 15, 6), (125, 15, 6);	insert into game_event (game_id, team_id, event_id) values (125, 3, 6), (125, 3, 6), (125, 3, 6);
	
insert into game_event (game_id, team_id, event_id) values (123, 13, 6), (123, 13, 6), (123, 13, 6);	insert into game_event (game_id, team_id, event_id) values (123, 4, 6), (123, 4, 6), (123, 4, 6);
insert into game_event (game_id, team_id, event_id) values (122, 7, 6), (122, 7, 6);	
insert into game_event (game_id, team_id, event_id) values (121, 12, 6);	insert into game_event (game_id, team_id, event_id) values (121, 2, 6);
insert into game_event (game_id, team_id, event_id) values (120, 2, 6);	insert into game_event (game_id, team_id, event_id) values (120, 15, 6), (120, 15, 6);
insert into game_event (game_id, team_id, event_id) values (119, 3, 6), (119, 3, 6), (119, 3, 6), (119, 3, 6), (119, 3, 6);	insert into game_event (game_id, team_id, event_id) values (119, 16, 6);
insert into game_event (game_id, team_id, event_id) values (118, 9, 6), (118, 9, 6);	insert into game_event (game_id, team_id, event_id) values (118, 14, 6), (118, 14, 6);
	
insert into game_event (game_id, team_id, event_id) values (116, 4, 6), (116, 4, 6);	insert into game_event (game_id, team_id, event_id) values (116, 10, 6);
insert into game_event (game_id, team_id, event_id) values (115, 6, 6);	insert into game_event (game_id, team_id, event_id) values (115, 7, 6), (115, 7, 6);
insert into game_event (game_id, team_id, event_id) values (114, 8, 6);	insert into game_event (game_id, team_id, event_id) values (114, 12, 6);
insert into game_event (game_id, team_id, event_id) values (113, 1, 6), (113, 1, 6), (113, 1, 6), (113, 1, 6), (113, 1, 6);	insert into game_event (game_id, team_id, event_id) values (113, 11, 6);
insert into game_event (game_id, team_id, event_id) values (112, 7, 6), (112, 7, 6), (112, 7, 6);	insert into game_event (game_id, team_id, event_id) values (112, 11, 6);
insert into game_event (game_id, team_id, event_id) values (111, 10, 6);	insert into game_event (game_id, team_id, event_id) values (111, 6, 6);
insert into game_event (game_id, team_id, event_id) values (110, 9, 6), (110, 9, 6), (110, 9, 6), (110, 9, 6), (110, 9, 6);	insert into game_event (game_id, team_id, event_id) values (110, 15, 6);
	
insert into game_event (game_id, team_id, event_id) values (108, 2, 6), (108, 2, 6), (108, 2, 6), (108, 2, 6);	insert into game_event (game_id, team_id, event_id) values (108, 5, 6);
insert into game_event (game_id, team_id, event_id) values (107, 3, 6);	
insert into game_event (game_id, team_id, event_id) values (106, 8, 6), (106, 8, 6), (106, 8, 6);	
	
	
insert into game_event (game_id, team_id, event_id) values (103, 16, 6);	insert into game_event (game_id, team_id, event_id) values (103, 2, 6), (103, 2, 6);
insert into game_event (game_id, team_id, event_id) values (102, 14, 6);	
	insert into game_event (game_id, team_id, event_id) values (101, 8, 6);
insert into game_event (game_id, team_id, event_id) values (100, 11, 6);	insert into game_event (game_id, team_id, event_id) values (100, 6, 6), (100, 6, 6);
insert into game_event (game_id, team_id, event_id) values (99, 10, 6);	insert into game_event (game_id, team_id, event_id) values (99, 9, 6);
insert into game_event (game_id, team_id, event_id) values (98, 15, 6);	
insert into game_event (game_id, team_id, event_id) values (97, 1, 6), (97, 1, 6), (97, 1, 6), (97, 1, 6);	insert into game_event (game_id, team_id, event_id) values (97, 3, 6);
insert into game_event (game_id, team_id, event_id) values (96, 6, 6), (96, 6, 6);	insert into game_event (game_id, team_id, event_id) values (96, 2, 6);
insert into game_event (game_id, team_id, event_id) values (95, 1, 6), (95, 1, 6), (95, 1, 6), (95, 1, 6), (95, 1, 6), (95, 1, 6), (95, 1, 6);	insert into game_event (game_id, team_id, event_id) values (95, 10, 6);
insert into game_event (game_id, team_id, event_id) values (94, 7, 6);	
insert into game_event (game_id, team_id, event_id) values (93, 14, 6);	insert into game_event (game_id, team_id, event_id) values (93, 15, 6);
insert into game_event (game_id, team_id, event_id) values (92, 5, 6), (92, 5, 6), (92, 5, 6);	insert into game_event (game_id, team_id, event_id) values (92, 8, 6);
insert into game_event (game_id, team_id, event_id) values (91, 9, 6), (91, 9, 6), (91, 9, 6), (91, 9, 6);	
insert into game_event (game_id, team_id, event_id) values (90, 11, 6);	insert into game_event (game_id, team_id, event_id) values (90, 4, 6), (90, 4, 6), (90, 4, 6), (90, 4, 6);
insert into game_event (game_id, team_id, event_id) values (89, 3, 6), (89, 3, 6), (89, 3, 6), (89, 3, 6);	insert into game_event (game_id, team_id, event_id) values (89, 13, 6);
insert into game_event (game_id, team_id, event_id) values (88, 4, 6);	insert into game_event (game_id, team_id, event_id) values (88, 14, 6);
insert into game_event (game_id, team_id, event_id) values (87, 8, 6), (87, 8, 6);	
insert into game_event (game_id, team_id, event_id) values (86, 13, 6), (86, 13, 6);	
	insert into game_event (game_id, team_id, event_id) values (85, 5, 6);
insert into game_event (game_id, team_id, event_id) values (84, 2, 6), (84, 2, 6), (84, 2, 6);	insert into game_event (game_id, team_id, event_id) values (84, 9, 6), (84, 9, 6);
insert into game_event (game_id, team_id, event_id) values (83, 10, 6), (83, 10, 6);	insert into game_event (game_id, team_id, event_id) values (83, 3, 6), (83, 3, 6);
insert into game_event (game_id, team_id, event_id) values (82, 15, 6), (82, 15, 6);	insert into game_event (game_id, team_id, event_id) values (82, 6, 6), (82, 6, 6);
insert into game_event (game_id, team_id, event_id) values (81, 16, 6), (81, 16, 6);	insert into game_event (game_id, team_id, event_id) values (81, 1, 6);
	insert into game_event (game_id, team_id, event_id) values (80, 10, 6);
insert into game_event (game_id, team_id, event_id) values (79, 6, 6);	insert into game_event (game_id, team_id, event_id) values (79, 9, 6), (79, 9, 6);
insert into game_event (game_id, team_id, event_id) values (78, 1, 6);	insert into game_event (game_id, team_id, event_id) values (78, 2, 6), (78, 2, 6);
	insert into game_event (game_id, team_id, event_id) values (77, 12, 6);
	
	
	insert into game_event (game_id, team_id, event_id) values (74, 8, 6);
	insert into game_event (game_id, team_id, event_id) values (73, 11, 6);
	insert into game_event (game_id, team_id, event_id) values (72, 5, 6), (72, 5, 6);
insert into game_event (game_id, team_id, event_id) values (71, 12, 6), (71, 12, 6);	
insert into game_event (game_id, team_id, event_id) values (70, 4, 6), (70, 4, 6), (70, 4, 6);	
insert into game_event (game_id, team_id, event_id) values (69, 9, 6);	insert into game_event (game_id, team_id, event_id) values (69, 7, 6), (69, 7, 6);
insert into game_event (game_id, team_id, event_id) values (68, 3, 6), (68, 3, 6);	
insert into game_event (game_id, team_id, event_id) values (67, 10, 6), (67, 10, 6);	
insert into game_event (game_id, team_id, event_id) values (66, 1, 6), (66, 1, 6);	insert into game_event (game_id, team_id, event_id) values (66, 8, 6);
	
insert into game_event (game_id, team_id, event_id) values (64, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (63, 15, 6);	insert into game_event (game_id, team_id, event_id) values (63, 1, 6), (63, 1, 6), (63, 1, 6);
	
	insert into game_event (game_id, team_id, event_id) values (61, 3, 6);
insert into game_event (game_id, team_id, event_id) values (60, 11, 6), (60, 11, 6);	insert into game_event (game_id, team_id, event_id) values (60, 16, 6), (60, 16, 6), (60, 16, 6);
	insert into game_event (game_id, team_id, event_id) values (59, 4, 6), (59, 4, 6);
insert into game_event (game_id, team_id, event_id) values (58, 8, 6), (58, 8, 6), (58, 8, 6), (58, 8, 6);	insert into game_event (game_id, team_id, event_id) values (58, 9, 6), (58, 9, 6);
insert into game_event (game_id, team_id, event_id) values (57, 14, 6), (57, 14, 6), (57, 14, 6);	insert into game_event (game_id, team_id, event_id) values (57, 13, 6), (57, 13, 6);
insert into game_event (game_id, team_id, event_id) values (56, 9, 6);	insert into game_event (game_id, team_id, event_id) values (56, 4, 6);
insert into game_event (game_id, team_id, event_id) values (55, 15, 6), (55, 15, 6), (55, 15, 6), (55, 15, 6);	
insert into game_event (game_id, team_id, event_id) values (54, 3, 6);	insert into game_event (game_id, team_id, event_id) values (54, 11, 6), (54, 11, 6);
insert into game_event (game_id, team_id, event_id) values (53, 2, 6), (53, 2, 6), (53, 2, 6);	insert into game_event (game_id, team_id, event_id) values (53, 14, 6);
insert into game_event (game_id, team_id, event_id) values (52, 16, 6), (52, 16, 6);	insert into game_event (game_id, team_id, event_id) values (52, 5, 6), (52, 5, 6);
insert into game_event (game_id, team_id, event_id) values (51, 10, 6), (51, 10, 6), (51, 10, 6);	insert into game_event (game_id, team_id, event_id) values (51, 13, 6);
insert into game_event (game_id, team_id, event_id) values (50, 1, 6), (50, 1, 6), (50, 1, 6);	insert into game_event (game_id, team_id, event_id) values (50, 7, 6);
insert into game_event (game_id, team_id, event_id) values (49, 6, 6), (49, 6, 6);	
insert into game_event (game_id, team_id, event_id) values (48, 4, 6), (48, 4, 6);	
insert into game_event (game_id, team_id, event_id) values (47, 3, 6);	insert into game_event (game_id, team_id, event_id) values (47, 6, 6);
insert into game_event (game_id, team_id, event_id) values (46, 13, 6);	insert into game_event (game_id, team_id, event_id) values (46, 11, 6);
insert into game_event (game_id, team_id, event_id) values (45, 12, 6);	insert into game_event (game_id, team_id, event_id) values (45, 9, 6);
insert into game_event (game_id, team_id, event_id) values (44, 1, 6);	
insert into game_event (game_id, team_id, event_id) values (43, 7, 6), (43, 7, 6);	insert into game_event (game_id, team_id, event_id) values (43, 16, 6);
insert into game_event (game_id, team_id, event_id) values (42, 10, 6);	insert into game_event (game_id, team_id, event_id) values (42, 2, 6), (42, 2, 6);
insert into game_event (game_id, team_id, event_id) values (41, 14, 6);	insert into game_event (game_id, team_id, event_id) values (41, 8, 6), (41, 8, 6);
insert into game_event (game_id, team_id, event_id) values (40, 13, 6);	insert into game_event (game_id, team_id, event_id) values (40, 15, 6);
insert into game_event (game_id, team_id, event_id) values (39, 11, 6);	insert into game_event (game_id, team_id, event_id) values (39, 9, 6), (39, 9, 6);
insert into game_event (game_id, team_id, event_id) values (38, 6, 6), (38, 6, 6);	insert into game_event (game_id, team_id, event_id) values (38, 4, 6);
insert into game_event (game_id, team_id, event_id) values (37, 8, 6);	
	insert into game_event (game_id, team_id, event_id) values (36, 3, 6);
insert into game_event (game_id, team_id, event_id) values (35, 14, 6);	insert into game_event (game_id, team_id, event_id) values (35, 1, 6);
insert into game_event (game_id, team_id, event_id) values (34, 16, 6);	insert into game_event (game_id, team_id, event_id) values (34, 10, 6);
insert into game_event (game_id, team_id, event_id) values (33, 5, 6), (33, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (32, 2, 6), (32, 2, 6), (32, 2, 6);	
insert into game_event (game_id, team_id, event_id) values (31, 4, 6), (31, 4, 6), (31, 4, 6);	insert into game_event (game_id, team_id, event_id) values (31, 16, 6), (31, 16, 6);
insert into game_event (game_id, team_id, event_id) values (30, 15, 6);	insert into game_event (game_id, team_id, event_id) values (30, 8, 6);
insert into game_event (game_id, team_id, event_id) values (29, 6, 6);	insert into game_event (game_id, team_id, event_id) values (29, 1, 6);
insert into game_event (game_id, team_id, event_id) values (28, 7, 6), (28, 7, 6);	insert into game_event (game_id, team_id, event_id) values (28, 3, 6);
insert into game_event (game_id, team_id, event_id) values (27, 9, 6);	insert into game_event (game_id, team_id, event_id) values (27, 5, 6), (27, 5, 6), (27, 5, 6);
insert into game_event (game_id, team_id, event_id) values (26, 11, 6);	insert into game_event (game_id, team_id, event_id) values (26, 14, 6), (26, 14, 6);
insert into game_event (game_id, team_id, event_id) values (25, 10, 6);	
insert into game_event (game_id, team_id, event_id) values (24, 2, 6), (24, 2, 6);	
insert into game_event (game_id, team_id, event_id) values (23, 3, 6), (23, 3, 6);	insert into game_event (game_id, team_id, event_id) values (23, 5, 6);
insert into game_event (game_id, team_id, event_id) values (22, 15, 6), (22, 15, 6);	insert into game_event (game_id, team_id, event_id) values (22, 7, 6);
insert into game_event (game_id, team_id, event_id) values (21, 13, 6);	insert into game_event (game_id, team_id, event_id) values (21, 9, 6);
insert into game_event (game_id, team_id, event_id) values (20, 10, 6);	insert into game_event (game_id, team_id, event_id) values (20, 11, 6), (20, 11, 6);
insert into game_event (game_id, team_id, event_id) values (19, 16, 6), (19, 16, 6);	insert into game_event (game_id, team_id, event_id) values (19, 8, 6);
insert into game_event (game_id, team_id, event_id) values (18, 1, 6), (18, 1, 6), (18, 1, 6);	insert into game_event (game_id, team_id, event_id) values (18, 4, 6), (18, 4, 6);
insert into game_event (game_id, team_id, event_id) values (17, 14, 6);	insert into game_event (game_id, team_id, event_id) values (17, 6, 6);
insert into game_event (game_id, team_id, event_id) values (16, 7, 6);	insert into game_event (game_id, team_id, event_id) values (16, 2, 6), (16, 2, 6);
	insert into game_event (game_id, team_id, event_id) values (15, 13, 6);
insert into game_event (game_id, team_id, event_id) values (14, 9, 6), (14, 9, 6);	insert into game_event (game_id, team_id, event_id) values (14, 1, 6), (14, 1, 6), (14, 1, 6), (14, 1, 6);
insert into game_event (game_id, team_id, event_id) values (13, 12, 6);	insert into game_event (game_id, team_id, event_id) values (13, 11, 6);
insert into game_event (game_id, team_id, event_id) values (12, 5, 6);	insert into game_event (game_id, team_id, event_id) values (12, 6, 6), (12, 6, 6);
insert into game_event (game_id, team_id, event_id) values (11, 14, 6), (11, 14, 6);	insert into game_event (game_id, team_id, event_id) values (11, 3, 6), (11, 3, 6), (11, 3, 6);
	insert into game_event (game_id, team_id, event_id) values (10, 15, 6), (10, 15, 6), (10, 15, 6);
	insert into game_event (game_id, team_id, event_id) values (9, 10, 6);
insert into game_event (game_id, team_id, event_id) values (8, 11, 6);	
insert into game_event (game_id, team_id, event_id) values (7, 5, 6);	
insert into game_event (game_id, team_id, event_id) values (6, 8, 6);	insert into game_event (game_id, team_id, event_id) values (6, 7, 6), (6, 7, 6);
	insert into game_event (game_id, team_id, event_id) values (5, 4, 6), (5, 4, 6), (5, 4, 6);
insert into game_event (game_id, team_id, event_id) values (4, 6, 6), (4, 6, 6), (4, 6, 6);	insert into game_event (game_id, team_id, event_id) values (4, 16, 6);
insert into game_event (game_id, team_id, event_id) values (3, 15, 6);	
insert into game_event (game_id, team_id, event_id) values (2, 13, 6);	insert into game_event (game_id, team_id, event_id) values (2, 1, 6), (2, 1, 6), (2, 1, 6);
	insert into game_event (game_id, team_id, event_id) values (1, 3, 6), (1, 3, 6);



-- =ЕСЛИ(I2>0;СЦЕПИТЬ("insert into game_event (game_id, team_id, event_id) values (";$A2;", ";G2;", 6)";ЕСЛИ(I2>1;ПОВТОР(СЦЕПИТЬ(", (";$A2;", ";G2;", 6)");I2-1);"");";");"")