clear all;
clc;
N = 10^5; %Number of symbols to transmit
MOD_TYPE = 'PAM'; %modulation type
M = 4; %modulation level for the chosen modulation MOD_TYPE
d = ceil(M.*rand(1,N)); %random numbers from 1 to M for input to PAM
u = modulate(MOD_TYPE,M,d);%MPAM modulation
figure; stem(real(u)); %plot modulated symbols
title('PAM modulated symbols u(k)');
xlim([0 20])
ylim([-5 5])

L=4; %Oversampling factor (L samples per symbol period)
v=[u;zeros(L-1,length(u))];%insert L-1 zero between each symbols
%Convert to a single stream
v=v(:).';%now the output is at sampling rate
figure;stem(real(v)); title('Oversampled symbols v(n)');
xlim([0 150])
ylim([-5 5])

%----Pulse shaping-----
beta = 0.3;% roll-off factor for Tx SRRC filter
Nsym=8;%SRRC filter span in symbol durations
L=4; %Oversampling factor (L samples per symbol period)
[p,t,filtDelay] = srrcFunction(beta,L,Nsym);%design filter
s=conv(v,p,'full');%Convolve modulated syms with p[n] filter
figure; plot(real(s),'r'); title('Pulse shaped symbols s(n)');
xlim([0 150])
ylim([-5 5])

EbN0dB = 1000; %EbN0 in dB for AWGN channel
snr = 10*log10(log2(M))+EbN0dB; %Converting given Eb/N0 dB to SNR
%log2(M) gives the number of bits in each modulated symbol
r = add_awgn_noise(s,snr,L); %AWGN , add noise for given SNR, r=s+w
%L is the oversampling factor used in simulation
figure; plot(real(r),'r');title('Received signal r(n)');
xlim([0 150])
ylim([-5 5])


vCap=conv(r,p,'full');%convolve received signal with Rx SRRC filter
figure; plot(real(vCap),'r');
title('After matched filtering $\hat{v}$(n)','Interpreter','Latex');
xlim([0 150])
ylim([-20 20])

%------Symbol rate Sampler-----
uCap = vCap(2*filtDelay+1:L:end-(2*filtDelay))/L;
%downsample by L from 2*filtdelay+1 position result by normalized L,
%as the matched filter result is scaled by L
figure; stem(real(uCap)); hold on;
title('After symbol rate sampler $\hat{u}$(n)',...
'Interpreter','Latex');
dCap = demodulate(MOD_TYPE,M,uCap); %demodulation
xlim([0 20])
ylim([-5 5])


%plot eye at the receiver after matched filtering
figure; 
plotEyeDiagram(vCap,L,3*L,2*filtDelay,100);
xlim([0 3])
ylim([-15 15])
