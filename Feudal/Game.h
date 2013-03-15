//
//  Game.h
//  Feudal
//
//  Created by Vadim Gaidukevich on 01.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "FieldObject.h"
#import "Field.h"

#define sc(x) x / [UIScreen mainScreen].scale

@interface Game : CCLayer// <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray * next;
    CGPoint nextControlOffset;
    
    FieldObject * draggedItem;
    CGPoint draggedItemInitialPosition;
    FieldObject * selectedItem;
    id selectedItemAction;

    Field * field;
    
    CCLabelTTF * moneyLabel;
    CCLabelTTF * turnsLabel;
    
    BOOL isShopMode;
    
}

+(CCScene *) scene;

+(Game *) game;

-(void)generateNext;
-(void)updateNext;
-(CGPoint)nextPositionFromIndex:(int)index;
-(void)doTurn;

-(void)addMoney:(CGPoint) position :(int) count;

-(void)purchaseItem:(FieldObject *) obj;

-(void)closeShop;

+(void)addLabel:(NSString *) txt :(CCNode *) node;

@end
