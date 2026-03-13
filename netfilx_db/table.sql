DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      varchar(5),
    type         varchar(10),
    title        varchar(250),
    director     varchar(550),
    casts        varchar(1050),
    country      varchar(550),
    date_added   varchar(55),
    release_year int,
    rating       varchar(15),
    duration     varchar(15),
    listed_in    varchar(250),
    description  varchar(550)
);

select * from netflix
limit 10
ALTER TABLE netflix
rename listed_in to genre 