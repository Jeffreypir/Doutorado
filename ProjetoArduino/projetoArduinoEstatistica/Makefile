# Makefile para Arduino CLI

# Configurações do Arduino CLI
ARDUINO_CLI = arduino-cli
BOARD = arduino:avr:uno          # Placa a ser usada
	PORT = /dev/ttyACM0           # Porta para upload
	SKETCH = projetoArduinoEstatistica.ino         # Nome do arquivo com a extensão .ino
	BUILD_DIR = build

# Compilar o código
compile:
	$(ARDUINO_CLI) compile --fqbn $(BOARD) $(SKETCH)

# Upload para a placa
upload: compile
	$(ARDUINO_CLI) upload -p $(PORT) --fqbn $(BOARD) $(SKETCH)

# Limpar arquivos de compilação
clean:
	rm -rf $(BUILD_DIR)

# Verificar o código
verify:
	$(ARDUINO_CLI) verify --fqbn $(BOARD) $(SKETCH)

