CREATE TABLE phase_transition (
       phase_transition_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
       trial_id INTEGER NOT NULL,
       trial_type VARCHAR(16) NOT NULL,
       i_to_n FLOAT NOT NULL,
       n_to_cry FLOAT NOT NULL,
       n_to_b4 FLOAT NOT NULL
);

CREATE TABLE microscope_photo (
       photo_name VARCHAR(32) NOT NULL PRIMARY KEY,
       microscope_trial_id INTEGER NOT NULL,
       temperture INTEGER NOT NULL
);

CREATE TABLE microscope_trial (
       microscope_trial_id INTEGER NOT NULL PRIMARY KEY,
       cell_id INTEGER NOT NULL,
       date DATE NOT NULL
);

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
       rotation_angle INTEGER NOT NULL,
       sample_angle INTEGER NOT NULL,
       laser_position INTEGER NOT NULL,
       nd_filter_position INTEGER NOT NULL,
       polarizer_angle INTEGER NOT NULL,
       sample_position INTEGER NOT NULL
);

CREATE TABLE cell (
       cell_id INTEGER NOT NULL PRIMARY KEY,
       sample_id INTEGER NOT NULL,
       thickness FLOAT NOT NULL
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
       p8_ratio FLOAT NOT NULL
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



