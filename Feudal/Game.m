//
//  Game.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 01.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "AppDelegate.h"
#import "Field.h"
#import "Shop.h"
#import "GameDTO.h"

#define sc(x) x / [UIScreen mainScreen].scale

@implementation Game

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Game *layer = [Game node];
	[scene addChild: layer];
    layer.tag = 1;
        
	return scene;
}


Game * __sg = nil;

+(Game*) game {
    return __sg;
}

-(id) init
{
	if( (self=[super init]) ) {
        
        __sg = self;
        
        next = [[NSMutableArray alloc] initWithCapacity:10];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
		
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//		CGSize size = [[CCDirector sharedDirector] winSize];
//		label.position =  ccp( size.width /2 , size.height/2 );
//		[self addChild: label];
        
        
        CCSprite * background = [CCSprite spriteWithFile:@"map.png"];
        background.position = ccp( size.width /2 , size.height/2 );
        [self addChild:background];

        CCSprite * frame = [CCSprite spriteWithFile:@"treeframe.png"];
        frame.position = ccp( size.width /2 , size.height/2 );
        [self addChild:frame];
        
        
        field = [[Field alloc] init];
        field.position = ccp( size.width /2 , size.height/2 );
        [self addChild:field];
        [field restoreFieldFromDTO];
        
        CGSize nw = frame.boundingBox.size;
        
        nextControlOffset = [frame convertToWorldSpace:ccp(nw.width / 4 - sc(66), nw.height / 2 - sc(434))];

        
        
        [self generateNext];
        [self updateNext];
        
        
        self.isTouchEnabled = YES;
        
        
        moneyLabel = [CCLabelTTF labelWithString:@"00000" fontName:@"Old London Alternate" fontSize:sc(48)];
        moneyLabel.color = ccc3(128, 64, 0);
        [self addChild:moneyLabel];
        moneyLabel.position = [frame convertToWorldSpace:ccp(nw.width / 2 - sc(140), nw.height - sc(98))];
        
        turnsLabel = [CCLabelTTF labelWithString:@"00000" fontName:@"Old London Alternate" fontSize:sc(48)];
        turnsLabel.color = ccc3(128, 64, 0);
        [self addChild:turnsLabel];
        turnsLabel.position = [frame convertToWorldSpace:ccp(nw.width / 2 + sc(127), nw.height - sc(98))];
        
        [self updateGameState];
        
        

		CCMenuItem * marketplace = [CCMenuItemImage itemWithNormalImage:@"shop_button.png" selectedImage:@"shop_button.png" block:^(id sender) {
            
            if (!isShopMode) {
                isShopMode = YES;
                
                Shop * shop  = [Shop node];
                shop.tag = 137;
                [self addChild:shop];
                //shop.position = ccp( size.width /2 , size.height/2 );
                shop.position = [((CCMenuItem *)sender) convertToWorldSpace:((CCMenuItem *)sender).position];
                shop.scale = 0.1f;
                
                
                CCMoveTo * moveAction = [CCMoveTo actionWithDuration:0.25f position:ccp( size.width /2 , size.height/2 )];
                CCScaleTo * scaleAction = [CCScaleTo actionWithDuration:0.25f scale:1.0f];
                [shop runAction:[CCSpawn actionOne:moveAction two:scaleAction]];
            }
            
		}
        ];
		
		CCMenu * menu = [CCMenu menuWithItems:marketplace, nil];
        [self addChild:menu];
        
        menu.position = [frame convertToWorldSpace:ccp(nw.width / 2 + sc(190), nw.height / 2 - sc(444))];
        
        //menu.position = ccp(100, 100);
        
	}
	return self;
}


-(void)closeShop {
    isShopMode = NO;
    CCNode * shop = [self getChildByTag:137];
    
    
    CGSize nw = shop.parent.boundingBox.size;
    
    CCMoveTo * moveAction = [CCMoveTo actionWithDuration:0.25f position:[shop.parent convertToWorldSpace:ccp(nw.width / 2 + sc(190), nw.height / 2 - sc(444))]];
    CCScaleTo * scaleAction = [CCScaleTo actionWithDuration:0.25f scale:0.1f];
    
    
    id block = ^{
        [shop removeFromParentAndCleanup:YES];
    };


    id removeShop = [CCCallBlock actionWithBlock:block];
        
    [shop runAction:[CCSequence actions:[CCSpawn actionOne:moveAction two:scaleAction], removeShop, nil]];

}

-(void)generateNext {
    while ([next count] < 3) {
        FieldObject * fo = [FieldObject getRandom];
        fo.view.position = [self nextPositionFromIndex:10];
        [next addObject:fo];
    }
}

-(CGPoint)nextPositionFromIndex:(int)index {
    if (index < 3)
        return ccp(nextControlOffset.x + index * sc(144), nextControlOffset.y);
    else
        return ccp(nextControlOffset.x + 10 * sc(144), nextControlOffset.y);
}

-(void)updateNext {
    int count = 0;
    for (FieldObject * obj in next) {
        
            if (obj.view.parent == nil) {
                [self addChild:obj.view];
            }
        
        
//        if (count < 3) {
//            if (obj.view.parent == nil) {
//                [self addChild:obj.view];
//            }
//
//        }
        [obj.view runAction: [CCMoveTo actionWithDuration:0.2f position:[self nextPositionFromIndex:count]]];
        count++;
    }
}


-(void)purchaseItem:(FieldObject *) obj {
    [next insertObject:obj atIndex:0];
    [self updateNext];
    
}


-(void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


-(void)startSelectionAnimation:(FieldObject *) obj {

    if (selectedItem) {
//        [selectedItem.view stopAction:selectedItemAction];
        [selectedItem.view stopAllActions];
    }
    
    selectedItem = obj;
    [selectedItem.view setRotation:5];
    id rotateLeft = [CCRotateTo actionWithDuration:0.5 angle:-5];
    id rotateRight = [CCRotateTo actionWithDuration:0.5 angle:+5];
    id sequnce = [CCSequence actions:rotateLeft, rotateRight, nil];
//    selectedItemAction = [CCRepeatForever actionWithAction:sequnce];
    CCRepeatForever * repeat = [CCRepeatForever actionWithAction:sequnce];
    repeat.tag = 2;
    [selectedItem.view runAction:repeat];
    
}

-(void)stopSelectionAnimation {
    [selectedItem.view stopActionByTag:2];
    [selectedItem.view setRotation:0];

//    if (selectedItemAction != nil) {
//        CCAction * action = selectedItemAction;
//        [selectedItem.view stopAction:selectedItemAction];
//        selectedItemAction = nil;
//    }
    
    selectedItem = nil;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    CGPoint pt = [self convertTouchToNodeSpace:touch];
    
    for (int i = 0; i < 3; i++) {
        FieldObject * fo = [next objectAtIndex:i];
        if(CGRectContainsPoint(fo.view.boundingBox, pt)) {
            draggedItem = fo;
            draggedItemInitialPosition = fo.view.position;
            
            [self startSelectionAnimation:fo];
            break;
        }
    }
    
    return true;
}




- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [self convertTouchToNodeSpace:touch];
    if (draggedItem != nil) {
        if (selectedItem != nil) {
            [self stopSelectionAnimation];
        }
        if (CGRectContainsPoint(field.boundingBox, pt)) {
            CGPoint ptOnField = [field convertTouchToNodeSpace:touch];
            draggedItem.view.position = [field convertToWorldSpace:[field truncate:ptOnField]];
        } else {
            draggedItem.view.position = pt;
            
        }
    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
     CGPoint pt = [self convertTouchToNodeSpace:touch];
     CGPoint ptOnField = [field convertTouchToNodeSpace:touch];

    if (selectedItem) {
        if (CGRectContainsPoint(field.boundingBox, pt)) {
            
            if (![field tryToDrop:selectedItem :ptOnField]) {
                //[draggedItem.view runAction: [CCMoveTo actionWithDuration:0.2f position:draggedItemInitialPosition]];
            } else {
                id tmp = selectedItem;
                [self stopSelectionAnimation];
                [next removeObject:tmp];
                [self doTurn];
            }
            selectedItem = nil;
            draggedItem = nil;
        }
    } else if (draggedItem) {
        
        if (CGRectContainsPoint(field.boundingBox, pt)) {
    
            if (![field tryToDrop:draggedItem :ptOnField]) {
                [draggedItem.view runAction: [CCMoveTo actionWithDuration:0.2f position:draggedItemInitialPosition]];                
                [self startSelectionAnimation:draggedItem];
            } else {
                
                [next removeObject:draggedItem];
                [self doTurn];
            }
        } else {
            [draggedItem.view runAction: [CCMoveTo actionWithDuration:0.2f position:draggedItemInitialPosition]];            
        }
        draggedItem = nil;
        selectedItem = nil;        
    }
}

-(void)doTurn {
    [self generateNext];
    [self updateNext];

    
    while (!field.executionCounter == 0) {
        NSLog(@"waiting!!!");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    NSLog(@"Finished!!!");
    [field moveUnits];
    
    [GameDTO dto].turnLimit = @([GameDTO dto].turnLimit.integerValue - 1);
    [turnsLabel setString:[NSString stringWithFormat:@"%05d", [GameDTO dto].turnLimit.integerValue]];
    [field prepareFieldForSaving];
    [[GameDTO dto] save];
}

-(void)updateGameState {
    [moneyLabel setString:[NSString stringWithFormat:@"%05d", [GameDTO dto].money.integerValue]];
    [turnsLabel setString:[NSString stringWithFormat:@"%05d", [GameDTO dto].turnLimit.integerValue]];
}

-(void)addMoney:(CGPoint) position :(int) count {
    [GameDTO dto].money = @([GameDTO dto].money.integerValue + count);

    CCSprite * moneySpr = [CCSprite spriteWithFile:@"mf0038.png"];
    [self addChild:moneySpr];
    moneySpr.position = [field convertToWorldSpace:position];

    id cleanFlash = ^{
        [moneySpr removeFromParentAndCleanup:YES];
        [self updateGameState];
    };
    id cleanFlashAction = [CCCallBlock actionWithBlock:cleanFlash];

    
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveAction = [CCMoveTo actionWithDuration:0.4 position:ccp(90, size.height - 78)];

    [moneySpr runAction:[CCSequence actions:moveAction, cleanFlashAction, nil]];

}


@end
