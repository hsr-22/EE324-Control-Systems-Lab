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
gain1 = [-6.673982248
-7.529021857
-9.928528198
-10.7563819
-11.2019098
-11.2019098
-10.54190459
-10.33259592
-9.542425094
-9.355624569
-7.090985028
-6.147403474
-7.074726924
-8.966990243
-7.870016883
-9.264897025
-8.786653877
-7.398225701
-6.135646491
-5.684329933
-5.162035902
-4.762614284
-4.665564228
-4.380755446
-5.368852569
-7.245993048]; % Gain (magnitude in dB) for system 1
phase1 = [59.8
2.88
-13
-18.7
-21.8
-15.1
-13.5
-12.9
-25.3
-16.3
-37.8
-60.4
-83.7
-94
-104
-118
-133
-141
-157
-178
-198
-223
-248
-275.2
-308.1
-340.6]; % Phase (degrees) for system 1
gain2 = [7.432221399
5.494021139
3.17434326
1.728891587
0
-1.087153246
-0.903934975
-0.802344464
-0.984360453
-0.802344464
0.496471675
0.496471675
-1.289159785
-3.326628435
-2.670778167
-3.025353507
-3.272928792
-2.039790771
-0.837843227
-0.102792793
0
0.394881164
0.399421619
0.394881164
-0.837843227
-3.025353507]; % Gain (magnitude in dB) for system 2
phase2 = [44
-51
-107
-75
-130.8
-84.9
-134.6
-96.6
-135.4
-111.9
-129.5
-153.1
-178.25
-181.96
-181.16
-185.41
-186.94
-195.1
-208.6
-220.3
-236.7
-257.1
-270.6
-293
-321
-351]; % Phase (degrees) for system 2
gain3 = [7.432221399
6.577181791
4.177675449
3.349821746
2.904293852
2.904293852
3.564299054
3.773607727
4.563778553
4.750579078
7.01521862
7.958800173
7.031476724
5.139213404
6.236186764
4.841306623
5.319549771
6.707977946
7.970557156
8.421873714
8.944167745
9.343589364
9.440639419
9.725448202
8.737351078
6.860210599];

% Create a new figure
figure;

% Plot the magnitude (gain) for both systems
subplot(2, 1, 1); % Top plot for magnitude
semilogx(frequencies, gain1, '-o', 'Color', [0 0 0.5], 'LineWidth', 1, 'DisplayName', 'Uncompensated Plant'); % Plot System 1 gain
hold on;
semilogx(frequencies, gain2, '-x', 'Color', [0.85 0.33 0], 'LineWidth', 1, 'DisplayName', 'Compensated Plant'); % Plot System 2 gain
semilogx(frequencies, gain3, '--', 'Color', [0 0 0.3], 'LineWidth', 1, 'DisplayName', 'Amplified Plant'); % Plot System 1 gain
% Add a bold 0 dB line using plot (for compatibility)
plot([frequencies(1),10^4], [0, 0], 'k', 'LineWidth', 0.5, 'DisplayName', '0 dB');

hold off;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Bode Plot - Magnitude');
legend;
grid on;

% Plot the phase for both systems
subplot(2, 1, 2); % Bottom plot for phase
semilogx(frequencies, phase1, '-o', 'Color', [0 0 0.5], 'LineWidth', 1, 'DisplayName', 'Uncompensated Plant'); % Plot System 1 phase
hold on;
semilogx(frequencies, phase2, '-x', 'Color', [0.85 0.33 0], 'LineWidth', 1, 'DisplayName', 'Compensated Plant'); % Plot System 2 phase
hold off;
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
title('Bode Plot - Phase');
legend;
grid on;
