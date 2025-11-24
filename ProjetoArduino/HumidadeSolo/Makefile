# ==========================================================
# Makefile para Arduino CLI
# Gerado automaticamente por CreateMakefile()
# ==========================================================

ARDUINO_CLI = arduino-cli
BOARD = arduino:avr:uno
PORT = /dev/ttyACM0
SKETCH = HumidadeSolo.ino
BUILD_DIR = build
BAUD = 9600

compile:
	$(ARDUINO_CLI) compile --fqbn $(BOARD) $(SKETCH)

upload:
	$(ARDUINO_CLI) upload -p $(PORT) --fqbn $(BOARD) $(SKETCH)

usb: compile
	$(ARDUINO_CLI) upload --fqbn $(BOARD) --programmer usbasp $(SKETCH)

clean:
	rm -rf $(BUILD_DIR)

monitor:
	$(ARDUINO_CLI) monitor -p $(PORT) -c baudrate=$(BAUD)

run: compile upload