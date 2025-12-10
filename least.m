clc; clear; close all;

% --- 1. VERİ GİRİŞİ (Görseldeki "Table 1. RTD Results" verileri) ---
% Time (s)
t = [1; 5; 10; 15; 20; 25; 30; 35; 40; 45; 50; 55; 60; 65; 70; 75; 80; ...
     85; 90; 95; 100; 105; 110; 115; 120; 125; 130; 135; 140; 145; 150; ...
     155; 160; 165; 170; 175; 180; 185; 190; 195; 200; 205; 210; 215; ...
     220; 225; 230];

% Temp (Celsius)
T = [25.166; 32.360; 33.864; 76.424; 91.004; 120.418; 124.559; 131.804; ...
     136.002; 143.332; 148.003; 152.660; 155.579; 157.971; 159.031; ...
     161.630; 162.560; 163.651; 164.492; 165.516; 165.741; 166.208; ...
     166.808; 167.166; 167.784; 167.788; 168.051; 168.308; 168.529; ...
     168.673; 168.833; 168.999; 169.079; 169.264; 169.319; 169.470; ...
     169.508; 169.552; 169.603; 169.710; 169.771; 169.842; 169.897; ...
     169.974; 169.999; 170.040; 170.044];

% --- 2. DOĞRUSALLAŞTIRMA (Linearization) ---
% Modelimiz: T = a * t^b
% Logaritma alarak: ln(T) = ln(a) + b * ln(t)
% Bu denklem Y = A0 + A1 * X formuna dönüşür.

n = length(t);      % Veri sayısı
X = log(t);         % ln(Time)
Y = log(T);         % ln(Temp)

% --- 3. MATRİS ELEMANLARININ HESAPLANMASI (Least Squares) ---
sum_X = sum(X);
sum_Y = sum(Y);
sum_XX = sum(X.^2); % x kareler toplamı
sum_XY = sum(X.*Y); % x*y çarpımları toplamı

% --- 4. MATRİS ÇÖZÜMÜ ---
% Denklem Sistemi: [Matris] * [Katsayılar] = [Sonuç]
% | n      sum_X  |   | A0 |   | sum_Y  |
% | sum_X  sum_XX | * | A1 | = | sum_XY |

M = [n, sum_X; sum_X, sum_XX];  % Katsayılar Matrisi
R = [sum_Y; sum_XY];            % Sonuç Vektörü

Coeffs = M \ R;  % Matris tersi ile çözüm (inv(M)*R)

A0 = Coeffs(1); % ln(a)
A1 = Coeffs(2); % b (üs)

% --- 5. ORİJİNAL KATSAYILARA DÖNÜŞ ---
a = exp(A0);    % ln(a)'dan a'yı bulma
b = A1;         % b zaten direkt eğimdir

% Sonuçları Ekrana Yazdır
fprintf('------------------------------------------------\n');
fprintf('LEAST SQUARES SONUÇLARI (Power Model: y = a*x^b)\n');
fprintf('------------------------------------------------\n');
fprintf('Hesaplanan a değeri: %.4f\n', a);
fprintf('Hesaplanan b değeri: %.4f\n', b);
fprintf('MODEL DENKLEMİ: T = %.4f * t^(%.4f)\n', a, b);
fprintf('------------------------------------------------\n');

% --- 6. GRAFİK ÇİZİMİ ---
T_model = a * (t.^b); % Bulunan katsayılarla modelin tahmini

figure;
plot(t, T, 'ko', 'MarkerFaceColor', 'b', 'MarkerSize', 6); hold on; % Gerçek Veriler
plot(t, T_model, 'r-', 'LineWidth', 2); % Model Eğrisi
grid on;
xlabel('Time (s)');
ylabel('Temp (Celsius)');
title(['Least Squares Fit: T = ' num2str(a,'%.3f') ' * t^{' num2str(b,'%.3f') '}']);
legend('Table 1 RTD Data', 'Fitted Model (y=ax^b)', 'Location', 'southeast');