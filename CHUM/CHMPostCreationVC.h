//
//  CHMPostCreationVC.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 07/01/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "PAARegistrationBaseVC.h"

extern NSString *const CHMPostCreationVCID;

@interface CHMPostCreationVC : PAARegistrationBaseVC
@property (weak, nonatomic) IBOutlet UITextView *postTV;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *symbolCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *superPostButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCnstr;

- (void)configureWithCreationType:(NSInteger)creationType placeID:(nullable NSString *)placeID;

@end
