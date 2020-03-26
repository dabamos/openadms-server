# OpenADMS Server API Access from GNU Octave

Basic example that shows how to import observations from an OpenADMS Server
instance in JSON format into GNU Octave in order to plot the timeseries.
Requires the [JSONLab library](https://github.com/fangq/jsonlab) to be stored in
the GNU Octave workspace. Name the JSONLab directory simply `jsonlab`.

Copy `api.m` and `profile.m` to your workspace directory. Edit `profile.m` and
fill out the server and project details. Then, run:

```matlab
>> source("api.m");
>> source("profile.m");
>> data = get_json(host, user, password, pid, nid, sensor, target, from, to);
>> [x, y] = get_values(data, 'temperature');
>> plot_values(x, y, "Temperature", "Time", "Temperature [°C]");
```

Instead of `temperature`, set the string to one of the response set names
present in the observations.

The example uses the [URL manipulation
functions](https://octave.org/doc/v4.0.1/URL-Manipulation.html) in GNU Octave
and should be compatible to MATLAB.
