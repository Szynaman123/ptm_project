close all; clear all; clc;

% create simple test signal
ts = 2e-5;      % [s]   sample time
tmax = 0.2-ts;  % [s]   signal duration
t = 0:ts:tmax;  % [s]   time vector
n = length(t);  % [-]   sample count

x = sin(2*pi*100*t) + 2*sin(2*pi*50*t) + 0.5*sin(2*pi*200*t); % [-]  test signal

% displaying input data
disp("Test signal:");
disp("x(t) = sin(2pi*100*t) + 2*sin(2pi*50*t) + 0.5*sin(2pi*200*t)\n");

% ploting result
subplot(3,1,1);
  plot(t, x); hold on; grid on;
  xlabel('Time [s]');
  ylabel('Amplitude');
  axis([0 tmax min(x)-0.1 max(x)+0.1]);

% compute discrete Fourier transform
fs = 1/ts;                % [Hz]    sampling frequency
f = (fs/n)*(-n/2:n/2-1);  % [Hz]   frequency vector

y = abs(fft(x, n));  % [-]    aplitude spectrum: sqrt(Re(F(x))^2 + Im(F(x))^2)
y = fftshift(y);     % [-]    shifted aplitude spectrum
y = y/n;             % [-]    scaled shifted aplitude spectrum

% ploting result
subplot(3,1,2);
  stem(f, y); hold on; grid on;
  axis([-250 250 0 1.1]);
  xlabel('Frequency [Hz]');
  ylabel('Amplitude');

% reconstructing orginal signal from DFT
x_approx = 0;  % [-]  test signal approximation 
A_th = 0.001;  % [-] aplitude threshold 

n_h = 0;   % [-]  harmonics counter
f_h = [];  % [Hz] harmonic frequencies vector
A_h = [];  % [-]  harmonic aplitudes vector

for i = n/2 : n;
  A_approx = 2*y(i);
  f_approx = f(i);  
  if (A_approx > A_th) % simple filtration by amplitude threshold 
    % add harmonic signal
    x_approx = x_approx + A_approx*sin(2*pi*f_approx*t);
    % save harmonic signal parameters
    n_h = n_h + 1;
    f_h = [f_h f_approx];
    A_h = [A_h A_approx];
  endif
endfor

% displaying approximation results
disp("Approximate signal:");
approx_result = "x(t) = ";
for h = 1 : n_h
  approx_result = [approx_result ...
                  [num2str(A_h(h),"%.1f") "*sin(2pi*" num2str(f_h(h)) "*t)"]];
  if (h != n_h)
    approx_result = [approx_result " + "];
  endif
endfor
disp([approx_result "\n"]);

% ploting result
subplot(3,1,3);
  plot(t, x); hold on; grid on;
  plot(t, x_approx);
  xlabel('Time [s]');
  ylabel('Amplitude');
  legend('test signal','approximation');
  axis([0 tmax min(x)-0.1 max(x)+0.1]);

