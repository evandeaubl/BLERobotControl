//
//  BRCViewController.m
//  BLERobotControl
//
//  Created by Evan Deaubl on 12/24/12.
//  Copyright (c) 2012 Evan Deaubl. All rights reserved.
//

#import "BRCViewController.h"
#import "BLE.h"

@interface BRCViewController ()

@end

@implementation BRCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _ble = [[BLE alloc] init];
    [_ble controlSetup:1];
	_ble.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeThrottle:(id)sender {
    UInt8 buf[3] = {0x01, 0x00, 0x00};
	
	UISlider *slider = (UISlider *)sender;
	float value = slider.value;
	
	buf[1] = (UInt8)((value - .5) * 255);
	
	NSLog(@"Writing throttle value: %d\n", buf[1]);
	
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}

- (void)changeDirection:(id)sender {
    UInt8 buf[3] = {0x02, 0x00, 0x00};
	
	UISlider *slider = (UISlider *)sender;
	float value = slider.value;
	
	buf[1] = (UInt8)((value - .5) * 255);
	
	NSLog(@"Writing direction value: %d\n", buf[1]);
	
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}

- (void)chargeButton:(id)sender {
    UInt8 buf[3] = {0x03, 0x00, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
}

- (void)stopButton:(id)sender {
	[_throttleSlider setValue:0.5 animated:YES];
	[_throttleSlider sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)straightButton:(id)sender {
	[_directionSlider setValue:0.5 animated:YES];
	[_directionSlider sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)connectButton:(id)sender {
    if (_ble.activePeripheral) {
        if(_ble.activePeripheral.isConnected) {
            [[_ble CM] cancelPeripheralConnection:[_ble activePeripheral]];
            [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
	}
	
	if (_ble.peripherals) {
		_ble.peripherals = nil;
	}

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self BLEConnect];
    [NSTimer scheduledTimerWithTimeInterval:(float)5.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

- (void)BLEConnect {
    [_ble findBLEPeripherals:5];
}

- (void)BLEDisconnect {
	[[_ble CM] cancelPeripheralConnection:[_ble activePeripheral]];
}

- (void)connectionTimer:(id)sender {
	if (_ble.peripherals.count > 0) {
        [_ble connectPeripheral:[_ble.peripherals objectAtIndex:0]];
		[_connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
	} else {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSLog(@"findBLEPeripherals failed");
	}
}

#pragma mark BLEDelegate methods

- (void)bleDidConnect {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)bleDidDisconnect {
	// TODO implement
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
	
}

- (void)bleDidUpdateRSSI:(NSNumber *)rssi {
	NSLog(@"RSSI: %d", [rssi intValue]);
}

@end
