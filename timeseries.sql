--
-- PostgreSQL database table for observation data in JSONB format.
--
-- Date:    2019-03-27
-- Author:  Philipp Engel
--

BEGIN;

SET CLIENT_ENCODING = 'UTF8';

CREATE SCHEMA openadms;

CREATE TABLE openadms.observations (
    id   BIGSERIAL PRIMARY KEY,
    data JSONB     NOT NULL
);

CREATE UNIQUE INDEX idx_nid       ON openadms.observations (data->'nid');
CREATE UNIQUE INDEX idx_pid       ON openadms.observations (data->'pid');
CREATE UNIQUE INDEX idx_target    ON openadms.observations (data->'target');
CREATE UNIQUE INDEX idx_timestamp ON openadms.observations (data->'timestamp');

COMMIT;

ANALYZE openadms.observations;
