clc; clear all;% Parameters
num_bits = 20;                     % Number of bits
samples_per_bit = 120;             % Samples per bit
num_carriers = 6;                  % Number of carrier frequencies
samples = [10, 20, 30, 40, 60, 120]; % Samples for each carrier frequency

% Manual Entry of Bit Sequence
disp('Enter your bit sequence as a series of 1s and 0s separated by spaces (e.g., "1 0 1 1 0"):');
manual_input = input('', 's'); % Take input as a string
bit_sequence = str2num(manual_input); % Convert to numeric array

if length(bit_sequence) ~= num_bits
    error('The number of bits entered must match the defined number of bits (%d).', num_bits);
end
% Convert 0 -> -1, 1 -> +1 for BPSK
sequence = 2 * bit_sequence - 1;
% Repeat bits for the bit duration
input_signal = repelem(sequence, samples_per_bit); % Repeat for bit duration

% Generate Carrier Signal with Exact Length
t_carrier = linspace(0, 2*pi*num_bits, samples_per_bit*num_bits); % Time vector
carrier_signal = cos(t_carrier); % Continuous cosine carrier wave

% Plot Original Bit Sequence
figure(1);
subplot(4,1,1); plot(input_signal); axis([-100 2400 -1.5 1.5]);
title('\bf\it Original Bit Sequence');

% BPSK Modulation
bpsk_mod_signal = input_signal .* carrier_signal;
subplot(4,1,2); plot(bpsk_mod_signal); axis([-100 2400 -1.5 1.5]);
title('\bf\it BPSK Modulated Signal');

% Generate 6 Carrier Frequencies
carriers = cell(1, num_carriers);
for i = 1:num_carriers
    t = linspace(0, 2*pi, samples(i) + 1); t(end) = []; % Time for each carrier
    carriers{i} = repmat(cos(t), 1, ceil(samples_per_bit / length(t)));
    carriers{i} = carriers{i}(1:samples_per_bit); % Trim to exact length
end

% Spread Signal with Random Carrier Frequencies
spread_signal = [];
for i = 1:num_bits
    carrier_idx = randi([1, num_carriers]); % Randomly select a carrier
    spread_signal = [spread_signal carriers{carrier_idx}];
end
subplot(4,1,3); plot(spread_signal); axis([-100 2400 -1.5 1.5]);
title('\bf\it Spread Signal with 6 frequencies');

% Spreading BPSK Signal
freq_hopped_sig = bpsk_mod_signal .* spread_signal;
subplot(4,1,4); plot(freq_hopped_sig); axis([-100 2400 -1.5 1.5]);
title('\bf\it Frequency Hopped Spread Spectrum Signal');

% Demodulation
bpsk_demodulated = freq_hopped_sig ./ spread_signal;
figure(2);
subplot(2,1,1); plot(bpsk_demodulated); axis([-100 2400 -1.5 1.5]);
title('\bf Demodulated BPSK Signal from Wide Spread');

% Recover Original Bit Sequence
original_BPSK_signal = bpsk_demodulated ./ carrier_signal;
subplot(2,1,2); plot(original_BPSK_signal); axis([-100 2400 -1.5 1.5]);
title('\bf Transmitted Original Bit Sequence');
