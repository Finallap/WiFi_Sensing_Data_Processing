fo = 4; %frequency of the sine wave
Fs = 100; %sampling rate
Ts = 1/Fs; %sampling time interval
t = 0:Ts:1-Ts; %sampling period
n = length(t); %number of samples
y = 2*sin(2*pi*fo*t); %the sine curve

sequence = amplitudeA(:,2);
sequence = medfilt1(sequence,40);%ÖÐÖµÂË²¨
y = sequence;
Fs = 100; %sampling rate
Ts = 1/Fs; %sampling time interval
t = 0:Ts:1-Ts; %sampling period
n = length(t); %number of samples

 
%plot the cosine curve in the time domain
%sinePlot = figure;
%plot(t,y)
%xlabel('time (seconds)')
%ylabel('y(t)')
%title('Sample Sine Wave')
%grid
 
%plot the frequency spectrum using the MATLAB fft command
matlabFFT = figure; %create a new figure
YfreqDomain = fft(y); %take the fft of our sin wave, y(t)

stem(abs(YfreqDomain)); %use abs command to get the magnitude
%similary, we would use angle command to get the phase plot!
%we'll discuss phase in another post though!
xlabel('Sample Number')
ylabel('Amplitude')
title('Using the Matlab fft command')
grid
axis([0,100,0,120])


[YfreqDomain,frequencyRange] = centeredFFT(y,Fs);
centeredFFT = figure;
%remember to take the abs of YfreqDomain to get the magnitude!
stem(frequencyRange,abs(YfreqDomain));
xlabel('Freq (Hz)')
ylabel('Amplitude')
title('Using the centeredFFT function')
grid
axis([-3,3,0,3])

[YfreqDomain,frequencyRange] = positiveFFT(y,Fs);
positiveFFT = figure;
stem(frequencyRange,abs(YfreqDomain));
set(positiveFFT,'Position',[500,500,500,300])
xlabel('Freq (Hz)')
ylabel('Amplitude')
title('Using the positiveFFT function')
grid
axis([0,20,0,1.5])
