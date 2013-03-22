//
//  MySoundManager.h
//  Geometris
//
//  Created by Vadim Gaidukevich on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MySoundManager : NSObject {
    NSString * currentMusic;
    bool musicEnabled;
}

-(id)init;

-(void)play:(NSString *)music;

-(bool)musicEnabled;
-(void)setMusicEnabled:(bool)enabled;
+(MySoundManager *)soundManager;

@end
