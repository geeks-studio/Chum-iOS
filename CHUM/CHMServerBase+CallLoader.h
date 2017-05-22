//
//  CHMServerBase+CallLoader.h
//  CHUM
//
//  Created by Andrey Mikhaylov on 30/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

#import "CHMServerBase.h"
@class VoxUser;

@interface CHMServerBase (CallLoader)

- (void)loadVoxUserWithCompletion:(void (^)(VoxUser *_Nullable voxUser,
                                            NSError *_Nullable error,
                                            NSInteger statusCode))completion;

- (void)extendVoxSession:(void (^)(NSError *_Nullable err, NSInteger statusCode))completion;
- (void)closeVoxSession:(void (^)(NSError *_Nullable err, NSInteger statusCode))completion;

- (void)getInterlocutorNameForConversationWithID:(NSString *)conversationID
                                      completion:(void (^)(NSString *_Nullable opponenName,
                                                           NSError *_Nullable error,
                                                           NSInteger statusCode))completion;


@end
