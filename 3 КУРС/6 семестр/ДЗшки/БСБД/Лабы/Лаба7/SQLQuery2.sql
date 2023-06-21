USE KutinMusic
CREATE TABLE genre 
(
 id bigint PRIMARY KEY,
 name varchar(100) NOT NULL,
 parent_genre_id bigint,
 FOREIGN KEY (parent_genre_id) REFERENCES genre(id)
);CREATE TABLE track 
(
 id bigint PRIMARY KEY ,
 name varchar(100) NOT NULL
);
CREATE TABLE track_genre 
(
 track_id bigint,
 genre_id bigint,
 PRIMARY KEY(track_id, genre_id),
 FOREIGN KEY (track_id) REFERENCES track(id),
 FOREIGN KEY (genre_id) REFERENCES genre(id)
);
