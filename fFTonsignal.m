function[amp,f1]=fFTonsignal(Signal)

% FFT on signal Function for HW2

Feq=2560;
tstart=0;
t=1/Feq;
L=length(Signal);
time=(0:(L-1))*t;

% Compute FFT
fft_result1 = fft(Signal)/length(Signal);
frequencies = (0:L-1)*(Feq/L);
feqmin=10;
% feqmax=30; % This will check for amp at first frequency
feqmax=60;  % This will check for changes in frequency
indmin=find(frequencies>=feqmin,1);
indmax=find(frequencies<=feqmax,1,'last');


%% Plot the magnitude spectrum
figure(10)
hold on
plot(frequencies, abs(fft_result1));
xlim([0 60]);
xlabel('Frequency (Hz)','FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
ylabel('Amplitude', 'FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
set(gca,'FontSize',25, 'FontWeight', 'bold','FontName','Times New Roman');
title('Amp vs Feq', 'FontSize',45, 'FontName','Times New Roman');

%% Getting Peak value within range
fftrange=abs(fft_result1(indmin:indmax));
filterdfeq=frequencies(indmin:indmax);
[p1,ind]=sort(abs(fftrange));
amp=p1(end);
f1=filterdfeq(ind(end));
