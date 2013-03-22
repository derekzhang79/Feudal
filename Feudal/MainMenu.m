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
#import "SHK.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "Options.h"
#import "MySoundManager.h"

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
        
        [Game addLabel:@"Continue" :continueItem];
		
        CCMenuItem * start = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            //  clear the save and start game from scratch
            [GameDTO dto].levels = nil;
            [GameDTO dto].types = nil;
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Game scene] withColor:ccWHITE]];
        }];
        
        [Game addLabel:@"New Game" :start];

        
        CCMenuItem * options = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            [MainMenu showOptionsMenu:self];
        }];
        
        [Game addLabel:@"Options" :options];
        
        CCMenuItem * help = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
        }];
        [Game addLabel:@"Help" :help];
        
        
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
        
        CCMenuItem * facebook = [CCMenuItemImage itemWithNormalImage:@"facebook.png" selectedImage:@"facebook.png" block:^(id sender) {
            SHKItem *item = [SHKItem text:@"test text"];
            SHKSharer* sharer = [[[SHKFacebook alloc] init] autorelease];
            sharer.shareDelegate = self;
            [sharer loadItem:item];
            
            [sharer share];
        }];
        
        CCMenuItem * twitter = [CCMenuItemImage itemWithNormalImage:@"twitter.png" selectedImage:@"twitter.png" block:^(id sender) {
            SHKItem *item = [SHKItem text:@"test text"];
            SHKSharer* sharer = [[[SHKTwitter alloc] init] autorelease];
            sharer.shareDelegate = self;
            [sharer loadItem:item];
            
            [sharer share];
        }];
        
        int offsetH = ((CCMenuItem *)([menu.children objectAtIndex:0])).position.y + ((CCMenuItem *)([menu.children objectAtIndex:0])).boundingBox.size.height / 2;
        menu.position = ccpSub(logo.position, ccp(0, logo.boundingBox.size.height / 2 + offsetH));
        
        CCMenu * socialMenu = [CCMenu menuWithItems:facebook, twitter, nil];
        socialMenu.position = ccp(FSZ(80), FSZ(40));
        [socialMenu alignItemsHorizontally];
        [background addChild:socialMenu];
        
        [[MySoundManager soundManager] setMusicEnabled:[[GameDTO dto].musicOnOff boolValue]];
        [[MySoundManager soundManager] play:@"game02.mp3"];
	}
	return self;
}

+ (void) showOptionsMenu:(id)sender {
    CGSize size = [[CCDirector sharedDirector] winSize];
    OptionsMode mode;
    if ([sender isKindOfClass:MainMenu.class]) {
        mode = OptionsModeDefault;
    } else {
        mode = OptionsModeShowsAbandon;
    }
    Options * options  = [[[Options alloc] initWithMode:mode] autorelease];
    options.tag = 138;
    [sender addChild:options];
    options.position = [((CCMenuItem *)sender) convertToWorldSpace:((CCMenuItem *)sender).position];
    options.scale = 0.1f;
    
    CCMoveTo * moveAction = [CCMoveTo actionWithDuration:0.25f position:ccp( size.width /2 , size.height/2 )];
    CCScaleTo * scaleAction = [CCScaleTo actionWithDuration:0.25f scale:1.0f];
    [options runAction:[CCSpawn actionOne:moveAction two:scaleAction]];
}

- (void)sharerFinishedSending:(SHKSharer *)sharer {
    [[GameDTO dto] userDidSharing];
}

@end
