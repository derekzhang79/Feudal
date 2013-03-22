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
#import "MySoundManager.h"

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
        
        
        CCMenuItem *soundOnItem = [CCMenuItemImage itemWithNormalImage:@"emptyOn.png"
                                                         selectedImage:@"emptyOn.png"
                                                                 block:^(id sender){}];
        [Game addLabel:@"Sound on" :soundOnItem];
        
        CCMenuItem *soundOffItem = [CCMenuItemImage itemWithNormalImage:@"empty.png"
                                                          selectedImage:@"empty.png"
                                                                  block:^(id sender){}];
        [Game addLabel:@"Sound off" :soundOffItem];
        
        CCMenuItem *musicOnItem = [CCMenuItemImage itemWithNormalImage:@"emptyOn.png"
                                                         selectedImage:@"emptyOn.png"
                                                                 block:^(id sender){}];
        [Game addLabel:@"Music on" :musicOnItem];
        
        CCMenuItem *musicOffItem = [CCMenuItemImage itemWithNormalImage:@"empty.png"
                                                          selectedImage:@"empty.png"
                                                                  block:^(id sender){}];
        [Game addLabel:@"Music off" :musicOffItem];
        
        CCMenuItemToggle *toggleSound = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleSoundSelector:) items:soundOnItem, soundOffItem, nil];
        CCMenuItemToggle *toggleMusic = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleMusicSelector:) items:musicOnItem, musicOffItem, nil];
        
        [toggleSound setSelectedIndex:![[GameDTO dto].soundOnOff integerValue]];
        [toggleMusic setSelectedIndex:![[GameDTO dto].musicOnOff integerValue]];
        
        CCMenu * menu2 = [CCMenu menuWithItems:toggleSound, toggleMusic, nil];
        [menu2 alignItemsVertically];
        [background addChild:menu2];
        
        menu2.position = ccp(background.boundingBox.size.width / 2,  background.boundingBox.size.height / 2);
    }
    return self;
}

- (IBAction)toggleSoundSelector:(id)sender {
    CCMenuItemToggle *toggleSound = (CCMenuItemToggle *)sender;
    [GameDTO dto].soundOnOff = [NSNumber numberWithInteger:!toggleSound.selectedIndex];
    [[GameDTO dto] save];
}

- (IBAction)toggleMusicSelector:(id)sender {
    CCMenuItemToggle *toggleMusic = (CCMenuItemToggle *)sender;
    [GameDTO dto].musicOnOff = [NSNumber numberWithInteger:!toggleMusic.selectedIndex];
    [[GameDTO dto] save];
    [[MySoundManager soundManager] setMusicEnabled:[[GameDTO dto].musicOnOff boolValue]];
}

@end
