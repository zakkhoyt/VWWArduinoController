# VWWArduinoController.h


I wanted to create a pure Objective-C ARC interface to quickly/easily communicate between Cocoa and Arduino over a serial connection. Also, I liked the idea of specifying an termination string/char so that the end user wouldn't need to worry about assembiling their data from the serial buffers before processing it. This framework provides these solutions.

This code is based off of SerialExample by Gabe Ghearing,   [available here:](http://playground.arduino.cc/Interfacing/Cocoa)

How to use this class

1.) Create an instace of this class:

`VWWArduinoController *arduinoController = [[VWWArduinoController alloc]init];`

2.) Query the available ports with: 

`-(void)availableSerialPorts;`

3.) Connect to a port by passing one of the string from step 1 (and a baud rate) into:

`-(BOOL)connectToSerialPort:(NSString*)serialPort withBaudRate:(NSUInteger)baudRate;`

4.) Implement the VWWArduinoControllerDelegate protocol in your controller. The delegate method will be called on any error

`-(void)arduinoController:(VWWArduinoController*)sender didEncounterError:(NSError*)error;`

5.) To verify that you are connected you can call

`-(NSString*)currentSerialPort;`

`-(NSUInteger)currentBaudRate;`

6.) To write data to the arduino, you can pick a format of your choice and write it by calling:

`-(void)writeString:(NSString*)outString;`

`-(void)writeBytes:(uint8_t*)val length:(NSUInteger)length;`

`-(void)writeData:(NSData*)data;`

7.) To receive data from the arduino, implement at least one of the protocol's delegate methods. VWWArduinoController will try to call all of these methods, so only implement the format you are interested in.


`-(void)arduinoController:(VWWArduinoController*)sender didReceiveString:(NSString*)inString;`

`-(void)arduinoController:(VWWArduinoController*)sender didReceiveData:(NSData*)inData;`

`-(void)arduinoController:(VWWArduinoController*)sender didReceiveBytes:(uint8_t*)buffer length:(NSUInteger)length;`




Arduino Sketch:

There is a simple sketch included which will echo data back in a couple of formats





