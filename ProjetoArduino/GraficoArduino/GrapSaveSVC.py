#!/usr/bin/python3

#==================== PROGRAM ==============================
# Program: <+name+>
# Date of Create: <+date+>
# Update in: <+update+>
# Author:Jefferson Bezerra dos Santos
# Description: <+description+>
#===========================================================

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime

def carregar_dados(arquivo_csv):
    """Carrega os dados do CSV para um DataFrame"""
    df = pd.read_csv(arquivo_csv, parse_dates=['timestamp'])
    df['timestamp'] = pd.to_datetime(df['timestamp'])
    return df

def plotar_dados(df):
    """Cria gráficos de temperatura e umidade ao longo do tempo"""
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8))
    fig.suptitle('Análise dos Dados do Sensor DHT11')
    
    # Gráfico de Temperatura
    ax1.plot(df['timestamp'], df['temperatura'], 'r-', label='Temperatura')
    ax1.set_ylabel('Temperatura (°C)')
    ax1.grid(True)
    ax1.legend()
    
    # Gráfico de Umidade
    ax2.plot(df['timestamp'], df['umidade'], 'b-', label='Umidade')
    ax2.set_ylabel('Umidade (%)')
    ax2.set_xlabel('Data e Hora')
    ax2.grid(True)
    ax2.legend()
    
    # Formatação do eixo x
    for ax in [ax1, ax2]:
        ax.xaxis.set_major_formatter(mdates.DateFormatter('%d/%m %H:%M'))
        plt.setp(ax.get_xticklabels(), rotation=45, ha='right')
    
    plt.tight_layout()
    plt.show()

def analise_estatistica(df):
    """Mostra estatísticas básicas dos dados"""
    print("\nEstatísticas dos Dados:")
    print(df[['temperatura', 'umidade']].describe())
    
    # Calcula variação por dia
    df['data'] = df['timestamp'].dt.date
    variacao_diaria = df.groupby('data').agg({
        'temperatura': ['min', 'max', 'mean'],
        'umidade': ['min', 'max', 'mean']
    })
    print("\nVariação Diária:")
    print(variacao_diaria)

def main_visualizacao():
    arquivo_csv = 'dados_sensor.csv'
    
    try:
        df = carregar_dados(arquivo_csv)
        
        if df.empty:
            print("Nenhum dado encontrado no arquivo CSV.")
            return
        
        analise_estatistica(df)
        plotar_dados(df)
        
    except FileNotFoundError:
        print(f"Arquivo {arquivo_csv} não encontrado.")
    except Exception as e:
        print(f"Erro ao processar dados: {e}")

if __name__ == '__main__':
    main_visualizacao()
