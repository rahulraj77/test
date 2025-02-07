clc;clear all;close all
fs = 1e6;                   % Sample rate (1 MHz)
numSamples = 10000;         % Number of samples
maxDopplerShift = 100;      % Maximum Doppler shift (100 Hz)


% Generate random data signal (complex baseband)
txSignal = (randn(numSamples, 1) + 1j*randn(numSamples, 1));  % Complex Gaussian signal
% Create flat Rayleigh fading channel
rayleighChan = comm.RayleighChannel( ...
    'SampleRate', fs, ...
    'MaximumDopplerShift', maxDopplerShift, ... % Doppler shift
    'NormalizePathGains', true);                % Normalize path gains
% Pass the signal through the flat Rayleigh fading channel
rxSignal = rayleighChan(txSignal);
% Plot the transmitted and received signals (first 100 samples)
figure;subplot(2, 1, 1);
plot(real(txSignal(1:100)), 'b-o');hold on;
plot(imag(txSignal(1:100)), 'r-x');
title('Transmitted Signal (First 100 Samples)');
xlabel('Sample Index');ylabel('Amplitude');
legend('Real Part', 'Imaginary Part');grid on;
subplot(2, 1, 2);
plot(real(rxSignal(1:100)), 'b-o');hold on;
plot(imag(rxSignal(1:100)), 'r-x');
title('Received Signal through Flat Rayleigh Fading Channel (First 100 Samples)');
xlabel('Sample Index');ylabel('Amplitude');
legend('Real Part', 'Imaginary Part');grid on;
% Compute and plot the power spectral density (PSD) of the transmitted and received signals
figure;
pwelch(txSignal, [], [], [], fs, 'centered');hold on;
pwelch(rxSignal, [], [], [], fs, 'centered');
title('Power Spectral Density (PSD) of Transmitted and Received Signals');
xlabel('Frequency (Hz)');ylabel('Power/Frequency (dB/Hz)');
legend('Transmitted Signal', 'Received Signal');grid on;