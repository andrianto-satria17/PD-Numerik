% 1. Definisi Parameter
R = 10;
L = 2;
E0 = 40;
h = 0.1;  % Step size
t_start = 0;
t_end = 4;
I0 = 0;

% Fungsi f(t, I) menggunakan "Anonymous Function" di Octave/MATLAB
f = @(t, I) 20 * exp(-4 * t) - 5 * I;

% Solusi Eksak/Analitik
exact_solution = @(t) 20 * (exp(-4 * t) - exp(-5 * t));

% 2. Persiapan Data
t_values = t_start:h:t_end;
N = length(t_values);

% Pre-alokasi array (berisi angka nol) untuk menyimpan data
I_numeric = zeros(1, N);
I_predict_list = zeros(1, N);
I_exact = exact_solution(t_values);

% Kondisi awal (Ingat: Indeks Octave dimulai dari 1)
I_numeric(1) = I0;
I_predict_list(1) = I0;

% 3. Proses Hitung & Tabel
% Header Tabel
fprintf('%3s | %4s | %15s | %15s | %15s | %15s\n', 'n', 't', 'Predictor (I*)', 'Corrector (I)', 'Eksak', 'Error');
fprintf('%s\n', repmat('-', 1, 81));

% Baris pertama (Kondisi Awal t=0)
error_awal = abs(I_exact(1) - I_numeric(1));
fprintf('%3d | %4.1f | %15s | %15.6f | %15.6f | %15.6f\n', 0, t_values(1), '-', I_numeric(1), I_exact(1), error_awal);

% Loop Predictor-Corrector
for i = 1:(N-1)
    tn = t_values(i);
    In = I_numeric(i);
    tn_next = t_values(i+1);

    % Predictor (Euler)
    slope_n = f(tn, In);
    I_pred = In + h * slope_n;
    I_predict_list(i+1) = I_pred;

    % Corrector (Trapezoidal/Heun)
    slope_next = f(tn_next, I_pred);
    I_corr = In + (h / 2) * (slope_n + slope_next);
    I_numeric(i+1) = I_corr;

    % Error
    error_n = abs(I_exact(i+1) - I_corr);

    % Cetak hasil (i akan bernilai 1 sampai 40, setara dengan langkah n=1 sampai 40)
    fprintf('%3d | %4.1f | %15.6f | %15.6f | %15.6f | %15.6f\n', i, tn_next, I_pred, I_corr, I_exact(i+1), error_n);
end

% 4. Visualisasi Data
figure('Position', [100, 100, 800, 500]); % Membuat jendela grafik
hold on; % Agar plot ditumpuk di satu grafik yang sama

% A. Plot Solusi Eksak (Garis tebal abu-abu/hitam transparan)
% Di Octave, kita gunakan warna abu-abu (RGB: [0.7 0.7 0.7]) agar menyerupai 'alpha' di Python
plot(t_values, I_exact, 'Color', [0.7 0.7 0.7], 'LineWidth', 4, 'DisplayName', 'Solusi Eksak/I\_exact');

% B. Plot Predictor (Garis putus-putus merah dengan marker bundar)
plot(t_values, I_predict_list, 'r--o', 'MarkerSize', 4, 'LineWidth', 1, 'DisplayName', 'I\_predictor');

% C. Plot Corrector (Garis biru solid dengan marker persegi)
plot(t_values, I_numeric, 'b-s', 'MarkerSize', 5, 'LineWidth', 1.5, 'DisplayName', 'I\_corrector');

% Dekorasi Grafik
title('Perbandingan solusi eksak, predictor, korektor', 'FontSize', 14);
xlabel('Waktu (t)', 'FontSize', 12);
ylabel('Arus (I)', 'FontSize', 12);

% Legenda dan Grid
legend('show', 'Location', 'best');
grid on;
hold off;
