%% LP
file = fopen('lp_2_3.txt');
LP = fscanf(file, '%f', [2 inf]);

%% LPCC
file = fopen('lpcc_2_3.txt');
LPCC = fscanf(file, '%f', [2 inf]);

%% MFCC
file = fopen('mfcc_2_3.txt');
MFCC = fscanf(file, '%f', [2 inf]);

%% PLOT
figure; 
plot(LP(1,:), LP(2,:), '.r');
title('Coeficientes [2][3] LP');
figure; 
plot(LPCC(1,:), LPCC(2,:), '.b');
title('Coeficientes [2][3] LPCC');
figure;
plot(MFCC(1,:), MFCC(2,:), '.g');
title('Coeficientes [2][3] MFCC');
