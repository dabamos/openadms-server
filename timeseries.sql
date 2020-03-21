--
-- PostgreSQL database table for observation data, log messages, and sensor node
-- pings.
--
-- Date:    2020-03-20
-- Author:  Philipp Engel
--

BEGIN;

SET CLIENT_ENCODING = 'UTF8';
SET TIMEZONE = 'Europe/Berlin';

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

-- Create the log messages table.
CREATE TABLE openadms.logs (
    id      BIGSERIAL PRIMARY KEY,
    pid     VARCHAR(80)  NOT NULL,
    nid     VARCHAR(80)  NOT NULL,
    dt      TIMESTAMPTZ,
    module  VARCHAR(80)  NOT NULL,
    level   VARCHAR(8)   NOT NULL,
    message VARCHAR(250) NOT NULL
);

-- Create additional indices for table `openadms.observations`.
CREATE INDEX idx_obs_id        ON openadms.observations ((data->>'id'));
CREATE INDEX idx_obs_nid       ON openadms.observations ((data->>'nid'));
CREATE INDEX idx_obs_pid       ON openadms.observations ((data->>'pid'));
CREATE INDEX idx_obs_sensor    ON openadms.observations ((data->>'sensorName'));
CREATE INDEX idx_obs_target    ON openadms.observations ((data->>'target'));
CREATE INDEX idx_obs_timestamp ON openadms.observations ((data->>'timestamp'));
CREATE INDEX idx_obs_type      ON openadms.observations ((data->>'type'));

-- Create additional indices for table `openadms.logs`.
CREATE INDEX idx_log_dt    ON openadms.logs (dt);
CREATE INDEX idx_log_level ON openadms.logs (level);
CREATE INDEX idx_log_nid   ON openadms.logs (nid);
CREATE INDEX idx_log_pid   ON openadms.logs (pid);

COMMIT;

ANALYZE openadms.observations;
ANALYZE openadms.heartbeats;
ANALYZE openadms.logs;
