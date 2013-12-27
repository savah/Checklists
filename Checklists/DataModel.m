//
//  DataModel.m
//  Checklists
//
//  Created by Paris Kapsouros on 16/12/13.
//  Copyright (c) 2013 Paris Kapsouros. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (void)registerDefaults
{
    NSDictionary *dictionary = @{
        @"ChecklistIndex" : @-1, //we put the @ before to convert the primitive type (int) to an object (NSNumber)
        @"FirstTime" : @YES //primitive type BOOL to NSNumber object convert
    }; //make an associative array
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)handleFirstTime
{
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    
    if (firstTime) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.name = @"List";
        
        [self.lists addObject:checklist];
        [self setIndexOfSelectedChecklist:0];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
    }
}


- (id)init
{
    if ((self = [super init])) {
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}


//returns the documents path to save the file that will have the checklists objects
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];
}

- (void)saveChecklists
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklists
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.lists = [unarchiver decodeObjectForKey:@"Checklists"];
        [unarchiver finishDecoding];
    } else {
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

- (NSInteger)indexOfSelectedChecklist
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
}

- (void)setIndexOfSelectedChecklist:(NSInteger)index
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:index forKey:@"ChecklistIndex"];
}

@end
