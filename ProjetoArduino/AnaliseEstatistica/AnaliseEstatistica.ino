/*
 * Sistema de Monitoramento Agrícola com Estatísticas Completas
 * 
 * Funcionalidades:
 * - Leitura de temperatura/umidade do DHT11
 * - Cálculo de estatísticas sem biblioteca algorithm:
 *   • Média, mediana, desvio padrão, variância
 *   • Quartis (Q1, Q3) e IQR para detecção de outliers
 * - Armazenamento em cartão SD
 * - Configuração flexível
 * 
 * Autor: Jefferson Bezerra dos Santos 
 * Data: 02-04-2025
 */

#include <DHT.h>
#include <SD.h>
#include <SPI.h>
#include <math.h>

// ================= CONFIGURAÇÕES =================
#define DHTPIN A1            // Pino do DHT11
#define DHTTYPE DHT11        // Tipo do sensor
#define SD_CS_PIN 4          // Pino do módulo SD
#define LOG_INTERVAL 300000  // 5 minutos em ms
#define SAMPLE_SIZE 12       // Janela de 1 hora (12 amostras)
#define IQR_FACTOR 1.5       // Fator para detecção de outliers

// ================= ESTRUTURAS ===================
struct Estatisticas {
  // Método tradicional
  float media;
  float desvio_padrao;
  float variancia;
  
  // Método IQR
  float q1;
  float mediana;
  float q3;
  float iqr;
  bool is_outlier;
};

// ================= VARIÁVEIS ====================
DHT dht(DHTPIN, DHTTYPE);
File dataFile;

float temp_samples[SAMPLE_SIZE] = {0};
float humid_samples[SAMPLE_SIZE] = {0};
int sample_index = 0;

// ================= FUNÇÕES AUXILIARES ===========

// Implementação manual do sort (bubble sort para pequenos arrays)
void bubbleSort(float arr[], int n) {
  for (int i = 0; i < n-1; i++) {
    for (int j = 0; j < n-i-1; j++) {
      if (arr[j] > arr[j+1]) {
        float temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
      }
    }
  }
}

// ================= FUNÇÕES ESTATÍSTICAS =========
Estatisticas calcularEstatisticas(float samples[], float new_val) {
  Estatisticas res;
  float sum = 0, sum_sq = 0;
  int valid_count = 0;

  // Calcula média e variância
  for (int i = 0; i < SAMPLE_SIZE; i++) {
    if (!isnan(samples[i])) {
      sum += samples[i];
      sum_sq += samples[i] * samples[i];
      valid_count++;
    }
  }
  
  res.media = sum / valid_count;
  res.variancia = (sum_sq - valid_count * pow(res.media, 2)) / (valid_count - 1);
  res.desvio_padrao = sqrt(res.variancia);

  // Calcula quartis (com sort manual)
  float sorted[SAMPLE_SIZE];
  memcpy(sorted, samples, sizeof(sorted));
  bubbleSort(sorted, SAMPLE_SIZE);
  
  res.q1 = sorted[SAMPLE_SIZE / 4];          // 25%
  res.mediana = sorted[SAMPLE_SIZE / 2];     // 50%
  res.q3 = sorted[3 * SAMPLE_SIZE / 4];      // 75%
  res.iqr = res.q3 - res.q1;

  // Verifica outlier
  float lower_bound = res.q1 - IQR_FACTOR * res.iqr;
  float upper_bound = res.q3 + IQR_FACTOR * res.iqr;
  res.is_outlier = (new_val < lower_bound) || (new_val > upper_bound);

  return res;
}

// ================= REGISTRO DE DADOS ============
void logData(float h, float t, Estatisticas hs, Estatisticas ts) {
  dataFile = SD.open("dados.csv", FILE_WRITE);
  
  if (dataFile) {
    // Cabeçalho (apenas na primeira vez)
    if (dataFile.size() == 0) {
      dataFile.println("Data,Hora,Umidade,MediaU,DesvioU,VarianciaU,Q1U,MedianaU,Q3U,IQRU,OutlierU,Temperatura,MediaT,DesvioT,VarianciaT,Q1T,MedianaT,Q3T,IQRT,OutlierT");
    }

    // Formata a linha de dados
    dataFile.print("2025-04-02,");  // Substituir por RTC
    dataFile.print("12:00:00,");    // Horário real
    
    // Dados de umidade
    dataFile.print(h); dataFile.print(",");
    dataFile.print(hs.media); dataFile.print(",");
    dataFile.print(hs.desvio_padrao); dataFile.print(",");
    dataFile.print(hs.variancia); dataFile.print(",");
    dataFile.print(hs.q1); dataFile.print(",");
    dataFile.print(hs.mediana); dataFile.print(",");
    dataFile.print(hs.q3); dataFile.print(",");
    dataFile.print(hs.iqr); dataFile.print(",");
    dataFile.print(hs.is_outlier ? "SIM" : "NAO"); dataFile.print(",");
    
    // Dados de temperatura
    dataFile.print(t); dataFile.print(",");
    dataFile.print(ts.media); dataFile.print(",");
    dataFile.print(ts.desvio_padrao); dataFile.print(",");
    dataFile.print(ts.variancia); dataFile.print(",");
    dataFile.print(ts.q1); dataFile.print(",");
    dataFile.print(ts.mediana); dataFile.print(",");
    dataFile.print(ts.q3); dataFile.print(",");
    dataFile.print(ts.iqr); dataFile.print(",");
    dataFile.println(ts.is_outlier ? "SIM" : "NAO");
    
    dataFile.close();
  }
}

// ================= SETUP ========================
void setup() {
  Serial.begin(9600);
  dht.begin();
  
  if (!SD.begin(SD_CS_PIN)) {
    Serial.println("Erro no cartão SD!");
    while(1);
  }
  
  Serial.println("Sistema iniciado!");
}

// ================= LOOP PRINCIPAL ===============
void loop() {
  static unsigned long last_log = 0;
  
  if (millis() - last_log >= LOG_INTERVAL) {
    last_log = millis();
    
    float umidade = dht.readHumidity();
    float temperatura = dht.readTemperature();

    if (!isnan(umidade) && !isnan(temperatura)) {
      // Armazena amostras
      temp_samples[sample_index] = temperatura;
      humid_samples[sample_index] = umidade;
      sample_index = (sample_index + 1) % SAMPLE_SIZE;

      // Calcula estatísticas
      Estatisticas stats_temp = calcularEstatisticas(temp_samples, temperatura);
      Estatisticas stats_umid = calcularEstatisticas(humid_samples, umidade);

      // Registra dados
      logData(umidade, temperatura, stats_umid, stats_temp);
      
      // Log serial
      Serial.print("Dados - U: ");
      Serial.print(umidade);
      Serial.print("%, T: ");
      Serial.print(temperatura);
      Serial.println("°C");
    }
  }
}
