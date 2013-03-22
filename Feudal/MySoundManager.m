//
//  MySoundManager.m
//  Geometris
//
//  Created by Vadim Gaidukevich on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MySoundManager.h"
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"



@implementation MySoundManager

-(id)init {
    if( (self=[super init])) {
        currentMusic = nil;
        musicEnabled = true;
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"game01.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"game02.mp3"];
    }
    
    return self;
}

-(void)play:(NSString *)music {
    if (currentMusic == nil || [music compare:currentMusic] != 0) {
        currentMusic = music;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:currentMusic];
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5f;
    }
}

-(bool)musicEnabled {
    return musicEnabled;
}

-(void)setMusicEnabled:(bool)enabled {
    musicEnabled = enabled;
    if (enabled) {    
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:currentMusic];
    } else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];        
    }
}

static MySoundManager * soundManageInst = nil;

+(MySoundManager *)soundManager {
    if (soundManageInst == nil) {
        soundManageInst = [[MySoundManager alloc] init];
    }
    
    return soundManageInst;
}





@end
