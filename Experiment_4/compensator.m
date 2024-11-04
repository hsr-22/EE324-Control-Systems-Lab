% % Define parameters
% C1 = 157e-9; % Capacitance value for C1
% C = 220e-9;  % Capacitance value for C
% R1 = 10e3; % Resistance value for R1
% R = 0.39e6;  % Resistance value for R
% R3 = 10e6; % Resistance value for R3
% R2 = 51e3; % Resistance value for R2
% Q = 0.5;  % Quality factor Q
% r = 1e3;  % Parameter r
% 
% % Numerator coefficients
% num = [(C1/C)^2, (1/C) * (1/R1 - r/(R * R3)), 1/(C^2 * R * R2)];
% 
% % Denominator coefficients
% denom = [1, 1/(Q * C * R), 1/(C^2 * R^2)];
% 
% % Transfer function
% T = tf(num, denom);
% 
% bodeplot(T);
% 
% % Frequency for cursor in rad/s
% cursor_frequency = 2 * pi * 100;
% 
% % Add cursor line
% hold on;
% xline(cursor_frequency, 'r--', 'LineWidth', 1.5, 'Label', sprintf('\\omega = %.1f rad/s', cursor_frequency));
% hold off;
% 
% % Adjust plot properties
% setoptions(bodeplot, 'FreqUnits', 'rad/s', 'Grid', 'on');

% Define parameters
C1 = 150e-12; % Capacitance value for C1
C = 150e-12;  % Capacitance value for C
R1 = 330e3;   % Resistance value for R1
R = 10e6;  % Resistance value for R
R3 = 100;   % Resistance value for R3
R2 = 100e3;   % Resistance value for R2
Q = 0.5;     % Quality factor Q
r = 1e3;     % Parameter r

% Numerator coefficients
num = [(C1/C)^2, (1/C) * (1/R1 - r/(R * R3)), 1/(C^2 * R * R2)];

% Denominator coefficients
denom = [1, 1/(Q * C * R), 1/(C^2 * R^2)];

% Transfer function
T = tf(num, denom);

% Create Bode plot
[mag, phase, w] = bode(T);
w = w(:); % Convert to a column vector
mag = squeeze(20*log10(mag)); % Convert to dB and reshape for plotting
phase = squeeze(phase); % Reshape for plotting

% Plot magnitude response
figure;
subplot(2,1,1);
semilogx(w, mag, 'b');
xlabel('Frequency (rad/s)');
ylabel('Magnitude (dB)');
grid on;
title('Bode Plot');

% Plot cursor line for magnitude plot
hold on;
cursor_frequency = 2 * pi * 100; % Frequency for cursor in rad/s
yline = interp1(w, mag, cursor_frequency); % Interpolate to find the magnitude at cursor frequency
plot(cursor_frequency, yline, 'ro', 'MarkerSize', 6, 'DisplayName', sprintf('\\omega = %.1f rad/s', cursor_frequency));
hold off;

% Plot phase response
subplot(2,1,2);
semilogx(w, phase, 'b');
xlabel('Frequency (rad/s)');
ylabel('Phase (degrees)');
grid on;

% Plot cursor line for phase plot
hold on;
yline_phase = interp1(w, phase, cursor_frequency); % Interpolate to find the phase at cursor frequency
plot(cursor_frequency, yline_phase, 'ro', 'MarkerSize', 6, 'DisplayName', sprintf('\\omega = %.1f rad/s', cursor_frequency));
hold off;
