/*
 * Autor: Jefferson Bezerra dos Santos 
 *
 * Sistema de Monitoramento Agrícola Inteligente (modo de teste sem SD)
 * 
 * Dispositivo: Arduino Nano
 * Sensores: DHT11 (Temperatura/Umidade), Higrômetro Resistivo (Solo)
 * 
 * Funcionalidades:
 * ✅ Leitura periódica de sensores
 * ✅ Cálculo estatístico (média, desvio padrão, quartis)
 * ✅ Detecção de outliers (IQR)
 * ✅ Correlação entre variáveis
 * ✅ Exibição em tempo real no Serial Monitor
 */

#include <DHT.h>
#include <SPI.h>
#include <math.h>

// ================= CONFIGURAÇÕES =================
#define DHTPIN A1
#define DHTTYPE DHT11
#define SOIL_PIN A0
#define SAMPLE_SIZE 8
#define CORR_BUFFER_SIZE 12
#define LOG_INTERVAL 10000    // Intervalo entre leituras (10 segundos p/ teste)
#define IQR_FACTOR 1.5
#define CORR_THRESHOLD 0.5

#define SOIL_DRY_VALUE 1023
#define SOIL_WET_VALUE 300

#define REFERENCE_YEAR 2025
#define REFERENCE_MONTH 10
#define REFERENCE_DAY 5
#define START_HOUR 14
#define START_MINUTE 0

// ================= ESTRUTURAS =================
struct Estatisticas {
  float media, desvio_padrao, variancia;
  float q1, mediana, q3, iqr;
  bool is_outlier;
};

struct ResultadoCorrelacao {
  float coeficiente;
  bool significativa;
  const char* variavel1;
  const char* variavel2;
};

struct DadosSensores {
  float temperatura;
  float umidade_ar;
  float umidade_solo_percent;
};

// ================= VARIÁVEIS =================
DHT dht(DHTPIN, DHTTYPE);

float temp_samples[SAMPLE_SIZE] = {0};
float umid_ar_samples[SAMPLE_SIZE] = {0};
float umid_solo_samples[SAMPLE_SIZE] = {0};
byte sample_index = 0;

float temp_buffer_corr[CORR_BUFFER_SIZE] = {0};
float umid_ar_buffer_corr[CORR_BUFFER_SIZE] = {0};
float umid_solo_buffer_corr[CORR_BUFFER_SIZE] = {0};
byte corr_index = 0;

// ================= FUNÇÕES AUXILIARES =================
void bubbleSort(float arr[], int n) {
  for (int i = 0; i < n - 1; i++) {
    bool swapped = false;
    for (int j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        float temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        swapped = true;
      }
    }
    if (!swapped) break;
  }
}

float mapSoilMoistureToPercent(int raw_value) {
  raw_value = constrain(raw_value, SOIL_WET_VALUE, SOIL_DRY_VALUE);
  return 100.0 - map(raw_value, SOIL_WET_VALUE, SOIL_DRY_VALUE, 0, 100);
}

// ================= CÁLCULOS =================
Estatisticas calcularEstatisticas(float samples[], float new_val) {
  Estatisticas res;
  float sum = 0, sum_sq = 0;
  byte valid_count = 0;

  for (byte i = 0; i < SAMPLE_SIZE; i++) {
    if (!isnan(samples[i])) {
      sum += samples[i];
      sum_sq += samples[i] * samples[i];
      valid_count++;
    }
  }

  res.media = sum / valid_count;
  res.variancia = (sum_sq - valid_count * pow(res.media, 2)) / (valid_count - 1);
  res.desvio_padrao = sqrt(res.variancia);

  float sorted[SAMPLE_SIZE];
  memcpy(sorted, samples, SAMPLE_SIZE * sizeof(float));
  bubbleSort(sorted, SAMPLE_SIZE);

  res.q1 = sorted[SAMPLE_SIZE / 4];
  res.mediana = sorted[SAMPLE_SIZE / 2];
  res.q3 = sorted[3 * SAMPLE_SIZE / 4];
  res.iqr = res.q3 - res.q1;

  float lower = res.q1 - IQR_FACTOR * res.iqr;
  float upper = res.q3 + IQR_FACTOR * res.iqr;
  res.is_outlier = (new_val < lower || new_val > upper);
  return res;
}

float calcularPearson(float x[], float y[], byte n) {
  float sum_x = 0, sum_y = 0, sum_xy = 0, sum_x2 = 0, sum_y2 = 0;
  for (byte i = 0; i < n; i++) {
    sum_x += x[i];
    sum_y += y[i];
    sum_xy += x[i] * y[i];
    sum_x2 += x[i] * x[i];
    sum_y2 += y[i] * y[i];
  }
  float num = n * sum_xy - sum_x * sum_y;
  float den = sqrt((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y));
  return (den != 0) ? num / den : 0;
}

ResultadoCorrelacao* atualizarCorrelacao(float t, float uar, float uso) {
  static ResultadoCorrelacao r[3] = {
    {0, false, "Temp", "UAr"},
    {0, false, "Temp", "USolo"},
    {0, false, "UAr", "USolo"}
  };

  temp_buffer_corr[corr_index] = t;
  umid_ar_buffer_corr[corr_index] = uar;
  umid_solo_buffer_corr[corr_index] = uso;
  corr_index = (corr_index + 1) % CORR_BUFFER_SIZE;

  if (corr_index == 0) {
    r[0].coeficiente = calcularPearson(temp_buffer_corr, umid_ar_buffer_corr, CORR_BUFFER_SIZE);
    r[1].coeficiente = calcularPearson(temp_buffer_corr, umid_solo_buffer_corr, CORR_BUFFER_SIZE);
    r[2].coeficiente = calcularPearson(umid_ar_buffer_corr, umid_solo_buffer_corr, CORR_BUFFER_SIZE);
    for (byte i = 0; i < 3; i++)
      r[i].significativa = fabs(r[i].coeficiente) > CORR_THRESHOLD;
  }

  return r;
}

// ================= FUNÇÃO DE EXIBIÇÃO =================
void mostrarDados(DadosSensores dados, Estatisticas eTemp, Estatisticas eUAr, Estatisticas eUSolo, ResultadoCorrelacao* corr) {
  Serial.println("===============================================");
  Serial.println("📊 Leitura Atual do Sistema de Monitoramento");
  Serial.print("Temperatura: "); Serial.print(dados.temperatura); Serial.println(" °C");
  Serial.print("Umidade do Ar: "); Serial.print(dados.umidade_ar); Serial.println(" %");
  Serial.print("Umidade do Solo: "); Serial.print(dados.umidade_solo_percent); Serial.println(" %");
  Serial.println("-----------------------------------------------");

  Serial.println("📈 Estatísticas:");
  Serial.print("Temp -> Média: "); Serial.print(eTemp.media);
  Serial.print(", DP: "); Serial.print(eTemp.desvio_padrao);
  Serial.print(", Outlier: "); Serial.println(eTemp.is_outlier ? "SIM" : "NÃO");

  Serial.print("UAr  -> Média: "); Serial.print(eUAr.media);
  Serial.print(", DP: "); Serial.print(eUAr.desvio_padrao);
  Serial.print(", Outlier: "); Serial.println(eUAr.is_outlier ? "SIM" : "NÃO");

  Serial.print("USolo-> Média: "); Serial.print(eUSolo.media);
  Serial.print(", DP: "); Serial.print(eUSolo.desvio_padrao);
  Serial.print(", Outlier: "); Serial.println(eUSolo.is_outlier ? "SIM" : "NÃO");

  Serial.println("-----------------------------------------------");
  Serial.println("🔗 Correlações:");
  for (byte i = 0; i < 3; i++) {
    Serial.print(corr[i].variavel1);
    Serial.print("↔");
    Serial.print(corr[i].variavel2);
    Serial.print(": ");
    Serial.print(corr[i].coeficiente, 3);
    Serial.print(" ");
    Serial.println(corr[i].significativa ? "(significativa)" : "(fraca)");
  }
  Serial.println("===============================================");
}

// ================= SENSOR =================
DadosSensores lerSensores() {
  DadosSensores d;
  d.umidade_ar = dht.readHumidity();
  d.temperatura = dht.readTemperature();
  int raw = analogRead(SOIL_PIN);
  d.umidade_solo_percent = mapSoilMoistureToPercent(raw);
  return d;
}

// ================= LOOP PRINCIPAL =================
void setup() {
  Serial.begin(9600);
  dht.begin();
  pinMode(SOIL_PIN, INPUT);
  Serial.println(F("Sistema de Monitoramento Agrícola - Modo TESTE"));
  Serial.println(F("==================================================="));
}

void loop() {
  static unsigned long last = 0;
  if (millis() - last >= LOG_INTERVAL) {
    last = millis();

    DadosSensores d = lerSensores();
    if (isnan(d.temperatura) || isnan(d.umidade_ar)) {
      Serial.println("Erro ao ler DHT11!");
      return;
    }

    temp_samples[sample_index] = d.temperatura;
    umid_ar_samples[sample_index] = d.umidade_ar;
    umid_solo_samples[sample_index] = d.umidade_solo_percent;
    sample_index = (sample_index + 1) % SAMPLE_SIZE;

    Estatisticas eT = calcularEstatisticas(temp_samples, d.temperatura);
    Estatisticas eUAr = calcularEstatisticas(umid_ar_samples, d.umidade_ar);
    Estatisticas eUS = calcularEstatisticas(umid_solo_samples, d.umidade_solo_percent);
    ResultadoCorrelacao* corr = atualizarCorrelacao(d.temperatura, d.umidade_ar, d.umidade_solo_percent);

    mostrarDados(d, eT, eUAr, eUS, corr);
  }
}

