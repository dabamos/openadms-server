--  _______                     _______ _____  _______ _______
-- |       |.-----.-----.-----.|   _   |     \|   |   |     __|
-- |   -   ||  _  |  -__|     ||       |  --  |       |__     |
-- |_______||   __|_____|__|__||___|___|_____/|__|_|__|_______|
--          |__|                                         Server
--
-- PostgreSQL database schema, tables for observation data, log messages,
-- and heartbeats, as well as PL/pgSQL functions.
--
-- Date:    2020-03-23
-- Author:  Philipp Engel

BEGIN;

SET CLIENT_ENCODING = 'UTF8';

-- DROP SCHEMA IF EXISTS openadms CASCADE;
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

--
-- Returns server information: database name, server time, server uptime, PostgreSQL version.
--
CREATE OR REPLACE FUNCTION openadms.get_version_json()
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT json_build_object('database', current_database(),
                             'timestamp', current_timestamp,
                             'uptime', date_trunc('second', current_timestamp - pg_postmaster_start_time()),
                             'version', version()) INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Stores or updates a "heartbeat" or "ping".
--
CREATE OR REPLACE FUNCTION openadms.update_heartbeat(project_id text, node_id text, frequency int, remote_addr text)
RETURNS void AS $$
BEGIN
    INSERT INTO openadms.heartbeats (pid, nid, freq, ip, dt)
    VALUES (project_id, node_id, frequency, remote_addr, NOW())
    ON CONFLICT (pid, nid) DO UPDATE
    SET pid = project_id, nid = node_id, freq = frequency, ip = remote_addr, dt = NOW();
END;
$$ LANGUAGE plpgsql;

--
-- Stores log message.
--
CREATE OR REPLACE FUNCTION openadms.store_log(project_id text, node_id text, dt text, module_name text, log_level text, log_message text)
RETURNS void AS $$
BEGIN
    INSERT INTO openadms.logs (pid, nid, dt, module, level, message)
    VALUES (project_id, node_id, dt::timestamptz, module_name, log_level, log_message);
END;
$$ LANGUAGE plpgsql;

--
-- Stores time series data in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.store_observation(obs json)
RETURNS void AS $$
BEGIN
    INSERT INTO openadms.observations (data) VALUES (obs);
END;
$$ LANGUAGE plpgsql;

--
-- Returns a single observation by id in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_observation_json(obs_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT data
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'id' = obs_id;
    RETURN COALESCE(result, '{}'::text);
END;
$$ LANGUAGE plpgsql;

--
-- Returns a single observation by id in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_observation_csv(obs_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT (
        SELECT concat_ws(',', data->>'timestamp', data->>'pid', data->>'nid', data->>'id', data->>'sensorName', data->>'target', string_agg(conc, ','))
        FROM (
            SELECT concat_ws(',', key, string_agg(value, ',')) AS conc
            FROM (
                SELECT key, (jsonb_each_text(value)).value
                FROM jsonb_each(data->'responseSets')
            ) AS x GROUP BY key
        ) AS csv
    ) AS csv
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'id' = obs_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns an array of all project ids in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_project_ids_json()
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(DISTINCT data->>'pid'), '[]'::json)
    INTO result
    FROM openadms.observations WHERE data->>'type' = 'observation';
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns an array of all project ids in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_project_ids_csv()
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT DISTINCT data->>'pid'
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation';
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns an array of all sensor node ids in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_sensor_node_ids_json(project_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(DISTINCT data->>'nid'), '[]'::json)
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns an array of all sensor node ids in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_project_ids_csv(project_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT DISTINCT data->>'nid'
    INTO result
    FROM openadms.observations WHERE data->>'type' = 'observation' AND data->>'pid' = project_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns heartbeat data of given sensor node in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_heartbeat_json(project_id text, node_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE((array_agg(row_to_json(t)))[1], '{}'::json)
    INTO result
    FROM (
        SELECT pid, nid, freq, ip, dt FROM openadms.heartbeats WHERE pid = project_id AND nid = node_id
    ) t;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns heartbeat data of given sensor node in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_heartbeat_csv(project_id text, node_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT array_to_string(array[pid::text, nid::text, freq::int, ip::text, dt::text], ',')
    INTO result
    FROM openadms.heartbeats WHERE pid = project_id AND nid = node_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns single log message of given id in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_log_json(log_id int)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE((array_agg(row_to_json(t)))[1], '{}'::json)
    INTO result
    FROM (SELECT id, pid, nid, dt, module, level, message FROM openadms.logs WHERE id = log_id) t;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns single log message of given id in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_log_csv(log_id int)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT array_to_string(array[id::text, pid::text, nid::text, dt::text, module::text, level::text, message::text], ',')
    INTO result
    FROM openadms.logs
    WHERE id = log_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns log messages of given sensor node by time range in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_logs_json(project_id text, node_id text, dt_from text, dt_to text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(t), '[]'::json)
    INTO result
    FROM (
        SELECT id, pid, nid, dt, module, level, message
        FROM openadms.logs
        WHERE pid = project_id AND nid = node_id AND dt >= dt_from::timestamptz AND dt < dt_to::timestamptz
    ) t;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns log messages of given sensor node by time range in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_logs_csv(project_id text, node_id text, dt_from text, dt_to text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(array_to_string(array[id::text, pid::text, nid::text, dt::text, module::text, level::text, message::text], ','), ''::text)
    INTO result
    FROM openadms.logs
    WHERE pid = project_id AND nid = node_id AND (dt BETWEEN dt_from::timestamptz AND dt_to::timestamptz);
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns all sensor names of given sensor node in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_sensors_json(project_id text, node_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(DISTINCT data->>'sensorName'), '[]'::json)
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns all sensor names of given sensor node in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_sensors_csv(project_id text, node_id text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT DISTINCT data->>'sensorName'
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns all target names of given sensor node in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_targets_json(project_id text, node_id text, sensor_name text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(DISTINCT data->>'target'), '[]'::json)
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id AND data->>'sensorName' = sensor_name;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns all target names of given sensor node in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_targets_csv(project_id text, node_id text, sensor_name text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT DISTINCT data->>'target'
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id AND data->>'sensorName' = sensor_name;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns all observation ids of given target in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_observation_ids_json(project_id text, node_id text, sensor_name text, target_name text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(DISTINCT data->>'id'), '[]'::json)
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id
    AND data->>'sensorName' = sensor_name AND data->>'target' = target_name;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns all observation ids of given target in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_observation_ids_csv(project_id text, node_id text, sensor_name text, target_name text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT DISTINCT data->>'id'
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id
    AND data->>'sensorName' = sensor_name AND data->>'target' = target_name;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns observations of given target and time range in JSON format.
--
CREATE OR REPLACE FUNCTION openadms.get_observations_json(project_id text, node_id text, sensor_name text, target_name text, dt_from text, dt_to text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(data), '[]'::json)
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id
    AND data->>'sensorName' = sensor_name AND data->>'target' = target_name
    AND (data->>'timestamp' BETWEEN dt_from AND dt_to);
    RETURN result;
END;
$$ LANGUAGE plpgsql;

--
-- Returns observations of given target and time range in CSV format.
--
CREATE OR REPLACE FUNCTION openadms.get_observations_csv(project_id text, node_id text, sensor_name text, target_name text, dt_from text, dt_to text)
RETURNS text AS $$
DECLARE
    result text;
BEGIN
    SELECT COALESCE(json_agg(data), '[]'::json)
    INTO result
    FROM openadms.observations
    WHERE data->>'type' = 'observation' AND data->>'pid' = project_id AND data->>'nid' = node_id
    AND data->>'sensorName' = sensor_name AND data->>'target' = target_name
    AND (data->>'timestamp' BETWEEN dt_from AND dt_to);
    RETURN result;
END;
$$ LANGUAGE plpgsql;

COMMIT;

ANALYZE openadms.observations;
ANALYZE openadms.heartbeats;
ANALYZE openadms.logs;
