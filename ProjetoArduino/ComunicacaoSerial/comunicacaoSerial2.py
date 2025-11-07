#!/usr/bin/python3

#==================== PROGRAM ==============================
# Program: <+name+>
# Date of Create: <+date+>
# Update in: <+update+>
# Author:Jefferson Bezerra dos Santos
# Description: <+description+>
#===========================================================
import serial
import time

def safe_serial_read(ser):
    raw_data = ser.readline()
    try:
        return raw_data.decode('utf-8').strip()
    except UnicodeDecodeError:
        try:
            return raw_data.decode('latin-1').strip()
        except:
            return f"[Dados binários: {raw_data.hex()}]"

def main():
    try:
        arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
        time.sleep(2)  # Espera inicial
        
        print("Monitorando porta serial...")
        
        while True:
            if arduino.in_waiting > 0:
                line = safe_serial_read(arduino)
                print(f"Dados recebidos: {line}")
                
    except serial.SerialException as e:
        print(f"Erro serial: {e}")
    except KeyboardInterrupt:
        print("\nPrograma encerrado pelo usuário")
    finally:
        if 'arduino' in locals() and arduino.is_open:
            arduino.close()

if __name__ == "__main__":
    main()
