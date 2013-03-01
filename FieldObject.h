//
//  FieldObject.h
//  Feudal
//
//  Created by Vadim Gaidukevich on 03.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum FIELD_OBJECT_TYPE {
    FO_FOOD = 1,
    FO_CREATURE = 2,
    FO_RELIGION = 3,
    FO_SPECIAL = 4,
} FIELD_OBJECT_TYPE;

@interface FieldObject : NSObject {
    
}

-(id)initWithType:(FIELD_OBJECT_TYPE) type :(int)level;
+(FieldObject *)getRandom;

- (BOOL)isEqualTo:(id)object;


@property (retain) CCSprite * view;

@property FIELD_OBJECT_TYPE objectType;
@property int level;


@property int x;
@property int y;

@end
