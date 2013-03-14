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
        logo.position = ccp( background.boundingBox.size.width / 4 + 10 , 4 * background.boundingBox.size.height / 5 );;
        [background addChild:logo];
        
        CCMenuItem * continueItem = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccWHITE]];
        }];
        
        [self addLableToMenu:@"Continue" :continueItem];

        
		
        CCMenuItem * start = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            //  clear the save and start game from scratch
            [GameDTO dto].levels = nil;
            [GameDTO dto].types = nil;
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccWHITE]];
        
        }];
        
        [self addLableToMenu:@"New Game" :start];

        
        CCMenuItem * options = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
        }];
        [self addLableToMenu:@"Options" :options];
        
        CCMenuItem * help = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
        }];
        [self addLableToMenu:@"Help" :help];
        
        
		CCMenu * menu = [CCMenu menuWithItems:nil];
        
        //  check if the game might be continued, i.e. if the save file contains any objects in grid
        if([[GameDTO dto].levels count] && [[GameDTO dto].levels count]){
            [menu addChild:continueItem];
        }
        [menu addChild:start];
        [menu addChild:options];
        [menu addChild:help];
        
        [menu alignItemsVertically];
        [background addChild:menu];
        
        
        [menu.children objectAtIndex:0];
        
        int offsetH = ((CCMenuItem *)([menu.children objectAtIndex:0])).position.y + ((CCMenuItem *)([menu.children objectAtIndex:0])).boundingBox.size.height / 2;
        menu.position = ccpSub(logo.position, ccp(0, logo.boundingBox.size.height / 2 + offsetH));
        
	}
	return self;
}


-(void)addLableToMenu:(NSString *) txt :(CCMenuItem *) item{
                

    CCLabelTTF * menuLable2 = [CCLabelTTF labelWithString:txt fontName:@"Old London Alternate" fontSize:FSZ(20)];
    menuLable2.color = ccc3(80, 40, 0);
    [item addChild:menuLable2];
    menuLable2.scale = 1.1f;
    menuLable2.position = ccp(item.boundingBox.size.width / 2, item.boundingBox.size.height / 2 - 2);
    
    CCLabelTTF * menuLable = [CCLabelTTF labelWithString:txt fontName:@"Old London Alternate" fontSize:FSZ(20)];
    menuLable.color = ccc3(255, 255, 120);
    [item addChild:menuLable];
    menuLable.position = ccp(item.boundingBox.size.width / 2, item.boundingBox.size.height / 2 - 2);
    
}

@end
