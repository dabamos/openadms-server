--
-- PostgreSQL database table for observation data and sensor node pings.
--
-- Date:    2019-09-19
-- Author:  Philipp Engel
--

BEGIN;

SET CLIENT_ENCODING = 'UTF8';

CREATE SCHEMA openadms;

-- Create the obversations table.
CREATE TABLE openadms.obversations (
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
CREATE INDEX idx_nid       ON openadms.obversations ((data->>'nid'));
CREATE INDEX idx_pid       ON openadms.obversations ((data->>'pid'));
CREATE INDEX idx_sensor    ON openadms.obversations ((data->>'sensorName'));
CREATE INDEX idx_target    ON openadms.obversations ((data->>'target'));
CREATE INDEX idx_timestamp ON openadms.obversations ((data->>'timestamp'));
CREATE INDEX idx_type      ON openadms.obversations ((data->>'type'));

COMMIT;

ANALYZE openadms.obversations;
ANALYZE openadms.heartbeats;
