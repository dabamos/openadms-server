################################################################################
# OpenADMS Server API Access Example
################################################################################
# Run inside the command window:
# >> source("api.m");
# >> source("profile.m");
# >> data = get_json(host, user, password, pid, nid, sensor, target, from, to);
# >> [x, y] = get_values(data, 'temperature');
# >> plot_values(x, y, "Temperature", "Time", "Temperature [°C]");
################################################################################

# Add JSONLab library.
addpath('./jsonlab');

# Retrieves JSON object from OpenADMS Server instance.
function x = get_json(host, user, password, pid, nid, sensor, target, from, to)
  api = strcat("https://", user, ":", password, "@", host, "/api/v1/projects/",
               pid, "/nodes/", nid, "/sensors/", sensor, "/targets/", target,
               "/observations/?start=", from, "&end=", to);
  printf("Loading observations from 'https://%s/' ...\n", host);
  x = loadjson(urlread(api));
endfunction

# Returns timestamps and values of given `name` from input `json`.
function [x, y] = get_values(json, name)
  x = nan(length(json));
  y = nan(length(json));
  for i = 1:length(json)
    # Convert ISO 8601 to serial. Strip everything beyond the seconds.
    x(i) = datenum(substr(json{i}.data.timestamp, 1, 19), "yyyy-mm-ddTHH:MM:SS");
    y(i) = getfield(json{i}.data.responseSets, name).value;
  endfor
endfunction

# Plots timestamps and values.
function plot_values(x, y, t, xl, yl)
  plot(x, y);
  xlabel(xl);
  ylabel(yl);
  title(t);
  datetick("x");
  grid();
endfunction