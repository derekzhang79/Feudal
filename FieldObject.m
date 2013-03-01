//
//  FieldObject.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 03.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FieldObject.h"


@implementation FieldObject

-(id) init
{
	if( (self=[super init]) ) {
	}
	return self;
}

-(id)initWithType:(FIELD_OBJECT_TYPE) type :(int)level {
    
	if( (self=[super init]) ) {
        

        if (type == FO_FOOD) {
            switch (level) {
                case 0:
                    self.view = [CCSprite spriteWithFile:@"field.png"];
                    break;
                case 1:
                    self.view = [CCSprite spriteWithFile:@"hay.png"];
                    break;
                case 2:
                    self.view = [CCSprite spriteWithFile:@"flour.png"];
                    break;
                case 3:
                    self.view = [CCSprite spriteWithFile:@"bread.png"];
                    break;
                case 4:
                    self.view = [CCSprite spriteWithFile:@"village.png"];
                    break;
                case 5:
                    self.view = [CCSprite spriteWithFile:@"zamok.png"];
                    break;
                default:
                    self.view = [CCSprite spriteWithFile:@"field.png"];
                    break;
            }
            
        } else if (type == FO_CREATURE) {
            switch (level) {
                case 0:
                    self.view = [CCSprite spriteWithFile:@"robber.png"];
                    break;
                case 1:
                    self.view = [CCSprite spriteWithFile:@"peasant.png"];
                    break;
                case 2:
                    self.view = [CCSprite spriteWithFile:@"rookie.png"];
                    break;
                case 3:
                    self.view = [CCSprite spriteWithFile:@"solider.png"];
                    break;
                case 4:
                    self.view = [CCSprite spriteWithFile:@"knight.png"];
                    break;
                case 5:
                    self.view = [CCSprite spriteWithFile:@"feudal.png"];
                    break;
                default:
                    self.view = [CCSprite spriteWithFile:@"robber.png"];
                    break;
            }
        } else if (type == FO_SPECIAL) {
            self.view = [CCSprite spriteWithFile:@"dragon.png"];
        }
        
        
        self.objectType = type;
        self.level = level;
    }
    return self;
}


+(FieldObject *)getRandom {
    
    
    int r = rand() % 100;
    int lvl = 0;
    
    if (r > 95) {
        lvl = 2;
    } else if (r > 80) {
        lvl = 1;
    } else {
        lvl = 0;
    }
    
    FIELD_OBJECT_TYPE fot = FO_FOOD;
    
    if (rand() % 100 < 10) {
        fot = FO_CREATURE;
        lvl = 0;
    }
    
    if (rand() % 100 < 30) {
        fot = FO_SPECIAL;
        lvl = 0;
    }
    
    FieldObject * obj = [[FieldObject alloc] initWithType:fot :lvl];
    
    return obj;
}

- (BOOL)isEqualTo:(id)object {
    return (((FieldObject *)object).objectType == self.objectType) && (((FieldObject *)object).level == self.level);
}

@end
