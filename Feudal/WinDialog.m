//
//  WinDialog.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 15.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WinDialog.h"
#import "Game.h"
#import "GameDTO.h"
#import "MainMenu.h"

@implementation WinDialog


-(id) init
{
    
    if( (self=[super init]) ) {
                
        CCSprite * background = [CCSprite spriteWithFile:@"fon.png"];
        [self addChild:background];
//        self.contentSize = background.contentSize;
        CGSize labelSize  = CGSizeMake(background.contentSize.width - FSZ(80), 60);
        
        CCNode * emptyNode = [[CCNode alloc] init];
        emptyNode.contentSize = CGSizeMake(FSZ(50), FSZ(50));
        
        [Game addLabel:@"WIN" :emptyNode];
        
        [self addChild:emptyNode];
        emptyNode.position = ccp(FSZ(-17), FSZ(48));
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:@"Congratulations, You won! You have achived score XXXX! " dimensions:labelSize hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeCharacterWrap fontName:@"Old London Alternate" fontSize:FSZ(24)];
        label.color = ccc3(128, 64, 0);
        [background addChild:label];
        label.position = ccp(background.boundingBox.size.width / 2, background.boundingBox.size.height / 2);
        

		CCMenuItem * ok = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            [GameDTO dto].levels = nil;
            [GameDTO dto].types = nil;
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenu scene] withColor:ccWHITE]];
            
		}];
		
        [Game addLabel:@"Ok" :ok];
		CCMenu * menu = [CCMenu menuWithItems:ok, nil];
        [background addChild:menu];
        
        menu.position = ccp(background.boundingBox.size.width / 2 + FSZ(10),  FSZ(40));
        
        CCMenu * socialMenu = [MainMenu socialMenuWithDelegate:self];
        socialMenu.position = ccp(FSZ(80), FSZ(38));
        [background addChild:socialMenu];
    }
    
    return self;
}

- (void)sharerFinishedSending:(SHKSharer *)sharer {
    [[GameDTO dto] userDidSharing];
}

@end
