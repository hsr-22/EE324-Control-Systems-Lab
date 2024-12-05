import numpy as np
import matplotlib.pyplot as plt

# Data points
arm_error = [4.64, 6.22, 6.79, 7.47, 8.39, 9.12, 9.38, 9.56, 10.20, 10.94, 11.21, 11.34, 
              11.95, 13.10, 13.71, 14.00, 14.61, 16.17, 17.82, 18.57, 18.77, 19.75, 22.00, 23.62, 
              24.00, 24.30, 25.23, 26.63, 27.18, 27.14, 27.58, 28.10, 28.52, 28.46, 28.81, 29.03, 
              29.23, 29.29, 29.25, 29.45, 29.45, 29.40, 29.47, 29.38, 29.47, 29.42, 29.40, 29.38, 
              29.40, 28.85, 27.09, 24.52, 22.24, 21.20, 20.24, 17.78, 12.46, 6.72, 2.79, 0.22, 
              2.72, 8.39, 15.36, 21.89, 26.98, 30.06, 31.60, 27.89, 25.78, 24.30, 21.51, 
              16.94, 12.28, 8.90, 5.80, 2.24, 1.82]

pendulum_error = [2.27, 1.88, 1.24, 0.80, 0.60, 0.47, 0.03, 0.41, 0.54, 0.47, 0.71, 1.15, 
                   1.26, 1.04, 1.00, 1.37, 1.57, 1.26, 0.69, 0.67, 1.24, 1.31, 0.56, 
                   0.25, 0.03, 0.47, 0.47, 0.10, 0.34, 0.10, 0.45, 0.14, 0.19, 0.01, 0.14, 
                   0.32, 0.10, 0.05, 0.27, 0.05, 0.14, 0.23, 0.43, 0.32, 0.58, 0.85, 1.07, 
                   1.42, 1.97, 2.45, 2.47, 2.01, 1.46, 1.57, 2.65, 3.07, 1.86, 0.03, 0.43, 0.63, 
                   1.26, 0.43, 1.33, 3.07, 3.31, 2.7, 1.92, 1.04, 1.33, 2.10, 2.16, 1.18, 0.01, 0.38, 0.27, 0.76, 1.72]

# Time array (separated by 25 ms)
time = np.arange(0, len(arm_error)) * 0.025  # in seconds

# Plotting the data
plt.figure(figsize=(10, 6))
plt.plot(time, arm_error, label="Arm Error (degrees)", color='b', linestyle='-', marker = 'o')
plt.plot(time, pendulum_error, label="Pendulum Error (degrees)", color='r', linestyle='-', marker = '.')

# plt.xlim(0, 5)
plt.xticks(np.arange(0, 2.25, 0.25))
plt.yticks(np.arange(0, 33, 3))

plt.title("Arm and Pendulum Error vs Time")
plt.xlabel("Time (seconds)")
plt.ylabel("Error (degrees)")
plt.legend()
plt.grid(True)
plt.show()
