function data = bgLoadData(myDirectory, sMaterial, sWeight, sType)
%bgLoadData returns raw data timetable 
%   User inputs their working directory as a file structure object, along
%   with assigned Sensor Material, Weight and Type based for analysis. The
%   output is a timetable object of the raw data with Voltage (V) and time
%   stamps of sensor reading in seconds. 

%Use directory and set operations to obtain name of subfolders
bgSensor = setdiff({myDirectory([myDirectory.isdir]).name}, {'.','..','.git'});
%Create a tabular text datastore of raw data for selected sensor material
ds = tabularTextDatastore(bgSensor{sMaterial},'IncludeSubfolders',true,'FileExtensions','.csv');

%Partition datastore based on sensor weight
ds = partition(ds,3,sWeight);

%Load data for No Backing
if sType == 1
    ds = partition(ds,2,1);
    idx = ismember(ds.VariableNames,["pres_0","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
%Load data for Cut Away   
elseif sType == 2
    ds = partition(ds,2,1);
    idx = ismember(ds.VariableNames,["pres_1","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
%Load data for Tear Away
elseif sType == 3
    ds = partition(ds,2,2);
    idx = ismember(ds.VariableNames,["pres_1","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
%Load data for Water Away
elseif sType == 4
    ds = partition(ds,2,2);
    idx = ismember(ds.VariableNames,["pres_0","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
end

%Load all files in datastore
data = readall(ds);
%Convert time stamp to readable data time format
data.time = datetime(data.time, 'ConvertFrom','posixtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss:SSS');

%Convert data to timetable object
data = table2timetable(data);
%Add time stamp of sensor readings in seconds
data.sec = seconds(data.time - data.time(1));

%Assign variable names to columns
data.Properties.VariableNames = {'Voltage_V', 'Time_sec'};
%COnvert ADC sensor data to Voltage values
data.Voltage_V = data.Voltage_V ./ 1023;
data.Voltage_V = data.Voltage_V .* 5;

end
