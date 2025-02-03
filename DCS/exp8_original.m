% MATLAB Code for Carrier Phase Estimation 
% Parameters
clc;
N = 1000;          % Number of symbols
SNR_dB = 10;       % Signal-to-Noise Ratio in dB
M = 4;             % QPSK modulation order
loop_bandwidth = 0.01; % PLL loop bandwidth
true_phase = pi / 3; % True phase of the carrier

% Generate QPSK symbols
tx_symbols = exp(1j * (2 * pi * (0:M-1) / M)); % QPSK constellation points
tx_data = randi([0 M-1], N, 1);                % Random data
tx_signal = tx_symbols(tx_data + 1);           % Modulated signal

% Add noise to the transmitted signal
noise = (1/sqrt(2*10^(SNR_dB/10))) * (randn(N, 1) + 1j * randn(N, 1));
rx_signal = tx_signal .* exp(1j * true_phase) + noise; % Received signal

% 1. Maximum Likelihood Carrier Phase Estimation
estimated_phase_ml = angle(sum(conj(tx_signal) .* rx_signal)); % ML estimation
%fprintf('True Phase: %.2f rad, Estimated Phase (ML): %.2f rad\n', true_phase, estimated_phase_ml);

% 2. Phase-Locked Loop (PLL) Implementation
phase_error_pll = zeros(N, 1); % Phase error for PLL
estimated_phase_pll = zeros(N, 1); % Estimated phase for PLL
current_phase_estimate_pll = 0; % Initial phase estimate for PLL

for n = 1:N
    % Phase detection
    phase_error_pll(n) = angle(rx_signal(n) * exp(-1j * current_phase_estimate_pll)); 
    current_phase_estimate_pll = current_phase_estimate_pll + loop_bandwidth * phase_error_pll(n);
    estimated_phase_pll(n) = current_phase_estimate_pll;
end

% 3. Apply Phase Correction to Received Signal
corrected_rx_signal = rx_signal .* exp(-1j * estimated_phase_pll); % Corrected received signal

% Plot Original and Corrected Constellation Diagrams
figure;
subplot(2, 1, 1);
scatter(real(rx_signal), imag(rx_signal), 'filled');
title('Received Signal Constellation Diagram');
xlabel('In-Phase');
ylabel('Quadrature');
axis equal;
grid on;

subplot(2, 1, 2);
scatter(real(corrected_rx_signal), imag(corrected_rx_signal), 'filled');
title('Corrected Signal Constellation Diagram');
xlabel('In-Phase');
ylabel('Quadrature');
axis equal;
grid on;

% 4. Effect of Additive Noise on Phase Estimate
SNR_dB_range = 0:2:20; % SNR range for variance calculation
phase_error_variance = zeros(length(SNR_dB_range), 1);

for idx = 1:length(SNR_dB_range)
    SNR_dB = SNR_dB_range(idx);
    noise_variance = 1/(2*10^(SNR_dB/10));
    noise = sqrt(noise_variance) * (randn(N, 1) + 1j * randn(N, 1));
    
    % Received signal with noise
    rx_signal = exp(1j * true_phase) + noise; % Use a single reference for variance calculation
    
    % ML phase estimation
    estimated_phase = angle(sum(rx_signal));
    
    % Phase error variance
    phase_error_variance(idx) = var(angle(rx_signal) - true_phase);
end

% Plot the phase error variance as a function of SNR
figure;
plot(SNR_dB_range, phase_error_variance);
xlabel('SNR (dB)');
ylabel('Phase Error Variance');
title('Effect of Noise on Phase Estimation');

% 5. Decision-Directed and Non-Decision-Directed Loops
phase_error_dd = zeros(N, 1); % Decision-directed phase error
phase_error_ndd = zeros(N, 1); % Non-decision-directed phase error
estimated_phase_dd = zeros(N, 1);
estimated_phase_ndd = zeros(N, 1);

% Initialization
current_phase_estimate_dd = 0;
current_phase_estimate_ndd = 0;

for n = 1:N
    % Simulate received signal with phase offset and noise
    noise = (1/sqrt(2*10^(SNR_dB))) * (randn + 1j * randn);
    rx_signal = tx_signal(n) * exp(1j * true_phase) + noise;

    % Decision-Directed (DD) Loop
    detected_symbol = exp(1j * round(angle(rx_signal) * M / (2 * pi)) * 2 * pi / M); % Symbol detection
    phase_error_dd(n) = angle(detected_symbol * exp(-1j * current_phase_estimate_dd)); 
    current_phase_estimate_dd = current_phase_estimate_dd + loop_bandwidth * phase_error_dd(n);
    estimated_phase_dd(n) = current_phase_estimate_dd;

    % Non-Decision-Directed (NDD) Loop
    phase_error_ndd(n) = angle(rx_signal * exp(-1j * current_phase_estimate_ndd));
    current_phase_estimate_ndd = current_phase_estimate_ndd + loop_bandwidth * phase_error_ndd(n);
    estimated_phase_ndd(n) = current_phase_estimate_ndd;
end

% Plot the results for DD and NDD loops
figure;
subplot(2, 1, 1);
plot(1:N, estimated_phase_dd);
title('Decision-Directed Phase Estimate');
xlabel('Samples');
ylabel('Estimated Phase (radians)');

subplot(2, 1, 2);
plot(1:N, estimated_phase_ndd);
title('Non-Decision-Directed Phase Estimate');
xlabel('Samples');
ylabel('Estimated Phase (radians)');
