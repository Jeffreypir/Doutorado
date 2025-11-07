#!/usr/bin/python3

#==================== PROGRAM ==============================
# Program: <+name+>
# Date of Create: <+date+>
# Update in: <+update+>
# Author:Jefferson Bezerra dos Santos
# Description: <+description+>
#===========================================================

import serial
import serial.tools.list_ports
import time

def encontrar_porta_arduino():
    """Identifica automaticamente a porta onde o Arduino está conectado"""
    ports = serial.tools.list_ports.comports()
    for port in ports:
        if 'Arduino' in port.description or 'ACM' in port.device or 'USB' in port.device:
            return port.device
    return None

def ler_dados_seguros(conexao_serial):
    """Lê e decodifica dados da porta serial de forma robusta"""
    dados_crus = conexao_serial.readline()
    try:
        return dados_crus.decode('utf-8').strip()
    except UnicodeDecodeError:
        try:
            return dados_crus.decode('latin-1').strip()
        except:
            return f"[Dados binários: {dados_crus.hex()}]"

def main():
    try:
        # Configuração da conexão serial
        porta_arduino = encontrar_porta_arduino()
        if not porta_arduino:
            print("Arduino não encontrado! Conecte o Arduino e tente novamente.")
            return

        arduino = serial.Serial(porta_arduino, 9600, timeout=1)
        time.sleep(2)  # Espera a conexão estabilizar
        
        print("Monitorando dados do Arduino. Pressione Ctrl+C para sair...")
        print("Esperando dados do sensor DHT11...")
        
        while True:
            if arduino.in_waiting > 0:
                linha = ler_dados_seguros(arduino)
                
                # Processamento dos dados (exemplo para DHT11)
                if "Umidade" in linha and "Temperatura" in linha:
                    print(linha)
                elif linha:
                    print(f"Dados recebidos: {linha}")
                
    except serial.SerialException as e:
        print(f"Erro na comunicação serial: {e}")
    except KeyboardInterrupt:
        print("\nPrograma encerrado pelo usuário")
    finally:
        if 'arduino' in locals() and arduino.is_open:
            arduino.close()
            print("Conexão serial fechada")

if __name__ == "__main__":
    main()
