
#include <DHT.h>

#define DHTPIN 2          // Pino digital conectado ao DHT11
#define DHTTYPE DHT11     // Tipo do sensor

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);     // Inicia a comunicação serial
  dht.begin();            // Inicia o sensor
  Serial.println("Sistema DHT11 iniciado");
}

void loop() {
  delay(2000);  // Espera 2 segundos entre leituras

  float umidade = dht.readHumidity();         // Lê a umidade
  float temperatura = dht.readTemperature();  // Lê a temperatura em Celsius

  // Verifica se a leitura foi bem sucedida
  if (isnan(umidade) || isnan(temperatura)) {
    Serial.println("Falha ao ler o sensor DHT11!");
    return;
  }

  // Envia os dados formatados pela serial
  Serial.print("Umidade: ");
  Serial.print(umidade);
  Serial.print("% | Temperatura: ");
  Serial.print(temperatura);
  Serial.println("°C");
}
