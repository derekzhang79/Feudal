//
//  MainMenu.h
//  Feudal
//
//  Created by Vadim Gaidukevich on 08.01.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SHKSharer.h"

@interface MainMenu : CCLayer <SHKSharerDelegate> {
    
}

+ (CCScene *) scene;
+ (void) showOptionsMenu:(id)sender;

@end
