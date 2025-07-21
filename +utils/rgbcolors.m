function colors = rgbcolors()

% Function to extract colors based on RGB codes.
% Inputs:
% none.
% Outputs:
%   colors: struct of colors and colormaps.

% Define dark colors
colors.blue = [31, 120, 180] ./ 255; % #1F78B4
colors.red = [227, 26, 28] ./ 255; % #E31A1C
colors.green = [51, 160, 44] ./ 255; % #33A02C
colors.orange = [255, 127, 0] ./ 255; % #FF7F00
colors.pink = [208, 28, 139] ./ 255; % #D01C8B
colors.purple = [106, 61, 154] ./ 255; % #6A3D9A
colors.yellow = [237, 177, 32] ./ 255;
colors.teal = [1, 133, 113] ./ 255;
colors.brown = [166, 97, 26] ./ 255;
colors.black = [0, 0, 0]; % #000000
colors.turquoise = [19, 216, 212] ./ 255;

colors.dark_blue = [8, 48, 107] ./ 255;
colors.dark_red = [103, 0, 13] ./ 255;

% Define light colors
colors.light_blue = [166, 206, 227] ./ 255; % #A6CEE3
colors.light_red = [251, 154, 153] ./ 255; % #FB9A99
colors.light_green = [178, 223, 138] ./ 255; % #B2DF8A
colors.light_orange = [253, 191, 111] ./ 255; % #FDBF6F
colors.light_pink = [241, 182, 218] ./ 255; % #F1B6DA
colors.light_purple = [202, 178, 214] ./ 255; % #CAB2D6
colors.light_yellow = [253, 244, 163] ./ 255;
colors.light_teal = [128, 205, 193] ./ 255;
colors.light_brown = [223, 194, 125] ./ 255;
colors.grey = [0.75, 0.75, 0.75]; % 

colors.white = [1, 1, 1];

% Define vectors of dark and light colors
colors.darkcolors = [colors.blue; colors.red; colors.yellow; colors.green; colors.pink; colors.purple; colors.teal];
colors.lightcolors = [colors.light_blue; colors.light_red; colors.light_yellow; colors.light_green; colors.light_pink; colors.light_purple; colors.light_teal];

end