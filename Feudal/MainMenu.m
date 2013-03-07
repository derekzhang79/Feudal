//
//  MainMenu.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 08.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "Game.h"
#import "GameDTO.h"

@implementation MainMenu

#define sc(x) x / [UIScreen mainScreen].scale

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenu *layer = [MainMenu node];
	
	[scene addChild: layer];
	
	return scene;
}


// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        CCSprite * background = [CCSprite spriteWithFile:@"splash.jpg"];
        background.position = ccp( size.width /2 , size.height/2 );
        [self addChild:background];

        
        CCSprite * logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.position = ccp( 3 * size.width / 8 , 3 * size.height / 5 );
        [background addChild:logo];
        
        CCMenuItem * continueItem = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"startOn.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccWHITE]];
        }];
		
        CCMenuItem * start = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"startOn.png" block:^(id sender) {
            //  clear the save and start game from scratch
            [GameDTO dto].levels = nil;
            [GameDTO dto].types = nil;
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccWHITE]];
        
        }];
        
		CCMenu * menu = [CCMenu menuWithItems:nil];
        
        //  check if the game might be continued, i.e. if the save file contains any objects in grid
        if([[GameDTO dto].levels count] && [[GameDTO dto].levels count]){
            [menu addChild:continueItem];
        }
        [menu addChild:start];
        
        [menu alignItemsVertically];
        [self addChild:menu];
        
        menu.position = [background convertToWorldSpace:ccp(size.width / 2 + sc(190), size.height / 2 - sc(444))];
        




            
        
	}
	return self;
}


@end
