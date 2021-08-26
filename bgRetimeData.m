function [dataRetime,dataSeconds] = bgRetimeData(data)
%bgRetimeData Summary of this function goes here
%   Detailed explanation goes here

uniqueRowsTT = unique(data);
uniqueTimes = unique(uniqueRowsTT.time);

dataRetime = retime(uniqueRowsTT,uniqueTimes,'mean');
dataSeconds = retime(dataRetime,'secondly','mean');
end

