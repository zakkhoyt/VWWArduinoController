//
//  VWWAppDelegate.m
//  VWWArduino
//
//  Created by Zakk Hoyt on 4/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWAppDelegate.h"
#import "VWWArduinoController.h"


@interface VWWAppDelegate () <VWWArduinoControllerDelegate>

// Our Arduino controller
@property (strong) VWWArduinoController *arduinoController;

// A few GUI variables
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSPopUpButton *devicesPopUp;
@property (weak) IBOutlet NSTextField *baudTextField;
@property (weak) IBOutlet NSTextField *inputTextField;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (unsafe_unretained) IBOutlet NSTextView *statusTextView;

@end

@implementation VWWAppDelegate

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Create our controller and set delegate
    self.arduinoController = [[VWWArduinoController alloc]init];
    self.arduinoController.delegate = self;
    
    // Populated the drop list
    [self scanDevicesButtonAction:nil];
}

#pragma mark IBAction

- (IBAction)connectButtonAction:(id)sender {
    NSMenuItem *menuItem = self.devicesPopUp.itemArray[self.devicesPopUp.indexOfSelectedItem];
    NSString *serialPort = menuItem.title;

    if(serialPort){
        if([self.arduinoController connectToSerialPort:serialPort withBaudRate:250000] == YES){
            [self.connectButton setTitle:@"Disconnect"];
        } else {
            [self.connectButton setTitle:@"Connect"];
        }
    }
}

- (IBAction)scanDevicesButtonAction:(id)sender {
    [self.devicesPopUp removeAllItems];
    NSArray *serialPorts = [self.arduinoController availableSerialPorts];
    if(serialPorts.count){
        [self.devicesPopUp addItemsWithTitles:serialPorts];
    }
}

- (IBAction)devicesPopupAction:(id)sender {
    // We could connect on select here
}

- (IBAction)changeBaudButtonAction:(id)sender {
    NSInteger baud = self.baudTextField.integerValue;
    [self.arduinoController setBaudRateForCurrentSerialPort:baud];
}

- (IBAction)resetArduinoButtonAction:(id)sender {
    [self.arduinoController sendResetCommand];
}

- (IBAction)currentDeviceButtonAction:(id)sender {
    NSAlert *alert = [[NSAlert alloc]init];
    NSString *currentDevice = self.arduinoController.currentSerialPort;
    NSString *alertString;
    if(currentDevice){
        alertString = [NSString stringWithFormat:@"Current device:\n%@", currentDevice];
    } else {
        alertString = [NSString stringWithFormat:@"Not connected"];
    }
    [alert setMessageText:alertString];
    [alert runModal];
}

- (IBAction)currentBaudButtonAction:(id)sender {
    NSAlert *alert = [[NSAlert alloc]init];
    NSUInteger currentBaud = self.arduinoController.currentBaudRate;
    NSString *alertString;
    if(currentBaud){
        alertString = [NSString stringWithFormat:@"Current baud:\n%ld", (long)currentBaud];
    } else {
        alertString = [NSString stringWithFormat:@"Not connected"];
    }
    [alert setMessageText:alertString];
    [alert runModal];
}

- (IBAction)sendAsStringButtonAction:(id)sender {
    NSString *outString = self.inputTextField.stringValue;
    [self.arduinoController writeString:outString];
}

- (IBAction)sendAsBytesButtonAction:(id)sender {
    NSString *outString = self.inputTextField.stringValue;
    NSData* outData = [outString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t *bytes = (uint8_t*)[outData bytes];
    [self.arduinoController writeBytes:bytes length:outData.length];
}

- (IBAction)sendAsDataButtonAction:(id)sender {
    NSString *outString = self.inputTextField.stringValue;
    NSData* outData = [outString dataUsingEncoding:NSUTF8StringEncoding];
    [self.arduinoController writeData:outData];
}

#pragma mark VWWArduinoControllerDelegate

-(void)arduinoController:(VWWArduinoController*)sender didEncounterError:(NSError*)error{
    NSString *status = [NSString stringWithFormat:@"%@\n%@", error.description, self.statusTextView.string];
    self.statusTextView.string = status;
}

-(void)arduinoController:(VWWArduinoController*)sender didReceiveString:(NSString*)inString{
    NSString *status = [NSString stringWithFormat:@"%@\n%@", inString, self.outputTextView.string];
    self.outputTextView.string = status;
}

-(void)arduinoController:(VWWArduinoController*)sender didReceiveData:(NSData*)inData{
    // If you like data format, implement this
}

-(void)arduinoController:(VWWArduinoController*)sender didReceiveBytes:(uint8_t*)buffer length:(NSUInteger)length{
    // If you like char* format implement this
}

@end
