//
//  Field.m
//  Feudal
//
//  Created by Vadim Gaidukevich on 01.11.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Field.h"
#import "Game.h"
#import "GameDTO.h"


@implementation Field

static int offsets[4][2] = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}};

-(id) init
{
	if( (self=[super init]) ) {
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
        //		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
        //		CGSize size = [[CCDirector sharedDirector] winSize];
        //		label.position =  ccp( size.width /2 , size.height/2 );
        //		[self addChild: label];
        
        
        self.anchorPoint = ccp(0.5, 0.5);
        CCSprite * cells = [CCSprite spriteWithFile:@"cells.png"];
        self.contentSize = cells.contentSize;
        cells.position = ccp( cells.contentSize.width / 2 , cells.contentSize.height / 2 );
        [self addChild:cells];
        
        
        self.executionCounter = 0;
        
        cellSZ = cells.contentSize.width / 6;
        
        
//        NSMutableArray * frames = [NSMutableArray arrayWithCapacity:10];
        

        
        flash = [CCAnimation animationWithSpriteFrames:nil delay:0.05f];
//        flash.loops = 1;
        
        [flash addSpriteFrameWithFilename:@"mf0005.png"];
        [flash addSpriteFrameWithFilename:@"mf0012.png"];
        [flash addSpriteFrameWithFilename:@"mf0017.png"];
        [flash addSpriteFrameWithFilename:@"mf0022.png"];
        [flash addSpriteFrameWithFilename:@"mf0028.png"];
        [flash addSpriteFrameWithFilename:@"mf0033.png"];
        [flash addSpriteFrameWithFilename:@"mf0038.png"];
        [flash addSpriteFrameWithFilename:@"mf0044.png"];
        [flash addSpriteFrameWithFilename:@"mf0049.png"];
        [flash addSpriteFrameWithFilename:@"mf0055.png"];
        [flash addSpriteFrameWithFilename:@"mf0060.png"];
        [flash addSpriteFrameWithFilename:@"mf0063.png"];
        [flash addSpriteFrameWithFilename:@"mf0065.png"];
        [flash addSpriteFrameWithFilename:@"mf0070.png"];
        [flash addSpriteFrameWithFilename:@"mf0073.png"];
        [flash addSpriteFrameWithFilename:@"mf0075.png"];
        
        flashAnimation = [[CCAnimate actionWithAnimation: flash] retain];
//        action1.duration = 0.1;
        
        
//        CCSprite * flashSpr = [CCSprite spriteWithFile:@"mf0005.png"];
//        
//        [self addChild:flashSpr];
//        
//        flashSpr.visible = false;
        
//        flashSpr.position = ccp(100, 100);
//        [flashSpr runAction:action1];
        
//        [self initialSetupTest];
        
        
//        for (int  i = 0; i < 6; i++) {
//            CCSprite * cells = [CCSprite spriteWithFile:@"bread.png"];
//            cells.position = ccp(i * cellSZ + cellSZ / 2, cellSZ / 2);
//            [self addChild:cells];
//        }
	}
	return self;
}



-(void)initialSetupTest {
    FieldObject * o = [[FieldObject alloc] initWithType:FO_FOOD :0];
    [self drop:o X:2 Y:3];

    o = [[FieldObject alloc] initWithType:FO_FOOD :0];
    [self drop:o X:1 Y:3];
    
    o = [[FieldObject alloc] initWithType:FO_FOOD :1];
    [self drop:o X:4 Y:3];

    o = [[FieldObject alloc] initWithType:FO_FOOD :1];
    [self drop:o X:5 Y:3];

    
    o = [[FieldObject alloc] initWithType:FO_FOOD :2];
    [self drop:o X:3 Y:1];
    
    o = [[FieldObject alloc] initWithType:FO_FOOD :2];
    [self drop:o X:3 Y:2];

    o = [[FieldObject alloc] initWithType:FO_FOOD :3];
    [self drop:o X:3 Y:4];
    
    o = [[FieldObject alloc] initWithType:FO_FOOD :3];
    [self drop:o X:3 Y:5];
    
}


-(FieldObject *)objectAtX:(int)x Y:(int)y {
    if (x >= 0 && x < 6 && y >= 0 && y < 6) {
        return map[x + y * 6];
    } else
        return nil;
}

- (void)put:(FieldObject *)fo y:(int)y x:(int)x :(BOOL) animate{
    if (fo.view.parent) {
        [fo.view removeFromParentAndCleanup:YES];
    }
    [self addChild:fo.view];
    fo.view.scale = 0.1;
    map[x + y * 6] = fo;
    fo.view.position = [self posToCoords:x :y];
    fo.x = x;
    fo.y = y;
    
    id grow = [CCScaleTo actionWithDuration:0.2 scale:1.0f];
    [fo.view runAction:grow];
    
}


-(BOOL)mutateRobers:(int) x :(int)y {

    FieldObject * rober = [self objectAtX:x Y:y];
    
    if (rober != nil && rober.objectType == FO_CREATURE && rober.level == 0) {
        
        NSMutableArray * list = [self findConnectedObjects:x :y];
        BOOL isBlocked = true;
        for (FieldObject * o in list) {
            for (int i = 0; i < 4; i++) {
                int nx = o.x + offsets[i][0];
                int ny = o.y + offsets[i][1];
                if ([self objectAtX:nx Y:ny] == nil && nx >= 0 && nx < 6 && ny >= 0 && ny < 6) {
                    isBlocked = false;
                }
            }
        }
        
        if (isBlocked) {

            
            for (FieldObject * o in list) {
                map[o.x + o.y * 6] = nil;
                FieldObject * newObj = [[FieldObject alloc] initWithType:o.objectType :o.level + 1 ];
                [self put:newObj y:o.y x:o.x :YES];
                [o.view runAction: [CCFadeOut actionWithDuration:0.2]];
                [newObj.view runAction: [CCFadeIn actionWithDuration:0.2]];
                                
            }
            
            return true;
        }
    }
    return false;
}


-(BOOL)apply3Rules:(int) x :(int)y :(float) delay{
    
    NSMutableArray * list = [self findConnectedObjects:x :y];
    
    CCDelayTime * initialDelay = [CCDelayTime actionWithDuration:delay];

    
    if (list.count >= 3) {
        
        FieldObject * targetObject = [self objectAtX:x Y:y];
        
        for (FieldObject * o in list) {
            map[o.x + o.y * 6] = nil;
            
            id action1 = [CCMoveTo actionWithDuration:0.2 position:targetObject.view.position];
            id action2 = [CCFadeOut actionWithDuration:0.2];
            
            [o.view runAction: [CCSequence actions:initialDelay, action1, action2, nil]];
        
            
            
        }
        
        self.executionCounter++;
        
        id block = ^{
            FieldObject * newObj = [[FieldObject alloc] initWithType:targetObject.objectType :targetObject.level + 1 ];
            [self drop:newObj X:targetObject.x Y:targetObject.y];
            self.executionCounter--;
            
        };
        
        id delay = [CCDelayTime actionWithDuration:0.4];
        id blockAction = [CCCallBlock actionWithBlock:block];
        [self runAction: [CCSequence actions:delay, blockAction, nil]];
        
        
//        CCSprite * flashSpr = [CCSprite spriteWithFile:@"mf0005.png"];
//        [self addChild:flashSpr];
//        flashSpr.zOrder = 100;
//        flashSpr.position = targetObject.view.position;
//        
//        id cleanFlash = ^{
//            [flashSpr removeFromParentAndCleanup:YES];
//        };
//        id cleanFlashAction = [CCCallBlock actionWithBlock:cleanFlash];
//        
//        [flashSpr runAction:[CCSequence actions:flashAnimation, cleanFlashAction, nil]];
        
        
        
        //self.scoreBonus += ;
        [[Game game] addMoney:targetObject.view.position :(list.count + list.count - 3) * (targetObject.level + 1)];
        return true;
    }
    return false;
}

-(void)drop:(FieldObject *) fo X:(int) x Y:(int)y {

    [self put:fo y:y x:x :YES];
    
    if (fo.objectType == FO_CREATURE && fo.level == 0) {
        
        if ([self mutateRobers:x :y]) {
            [self apply3Rules:x :y :0.4f];
        }
    } else {
        [self apply3Rules:x :y :0.0];
    }
}


-(BOOL)tryToDrop:(FieldObject *) obj:(CGPoint) pt {
    int x = pt.x / cellSZ;
    int y = pt.y / cellSZ;

    
    if ([self objectAtX:x Y:y] == nil) {
        [self drop:obj X:x Y:y];
                
        return true;
    } else  {
        return false;
    }

}

-(CGPoint)truncate:(CGPoint) pt {
    int x = pt.x / cellSZ;
    int y = pt.y / cellSZ;
    return [self posToCoords:x :y];
}

-(CGPoint)posToCoords:(int) x :(int)y {
    return ccp(x * cellSZ + cellSZ / 2, y * cellSZ  + cellSZ / 2);    
}




-(NSMutableArray *)findConnectedObjects: (int) x :(int) y {
    
    NSMutableArray * list = [[NSMutableArray alloc] initWithCapacity:36];
    
    int begin = 0;
    [list addObject:[self objectAtX:x Y:y]];
    
    while (begin != [list count]) {
        
        FieldObject * o = [list objectAtIndex:begin];
        
        for (int j = 0; j < 4; j++) {
                FieldObject * testObject = [self objectAtX:o.x + offsets[j][0] Y:o.y + offsets[j][1]];
                bool breakFlag = false;

                if (testObject == nil) {
                    continue;
                }

                for (int k = 0; k < [list count]; k++) {
                    if ([list objectAtIndex:k] == testObject) {
                        breakFlag = true;
                        break;
                    }
                }
            
                if (breakFlag) {
                    continue;
                }


                if ([o isEqualTo:testObject]) {
                    [list addObject:testObject];
                }

            
        }
        begin++;
    }
    
    return list;
}

-(NSMutableArray *)findObjectsByType:(FIELD_OBJECT_TYPE) fot :(int)lvl {
    NSMutableArray * objs = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i = 0; i < 36; i++) {
        if (map[i] != nil && map[i].objectType == fot && map[i].level == lvl) {
            [objs addObject:map[i]];
        }
    }
    return objs;
}

-(void)moveUnits {
    NSMutableArray * creatures = [self findObjectsByType:FO_CREATURE :0];
    
    BOOL flag = true;
    while (flag) {
        flag = false;
        for (int i = creatures.count - 1; i >= 0; i--) {
            FieldObject * creature = [creatures objectAtIndex:i];
            if ([self MoveCreature:creature]) {
                flag = true;
                [creatures removeObjectAtIndex:i];
            }
        }
    }
    
    for (FieldObject * blockedCreature in creatures) {
        if ([self mutateRobers:blockedCreature.x :blockedCreature.y]) {
            [self apply3Rules:blockedCreature.x :blockedCreature.y :0.4f];
        }
    }
}

-(BOOL)MoveCreature:(FieldObject *)creature {
    NSMutableArray * directions = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        int nx = creature.x + offsets[i][0];
        int ny = creature.y + offsets[i][1];
        
        if ([self objectAtX:nx Y:ny] == nil && nx >= 0 && nx < 6 && ny >= 0 && ny < 6) {
            [directions addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    if (directions.count == 0) {
        return false;
    }
    
    int index = [((NSNumber *)[directions objectAtIndex: (rand() % directions.count)]) intValue];
    
    int nx = creature.x + offsets[index][0];
    int ny = creature.y + offsets[index][1];
    
    [creature.view runAction:[CCMoveTo actionWithDuration:0.2 position:[self posToCoords:nx :ny]]];
    map[creature.x + creature.y * 6] = nil;
    creature.x = nx;
    creature.y = ny;
    map[creature.x + creature.y * 6] = creature;
        
    return true;
}

-(void)prepareFieldForSaving {
    NSMutableArray *levels = [NSMutableArray arrayWithCapacity:36];
    NSMutableArray *types = [NSMutableArray arrayWithCapacity:36];
    
    for(int i = 0; i < 36; ++i) {
        [types addObject:@(map[i].objectType)];
        [levels addObject:@(map[i].level)];
    }
    
    [GameDTO dto].levels = [levels copy];
    [GameDTO dto].types = [types copy];
}

-(void)restoreFieldFromDTO {
    if([GameDTO dto].types == nil || [GameDTO dto].levels == nil){
        return;
    }
    
    for(int i = 0; i < 36; ++i) {
        int type = [[[GameDTO dto].types objectAtIndex:i] intValue];
        if(type != FO_INVALID) {
            int level = [[[GameDTO dto].levels objectAtIndex:i] intValue];
            FieldObject *obj = [[FieldObject alloc] initWithType:type :level];
            [self put:obj y:i / 6 x:i % 6 :NO];
        }
    }
}

@end
