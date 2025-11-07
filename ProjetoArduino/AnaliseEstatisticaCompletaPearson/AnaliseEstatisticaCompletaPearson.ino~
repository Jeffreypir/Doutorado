/*
 * Sistema de Monitoramento Agrícola Inteligente
 * 
 * Autor: Jefferson Bezerra dos Santos
 * Data: 02-04-2025
 * 
 * Descrição: Monitora temperatura e umidade com análise estatística avançada,
 * detecção de anomalias e armazenamento em cartão SD.
 * 
 * Funcionalidades:
 * - Leitura periódica do sensor DHT11
 * - Cálculo de estatísticas descritivas (média, mediana, desvio padrão)
 * - Detecção de outliers pelo método IQR
 * - Análise de correlação entre temperatura e umidade
 * - Armazenamento em arquivo CSV
 * - Log serial para monitoramento em tempo real
 */

#include <DHT.h>
#include <SD.h>
#include <SPI.h>
#include <math.h>

// ================= CONFIGURAÇÕES HARDWARE =================
#define DHTPIN A1            // Pino digital conectado ao DHT11
#define DHTTYPE DHT11        // Tipo do sensor (DHT11 ou DHT22)
#define SD_CS_PIN 10          // Pino Chip Select do módulo SD
//#define LOG_INTERVAL 300000  // Intervalo entre leituras (5 minutos em ms)
#define LOG_INTERVAL 10000  // Intervalo entre leituras (5 minutos em ms)

// ================= CONFIGURAÇÕES ESTATÍSTICAS =============
#define SAMPLE_SIZE 12       // Janela para estatísticas (1 hora de dados)
#define CORR_BUFFER_SIZE 24  // Janela para correlação (12 horas de dados)
#define IQR_FACTOR 1.5       // Fator para detecção de outliers (1.5 padrão)
#define CORR_THRESHOLD 0.5   // Limiar para correlação significativa

// ================= ESTRUTURAS DE DADOS ====================

/**
 * @struct Estatisticas
 * @brief Armazena estatísticas descritivas para uma variável
 * 
 * @var media Média aritmética
 * @var desvio_padrao Desvio padrão amostral
 * @var variancia Variância amostral
 * @var q1 Primeiro quartil (25%)
 * @var mediana Mediana (50%)
 * @var q3 Terceiro quartil (75%)
 * @var iqr Intervalo interquartil (Q3-Q1)
 * @var is_outlier Indica se o último valor é outlier
 */
struct Estatisticas {
  float media;
  float desvio_padrao;
  float variancia;
  float q1;
  float mediana;
  float q3;
  float iqr;
  bool is_outlier;
};

/**
 * @struct Correlacao
 * @brief Armazena resultados da análise de correlação
 * 
 * @var coeficiente Coeficiente de Pearson (-1 a 1)
 * @var significativa Indica se a correlação é estatisticamente significativa
 */
struct Correlacao {
  float coeficiente;
  bool significativa;
};

// ================= VARIÁVEIS GLOBAIS ======================
DHT dht(DHTPIN, DHTTYPE);    // Objeto do sensor DHT
File dataFile;               // Arquivo no cartão SD

// Buffers para estatísticas básicas (1 hora)
float temp_samples[SAMPLE_SIZE] = {0};
float humid_samples[SAMPLE_SIZE] = {0};
int sample_index = 0;

// Buffers para análise de correlação (12 horas)
float temp_buffer_corr[CORR_BUFFER_SIZE] = {0};
float umid_buffer_corr[CORR_BUFFER_SIZE] = {0};
int corr_index = 0;

// ================= FUNÇÕES AUXILIARES =====================

/**
 * @brief Ordena um array usando bubble sort (otimizado para pequenos conjuntos)
 * @param arr Array a ser ordenado
 * @param n Tamanho do array
 * 
 * Exemplo:
 * float dados[3] = {3, 1, 2};
 * bubbleSort(dados, 3); // dados agora {1, 2, 3}
 */
void bubbleSort(float arr[], int n) {
  for (int i = 0; i < n-1; i++) {
    bool swapped = false;
    for (int j = 0; j < n-i-1; j++) {
      if (arr[j] > arr[j+1]) {
        float temp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = temp;
        swapped = true;
      }
    }
    if (!swapped) break; // Otimização: sai se já estiver ordenado
  }
}

// ================= FUNÇÕES ESTATÍSTICAS ===================

/**
 * @brief Calcula estatísticas descritivas para um conjunto de amostras
 * @param samples Array com as amostras
 * @param new_val Novo valor a ser avaliado
 * @return Estrutura Estatisticas com todos os cálculos
 * 
 * Exemplo:
 * float amostras[3] = {1, 2, 3};
 * Estatisticas stats = calcularEstatisticas(amostras, 2.5);
 */
Estatisticas calcularEstatisticas(float samples[], float new_val) {
  Estatisticas res;
  float sum = 0, sum_sq = 0;
  int valid_count = 0;

  // 1. Calcula média e variância
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

  // 2. Calcula quartis (requer dados ordenados)
  float sorted[SAMPLE_SIZE];
  memcpy(sorted, samples, sizeof(sorted));
  bubbleSort(sorted, SAMPLE_SIZE);
  
  res.q1 = sorted[SAMPLE_SIZE / 4];
  res.mediana = sorted[SAMPLE_SIZE / 2];
  res.q3 = sorted[3 * SAMPLE_SIZE / 4];
  res.iqr = res.q3 - res.q1;

  // 3. Verifica se o novo valor é outlier
  float lower_bound = res.q1 - IQR_FACTOR * res.iqr;
  float upper_bound = res.q3 + IQR_FACTOR * res.iqr;
  res.is_outlier = (new_val < lower_bound) || (new_val > upper_bound);

  return res;
}

/**
 * @brief Calcula o coeficiente de correlação de Pearson
 * @param x Primeira variável
 * @param y Segunda variável
 * @param n Número de amostras
 * @return Coeficiente de correlação (-1 a 1)
 * 
 * Exemplo:
 * float x[3] = {1, 2, 3};
 * float y[3] = {2, 4, 6};
 * float r = calcularPearson(x, y, 3); // r ≈ 1.0
 */
float calcularPearson(float x[], float y[], int n) {
  float sum_x = 0, sum_y = 0, sum_xy = 0;
  float sum_x2 = 0, sum_y2 = 0;
  
  for (int i = 0; i < n; i++) {
    sum_x += x[i];
    sum_y += y[i];
    sum_xy += x[i] * y[i];
    sum_x2 += x[i] * x[i];
    sum_y2 += y[i] * y[i];
  }
  
  float numerador = n * sum_xy - sum_x * sum_y;
  float denominador = sqrt((n * sum_x2 - sum_x * sum_x) * 
                         (n * sum_y2 - sum_y * sum_y));
  
  return (denominador != 0) ? numerador / denominador : 0;
}

/**
 * @brief Atualiza o buffer de correlação e calcula quando cheio
 * @param temp Valor de temperatura atual
 * @param umid Valor de umidade atual
 * @return Estrutura Correlacao com resultados
 */
Correlacao atualizarCorrelacao(float temp, float umid) {
  // Armazena no buffer circular
  temp_buffer_corr[corr_index] = temp;
  umid_buffer_corr[corr_index] = umid;
  corr_index = (corr_index + 1) % CORR_BUFFER_SIZE;
  
  Correlacao resultado;
  resultado.coeficiente = 0;
  resultado.significativa = false;
  
  // Só calcula quando o buffer estiver cheio
  if (corr_index == 0) {
    resultado.coeficiente = calcularPearson(temp_buffer_corr, umid_buffer_corr, CORR_BUFFER_SIZE);
    resultado.significativa = fabs(resultado.coeficiente) > CORR_THRESHOLD;
  }
  
  return resultado;
}

// ================= FUNÇÕES DE ARMAZENAMENTO ===============

/**
 * @brief Registra os dados no cartão SD
 * @param h Umidade atual
 * @param t Temperatura atual
 * @param hs Estatísticas da umidade
 * @param ts Estatísticas da temperatura
 * @param corr Dados de correlação
 * 
 * Formato do arquivo CSV:
 * Data,Hora,Umidade,MediaU,...,Correlacao,CorrSignificativa
 */
void logData(float h, float t, Estatisticas hs, Estatisticas ts, Correlacao corr) {
  dataFile = SD.open("dados.csv", FILE_WRITE);
  
  if (dataFile) {
    // Cabeçalho (apenas na primeira execução)
    if (dataFile.size() == 0) {
      dataFile.println("Data,Hora,Umidade,MediaU,DesvioU,VarianciaU,Q1U,MedianaU,Q3U,IQRU,OutlierU,Temperatura,MediaT,DesvioT,VarianciaT,Q1T,MedianaT,Q3T,IQRT,OutlierT,Correlacao,CorrSignificativa");
    }

    // Formata a linha de dados
    dataFile.print("2025-04-02,");  // Substituir por RTC real
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
    dataFile.print(ts.is_outlier ? "SIM" : "NAO"); dataFile.print(",");
    
    // Dados de correlação
    dataFile.print(corr.coeficiente, 4); dataFile.print(",");
    dataFile.println(corr.significativa ? "SIM" : "NAO");
    
    dataFile.close();
  }
}

// ================= SETUP ==================================

void setup() {
  Serial.begin(9600);
  Serial.println("Iniciando sistema de monitoramento...");
  
  // Inicializa sensor DHT
  dht.begin();
  
  // Inicializa cartão SD
  if (!SD.begin(SD_CS_PIN)) {
    Serial.println("Falha ao inicializar o cartão SD!");
    while(1); // Trava o programa se falhar
  }
  Serial.println("Cartão SD inicializado com sucesso");
  
  Serial.println("Sistema pronto para operação");
  Serial.println("============================");
}

// ================= LOOP PRINCIPAL ========================

void loop() {
  static unsigned long last_log = 0;
  static Correlacao ultima_correlacao = {0, false};
  
  if (millis() - last_log >= LOG_INTERVAL) {
    last_log = millis();
    
    // 1. Leitura dos sensores
    float umidade = dht.readHumidity();
    float temperatura = dht.readTemperature();

    // Verifica se as leituras são válidas
    if (!isnan(umidade) && !isnan(temperatura)) {
      Serial.print("Leitura: ");
      Serial.print(umidade);
      Serial.print("% | ");
      Serial.print(temperatura);
      Serial.println("°C");
      
      // 2. Armazena amostras para estatísticas
      temp_samples[sample_index] = temperatura;
      humid_samples[sample_index] = umidade;
      sample_index = (sample_index + 1) % SAMPLE_SIZE;

      // 3. Atualiza análise de correlação
      Correlacao correlacao = atualizarCorrelacao(temperatura, umidade);
      if (corr_index == 0) { // Buffer cheio
        ultima_correlacao = correlacao;
        Serial.print("Correlação T-U: ");
        Serial.print(correlacao.coeficiente, 4);
        Serial.println(correlacao.significativa ? " (Significativa)" : " (Não significativa)");
      }

      // 4. Calcula estatísticas descritivas
      Estatisticas stats_temp = calcularEstatisticas(temp_samples, temperatura);
      Estatisticas stats_umid = calcularEstatisticas(humid_samples, umidade);

      // 5. Exibe alertas de outliers
      if (stats_temp.is_outlier) {
        Serial.print("ALERTA: Outlier de temperatura detectado: ");
        Serial.println(temperatura);
      }
      if (stats_umid.is_outlier) {
        Serial.print("ALERTA: Outlier de umidade detectado: ");
        Serial.println(umidade);
      }

      // 6. Armazena dados no cartão SD
      logData(umidade, temperatura, stats_umid, stats_temp, ultima_correlacao);
    }
    else {
      Serial.println("Erro na leitura do sensor!");
    }
  }
}
