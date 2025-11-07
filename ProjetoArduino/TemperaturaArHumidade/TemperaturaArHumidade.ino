#include <DHT.h>

#define DHTPIN A1       // Pino digital conectado ao sensor
#define DHTTYPE DHT11  // Tipo do sensor (DHT11 ou DHT22)

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  Serial.println("Teste do Sensor DHT");
  dht.begin();
}

void loop() {
  delay(2000);  // Intervalo entre leituras (DHT requer ~2s entre leituras)

  float umidade = dht.readHumidity();      // Lê a umidade (%)
  float temperatura = dht.readTemperature(); // Lê a temperatura em Celsius

  // Verifica se a leitura falhou
  if (isnan(umidade) || isnan(temperatura)) {
    Serial.println("Falha ao ler o sensor DHT!");
    return;
  }

  Serial.print("Umidade: ");
  Serial.print(umidade);
  Serial.print("%\t");
  Serial.print("Temperatura: ");
  Serial.print(temperatura);
  Serial.println("°C");
}
