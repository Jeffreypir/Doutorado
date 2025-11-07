#!/usr/bin/python3

#==================== PROGRAM ==============================
# Program: graficoArduino
# Date of Create: 2025-03-25 11:12:01
# Update in: 2025-03-25 11:12:01
# Author:Jefferson Bezerra dos Santos
# Description: Plotagem de Gráfico em Tempo Real com Python
#===========================================================

import serial
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from collections import deque
from datetime import datetime
import re
import matplotlib.dates as mdates
import sys

# Configurações
SERIAL_PORT = '/dev/ttyUSB0'  # Confirme a porta correta
BAUD_RATE = 9600
MAX_DATA_POINTS = 100
UPDATE_INTERVAL = 500  # ms

# Inicializa estruturas de dados
times = deque(maxlen=MAX_DATA_POINTS)
temperatures = deque(maxlen=MAX_DATA_POINTS)
humidities = deque(maxlen=MAX_DATA_POINTS)

# Configuração do gráfico
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8))
fig.suptitle('Monitoramento DHT11 em Tempo Real')
plt.subplots_adjust(hspace=0.4)

# Configura eixos (ajuste conforme seus dados esperados)
ax1.set_ylabel('Temperatura (°C)')
ax1.set_ylim(10, 40)  # Faixa razoável para temperatura
ax1.grid(True)

ax2.set_ylabel('Umidade (%)')
ax2.set_ylim(20, 90)  # Faixa razoável para umidade
ax2.set_xlabel('Tempo')
ax2.grid(True)

# Formato do eixo x
date_format = mdates.DateFormatter('%H:%M:%S')
for ax in [ax1, ax2]:
    ax.xaxis.set_major_formatter(date_format)

# Linhas do gráfico
temp_line, = ax1.plot([], [], 'r-', label='Temperatura')
hum_line, = ax2.plot([], [], 'b-', label='Umidade')
ax1.legend()
ax2.legend()

def parse_data(line):
    """Versão mais robusta para análise dos dados"""
    try:
        # Tenta várias codificações possíveis
        for encoding in ['utf-8', 'latin-1', 'ascii']:
            try:
                line_str = line.decode(encoding).strip()
                # Padrão mais flexível para capturar os valores
                match = re.search(
                    r'Umidade:\s*([\d.]+).*Temperatura:\s*([\d.]+)', 
                    line_str, 
                    re.IGNORECASE
                )
                if match:
                    return float(match.group(2)), float(match.group(1))
            except (UnicodeDecodeError, ValueError):
                continue
        print(f"Linha não decodificada: {line}")
    except Exception as e:
        print(f"Erro na análise: {e}")
    return None, None

def init():
    """Inicializa o gráfico"""
    temp_line.set_data([], [])
    hum_line.set_data([], [])
    return temp_line, hum_line

def update(frame):
    try:
        while ser.in_waiting:
            line = ser.readline()
            print(f"Dado bruto recebido: {line}")  # Debug
            
            temp, hum = parse_data(line)
            
            if temp is not None and hum is not None:
                current_time = datetime.now()
                times.append(current_time)
                temperatures.append(temp)
                humidities.append(hum)
                
                # Atualiza gráficos
                temp_line.set_data(times, temperatures)
                hum_line.set_data(times, humidities)
                
                # Ajusta eixos se tiver dados suficientes
                if len(times) > 1:
                    x_min = min(times)
                    x_max = max(times)
                    for ax in [ax1, ax2]:
                        ax.set_xlim(x_min, x_max)
                    
                    # Ajuste automático com margem
                    temp_margin = (max(temperatures) - min(temperatures)) * 0.2
                    hum_margin = (max(humidities) - min(humidities)) * 0.2
                    
                    ax1.set_ylim(
                        min(temperatures) - temp_margin if temp_margin > 0 else min(temperatures) - 1,
                        max(temperatures) + temp_margin if temp_margin > 0 else max(temperatures) + 1
                    )
                    ax2.set_ylim(
                        min(humidities) - hum_margin if hum_margin > 0 else min(humidities) - 5,
                        max(humidities) + hum_margin if hum_margin > 0 else max(humidities) + 5
                    )
                
                # Rotaciona labels
                plt.setp(ax1.get_xticklabels(), rotation=45, ha='right')
                plt.setp(ax2.get_xticklabels(), rotation=45, ha='right')
                
                fig.tight_layout()
    
    except serial.SerialException as e:
        print(f"Erro serial: {e}")
    
    return temp_line, hum_line

# Tenta conectar ao Arduino
try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    ser.flushInput()
    print(f"Conectado à porta {SERIAL_PORT}")
    
    # Inicia animação
    ani = FuncAnimation(
        fig, 
        update, 
        init_func=init,
        interval=UPDATE_INTERVAL, 
        blit=False,
        cache_frame_data=False
    )
    
    plt.show()
    
except serial.SerialException as e:
    print(f"Falha ao conectar: {e}")
    sys.exit(1)
finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()
