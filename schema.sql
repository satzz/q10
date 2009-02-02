CREATE TABLE phase_transition (
       phase_transition_id INTEGER NOT NULL PRIMARY KEY,
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
       dls_trial_id INTEGER NOT NULL PRIMARY KEY,
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

CREATE TABLE sample (
       sample_id INTEGER NOT NULL PRIMARY KEY,
       p8_ratio FLOAT NOT NULL
);
