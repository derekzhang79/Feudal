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
    
    NSArray * table = @[
                        @[@(FO_FOOD),       @0, @60],
                        @[@(FO_FOOD),       @1, @10],
                        @[@(FO_FOOD),       @2, @3],
                        @[@(FO_CREATURE),   @0, @25],
                        @[@(FO_SPECIAL),    @0, @100]
                         ];
    
    
    int sum = 0;
    
    
    for (int i = 0; i < table.count; i++) {
        sum += [table[i][2] integerValue];
    }
    
    int r = rand() % sum;
    

    int lvl = 0;
    FIELD_OBJECT_TYPE fot = FO_FOOD;
    
    for (int i = 0; i < table.count; i++) {
        r -= [table[i][2] integerValue];
        if (r <= 0) {
            lvl = [table[i][1] integerValue];
            fot = [table[i][0] integerValue];
            break;
        }
    }
        
    FieldObject * obj = [[FieldObject alloc] initWithType:fot :lvl];
    
    return obj;
}

- (BOOL)isEqualTo:(id)object {
    return (((FieldObject *)object).objectType == self.objectType) && (((FieldObject *)object).level == self.level);
}

@end
