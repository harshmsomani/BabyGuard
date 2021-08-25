function data = bgLoadData(myDirectory, sMaterial, sWeight, sType)
%bgLoadData Summary of this function goes here
%   Detailed explanation goes here

bgSensor = setdiff({myDirectory([myDirectory.isdir]).name}, {'.','..','.git'});
ds = tabularTextDatastore(bgSensor{sMaterial},'IncludeSubfolders',true,'FileExtensions','.csv');

ds = partition(ds,3,sWeight);

if sType == 1
    ds = partition(ds,2,1);
    idx = ismember(ds.VariableNames,["pres_0","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
elseif sType == 2
    ds = partition(ds,2,1);
    idx = ismember(ds.VariableNames,["pres_1","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
elseif sType == 3
    ds = partition(ds,2,2);
    idx = ismember(ds.VariableNames,["pres_1","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
elseif sType == 4
    ds = partition(ds,2,2);
    idx = ismember(ds.VariableNames,["pres_0","time"]);
    ds.SelectedVariableNames = ds.VariableNames(idx);
end

data = readall(ds);
data.time = datetime(data.time, 'ConvertFrom','posixtime','TicksPerSecond',1e3,'Format','dd-MMM-yyyy HH:mm:ss:SSS');

data = table2timetable(data);
data.sec = seconds(data.time - data.time(1));

data.Properties.VariableNames = {'Voltage_V', 'Time_sec'};
data.Voltage_V = data.Voltage_V ./ 1023;
data.Voltage_V = data.Voltage_V .* 5;

end
