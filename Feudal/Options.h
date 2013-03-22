//
//  Options.h
//  Feudal
//
//  Created by Eugene Adereyko on 3/15/13.
//
//

#import "CCNode.h"
#import "cocos2d.h"

typedef NS_ENUM(NSInteger, OptionsMode) {
    OptionsModeDefault
    , OptionsModeShowsAbandon
};

@interface Options : CCNode

-(id) initWithMode:(OptionsMode)mode;

@end
