#!/usr/bin/python3

#==================== PROGRAM ==============================
# Program: comunicacaoSerial
# Date of Create: 2025-03-24 11:11:53
# Update in: 2025-03-24 11:11:53
# Author:Jefferson Bezerra dos Santos
# Description: Comunicação Serial com Python para leitura
# de dados em Arduino
#===========================================================

import serial
import time

def main():
    try:
        # Configura a porta serial - ajuste para sua porta
        arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
       # time.sleep(2)  # Espera a conexão estabilizar
        
        print("Lendo dados do DHT11. Pressione Ctrl+C para sair...")
        
        while True:
            if arduino.in_waiting > 0:
                line = arduino.readline().decode('latin-1').strip()
                print(line)
                
    except serial.SerialException as e:
        print(f"Erro na comunicação serial: {e}")
    except KeyboardInterrupt:
        print("Programa encerrado pelo usuário")
    finally:
        if 'arduino' in locals() and arduino.is_open:
            arduino.close()
            print("Porta serial fechada")

if __name__ == "__main__":
    main()
