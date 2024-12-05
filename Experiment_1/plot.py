import pandas as pd

import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator

# Read the CSV file
data = pd.read_csv('Experiment_1\sim_results.csv')

# Extract the required data columns
x = data['Time']
y = 360 - data['Angle']

fig, ax = plt.subplots(figsize=(8, 6))

# Create the plot
markers_on = [15, 48]
plt.plot(x, y, '--bo', markevery=markers_on)

etiqueta = "{:.1f}".format(x[15]), "{:.1f}".format(y[15])
plt.annotate(etiqueta, (x[15], y[15]), textcoords="offset points", xytext=(0,10), ha="center")

etiqueta2 = "{:.1f}".format(x[48]), "{:.1f}".format(y[47])
plt.annotate(etiqueta2, (x[48], y[48]), textcoords="offset points", xytext=(0,-10), ha="center")

plt.ylim(0, 300)

# Add grid to the plot
plt.grid(True)
ax.yaxis.set_minor_locator(AutoMinorLocator(5))
ax.grid(which='minor', color='gray', linestyle=':', linewidth=0.5)

# # Plot horizontal and vertical line when it reaches 90% of its maximum
# plt.axhline(max(y)-18, color='r', linestyle='--')
# plt.axhline(min(y)+18, color='r', linestyle='--')

# # Mark the point and show coordinates
# plt.annotate(f'{min(y)}', xy=(min(x), min(y)), xytext=(min(x), min(y)-50), arrowprops=dict(arrowstyle='->'))
# plt.annotate(f'{max(x)}', xy=(max(x), max(y)), xytext=(max(x), max(y)+50), arrowprops=dict(arrowstyle='->'))

plt.xlabel('Time (ms)')
plt.ylabel('Angle (degrees)')
plt.title('Motor Control Results')

# Display the plot
plt.show()