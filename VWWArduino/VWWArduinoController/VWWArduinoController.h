//
//  VWWArduinoController.h
//
//  Created by Zakk Hoyt on 4/19/14.
//  Copyright (c) 2014 Zakk Hoyt. No rights reserved.
//
//  This code is based off of SerialExample by Gabe Ghearing, available here: http://playground.arduino.cc/Interfacing/Cocoa.
//  I wanted a pure Objective-c interface so that I could quickly/easily implement projects between Cocoa and Arduino.
//  I also wanted to have the ability to setup a termination string or chars so that the end user doens't need to worry
//  about assembiling their data from the serial buffers
//
//  How to use this class:
//  1.) Create an instace of this class:
//
//  2.) Query the available ports with
//  -(void)refreshSerialList;
//
//  3.) Connect to a port by passing one of the string from step 1 (and a baud rate) into:
//  -(BOOL)connectToSerialPort:(NSString*)serialPort withBaudRate:(NSUInteger)baudRate;
//
//  4.) Implement the VWWArduinoControllerDelegate protocol in your controller
//  The delegate method will be called on any error
//  -(void)arduinoController:(VWWArduinoController*)sender didEncounterError:(NSError*)error;
//
//  5.) To verify that you are connected you can call
//  -(NSString*)currentSerialPort;
//  -(NSUInteger)currentBaudRate;
//
//  6.) To write data to the arduino, you can pick a format of your choice and write it by calling:
//  -(void)writeString:(NSString*)outString;
//  -(void)writeBytes:(uint8_t*)val length:(NSUInteger)length;
//  -(void)writeData:(NSData*)data;
//
//  7.) To receive data from the arduino, implement at least one of the protocol's delegate methods.
//  VWWArduinoController will try to call all of these methods, so only implement the format you are interested in.
//  -(void)arduinoController:(VWWArduinoController*)sender didReceiveString:(NSString*)inString;
//  -(void)arduinoController:(VWWArduinoController*)sender didReceiveData:(NSData*)inData;;
//  -(void)arduinoController:(VWWArduinoController*)sender didReceiveBytes:(uint8_t*)buffer length:(NSUInteger)length;
//

#import <Foundation/Foundation.h>

@protocol VWWArduinoControllerDelegate;

@interface VWWArduinoController : NSObject

// Enumeration
-(void)refreshSerialList;
-(NSArray*)getSerialPorts;

// Serial connections
-(BOOL)connectToSerialPort:(NSString*)serialPort withBaudRate:(NSUInteger)baudRate;
-(BOOL)setBaudRateForCurrentSerialPort:(NSUInteger)baudRate;
-(BOOL)disconnectFromCurrentSerialPort;
-(NSString*)currentSerialPort;
-(NSUInteger)currentBaudRate;


// Writing data
-(void)writeString:(NSString*)outString;
-(void)writeBytes:(uint8_t*)val length:(NSUInteger)length;
-(void)writeData:(NSData*)data;

// Reading data (see the protocols)
@property (nonatomic, weak) id <VWWArduinoControllerDelegate> delegate;

// Reset Arduino
-(void)sendResetCommand;

// Termination string
@property (nonatomic, strong) NSString *terminationString;

@end



@protocol VWWArduinoControllerDelegate <NSObject>
@required
-(void)arduinoController:(VWWArduinoController*)sender didEncounterError:(NSError*)error;
@optional
-(void)arduinoController:(VWWArduinoController*)sender didReceiveString:(NSString*)inString;
-(void)arduinoController:(VWWArduinoController*)sender didReceiveData:(NSData*)inData;;
-(void)arduinoController:(VWWArduinoController*)sender didReceiveBytes:(uint8_t*)buffer length:(NSUInteger)length;
@end
