function [dataFiltered, filter_name] = bgFilterData(dataRaw,filter_type,order,Fs,fL,fH)
%bgFilterData returns filtered data and name of filter
%   User inputs data as a time table object that needs to be filtered along
%   with type of filter, order of filtering, sampling frequency, low and
%   high passband frequency values. The output is filtered data and the
%   name of filter used for analysis.

%Define Nyquist frequency based on sampling frequency
Fn = Fs/2;

%Switch function based on selected filter type
switch filter_type
    
    %SMOOTHDATA
    case 1
        filter_name = 'Moving Average Smoothing with 100 Sample Window';
        dataFiltered = smoothdata(dataRaw,'movmean',100);
    %MEDFILT1
    case 2
        filter_name = 'Median Filtering with Zero Padding';
        dataFiltered = medfilt1(dataRaw,order);
    %FIR1   
    case 3
        filter_name = 'Bandpass FIR filter with Hamming Window';
        d = fir1(order,[fL fH]/Fn,'bandpass');
        dataFiltered = filtfilt(d,1,dataRaw);
    %BUTTER
    case 4
        filter_name = 'Butterworth IIR filter with Bandpass';
        [A,B,C,D] = butter(order,[fL fH]/Fn);
        [filter_SOS,g] = ss2sos(A,B,C,D);
        dataFiltered = filtfilt(filter_SOS,g,dataRaw);
    %CHEBY1
    case 5
        filter_name = 'Chebyshev Type I IIR filter with 0.1 dB passband ripple';
        [A,B,C,D] = cheby1(order,0.1,[fL fH]/Fn);
        [filter_SOS,g] = ss2sos(A,B,C,D);
        dataFiltered = filtfilt(filter_SOS,g,dataRaw);
    %CHEBY2
    case 6
        filter_name = 'Chebyshev Type II IIR filter with 20 dB stopband ripple';
        [A,B,C,D] = cheby2(order,20,[fL fH]/Fn);
        [filter_SOS,g] = ss2sos(A,B,C,D);
        dataFiltered = filtfilt(filter_SOS,g,dataRaw);
    %ELLIP
    case 7
        filter_name = 'Elliptic IIR filter with 0.1 dB passband & 30 dB stopband ripple';
        [A,B,C,D] = ellip(order,0.1,30,[fL fH]/Fn);
        [filter_SOS,g] = ss2sos(A,B,C,D);
        dataFiltered = filtfilt(filter_SOS,g,dataRaw);
    %DESIGNFILT
    case 8
        filter_name = 'Parks-McClellan Equiripple FIR filter';  
        d = designfilt('bandpassfir','FilterOrder',order,'StopbandFrequency1',fL-0.005,'PassbandFrequency1',fL,'PassbandFrequency2',fH,'StopbandFrequency2',fH+0.1,'DesignMethod','equiripple','SampleRate',Fs);
        dataFiltered = filtfilt(d,dataRaw);

end

end
