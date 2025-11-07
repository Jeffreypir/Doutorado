// Código para testar o sensor de umidade do solo HD-38
#define SENSOR_PINO A0  // Pino analógico conectado ao sensor

void setup() {
  Serial.begin(9600); // Inicia a comunicação serial
  Serial.println("Teste do Sensor de Umidade do Solo HD-38");
  Serial.println("---------------------------------------");
}

void loop() {
  int leitura = analogRead(SENSOR_PINO); // Lê o valor do sensor
  int porcentagem = map(leitura, 0, 1023, 100, 0); // Converte para porcentagem
  
  Serial.print("Leitura bruta: ");
  Serial.print(leitura);
  Serial.print(" | Umidade: ");
  Serial.print(porcentagem);
  Serial.println("%");
  
  // Classifica a umidade
  if (porcentagem >= 70) {
    Serial.println("Solo muito úmido");
  } else if (porcentagem >= 40) {
    Serial.println("Solo úmido (ideal)");
  } else if (porcentagem >= 20) {
    Serial.println("Solo seco");
  } else {
    Serial.println("Solo muito seco");
  }
  
  Serial.println("---------------------------------------");
  delay(2000); // Espera 2 segundos entre as leituras
}
