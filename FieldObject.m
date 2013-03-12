//
//  FieldObject.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 03.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FieldObject.h"


@implementation FieldObject

static NSArray * table;

+(void)initialize {
    table = [@[
                @[@(FO_FOOD),       @0, @60,    @"field.png"],
                @[@(FO_FOOD),       @1, @10,    @"hay.png"],
                @[@(FO_FOOD),       @2, @3,     @"flour.png"],
                @[@(FO_FOOD),       @3, @0,     @"bread.png"],
                @[@(FO_FOOD),       @4, @0,     @"village.png"],
                @[@(FO_FOOD),       @5, @0,     @"zamok.png"],
                @[@(FO_CREATURE),   @0, @25,    @"robber.png"],
                @[@(FO_CREATURE),   @1, @0,    @"peasant.png"],
                @[@(FO_CREATURE),   @2, @0,    @"rookie.png"],
                @[@(FO_CREATURE),   @3, @0,    @"solider.png"],
                @[@(FO_CREATURE),   @4, @0,    @"knight.png"],
                @[@(FO_CREATURE),   @5, @0,    @"feudal.png"],
                @[@(FO_SPECIAL),    @0, @2,    @"dragon.png"],
                @[@(FO_SPECIAL),    @1, @10,    @"mf0038.png"]
                ] copy];
}

-(id) init
{
	if( (self=[super init]) ) {
        
	}
	return self;
}

-(id)initWithType:(FIELD_OBJECT_TYPE) type :(int)level {
    
	if( (self=[super init]) ) {
        
    
        for (int i = 0; i < table.count; i++) {
            if ([table[i][0] integerValue] == type && [table[i][1] integerValue] == level) {
                self.view = [CCSprite spriteWithFile:table[i][3]];
            }
        }        
        
        self.objectType = type;
        self.level = level;
    }
    return self;
}


+(FieldObject *)getRandom {
    

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
