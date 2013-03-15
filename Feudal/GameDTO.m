//
//  GameDTO.m
//  Feudal
//
//  Created by Eugene Adereyko on 3/1/13.
//
//

#import "GameDTO.h"
#import "objc/runtime.h"

@implementation GameDTO

+ (GameDTO *) dto{
    static GameDTO *gameDTO;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        gameDTO = [GameDTO new];
        [gameDTO load];
    });
    
    return gameDTO;
}

- (void) save{
    unsigned int varCount;
    
    Ivar *vars = class_copyIvarList([GameDTO class], &varCount);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // loop through all the variables of our class
    for (int i = 0; i < varCount; i++){
        Ivar var = vars[i];
        
        // get variable name
        NSString *varName = [NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding];
        
        id obj = [self valueForKey:varName];
        if(obj != nil){
            [dictionary setObject:obj forKey:varName];
        }
    }
    
    NSString *filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:[self pathForDocuments], @"savegame.plist", nil]];
    
    NSString* error;
    NSData* pListData = [NSPropertyListSerialization dataFromPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    [pListData writeToFile:filePath atomically:YES];
    
    free(vars);
}

- (void) load{
    NSString *filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:[self pathForDocuments], @"savegame.plist", nil]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    self.isFirstRun = @(!fileExists);
    
    if(fileExists){
        unsigned int varCount;
        Ivar *vars = class_copyIvarList([GameDTO class], &varCount);
        
        NSError* error;
        NSData *pListData = [NSData dataWithContentsOfFile:filePath];
        NSPropertyListFormat plistFormat;
        NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:pListData options:NSPropertyListImmutable format:&plistFormat error:&error];
        
        // loop through all the variables of our class
        for (int i = 0; i < varCount; i++){
            Ivar var = vars[i];
            
            NSString *varName = [NSString stringWithUTF8String:ivar_getName(var)];
            NSObject *object = [dictionary objectForKey:varName];
            if(object != nil){
                [self setValue:object forKey:varName];
            }
        }
        
        free(vars);
    }
    else{
        self.money = @(100);
        self.turnLimit = @(TURN_LIMIT);
    }
}

- (NSString *) pathForDocuments {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (void) userDidSharing {
    if(!self.lastSharingTime) {
        self.lastSharingTime = [NSDate date];
        [self incrementLimitAfterSharing];
    }
    else {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
        if(interval > 60 * 60 * 24) {
            [self incrementLimitAfterSharing];
            self.lastSharingTime = [NSDate date];
        }
    }
    
    [self save];
}

- (void) incrementLimitAfterSharing {
    NSInteger turnCount = [self.turnCount integerValue];
    turnCount += TURN_SHARING_INC;
    if(turnCount > TURN_LIMIT) {
        turnCount = TURN_LIMIT;
    }
}

@end
