//
//  Field.h
//  Feudal
//
//  Created by Vadim Gaidukevich on 01.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FieldObject.h"


@interface Field : CCNode {
    FieldObject * map[36];
    
    int cellSZ;
    
    CCAnimation * flash;
    CCAnimate * flashAnimation;
    
    CCAnimation * dragon;
    CCAnimate * dragonAnimation;
    
    CCAnimation * dragonBreath;
    CCAnimate * dragonBreathAnimation;
    
    
    FIELD_OBJECT_TYPE gemEvaluateType;
    int gemEvaluateLevel;
    
}

-(FieldObject *)objectAtX:(int)x Y:(int)y;
-(void)drop:(FieldObject *) fo X:(int) x Y:(int)y;

-(BOOL)tryToDrop:(FieldObject *) obj :(CGPoint) pt;

-(CGPoint)truncate:(CGPoint) pt;
-(CGPoint)posToCoords:(int) x :(int)y;

-(void)moveUnits;
-(NSMutableArray *)findObjectsByType:(FIELD_OBJECT_TYPE) fot :(int)lvl;

-(BOOL)MoveCreature:(FieldObject *)creature;

-(BOOL)mutateRobers:(int) x :(int)y;
-(BOOL)apply3Rules:(int) x :(int)y :(float)delay;


-(void)initialSetupTest;
-(void)prepareFieldForSaving;
-(void)restoreFieldFromDTO;

-(BOOL)isFreeSpace;

@property int executionCounter;

@property int scoreBonus;


@end
