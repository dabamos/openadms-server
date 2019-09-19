--
-- PostgreSQL database table for observation data and sensor node pings.
--
-- Date:    2019-09-19
-- Author:  Philipp Engel
--

BEGIN;

SET CLIENT_ENCODING = 'UTF8';

CREATE SCHEMA openadms;

-- Create the timeseries table.
CREATE TABLE openadms.timeseries (
    id   BIGSERIAL PRIMARY KEY,
    data JSONB     NOT NULL
);

-- Create the heartbeats table for sensor node pings.
CREATE TABLE openadms.heartbeats (
    pid VARCHAR(80) NOT NULL,
    nid VARCHAR(80) NOT NULL,
    ip  VARCHAR(15),
    dt  TIMESTAMPTZ,
    UNIQUE (pid, nid)
);

-- Create indices.
CREATE INDEX idx_nid       ON openadms.timeseries ((data->>'nid'));
CREATE INDEX idx_pid       ON openadms.timeseries ((data->>'pid'));
CREATE INDEX idx_sensor    ON openadms.timeseries ((data->>'sensorName'));
CREATE INDEX idx_target    ON openadms.timeseries ((data->>'target'));
CREATE INDEX idx_timestamp ON openadms.timeseries ((data->>'timestamp'));
CREATE INDEX idx_type      ON openadms.timeseries ((data->>'type'));

COMMIT;

ANALYZE openadms.timeseries;
ANALYZE openadms.heartbeats;
