import numpy as np
import matplotlib.pyplot as plt

# 1. Definisi Parameter
R = 10
L = 2
E0 = 40
h = 0.1  # Step size
t_start = 0
t_end = 2
I0 = 0

def f(t, I):
    return 20 * np.exp(-4 * t) - 5 * I

def exact_solution(t):
    return 20 * (np.exp(-4 * t) - np.exp(-5 * t))

# 2. Persiapan Data
t_values = np.arange(t_start, t_end + h, h)
I_numeric = np.zeros(len(t_values)) # Ini adalah hasil Corrector (final)
I_predict_list = [I0]               # Untuk menyimpan histori Predictor
I_exact = [exact_solution(t) for t in t_values]

I_numeric[0] = I0

# 3. Proses Hitung & Tabel
print(f"{'t':>4} | {'Predictor (I*)':>15} | {'Corrector (I)':>15} | {'Eksak':>15}")
print("-" * 59)
print(f"{t_values[0]:4.1f} | {'-':>15} | {I_numeric[0]:15.6f} | {I_exact[0]:15.6f}")

for n in range(len(t_values) - 1):
    tn = t_values[n]
    In = I_numeric[n]
    tn_next = t_values[n+1]
    
    # Predictor (Euler)
    slope_n = f(tn, In)
    I_pred = In + h * slope_n
    I_predict_list.append(I_pred)
    
    # Corrector (Trapezoidal/Heun)
    slope_next = f(tn_next, I_pred)
    I_corr = In + (h / 2) * (slope_n + slope_next)
    I_numeric[n+1] = I_corr
    
    print(f"{tn_next:4.1f} | {I_pred:15.6f} | {I_corr:15.6f} | {I_exact[n+1]:15.6f}")

# 4. Visualisasi Data (SEMUA DALAM SATU GRAFIK)
plt.figure(figsize=(10, 6)) # Membuat satu frame grafik

# A. Plot Solusi Eksak (Garis hitam tebal abu-abu sebagai referensi utama)
plt.plot(t_values, I_exact, 
         color='black', linestyle='-', linewidth=4, alpha=0.3, 
         label='Solusi Eksak (Analitik)')

# B. Plot Predictor (Garis putus-putus merah dengan titik bundar)
# Ini menunjukkan di mana tebakan Euler berada sebelum dikoreksi
plt.plot(t_values, I_predict_list, 
         color='red', linestyle='--', marker='o', markersize=4, linewidth=1, 
         label='Predictor (Euler Step - Kasar)')

# C. Plot Corrector (Garis biru solid dengan marker persegi)
# Ini adalah hasil akhir yang seharusnya sangat dekat dengan Eksak
plt.plot(t_values, I_numeric, 
         color='blue', linestyle='-', marker='s', markersize=5, linewidth=1.5, 
         label='Corrector (Heun Method - Final)')

# Dekorasi Grafik
plt.title('Perbandingan: Eksak vs Predictor vs Corrector', fontsize=14)
plt.xlabel('Waktu (t)', fontsize=12)
plt.ylabel('Arus (I)', fontsize=12)
plt.legend(loc='best') # Menampilkan legenda
plt.grid(True, which='both', linestyle='--', alpha=0.5) # Menambahkan grid


# Menampilkan plot
plt.show()