import numpy as np
import matplotlib.pyplot as plt

# 1. Definisi Parameter
R = 10
L = 2
E0 = 40
h = 0.1  # Step size (delta t)
t_start = 0
t_end = 2
I0 = 0   # Arus awal

# Fungsi turunan: dI/dt = f(t, I)
def f(t, I):
    return 20 * np.exp(-4 * t) - 5 * I

# Solusi Eksak (Analitik)
def exact_solution(t):
    return 20 * (np.exp(-4 * t) - np.exp(-5 * t))

# 2. Inisialisasi Data
t_values = np.arange(t_start, t_end + h, h)
I_numeric = np.zeros(len(t_values))
I_numeric[0] = I0

# Header Tabel
print(f"{'t':>4} | {'Prediktor (I*)':>15} | {'Korektor (I)':>15} | {'Eksak':>15} | {'Error':>12}")
print("-" * 75)
# Baris pertama (t=0)
print(f"{t_values[0]:4.1f} | {'-':>15} | {I_numeric[0]:15.6f} | {exact_solution(0):15.6f} | {0:12.6f}")

# 3. Iterasi Metode Predictor-Corrector
for n in range(len(t_values) - 1):
    tn = t_values[n]
    In = I_numeric[n]
    tn_next = t_values[n+1]
    
    # --- PREDIKTOR (Euler Step) ---
    # I_pred = In + h * f(tn, In)
    slope_n = f(tn, In)
    I_pred = In + h * slope_n
    
    # --- KOREKTOR (Heun/Trapezoid Step) ---
    # I_corr = In + (h/2) * (f(tn, In) + f(tn_next, I_pred))
    slope_next = f(tn_next, I_pred)
    I_corr = In + (h / 2) * (slope_n + slope_next)
    
    # Simpan hasil korektor sebagai nilai I resmi untuk step ini
    I_numeric[n+1] = I_corr
    I_ex = exact_solution(tn_next)
    error = abs(I_ex - I_corr)
    
    # Cetak hasil ke tabel
    print(f"{tn_next:4.1f} | {I_pred:15.6f} | {I_corr:15.6f} | {I_ex:15.6f} | {error:12.6f}")

#visualisasi
# 4. Visualisasi
plt.figure(figsize=(10, 5))
plt.plot(t_values, [exact_solution(t) for t in t_values], 'r-', label='Eksak', alpha=0.7)
plt.plot(t_values, I_numeric, 'bo--', label='Predictor-Corrector', markersize=4)
plt.title('Simulasi Arus (I) dengan Metode Predictor-Corrector')
plt.xlabel('Waktu (t)')
plt.ylabel('Arus (I)')
plt.legend()
plt.grid(True, linestyle='--', alpha=0.6)
plt.show()