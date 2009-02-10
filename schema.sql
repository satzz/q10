CREATE TABLE temperture_p8_ratio (
       temperture_p8_ratio_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
       temperture INTEGER NOT NULL,
       p8_ratio NUMERIC NOT NULL,
       a NUMERIC NOT NULL,
       b NUMERIC NOT NULL,
       KEY (temperture, p8_ratio)
);

CREATE TABLE microscope_photo (
       photo_name VARCHAR(32) NOT NULL PRIMARY KEY,
       microscope_trial_id INTEGER NOT NULL,
       temperture INTEGER NOT NULL
);

CREATE TABLE microscope_trial (
       microscope_trial_id INTEGER NOT NULL PRIMARY KEY,
       cell_id INTEGER NOT NULL,
       date DATE NOT NULL,
       i_to_n NUMERIC,
       n_to_cry NUMERIC,
       n_to_b4 NUMERIC
);

INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (1,  1,  '2008-12-08', 151.9, 74.7, 103.0);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (2,  2,  '2008-12-08', 145.0, 76.5, 110.8);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (3,  3,  '2008-12-09', 160.6, 80.0, NULL);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (4,  4,  '2008-12-16', 158.8, 75.7, 57.5);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (5,  1,  '2009-01-03', 150.7, 76.4, 89.2);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (6,  10, '2009-01-03', 156.3, 74.5, 72.5);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (7,  9,  '2009-01-03', 152.9, 76.7, 96.8);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (8,  6,  '2009-01-05', 159,   78.2, 66.2);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (9,  7,  '2009-01-05', 154.5, 80.4, 95.0);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (10, 8,  '2009-01-05', 154.3, 76.1, 71.0);
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date, i_to_n, n_to_cry, n_to_b4) VALUES (11, 11, '2009-01-05', 150.4, 76.9, 87.9);


CREATE TABLE dls_photo (
       photo_name VARCHAR(32) NOT NULL PRIMARY KEY,
       dls_trial_id INTEGER NOT NULL
);

CREATE TABLE dls_trial (
       dls_trial_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
       cell_id INTEGER NOT NULL,
       date DATE NOT NULL,
       temperture INTEGER NOT NULL,
       relaxation_time NUMERIC NOT NULL,
       rotation_angle INTEGER NOT NULL,
       sample_angle INTEGER NOT NULL,
       laser_position INTEGER NOT NULL,
       nd_filter_position INTEGER NOT NULL,
       polarizer_angle INTEGER NOT NULL,
       sample_position INTEGER NOT NULL,
       fit_wssr NUMERIC NOT NULL,
       fit_stdfit NUMERIC NOT NULL,
       correlation_max NUMERIC NOT NULL,
       count_rate_max NUMERIC NOT NULL,
       count_rate_min NUMERIC NOT NULL
);

CREATE TABLE cell (
       cell_id INTEGER NOT NULL PRIMARY KEY,
       sample_id INTEGER NOT NULL,
       thickness NUMERIC NOT NULL
);

INSERT INTO cell (cell_id, sample_id, thickness) VALUES(1,  10, 7.2);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(2,  9,  7.5);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(3,  8,  8.1);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(4,  11, 10.7);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(6,  14, 6.0);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(7,  15, 8.3);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(8,  16, 10.2);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(9,  13, 7.9);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(10, 12, 6.7);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(11, 17, 7.2);

CREATE TABLE sample (
       sample_id INTEGER NOT NULL PRIMARY KEY,
       p8_ratio NUMERIC NOT NULL
);

INSERT INTO sample (sample_id, p8_ratio) VALUES(8,  0);
INSERT INTO sample (sample_id, p8_ratio) VALUES(9,  40.3);
INSERT INTO sample (sample_id, p8_ratio) VALUES(10, 20.4);
INSERT INTO sample (sample_id, p8_ratio) VALUES(11, 10.3);
INSERT INTO sample (sample_id, p8_ratio) VALUES(12, 4.8);
INSERT INTO sample (sample_id, p8_ratio) VALUES(13, 15.1);
INSERT INTO sample (sample_id, p8_ratio) VALUES(14, 11.0);
INSERT INTO sample (sample_id, p8_ratio) VALUES(15, 20.3);
INSERT INTO sample (sample_id, p8_ratio) VALUES(16, 7.5);
INSERT INTO sample (sample_id, p8_ratio) VALUES(17, 12.9);

select date,  temperture, p8_ratio, rotation_angle, count_rate_max, 1/relaxation_time from dls_trial inner join cell using(cell_id) inner join sample using (sample_id) where relaxation_time > 0 and temperture = 800 and p8_ratio > 40 order by date,temperture, rotation_angle;




