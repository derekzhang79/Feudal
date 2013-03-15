//
//  Shop.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Shop.h"
#import "FieldObject.h"
#import "Game.h"
#import "ccConfig.h"
#import "GameDTO.h"


#define sc(x) x / [UIScreen mainScreen].scale

@interface ShopMenuItem : CCNode {
    void (^_block)(id sender);
}

+(id) itemWithString: (NSString*) value picture:(NSString *) view block:(void(^)(id sender))block;

-(CGRect) rect;

@end

@implementation ShopMenuItem

-(CGRect) rect {
    return CGRectMake( position_.x - contentSize_.width*anchorPoint_.x,
                      position_.y - contentSize_.height*anchorPoint_.y,
                      contentSize_.width, contentSize_.height);
}

-(id) initWithString: (NSString*) value picture:(NSString *) view block:(void(^)(id sender))block {
    if( (self=[super init]) ) {
        
        _block = [block copy];

        CCSprite * sprite = [CCSprite spriteWithFile:view];
        [self addChild:sprite];
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:value fontName:@"Old London Alternate" fontSize:FSZ(24)];
        label.color = ccc3(128, 64, 0);
        [self addChild:label];
        
        label.position = ccp(sprite.contentSize.width, 0);
        
        //sprite.position = ccp(sprite.contentSize.width / 2, sprite.contentSize.height / 2);        
        //label.position = ccp(sprite.contentSize.width + 20, sprite.contentSize.height / 2);

        [self setContentSize:CGSizeMake(sprite.contentSize.width + (sprite.contentSize.width + label.contentSize.width) / 2, sprite.contentSize.height)];        
        [self registerWithTouchDispatcher];
    }
    return self;
    
}

-(CGRect)boundingBox {
    if ([children_ count] > 1) {
        CGRect rect1 = [[children_ objectAtIndex:0] boundingBox];
//        CGRect rect2 = [[children_ objectAtIndex:1] boundingBox];
        return CGRectMake(rect1.origin.x, rect1.origin.y, contentSize_.width, contentSize_.height);
        //return CGRect[[children_ objectAtIndex:0] boundingBox];
    } else
        return [super boundingBox];
}

//-(void) draw
//{
//    ccDrawRect(self.boundingBox.origin, ccpAdd(self.boundingBox.origin, ccp(self.boundingBox.size.width,self.boundingBox.size.height)));    
//}

+(id) itemWithString: (NSString*) value picture:(NSString *) view block:(void(^)(id sender))block
{
    return [[[self alloc] initWithString:value picture:view block:block] autorelease];
}

-(void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint pt = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(self.boundingBox, pt)) {
        
        _block(self);
        return true;
    }
    return false;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
}



@end


@implementation Shop


-(id) init
{
	if( (self=[super init]) ) {
        

        CCSprite * background = [CCSprite spriteWithFile:@"fon_large.png"];
        [self addChild:background];
        self.contentSize = background.contentSize;

        CCNode * emptyNode = [[CCNode alloc] init];
        emptyNode.contentSize = CGSizeMake(FSZ(50), FSZ(50));
        
        [Game addLabel:@"Shop" :emptyNode];
        
        [self addChild:emptyNode];
        emptyNode.position = ccp(FSZ(-17), FSZ(145));
		
		ShopMenuItem *item1 = [ShopMenuItem itemWithString:@"10" picture:@"field.png" block:^(id sender) {
			FieldObject * fo = [[FieldObject alloc] initWithType:FO_FOOD :0];
            ShopMenuItem * item = (ShopMenuItem *)sender;
            fo.view.position = [self convertToWorldSpace:item.position];
            [parent_ addChild:fo.view];
            [[Game game] purchaseItem:fo];
            [[Game game] closeShop];            

		}];

		ShopMenuItem *item2 = [ShopMenuItem itemWithString:@"20" picture:@"hay.png" block:^(id sender) {
			FieldObject * fo = [[FieldObject alloc] initWithType:FO_FOOD :1];
            ShopMenuItem * item = (ShopMenuItem *)sender;
            fo.view.position = [self convertToWorldSpace:item.position];
            [parent_ addChild:fo.view];
            [[Game game] purchaseItem:fo];
            [[Game game] closeShop];
            
		}];

		ShopMenuItem *item3 = [ShopMenuItem itemWithString:@"30" picture:@"flour.png" block:^(id sender) {
			FieldObject * fo = [[FieldObject alloc] initWithType:FO_FOOD :2];
            ShopMenuItem * item = (ShopMenuItem *)sender;
            fo.view.position = [self convertToWorldSpace:item.position];
            [parent_ addChild:fo.view];
            [[Game game] purchaseItem:fo];
            [[Game game] closeShop];
            
		}];

        
		ShopMenuItem *item4 = [ShopMenuItem itemWithString:@"40" picture:@"dragon.png" block:^(id sender) {
			FieldObject * fo = [[FieldObject alloc] initWithType:FO_SPECIAL :0];
            ShopMenuItem * item = (ShopMenuItem *)sender;
            fo.view.position = [self convertToWorldSpace:item.position];
            [parent_ addChild:fo.view];
            [[Game game] purchaseItem:fo];
            [[Game game] closeShop];
            
		}];

		ShopMenuItem *item5 = [ShopMenuItem itemWithString:@"50" picture:@"mf0044.png" block:^(id sender) {
			FieldObject * fo = [[FieldObject alloc] initWithType:FO_SPECIAL :1];
            ShopMenuItem * item = (ShopMenuItem *)sender;
            fo.view.position = [self convertToWorldSpace:item.position];
            [parent_ addChild:fo.view];
            [[Game game] purchaseItem:fo];
            [[Game game] closeShop];
            
		}];

		ShopMenuItem *item6 = [ShopMenuItem itemWithString:@"$.99" picture:@"flour.png" block:^(id sender) {
			FieldObject * fo = [[FieldObject alloc] initWithType:FO_SPECIAL :1];
            ShopMenuItem * item = (ShopMenuItem *)sender;
            fo.view.position = [self convertToWorldSpace:item.position];
            [parent_ addChild:fo.view];
            [[Game game] purchaseItem:fo];
            [[Game game] closeShop];
            
		}];
        
        
        [self addChild:item1];
        item1.position = ccp(FSZ(-100),  FSZ(50));

        [self addChild:item2];
        item2.position = ccp(FSZ(-100),  FSZ(0));
        
        [self addChild:item3];
        item3.position = ccp(FSZ(-100),  FSZ(-50));

        
        [self addChild:item4];
        item4.position = ccp(FSZ(50),  FSZ(50));
        
        [self addChild:item5];
        item5.position = ccp(FSZ(50),  FSZ(0));
        
        [self addChild:item6];
        item6.position = ccp(FSZ(50),  FSZ(-50));

        
        
		CCMenuItem * ok = [CCMenuItemImage itemWithNormalImage:@"empty.png" selectedImage:@"emptyOn.png" block:^(id sender) {
            [[Game game] closeShop];
		}
                                    ];
		
        [Game addLabel:@"Close" :ok];
		CCMenu * menu = [CCMenu menuWithItems:ok, nil];
        [background addChild:menu];
        
        menu.position = ccp(background.boundingBox.size.width / 2,  FSZ(60));
        
        
        
    }
    return self;
}




@end
