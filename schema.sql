CREATE TABLE temperture_p8_ratio (
       temperture_p8_ratio_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
       temperture INTEGER NOT NULL,
       p8_ratio NUMERIC(3,1) NOT NULL,
       a NUMERIC(2,1) NOT NULL,
       b NUMERIC(2,1) NOT NULL,
       temp_column INTEGER NOT NULL DEFAULT 0,
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
       temp_column INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE phase_transition (
       phase_transition_type VARCHAR(8) PRIMARY KEY
);

CREATE TABLE microscope_trial_phase_transition (
       microscope_trial_phase_transition_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
       microscope_trial_id INTEGER NOT NULL,
       phase_transition_type  VARCHAR(8) NOT NULL,
       temperture INTEGER NOT NULL,
       UNIQUE (microscope_trial_id, phase_transition_type)
);

INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (1,  1,  '2008-12-08');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (2,  2,  '2008-12-08');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (3,  3,  '2008-12-09');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (4,  4,  '2008-12-16');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (5,  1,  '2009-01-03');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (6,  10, '2009-01-03');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (7,  9,  '2009-01-03');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (8,  6,  '2009-01-05');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (9,  7,  '2009-01-05');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (10, 8,  '2009-01-05');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (11, 11, '2009-01-05');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (12, 2,  '2009-02-07');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (13, 7,  '2009-02-08');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (14, 12, '2009-02-08');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (15, 4,  '2009-02-08');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (16, 12, '2009-02-14');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (17, 12, '2009-02-14');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (18, 12, '2009-02-14');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (19, 12, '2009-02-14');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (20, 12, '2009-02-14');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (21, 13, '2009-02-15');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (22, 13, '2009-02-15');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (23, 13, '2009-02-17');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (24, 13, '2009-02-18');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (25, 3, '2009-02-21');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (26, 7, '2009-02-21');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (27, 14, '2009-02-22');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (28, 15, '2009-02-22');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (29, 16, '2009-02-25');
INSERT INTO microscope_trial (microscope_trial_id, cell_id, date) VALUES (30, 17, '2009-02-25');

INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (1,  'i_to_n', 1519);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (1,  'n_to_cry', 747);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (1,  'n_to_b4', 1030);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (2,  'i_to_n', 1450);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (2,  'n_to_cry', 765);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (2,  'n_to_b4', 1108);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (3,  'i_to_n', 1606);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (3,  'n_to_cry', 800);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (4,  'i_to_n', 1588);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (4,  'n_to_cry', 757);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (4,  'n_to_b4', 575);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (5,  'i_to_n', 1507);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (5,  'n_to_cry', 764);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (5,  'n_to_b4', 892);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (6,  'i_to_n', 1563);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (6,  'n_to_cry', 745);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (6,  'n_to_b4', 725);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (7,  'i_to_n', 1529);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (7,  'n_to_cry', 767);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (7,  'n_to_b4', 968);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (8,  'i_to_n', 1590);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (8,  'n_to_cry', 782);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (8,  'n_to_b4', 662);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (9,  'i_to_n', 1545);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (9,  'n_to_cry', 804);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (9,  'n_to_b4', 950);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (10,  'i_to_n', 1543);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (10,  'n_to_cry', 761);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (10,  'n_to_b4', 710);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (11,  'i_to_n', 1504);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (11,  'n_to_cry', 769);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (11,  'n_to_b4', 879);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (12,  'i_to_n', 1719);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (12,  'n_to_b4', 1175);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (13,  'i_to_n', 1538);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (13,  'n_to_b4', 958);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (14,  'i_to_n', 1334);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (14,  'n_to_cry', 711);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (14,  'n_to_b4', 1213);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (15,  'i_to_n', 1546);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (15,  'n_to_cry', 780);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (15,  'n_to_b4', 563);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (16,  'i_to_n', 1355);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (17,  'i_to_n', 1395);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (17,  'n_to_b4', 1273);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (18,  'i_to_n', 1362);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (19,  'n_to_b4', 1271);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (20,  'n_to_cry', 763);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (21,  'i_to_n', 1396);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (21,  'n_to_b4', 1163);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (22,  'i_to_n', 1410);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (22,  'n_to_cry', 780);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (22,  'n_to_b4', 1190);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (23,  'i_to_n', 1410);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (23,  'n_to_cry', 810);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (23,  'n_to_b4', 1210);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (24,  'i_to_n', 1415);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (24,  'n_to_cry', 790);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (24,  'n_to_b4', 1197);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (25,  'i_to_n', 1715);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (25,  'n_to_cry', 915);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (26,  'i_to_n', 1605);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (26,  'n_to_cry', 865);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (26,  'n_to_b4', 1000);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (27,  'i_to_n', 1400);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (27,  'n_to_b4', 1152);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (28,  'i_to_n', 1520);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (28,  'n_to_b4', 821);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (29,  'i_to_n', 1645);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (29,  'n_to_cry', 793);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (29,  'n_to_b4', 620);
INSERT INTO microscope_trial_phase_transition (microscope_trial_id, phase_transition_type, temperture) VALUES (30,  'i_to_n', 1615);



    SELECT p8_ratio,
           temperture,
           phase_transition_type
      FROM microscope_trial
INNER JOIN microscope_trial_phase_transition USING(microscope_trial_id)
INNER JOIN cell USING(cell_id)
INNER JOIN sample USING(sample_id)
--     WHERE p8_ratio = 40.3
;
 


CREATE TABLE dls_photo (
       photo_name VARCHAR(32) NOT NULL PRIMARY KEY,
       dls_trial_id INTEGER NOT NULL
);

CREATE TABLE dls_trial (
       dls_trial_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
       cell_id INTEGER NOT NULL,
       date DATE NOT NULL,
       temperture INTEGER NOT NULL,
       relaxation_time FLOAT NOT NULL,
       beta FLOAT NOT NULL,
       a FLOAT NOT NULL,
       y FLOAT NOT NULL,
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
       thickness NUMERIC(2,1) NOT NULL
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
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(12, 9, 7.6);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(13, 9, 8.9);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(14, 9, 0); -- thickness unknown
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(15, 15, 10.3);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(16, 14, 10.6);
INSERT INTO cell (cell_id, sample_id, thickness) VALUES(17, 8, 9.2);

CREATE TABLE sample (
       sample_id INTEGER NOT NULL PRIMARY KEY,
       p8_ratio NUMERIC(3,1) NOT NULL
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




