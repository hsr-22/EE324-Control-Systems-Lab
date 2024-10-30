function interactive_bode_plot
    % Initial values for the constants
    a = 1;  % Example initial value for 'a'
    b = 2;  % Example initial value for 'b'
    c = 3;  % Example initial value for 'c'
    d = 4;  % Example initial value for 'd'
    k = 1;  % Example initial value for 'k'

    % Create the figure and sliders
    fig = figure('Name', 'Interactive Bode Plot', 'NumberTitle', 'off');
    
    % Axes for the Bode plot
    ax = axes('Position', [0.1 0.3 0.8 0.6]);
    
    % Plot the initial Bode plot
    update_plot(a, b, c, d, k, ax);

    % Slider for 'a'
    uicontrol('Style', 'text', 'Position', [20 220 60 20], 'String', 'a');
    a_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 3000, 'Value', a, 'Position', [100 220 600 20]);
    a_value = uicontrol('Style', 'text', 'Position', [910 220 60 20], 'String', num2str(a));  % Text to display 'a' value

    % Slider for 'b'
    uicontrol('Style', 'text', 'Position', [20 180 60 20], 'String', 'b');
    b_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 3000, 'Value', b, 'Position', [100 180 600 20]);
    b_value = uicontrol('Style', 'text', 'Position', [910 180 60 20], 'String', num2str(b));  % Text to display 'b' value

    % Slider for 'c'
    uicontrol('Style', 'text', 'Position', [20 140 60 20], 'String', 'c');
    c_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 3000, 'Value', c, 'Position', [100 140 600 20]);
    c_value = uicontrol('Style', 'text', 'Position', [910 140 60 20], 'String', num2str(c));  % Text to display 'c' value

    % Slider for 'd'
    uicontrol('Style', 'text', 'Position', [20 100 60 20], 'String', 'd');
    d_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 3000, 'Value', d, 'Position', [100 100 600 20]);
    d_value = uicontrol('Style', 'text', 'Position', [910 100 60 20], 'String', num2str(d));  % Text to display 'd' value

    % Slider for 'k'
    uicontrol('Style', 'text', 'Position', [20 60 60 20], 'String', 'k');
    k_slider = uicontrol('Style', 'slider', 'Min', -3, 'Max', 10, 'Value', k, 'Position', [100 60 600 20]);
    k_value = uicontrol('Style', 'text', 'Position', [910 60 60 20], 'String', num2str(k));  % Text to display 'k' value

    % Update function call with the sliders and labels
    addlistener(a_slider, 'Value', 'PreSet', @(src, event) update_plot(get(a_slider, 'Value'), get(b_slider, 'Value'), get(c_slider, 'Value'), get(d_slider, 'Value'), get(k_slider, 'Value'), ax, a_value, b_value, c_value, d_value, k_value));
    addlistener(b_slider, 'Value', 'PreSet', @(src, event) update_plot(get(a_slider, 'Value'), get(b_slider, 'Value'), get(c_slider, 'Value'), get(d_slider, 'Value'), get(k_slider, 'Value'), ax, a_value, b_value, c_value, d_value, k_value));
    addlistener(c_slider, 'Value', 'PreSet', @(src, event) update_plot(get(a_slider, 'Value'), get(b_slider, 'Value'), get(c_slider, 'Value'), get(d_slider, 'Value'), get(k_slider, 'Value'), ax, a_value, b_value, c_value, d_value, k_value));
    addlistener(d_slider, 'Value', 'PreSet', @(src, event) update_plot(get(a_slider, 'Value'), get(b_slider, 'Value'), get(c_slider, 'Value'), get(d_slider, 'Value'), get(k_slider, 'Value'), ax, a_value, b_value, c_value, d_value, k_value));
    addlistener(k_slider, 'Value', 'PreSet', @(src, event) update_plot(get(a_slider, 'Value'), get(b_slider, 'Value'), get(c_slider, 'Value'), get(d_slider, 'Value'), get(k_slider, 'Value'), ax, a_value, b_value, c_value, d_value, k_value));
end

function update_plot(a, b, c, d, k, ax, varargin)
    % If additional arguments for labels are provided, update them
    if ~isempty(varargin)
        a_label = varargin{1};
        b_label = varargin{2};
        c_label = varargin{3};
        d_label = varargin{4};
        k_label = varargin{5};

        % Update the text labels for the slider values
        set(a_label, 'String', num2str(a));  % Update 'a' value label
        set(b_label, 'String', num2str(b));  % Update 'b' value label
        set(c_label, 'String', num2str(c));  % Update 'c' value label
        set(d_label, 'String', num2str(d));  % Update 'd' value label
        set(k_label, 'String', num2str(k));  % Update 'k' value label
    end

    % Define the transfer function
    numerator = k * [1, (a + b), a*b];
    denominator = [1, (c + d), c*d];

    % Create the transfer function
    sys = tf(numerator, denominator);

    % Clear the current plot
    cla(ax);

    % Plot the updated Bode plot
    bode(ax, sys);
    grid on;
end
