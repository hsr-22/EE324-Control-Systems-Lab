function interactive_bode_plot
    % Initial values for the constants
    C1 = 1e-9;    % 1 nF
    C = 1e-9;     % 1 nF
    R1 = 10e3;    % 10 kΩ
    R2 = 51.6e3;  % 51.6 kΩ
    R = 1e6;      % 1 MΩ
    R3 = 10e6;    % 10 MΩ
    r = 998;      % 998 Ω
    Q = 0.5;      % Example quality factor

    % Create the figure and sliders
    fig = figure('Name', 'Interactive Bode Plot', 'NumberTitle', 'off');
    
    % Axes for the Bode plot
    ax = axes('Position', [0.1 0.3 0.8 0.6]);
    
    % Plot the initial Bode plot
    update_plot(C1, C, R1, R2, R, R3, r, Q, ax);

    % Slider for C1
    uicontrol('Style', 'text', 'Position', [20 220 60 20], 'String', 'C1 (pF)');
    C1_slider = uicontrol('Style', 'slider', 'Min', 1e-9, 'Max', 10e-9, 'Value', C1, 'Position', [100 220 200 20]);
    C1_value = uicontrol('Style', 'text', 'Position', [310 220 60 20], 'String', num2str(C1 * 1e12, '%.2f pF'));  % Text to display C1 value

    % Slider for C
    uicontrol('Style', 'text', 'Position', [20 180 60 20], 'String', 'C (nF)');
    C_slider = uicontrol('Style', 'slider', 'Min', 1e-9, 'Max', 10e-9, 'Value', C, 'Position', [100 180 200 20]);
    C_value = uicontrol('Style', 'text', 'Position', [310 180 60 20], 'String', num2str(C * 1e9, '%.2f nF'));  % Text to display C value

    % Slider for R1
    uicontrol('Style', 'text', 'Position', [20 140 60 20], 'String', 'R1 (kΩ)');
    R1_slider = uicontrol('Style', 'slider', 'Min', 1e3, 'Max', 100e3, 'Value', R1, 'Position', [100 140 200 20]);
    R1_value = uicontrol('Style', 'text', 'Position', [310 140 60 20], 'String', num2str(R1 / 1e3, '%.2f kΩ'));  % Text to display R1 value

    % Slider for R2
    uicontrol('Style', 'text', 'Position', [20 100 60 20], 'String', 'R2 (kΩ)');
    R2_slider = uicontrol('Style', 'slider', 'Min', 1e3, 'Max', 100e3, 'Value', R2, 'Position', [100 100 200 20]);
    R2_value = uicontrol('Style', 'text', 'Position', [310 100 60 20], 'String', num2str(R2 / 1e3, '%.2f kΩ'));  % Text to display R2 value

    % Slider for R
    uicontrol('Style', 'text', 'Position', [20 60 60 20], 'String', 'R (MΩ)');
    R_slider = uicontrol('Style', 'slider', 'Min', 0.1e6, 'Max', 10e6, 'Value', R, 'Position', [100 60 200 20]);
    R_value = uicontrol('Style', 'text', 'Position', [310 60 60 20], 'String', num2str(R / 1e6, '%.2f MΩ'));  % Text to display R value

    % Slider for R3
    uicontrol('Style', 'text', 'Position', [20 20 60 20], 'String', 'R3 (MΩ)');
    R3_slider = uicontrol('Style', 'slider', 'Min', 1e6, 'Max', 100e6, 'Value', R3, 'Position', [100 20 200 20]);
    R3_value = uicontrol('Style', 'text', 'Position', [310 20 60 20], 'String', num2str(R3 / 1e6, '%.2f MΩ'));  % Text to display R3 value

    % Update function call with the sliders and labels
    addlistener(C1_slider, 'Value', 'PreSet', @(src, event) update_plot(get(C1_slider, 'Value'), C, R1, R2, R, R3, r, Q, ax, C1_value, C_value, R1_value, R2_value, R_value, R3_value));
    addlistener(C_slider, 'Value', 'PreSet', @(src, event) update_plot(C1, get(C_slider, 'Value'), R1, R2, R, R3, r, Q, ax, C1_value, C_value, R1_value, R2_value, R_value, R3_value));
    addlistener(R1_slider, 'Value', 'PreSet', @(src, event) update_plot(C1, C, get(R1_slider, 'Value'), R2, R, R3, r, Q, ax, C1_value, C_value, R1_value, R2_value, R_value, R3_value));
    addlistener(R2_slider, 'Value', 'PreSet', @(src, event) update_plot(C1, C, R1, get(R2_slider, 'Value'), R, R3, r, Q, ax, C1_value, C_value, R1_value, R2_value, R_value, R3_value));
    addlistener(R_slider, 'Value', 'PreSet', @(src, event) update_plot(C1, C, R1, R2, get(R_slider, 'Value'), R3, r, Q, ax, C1_value, C_value, R1_value, R2_value, R_value, R3_value));
    addlistener(R3_slider, 'Value', 'PreSet', @(src, event) update_plot(C1, C, R1, R2, R, get(R3_slider, 'Value'), r, Q, ax, C1_value, C_value, R1_value, R2_value, R_value, R3_value));
end

function update_plot(C1, C, R1, R2, R, R3, r, Q, ax, varargin)
    % If additional arguments for labels are provided, update them
    if ~isempty(varargin)
        C1_label = varargin{1};
        C_label = varargin{2};
        R1_label = varargin{3};
        R2_label = varargin{4};
        R_label = varargin{5};
        R3_label = varargin{6};

        % Update the text labels for the slider values
        set(C1_label, 'String', num2str(C1 * 1e12, '%.2f pF'));  % Update C1 value label
        set(C_label, 'String', num2str(C * 1e9, '%.2f nF'));      % Update C value label
        set(R1_label, 'String', num2str(R1 / 1e3, '%.2f kΩ'));    % Update R1 value label
        set(R2_label, 'String', num2str(R2 / 1e3, '%.2f kΩ'));    % Update R2 value label
        set(R_label, 'String', num2str(R / 1e6, '%.2f MΩ'));      % Update R value label
        set(R3_label, 'String', num2str(R3 / 1e6, '%.2f MΩ'));    % Update R3 value label
    end

    % Define the numerator and denominator of the transfer function
    numerator = [(C1/C)^2, (1/C)*(1/R1 - r/(R*R3)), 1/(C^2*R*R2)];
    denominator = [1, 1/(Q*C*R), 1/(C^2*R^2)];

    % Create the transfer function
    sys = tf(numerator, denominator);

    % Clear the current plot
    cla(ax);

    % Plot the updated Bode plot
    bode(ax, sys);
    grid on;
end
