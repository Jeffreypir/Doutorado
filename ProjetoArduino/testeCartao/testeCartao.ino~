#include <SPI.h>
#include <SD.h>

const int chipSelect = 10; // Pino CS do módulo SD ligado ao D10 do Nano

void setup() {
  Serial.begin(9600);
  while (!Serial); // Aguarda inicialização da serial (opcional)

  Serial.println("=== Teste do Módulo SD no Arduino Nano ===");
  delay(1000);

  // Inicializa o cartão SD
  Serial.print("Inicializando o cartão SD... ");
  if (!SD.begin(chipSelect)) {
    Serial.println("Falhou!");
    Serial.println("Verifique:");
    Serial.println("- Conexões dos pinos (MISO, MOSI, SCK, CS)");
    Serial.println("- Se o cartão está formatado em FAT16/FAT32");
    Serial.println("- Se o pino CS está ligado ao D10");
    while (true); // Para o programa
  }
  Serial.println("Cartão SD inicializado com sucesso!");

  // Testa a criação de arquivo
  File arquivo = SD.open("teste.txt", FILE_WRITE);
  if (arquivo) {
    arquivo.println("Teste OK: Arduino Nano + Módulo SD funcionando!");
    arquivo.close();
    Serial.println("Arquivo 'teste.txt' criado e texto gravado.");
  } else {
    Serial.println("Erro ao criar o arquivo 'teste.txt'.");
  }

  // Testa a leitura do arquivo
  arquivo = SD.open("teste.txt");
  if (arquivo) {
    Serial.println("\nLendo conteúdo do arquivo:");
    Serial.println("--------------------------------------");
    while (arquivo.available()) {
      Serial.write(arquivo.read());
    }
    arquivo.close();
    Serial.println("\n--------------------------------------");
    Serial.println("Leitura concluída!");
  } else {
    Serial.println("Erro ao abrir o arquivo para leitura!");
  }
}

void loop() {
  // Nada no loop — teste executa uma vez
}

