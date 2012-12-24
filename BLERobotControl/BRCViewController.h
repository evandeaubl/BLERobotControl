//
//  BRCViewController.h
//  BLERobotControl
//
//  Created by Evan Deaubl on 12/24/12.
//  Copyright (c) 2012 Evan Deaubl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface BRCViewController : UIViewController<BLEDelegate> {
	@private
	BLE *_ble;
	IBOutlet UIButton *_connectButton;
}

- (IBAction)changeThrottle:(id)sender;
- (IBAction)changeDirection:(id)sender;
- (IBAction)chargeButton:(id)sender;
- (IBAction)connectButton:(id)sender;

@end
