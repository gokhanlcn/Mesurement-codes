clc; clear; close all;

% --- 1. VERİ GİRİŞİ (Table 2. Thermocouple Results) ---
% Time (s)
t = [1; 3; 6; 9; 12; 15; 18; 21; 24; 27; 30; 33; 36; 39; 42; 45; 48; ...
     51; 54; 57; 60; 63; 66; 69; 72; 75; 78; 81; 84; 87; 90];

% Thot (Celsius) - Sıcaklık verileri
T = [23.98; 127.80; 138.15; 141.85; 148.78; 152.50; 155.98; 159.73; ...
     161.48; 162.73; 163.95; 164.95; 165.70; 166.95; 167.20; 167.70; ...
     167.95; 168.45; 168.70; 168.95; 169.20; 169.20; 169.45; 169.70; ...
     169.95; 169.95; 169.95; 170.20; 170.20; 170.20; 170.20];

% --- 2. DOĞRUSALLAŞTIRMA (Linearization) ---
% Model: T = a * t^b  =>  ln(T) = ln(a) + b * ln(t)
% Y = A0 + A1 * X

n = length(t);
X = log(t);
Y = log(T);

% --- 3. MATRİS İÇİN TOPLAM HESAPLARI ---
sum_X = sum(X);
sum_Y = sum(Y);
sum_XX = sum(X.^2);
sum_XY = sum(X.*Y);

% --- 4. KATSAYILARIN HESAPLANMASI (Manuel Matris Çözümü) ---
% | n      sum_X  |   | A0 |   | sum_Y  |
% | sum_X  sum_XX | * | A1 | = | sum_XY |

M = [n, sum_X; sum_X, sum_XX];
R = [sum_Y; sum_XY];

% Matris Tersi Yöntemi ile Çözüm
Katsayilar = M \ R; 

A0 = Katsayilar(1); % ln(a)
A1 = Katsayilar(2); % b

% --- 5. SONUÇLARIN DÖNÜŞTÜRÜLMESİ ---
a = exp(A0);
b = A1;

% Ekrana Yazdır
fprintf('------------------------------------------------\n');
fprintf('THERMOCOUPLE SONUÇLARI (Model: y = a*x^b)\n');
fprintf('------------------------------------------------\n');
fprintf('Hesaplanan a değeri: %.4f\n', a);
fprintf('Hesaplanan b değeri: %.4f\n', b);
fprintf('MODEL DENKLEMİ: T = %.4f * t^(%.4f)\n', a, b);
fprintf('------------------------------------------------\n');

% --- 6. GRAFİK ÇİZİMİ ---
T_model = a * (t.^b);

figure;
plot(t, T, 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 6); hold on; % Termokupl Verisi (Kırmızı Nokta)
plot(t, T_model, 'b-', 'LineWidth', 2); % Model Çizgisi (Mavi)
grid on;
xlabel('Time (s)');
ylabel('Thot (°C)');
title(['Thermocouple Least Squares: T = ' num2str(a,'%.2f') ' * t^{' num2str(b,'%.3f') '}']);
legend('Table 2 Thermocouple Data', 'Fitted Model', 'Location', 'southeast');