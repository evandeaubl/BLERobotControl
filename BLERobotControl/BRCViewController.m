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
	
}

- (void)changeDirection:(id)sender {
	
}

- (void)chargeButton:(id)sender {
    UInt8 buf[3] = {0x03, 0x00, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [_ble write:data];
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
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

- (void)BLEConnect {
    [_ble findBLEPeripherals:2];
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
