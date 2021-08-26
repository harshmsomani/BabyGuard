%%
fprintf('\n');
disp('ENTER 1 for 100% Cotton | ENTER 2 for 94% Cotton');
disp('ENTER 3 for 100% Nylon  | ENTER 4 for 82% Nylon');
fprintf('\n');
disp('ENTER 1 for 0oz | ENTER 2 for 2oz | ENTER 3 for 4oz');
fprintf('\n');
disp('ENTER 1 for No Backing | ENTER 2 for Cut Away');
disp('ENTER 3 for Tear Away  | ENTER 4 for Water Away');
fprintf('\n');
disp('For example: To Load 100% Cotton - 2oz - Tear Away')
disp('Enter the command: cottonTA2 = bgLoadData(myDirectory,1,2,3)')
fprintf('\n');
%%
myDirectory = dir();
sMaterial = 1;
sWeight = 1;
sType = 1;

dataRaw = bgLoadData(myDirectory,sMaterial,sWeight,sType);

[dataRetime,dataSeconds] = bgRetimeData(dataRaw);
%%
fprintf('\n');
disp('Assign order of filter to "order"');
disp('Assign sampling frequency of data to "Fs"');
disp('Assign Low & High Passband Frequency to "fL & fH"');
fprintf('\n');
disp('Select Filter Type and assign to "filter_type"');
disp('1: Moving Average Smoothing with 100 Sample Window');
disp('2: Median Filtering with zero padding');
disp('3: Bandpass FIR filter with Hamming Window');
disp('4: Butterworth IIR filter with Bandpass');
disp('5: Chebyshev Type I IIR filter with 0.1 dB passband ripple');
disp('6: Chebyshev Type II IIR filter with 20 dB stopband ripple');
disp('7: Elliptic IIR filter with 0.1 dB passband & 30 dB stopband ripple');
disp('8: Parks-McClellan Equiripple FIR filter - Filter order must be 3 or more');
fprintf('\n');
disp('For example: To run Butterworth IIR Filter with Bandpass');
disp('After assigning order, Fs, fL, fH & filter_type');
disp('Enter the command: [dataFiltered, filter_name] = filter_configuration(dataRetime.Voltage_V,filter_type,order,Fs,fL,fH);');
fprintf('\n');
%%
order = 2;
Fs = 1/mean(diff(dataRetime.Time_sec));
fL = 0.01;
fH = 0.2;

filter_type = 1;
[dataFiltered, filter_name] = bgFilterData(dataRetime.Voltage_V,filter_type,order,Fs,fL,fH);
%%
figure()
plot(dataRetime.Time_sec,dataRetime.Voltage_V);

hold on
plot(dataRetime.Time_sec,dataFiltered);

title("Sensor Data with " + filter_name)
subtitle("Order: " + order + " | fL: " + fL + "Hz" + " | fH: " + fH + "Hz")
legend("Raw Data", "Filtered Data")
ylabel("Voltage (V)")
xlabel("Time (Seconds)")

hold off