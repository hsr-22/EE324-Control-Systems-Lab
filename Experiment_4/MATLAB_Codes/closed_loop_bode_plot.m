% Sample data
frequencies = [100
200
300
400
500
600
700
800
900
1000
1250
1500
1750
2000
2250
2500
2750
3000
3250
3500
3750
4000
4250
4500
4750
5000]; % Frequency in Hz (log scale)
gain1 = [-6.547178688
-6.403606995
-6.97443972
-6.403606995
-7.146443155
-7.146443155
-6.841643824
-6.669640389
-6.23160356
-6.09036647
-4.553565866
-2.202765575
-1.350524706
-3.349821746
-2.662443713
-2.202765575
-2.475643188
-0.574483025
-0.500560114
-3.291066913
-4.791550332
-6.841643824
-8.130803609
-9.214616771
-10.28891155
-11.18181836]; % Gain (magnitude in dB) for system 1
phase1 = [34.5
31.6
45.2
-38.4
-47.1
-77.6
-92
-8.74
-73.9
-103
-44.8
-90.8
-92
-104
-162
-145
-170
-177
-197
-225
-260
-279.4
-286.8
-321.1
-322.5
-349.2]; % Phase (degrees) for system 1

% Create a new figure
figure;

% Plot the magnitude (gain) for both systems
subplot(2, 1, 1); % Top plot for magnitude
semilogx(frequencies, gain1, '-o', 'Color', [0 0 0.5], 'LineWidth', 1, 'DisplayName', 'Closed Loop Compensated Plant'); % Plot System 1 gain
hold on;
% Add a bold 0 dB line using plot (for compatibility)
plot([frequencies(1),10^4], [0, 0], 'k', 'LineWidth', 0.5, 'DisplayName', '0 dB');
hold off;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ylim([-12, 2]);
title('Bode Plot - Magnitude');
legend;
grid on;

% Plot the phase for both systems
subplot(2, 1, 2); % Bottom plot for phase
semilogx(frequencies, phase1, '-o', 'Color', [0.85 0.33 0], 'LineWidth', 1, 'DisplayName', 'Closed Loop Compensated Plant'); % Plot System 1 phase
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
title('Bode Plot - Phase');
legend;
grid on;
