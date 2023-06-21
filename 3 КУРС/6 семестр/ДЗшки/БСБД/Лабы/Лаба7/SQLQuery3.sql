USE KutinMusic
INSERT INTO genre(id, name, parent_genre_id)
VALUES
 (1, 'pop', null),
 (2, 'rock', null),
 (3, 'blues', null),
 (4, 'russian pop', 1),
 (5, 'k-pop', 1),
 (6, 'euro pop', 1),
 (7, 'hard rock', 2),
 (8, 'metal', 2),
 (9, 'punk rock', 2),
 (10, 'delta blues', 3),
 (11, 'electric blues', 3),
 (12, 'heavy metal', 8),
 (13, 'trash metal', 8),
 (14, 'post punk', 9),
 (15, 'horror punk', 9);
INSERT INTO track(id, name)
VALUES
 (1, 'Hallowed Be Thy Name'),
 (2, 'Boys Don''t Cry'),
 (3, 'Riding With The King'),
 (4, 'You Give Love A Bad Name'),
 (5, 'Since I''ve Been Loving You');
INSERT INTO track_genre(track_id, genre_id)
VALUES
 (1, 12),
 (2, 14),
 (3, 3),
 (4, 2),
 (4, 7),
 (5, 3),
 (5, 7);