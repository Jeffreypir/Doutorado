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

import pandas as pd

def detectar_outliers_iqr(serie, k=1.5):
    Q1 = serie.quantile(0.25)
    Q3 = serie.quantile(0.75)
    IQR = Q3 - Q1
    limite_inferior = Q1 - k * IQR
    limite_superior = Q3 + k * IQR
    return serie[(serie < limite_inferior) | (serie > limite_superior)]

dados = pd.read_csv('dados_sensor.csv')

# Boxplot para temperatura e umidade
plt.figure(figsize=(10, 5))
dados[['temperatura', 'umidade']].boxplot()
plt.title('Boxplot de Temperatura e Umidade')
plt.show()

print (detectar_outliers_iqr(dados['temperatura']))
print (detectar_outliers_iqr(dados['umidade']))

