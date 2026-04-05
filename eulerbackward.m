% 1. Definisi Parameter
h = 0.1;  % Step size
t_start = 0;
t_end = 20;
I0 = 0;

% Solusi Eksak/Analitik
exact_solution = @(t) 20 * (exp(-4 * t) - exp(-5 * t));

% 2. Persiapan Data
t_values = t_start:h:t_end;
N = length(t_values);

% Pre-alokasi array
I_implicit = zeros(1, N);
I_exact = exact_solution(t_values);

% Kondisi awal
I_implicit(1) = I0;

% 3. Proses Hitung & Tabel
% Header Tabel
fprintf('%3s | %4s | %15s | %15s | %15s\n', 'n', 't', 'I_implisit', 'I_exact', 'Abs Error');
fprintf('%s\n', repmat('-', 1, 64));

% Baris pertama (Kondisi Awal t=0)
error_awal = abs(I_exact(1) - I_implicit(1));
fprintf('%3d | %4.1f | %15.6f | %15.6f | %15.6f\n', 0, t_values(1), I_implicit(1), I_exact(1), error_awal);

% Loop Backward Euler
for i = 1:(N-1)
    tn_next = t_values(i+1);
    In = I_implicit(i);

    % Rumus Euler Implisit hasil manipulasi aljabar
    I_next = (In + 20 * h * exp(-4 * tn_next)) / (1 + 5 * h);

    I_implicit(i+1) = I_next;

    % Hitung Error
    error_n = abs(I_exact(i+1) - I_next);

    % Cetak hasil
    fprintf('%3d | %4.1f | %15.6f | %15.6f | %15.6f\n', i, tn_next, I_next, I_exact(i+1), error_n);
end

% 4. Visualisasi Data
figure('Position', [100, 100, 800, 500]);
hold on;

% Plot Solusi Eksak (Garis tebal abu-abu)
plot(t_values, I_exact, 'Color', [0.7 0.7 0.7], 'LineWidth', 4);

% Plot Solusi Implisit (Garis merah solid dengan marker bulat)
plot(t_values, I_implicit, 'r-o', 'MarkerSize', 5, 'LineWidth', 1.5);

% Dekorasi Grafik
title('Metode Euler Implisit (Euler Implisit)', 'FontSize', 14);
xlabel('Waktu (t)', 'FontSize', 12);
ylabel('Arus (I)', 'FontSize', 12);
legend('I(solusi eksak)', 'I(euler implisit)', 'Location', 'best');   %menuliskan legenda/petunjuk
grid on;
hold off;

% --- TAMBAHAN: VISUALISASI GRAFIK ERROR --- tidak wajib masuk dokumen
% Membuat jendela grafik baru (Figure 2) khusus untuk error
figure('Position', [150, 150, 800, 400]);

% Menghitung seluruh error sekaligus (menggunakan I_implicit)
error_array = abs(I_exact - I_implicit);

% Plot grafik error
plot(t_values, error_array, 'm-o', 'LineWidth', 1.5, 'MarkerSize', 4);

% Dekorasi Grafik Error
title('Grafik Error Absolut (Euler Implisit)', 'FontSize', 14);
xlabel('Waktu (t)', 'FontSize', 12);
ylabel('Nilai Error Absolut', 'FontSize', 12);
grid on;
