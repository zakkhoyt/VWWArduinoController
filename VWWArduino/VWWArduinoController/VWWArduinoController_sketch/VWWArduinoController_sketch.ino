
void setup() {
    Serial.begin(250000);
    Serial.flush();
    Serial.print("Hello, I just rebooted");
}

void loop() {
    uint8_t incomingByte;

    // send data only when you receive data:
	if (Serial.available() > 0) {

		// read the incoming byte:
		incomingByte = Serial.read();
                
		// say what you got with both the ASCII and decimal representations
		Serial.print("->");
        
        // Hex representation
		Serial.print(incomingByte, HEX);
		Serial.print(":");
        
        // Decimal representation
		Serial.print(incomingByte, DEC);
		Serial.print(":");

        // String representation
        char *str = (char*)malloc(10 * sizeof(byte));
        sprintf(str, "%c\0", incomingByte);
        Serial.println(str);
        free(str);
    }
}

