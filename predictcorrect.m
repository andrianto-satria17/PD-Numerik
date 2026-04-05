% 1. Definisi Parameter
R = 10;
L = 2;
E0 = 40;
h = 0.1;  % Step size
t_start = 0;
t_end = 20;
I0 = 0;

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
fprintf('%3s | %4s | %15s | %15s | %15s | %15s\n', 'n', 't', 'Predictor (I*)', 'Corrector (I)', 'I_Eksak', 'Abs Error');
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
plot(t_values, I_exact, 'Color', [0.7 0.7 0.7], 'LineWidth', 4);

% B. Plot Predictor (Garis putus-putus merah dengan marker bundar)
plot(t_values, I_predict_list, 'r--o', 'MarkerSize', 4, 'LineWidth', 1);

% C. Plot Corrector (Garis biru solid dengan marker persegi)
plot(t_values, I_numeric, 'b-s', 'MarkerSize', 5, 'LineWidth', 1.5);

% Dekorasi Grafik
title('Perbandingan solusi eksak, predictor, korektor', 'FontSize', 14);
xlabel('Waktu (t)', 'FontSize', 12);
ylabel('Arus (I)', 'FontSize', 12);
ylim([0, 2.5]); % Mengatur batas sumbu Y dari 0 sampai 3

% Legenda
legend('I(solusi eksak)', 'I(predictor)', 'I(corrector)', 'Location', 'best');
grid on;
hold off;

% --- TAMBAHAN: VISUALISASI GRAFIK ERROR --- tidak wajib masuk dokumen
% Membuat jendela grafik baru (Figure 2) khusus untuk error
figure('Position', [150, 150, 800, 400]);

% Menghitung seluruh error sekaligus dari array yang sudah ada
error_array = abs(I_exact - I_numeric);

% Plot grafik error
plot(t_values, error_array, 'm-o', 'LineWidth', 1.5, 'MarkerSize', 4);

% Dekorasi Grafik Error
title('Grafik Error Absolut (Prediktor-Korektor)', 'FontSize', 14);
xlabel('Waktu (t)', 'FontSize', 12);
ylabel('Nilai Error Absolut', 'FontSize', 12);
grid on;
