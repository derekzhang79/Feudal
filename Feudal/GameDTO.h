//
//  GameDTO.h
//  Feudal
//
//  Created by Eugene Adereyko on 3/1/13.
//
//

#import <Foundation/Foundation.h>

#define FSZ(x) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) + 1) * x

#define TURN_LIMIT          500
#define TURN_SHARING_INC    100

@interface GameDTO : NSObject
@property (nonatomic, strong) NSNumber *wasPurchased;
@property (nonatomic, strong) NSNumber *isFirstRun;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *turnLimit;
@property (nonatomic, strong) NSNumber *turnCount;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, strong) NSDate *lastSharingTime;
@property (nonatomic, strong) NSNumber *musicOnOff;
@property (nonatomic, strong) NSNumber *soundOnOff;

+ (GameDTO *) dto;
- (void) save;
- (void) userDidSharing;

@end
