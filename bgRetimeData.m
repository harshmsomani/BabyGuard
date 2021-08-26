function [dataRetime,dataSeconds] = bgRetimeData(data)
%bgRetimeData return retimed and secondly data
%   User inputs raw data as a time table object. The repeated time stamp
%   values are retimed and returned along with secondly data. 

%Find unique rows in data
uniqueRowsTT = unique(data);
%Find unique time stamps in data
uniqueTimes = unique(uniqueRowsTT.time);

%Retime data to include mean values of Voltage for repeated time stamps
dataRetime = retime(uniqueRowsTT,uniqueTimes,'mean');
%Retime data to average values on a per second scale
dataSeconds = retime(dataRetime,'secondly','mean');
end

