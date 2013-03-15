//
//  Options.m
//  Feudal
//
//  Created by Eugene Adereyko on 3/15/13.
//
//

#import "FieldObject.h"
#import "Game.h"
#import "ccConfig.h"
#import "GameDTO.h"
#import "Options.h"

@implementation Options

-(id) init
{
	if( (self=[super init]) ) {
        CCSprite * background = [CCSprite spriteWithFile:@"fon_large.png"];
        [self addChild:background];
        self.contentSize = background.contentSize;
        
        CCNode * emptyNode = [[CCNode alloc] init];
        emptyNode.contentSize = CGSizeMake(FSZ(50), FSZ(50));
        
        [Game addLabel:@"Optionsb" :emptyNode];
        
        [self addChild:emptyNode];
        emptyNode.position = ccp(FSZ(-17), FSZ(145));
        
        CCMenuItem * ok = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            CGSize nw = self.parent.boundingBox.size;
            
            CCMoveTo * moveAction = [CCMoveTo actionWithDuration:0.25f position:[self.parent convertToWorldSpace:ccp(nw.width / 2, nw.height / 2)]];
            CCScaleTo * scaleAction = [CCScaleTo actionWithDuration:0.25f scale:0.1f];
            
            
            id block = ^{
                [self removeFromParentAndCleanup:YES];
            };
            
            id removeShop = [CCCallBlock actionWithBlock:block];
            
            [self runAction:[CCSequence actions:[CCSpawn actionOne:moveAction two:scaleAction], removeShop, nil]];
		}];
		
        [Game addLabel:@"Close" :ok];
		CCMenu * menu = [CCMenu menuWithItems:ok, nil];
        [background addChild:menu];
        
        menu.position = ccp(background.boundingBox.size.width / 2,  FSZ(60));
    }
    return self;
}

@end
