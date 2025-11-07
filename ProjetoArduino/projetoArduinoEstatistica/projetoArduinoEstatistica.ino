
/*==================== PROGRAM ==============================
 * Program: projetoArduinoEstatistica
 * Date of Create: 2025-03-24 11:20:31
 * Update in: 2025-03-24 11:20:31
 * Author:Jefferson Bezerra dos Santos
 * Description: Análise de dados com Estatistica
 *===========================================================
 */

#include <Arduino.h>
#include <DHT.h>

/* ==================== MACROS ============================ */
#define DHTPIN A1      // Pino que estamos conectados 
#define DHTTYPE DHT11  // DHT11 
/* ================== End of macro =========================*/


/* ================ PROTOTYPE OF FUNCTIONS ================ */

/* ================== End of prototype =====================*/

// Conecte pino 1 do sensor (esquerda) ao +5V
// Conecte pino 2 do sensor ao pino de dados definido em seu Arduino
// Conecte pino 4 do sensor ao GND
// Conecte o resistor de 10K entre pin 2 (dados) 
// e ao pino 1 (VCC) do sensor

DHT dht(DHTPIN, DHTTYPE);

/*=================== FUNCTION SETUP () ======================
 * Function: setup()
 * Description: Put setup configuration 
 * ==========================================================
 */
void setup() {
     Serial.begin(9600);
     Serial.println("DHTxx test!");
     dht.begin();
}
/*----------End of function-----------------*/



/*=================== FUNCTION SETUP () ======================
 * Function: loop()
 * Description: Put code for loop
 * ==========================================================
 */
void loop() {
   // A leitura da temperatura e umidade pode levar 250ms!
  // O atraso do sensor pode chegar a 2 segundos.
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  // testa se retorno é valido, caso contrário algo está errado.
  if (isnan(t) || isnan(h)) 
  {
    Serial.println("Failed to read from DHT");
  } 
  else 
  {
      Serial.print("Umidade: "); 
      Serial.print(h); 
      Serial.print("%\t");
      Serial.print("Temperatura: "); 
      Serial.print(t); 
      Serial.println("C");  // Removido o ° para evitar problemas}
}
}
/*----------End of function-----------------*/


