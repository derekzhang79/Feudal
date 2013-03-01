//
//  GameDTO.h
//  Feudal
//
//  Created by Eugene Adereyko on 3/1/13.
//
//

#import <Foundation/Foundation.h>

@interface GameDTO : NSObject
@property (nonatomic, strong) NSNumber *wasPurchased;
@property (nonatomic, strong) NSNumber *isFirstRun;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *turnLimit;
@property (nonatomic, strong) NSNumber *turnCount;

+ (GameDTO *) dto;
- (void) save;

@end
