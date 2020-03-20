--
-- PostgreSQL database table for observation data and sensor node pings.
--
-- Date:    2020-03-20
-- Author:  Philipp Engel
--

BEGIN;

SET CLIENT_ENCODING = 'UTF8';

CREATE SCHEMA openadms;

-- Create the observations table.
CREATE TABLE openadms.observations (
    id   BIGSERIAL PRIMARY KEY,
    data JSONB     NOT NULL
);

-- Create the heartbeats table for sensor node pings.
CREATE TABLE openadms.heartbeats (
    pid  VARCHAR(80) NOT NULL,
    nid  VARCHAR(80) NOT NULL,
    freq BIGINT,
    ip   VARCHAR(15),
    dt   TIMESTAMPTZ,
    UNIQUE (pid, nid)
);

-- Create indices.
CREATE INDEX idx_id        ON openadms.observations ((data->>'id'));
CREATE INDEX idx_nid       ON openadms.observations ((data->>'nid'));
CREATE INDEX idx_pid       ON openadms.observations ((data->>'pid'));
CREATE INDEX idx_sensor    ON openadms.observations ((data->>'sensorName'));
CREATE INDEX idx_target    ON openadms.observations ((data->>'target'));
CREATE INDEX idx_timestamp ON openadms.observations ((data->>'timestamp'));
CREATE INDEX idx_type      ON openadms.observations ((data->>'type'));

COMMIT;

ANALYZE openadms.observations;
ANALYZE openadms.heartbeats;
