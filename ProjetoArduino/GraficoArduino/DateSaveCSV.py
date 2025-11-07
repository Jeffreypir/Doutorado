#!/usr/bin/python3

#==================== PROGRAM ==============================
# Program: DateSaveCSV
# Date of Create: 2025-03-28 10:48:24
# Update in: 2025-03-28 10:48:24
# Author:Jefferson Bezerra dos Santos
# Description: Tratamento de dados com Python para Arduino 
#===========================================================

import serial
import csv
from datetime import datetime
import re
import time

# Configurações
SERIAL_PORT = '/dev/ttyUSB0'  # Altere para sua porta
BAUD_RATE = 9600
ARQUIVO_CSV = 'dados_sensor.csv'
INTERVALO_LEITURA = 2  # Segundos entre leituras

def conectar_arduino():
    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
        ser.flushInput()
        print(f"Conectado ao Arduino na porta {SERIAL_PORT}")
        return ser
    except serial.SerialException as e:
        print(f"Falha ao conectar: {e}")
        return None

def parse_dados(linha):
    """Extrai temperatura e umidade da linha do Arduino"""
    try:
        linha_str = linha.decode('utf-8').strip()
        # Padrão para: "Umidade: 45.00%  Temperatura: 23.00C"
        match = re.search(r'Umidade:\s*([\d.]+).*Temperatura:\s*([\d.]+)', linha_str)
        if match:
            return float(match.group(1)), float(match.group(2))
    except Exception as e:
        print(f"Erro ao analisar dados: {e}")
    return None, None

def inicializar_csv():
    """Cria o arquivo CSV com cabeçalhos se não existir"""
    try:
        with open(ARQUIVO_CSV, 'x', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['timestamp', 'umidade', 'temperatura'])
    except FileExistsError:
        pass  # Arquivo já existe, não precisa fazer nada

def salvar_dados(timestamp, umidade, temperatura):
    """Adiciona uma nova linha ao CSV"""
    with open(ARQUIVO_CSV, 'a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([timestamp, umidade, temperatura])
    print(f"Dados salvos: {timestamp} - {umidade}% - {temperatura}°C")

def main_coleta():
    inicializar_csv()
    ser = conectar_arduino()
    
    if ser is None:
        return
    
    try:
        while True:
            if ser.in_waiting:
                linha = ser.readline()
                umidade, temperatura = parse_dados(linha)
                
                if umidade is not None and temperatura is not None:
                    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    salvar_dados(timestamp, umidade, temperatura)
            
            time.sleep(INTERVALO_LEITURA)
            
    except KeyboardInterrupt:
        print("\nColeta de dados encerrada pelo usuário")
    finally:
        if ser and ser.is_open:
            ser.close()

if __name__ == '__main__':
    main_coleta()
