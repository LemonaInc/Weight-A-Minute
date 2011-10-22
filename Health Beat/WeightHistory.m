//
//  WeightHistory.m
//  Health Beat
//
//  Created by Rich Warren on 10/7/11.
//  Copyright (c) 2011 Freelance Mad Science Labs. All rights reserved.
//

#import "WeightHistory.h"
#import "NSMutableArray+Union.h"

// Private class, used to store undo information
@interface UndoInfo : NSObject 

@property (strong, nonatomic) WeightEntry* weight;
@property (assign, nonatomic) NSUInteger index;

@end



@implementation UndoInfo

@synthesize weight = _weight;
@synthesize index = _index;

@end

static NSString* const FileName = @"health_beat.hbhistory";

@interface WeightHistory() 

@property (nonatomic, strong) NSMutableArray* weightHistory;

- (void) undoAddWeight:(UndoInfo*)info;
- (void)undoRemoveWeight:(UndoInfo*)info;

- (void)documentStateChanged:(NSNotification*)notification;

- (void)resolveConflictsWithCurrentURL:(NSURL*)currentURL 
                           coordinator:(NSFileCoordinator*)coordinator;

- (void)mergeCurrentHistory:(NSMutableArray*)currentHistory
     withConflictingVersion:(NSFileVersion*)version 
                coordinator:(NSFileCoordinator*)coordinator;

- (void)saveMergedHistory:(NSArray*)currentHistory
                    ToURL:(NSURL*)url 
              coordinator:(NSFileCoordinator*)coordinator
              oldVersions:(NSArray*)oldVersions;

+ (NSURL*)localURL;
+ (NSURL*)cloudURL;
+ (BOOL)isCloudAvailable;

+ (void)queryForCloudHistory:(historyAccessHandler)accessHandler; 

+ (void)processQuery:(NSMetadataQuery*)query 
            thenCall:(historyAccessHandler)accessHandler;

+ (void)createCloudDocumentAtURL:(NSURL*)url
                        thenCall:(historyAccessHandler)accesshandler;

+ (void)loadCloudDocumentAtURL:(NSURL*)url 
                      thenCall:(historyAccessHandler)accessHandler;

@end



@implementation WeightHistory

@synthesize weightHistory = _weightHistory;

#pragma mark - virtual weights property

// This ensures key-value observing works for weights.
+ (NSSet *)keyPathsForValuesAffectingWeights {
    return [NSSet setWithObjects:@"weightHistory", nil];
}

// Virtual property implementation.
- (NSArray*) weights {
    
    return self.weightHistory;
}

#pragma mark - initialization

- (id)initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self) {
        
        // set an initial defaults
        _weightHistory = [[NSMutableArray alloc] init];
        
        // monitor document state
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(documentStateChanged:) 
         name:UIDocumentStateChangedNotification
         object:self];
    }
    
    return self;
}

- (void)dealloc {
    
    // unregister for notifications
    
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self
     name:UIDocumentStateChangedNotification
     object:self];
}

#pragma mark - public methods

- (void)addWeight:(WeightEntry*)weight {
    
    // Manually send KVO messages.
    [self willChange:NSKeyValueChangeInsertion 
     valuesAtIndexes:[NSIndexSet indexSetWithIndex:0]
              forKey:KVOWeightChangeKey];
    
    // Add to the front of the list.
    [self.weightHistory insertObject:weight atIndex:0];
    
    // Manually send KVO messages.
    [self didChange:NSKeyValueChangeInsertion 
    valuesAtIndexes:[NSIndexSet indexSetWithIndex:0]
             forKey:KVOWeightChangeKey];
    
    // Now set the undo settings...this will also trigger 
    // UIDocument's autosave
    UndoInfo* info = [[UndoInfo alloc] init];
    info.weight = weight;
    info.index = 0;
    
    [self.undoManager 
     registerUndoWithTarget:self
     selector:@selector(undoAddWeight:)
     object:info];
    
    NSString* name = 
    [NSString stringWithFormat:@"Remove the %@ entry?",
     [weight stringForWeightInUnit:getDefaultUnits()]];
    
    
    [self.undoManager setActionName:name];
}

// This will be auto KVO'ed.
- (void)removeWeightAtIndex:(NSUInteger)weightIndex {
    
    // grab a reference to the weight before we delete it
    WeightEntry* weight = 
    [self.weightHistory objectAtIndex:weightIndex];
    
    // Manually send KVO messages
    [self willChange:NSKeyValueChangeRemoval 
     valuesAtIndexes:[NSIndexSet indexSetWithIndex:weightIndex]
              forKey:KVOWeightChangeKey];
    
    // remove the weight
    [self.weightHistory removeObjectAtIndex:weightIndex];
    
    // Manually send KVO messages
    [self didChange:NSKeyValueChangeRemoval 
    valuesAtIndexes:[NSIndexSet indexSetWithIndex:weightIndex]
             forKey:KVOWeightChangeKey];
    
    // Now set the undo settings...this will also trigger 
    // UIDocument's autosave
    
    UndoInfo* info = [[UndoInfo alloc] init];
    info.weight = weight;
    info.index = weightIndex;
    
    [self.undoManager registerUndoWithTarget:self
                                    selector:@selector(undoRemoveWeight:) 
                                      object:info];
    
    NSString* name = [NSString stringWithFormat:@"restore the %@ entry?",
                      [weight stringForWeightInUnit:getDefaultUnits()]];
    
    
    [self.undoManager setActionName:name];
}

#pragma mark -  Undo Methods

- (void) undoAddWeight:(UndoInfo*)info {
    
    // Manually send KVO messages
    [self willChange:NSKeyValueChangeRemoval 
     valuesAtIndexes:[NSIndexSet indexSetWithIndex:info.index]
              forKey:KVOWeightChangeKey];
    
    // add to the front of the list
    [self.weightHistory removeObjectAtIndex:info.index];
    
    // Manually send KVO messages
    [self didChange:NSKeyValueChangeRemoval 
    valuesAtIndexes:[NSIndexSet indexSetWithIndex:info.index]
             forKey:KVOWeightChangeKey];
    
}

- (void)undoRemoveWeight:(UndoInfo*)info {
    
    // Manually send KVO messages
    [self willChange:NSKeyValueChangeInsertion 
     valuesAtIndexes:[NSIndexSet indexSetWithIndex:info.index]
              forKey:KVOWeightChangeKey];
    
    // add to the front of the list
    [self.weightHistory insertObject:info.weight atIndex:info.index];
    
    // Manually send KVO messages
    [self didChange:NSKeyValueChangeInsertion 
    valuesAtIndexes:[NSIndexSet indexSetWithIndex:info.index]
             forKey:KVOWeightChangeKey];
    
}

- (void)undo {
    
    if ([self.undoManager canUndo]) {
        
        NSString* title = @"Confirm Undo";
        
        NSString* message = 
        [self.undoManager undoActionName];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message 
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"Undo",
                              nil];
        
        [alert show];
        
    }
    else {
        
        NSString* title = @"Cannot Undo";
        
        NSString* message = 
        @"There are no changes that can be undone at this time.";
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}


# pragma mark - alert view delegate methods

- (void)alertView:(UIAlertView *)alertView 
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // undo the last action if it is confirmed
    if (buttonIndex == 1) {
        
        [self.undoManager undo];
    }
}

#pragma mark - iCloud Methods

- (id)contentsForType:(NSString *)typeName 
                error:(NSError **)outError {
    
    return [NSKeyedArchiver archivedDataWithRootObject:self.weightHistory];
}

- (BOOL)loadFromContents:(id)contents 
                  ofType:(NSString *)typeName 
                   error:(NSError **)outError {
    
    self.weightHistory = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
    
    // clear the undo stack
    [self.undoManager removeAllActions];
        
    return YES;
}

#pragma mark - Resolve Conflicts

- (void)documentStateChanged:(NSNotification*)notification {
    
    UIDocumentState state = self.documentState;
    
    if (state & UIDocumentStateInConflict) {
        
        NSURL* url = self.fileURL;
        
        NSURL* currentURL = 
        [[NSFileVersion currentVersionOfItemAtURL:url] URL];
        
        NSFileCoordinator* coordinator = 
        [[NSFileCoordinator alloc] initWithFilePresenter:self];
        
        dispatch_queue_t backgroundQueue = 
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(backgroundQueue, ^{
            
            [self resolveConflictsWithCurrentURL:currentURL
                                     coordinator:coordinator];
        });
    }
}


- (void)resolveConflictsWithCurrentURL:(NSURL*)currentURL 
                           coordinator:(NSFileCoordinator*)coordinator {
    
    
    NSError* error;
    
    [coordinator
     coordinateReadingItemAtURL:currentURL 
     options:0 
     writingItemAtURL:currentURL
     options:NSFileCoordinatorWritingForMerging 
     error:&error 
     byAccessor:^(NSURL *inputURL, NSURL *outputURL) {
         
         // load our data
         NSData* data = 
         [NSData dataWithContentsOfURL:inputURL];
         
         NSMutableArray* currentHistory = 
         [NSKeyedUnarchiver unarchiveObjectWithData:data];
         
         // read in all the old versions
         NSArray* unresolvedVersions = 
         [NSFileVersion unresolvedConflictVersionsOfItemAtURL:inputURL];
         
         // Merge the histories
         for (NSFileVersion* version in unresolvedVersions) {
             
             [self mergeCurrentHistory:currentHistory
                withConflictingVersion:version
                           coordinator:coordinator];
             
         }
         
         // sort the current history
         NSSortDescriptor* sortByDate = 
         [NSSortDescriptor sortDescriptorWithKey:@"date" 
                                       ascending:NO];
         
         [currentHistory sortUsingDescriptors:
          [NSArray arrayWithObject:sortByDate]];
         
         
         // save the changes
         [self saveMergedHistory:currentHistory
                           ToURL:outputURL
                     coordinator:coordinator 
                     oldVersions:unresolvedVersions];
         
     }]; // Current File Read/Write block
    
    if (error != nil) {
        NSLog(@"*** Error: Unable to perform a coordinated read/write "
              @"on our current history! %@ ***", 
              [error localizedDescription]);
    } 
    
}

- (void)mergeCurrentHistory:(NSMutableArray*)currentHistory
     withConflictingVersion:(NSFileVersion*)version 
                coordinator:(NSFileCoordinator*)coordinator {
    
    NSError* readError;
    
    [coordinator
     coordinateReadingItemAtURL:version.URL
     options:0
     error:&readError
     byAccessor:^(NSURL *oldVersionURL) {
         
         NSData* oldData = 
         [NSData dataWithContentsOfURL:oldVersionURL];
         
         NSArray* oldHistory = 
         [NSKeyedUnarchiver unarchiveObjectWithData:oldData];
         
         [currentHistory unionWith: oldHistory];
         
     }];
    
    if (readError) {
        
        NSLog(@"*** Error: Unable to perform a coordinated read "
              @"on a previous version! %@ ***",
              [readError localizedDescription]);
        
    }
}


- (void)saveMergedHistory:(NSArray*)currentHistory
                    ToURL:(NSURL*)url 
              coordinator:(NSFileCoordinator*)coordinator
              oldVersions:(NSArray*)oldVersions {
    
    NSError* writeError;
    [coordinator 
     coordinateWritingItemAtURL:url
     options:NSFileCoordinatorWritingForMerging
     error:&writeError
     byAccessor:^(NSURL *outputURL) {
         
         NSData* dataToSave = 
         [NSKeyedArchiver archivedDataWithRootObject:currentHistory];
         
         NSError* innerWriteError;
         BOOL success = [dataToSave 
                         writeToURL:outputURL 
                         options:NSDataWritingAtomic
                         error:&innerWriteError];
         
         if (success) {
             
             // Mark the conflicting versions as resolved
             for (NSFileVersion* version in oldVersions) {
                 version.resolved = YES;
             }
             
             // Remove Old versions
             NSError* removeError;
             BOOL removed = 
             [NSFileVersion removeOtherVersionsOfItemAtURL:outputURL 
                                                     error:&removeError];
             
             if (!removed) {
                 
                 NSLog(@"*** Error: Could not erase outdated versions! %@",
                       [removeError localizedDescription]);
             }
             
             // and reload our document
             NSError* reloadError;
             BOOL reloaded = [self readFromURL:self.fileURL 
                                         error:&reloadError];
             
             if (!reloaded) {
                 
                 NSLog(@"*** Error: Unable to reload our UIDocument! "
                       @"%@ ***",
                       [reloadError localizedDescription]);
             }
             
             
         } else {
             
             NSLog(@"*** Error: Unable to save our merged history! "
                   @"%@ ***",
                   [innerWriteError localizedDescription]);
         }
     }]; 
    
    if (writeError != nil) {
        
        NSLog(@"*** Error: Unable to perform a coordinated write "
              @"on our merged version: %@ ***",
              [writeError localizedDescription]);
    }
}


#pragma mark - Conveniance Methods

+ (NSURL*)localURL {
    
    static NSURL* sharedLocalURL;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSError* error;
        NSURL* documentDirectory = 
        [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                               inDomain:NSUserDomainMask
                                      appropriateForURL:nil 
                                                 create:NO 
                                                  error:&error];
        
        if (documentDirectory == nil) {
            [NSException 
             raise:NSInternalInconsistencyException 
             format:@"Unable to locate the local document directory, %@", 
             [error localizedDescription]];
        }
        
        sharedLocalURL = [documentDirectory URLByAppendingPathComponent:FileName];
    });
    
    return sharedLocalURL;
}

+ (NSURL*)cloudURL {
    
    static NSURL* sharedCloudURL;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        
        NSURL* containerURL = 
        [fileManager URLForUbiquityContainerIdentifier:nil];
        
        if (containerURL) {
            
            NSURL* documentURL = [containerURL URLByAppendingPathComponent:@"Documents"];            
            sharedCloudURL = [documentURL URLByAppendingPathComponent:FileName];
            
        } else {
            
            sharedCloudURL = nil;
        }
    });
    
    return sharedCloudURL;
}

+ (BOOL)isCloudAvailable {
    
    return [self cloudURL] != nil;
}

+ (void)accessWeightHistory:(historyAccessHandler)accessHandler {
    
    NSURL* url;
    
    if ([self isCloudAvailable]) {
        
        [self queryForCloudHistory:accessHandler];
        
    } else {
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        url = [self localURL];
        WeightHistory* history = [[self alloc] initWithFileURL:url];
        
        if ([fileManager fileExistsAtPath:[url path]]) {
            
            [history openWithCompletionHandler:^(BOOL success) {
                accessHandler(success, history);
            }];
            
        } else {
            
            [history saveToURL:url
              forSaveOperation:UIDocumentSaveForCreating
             completionHandler:^(BOOL success) {
                 accessHandler(success, history);
             }];
            
        }
    }
}

+ (void)queryForCloudHistory:(historyAccessHandler)accessHandler {   
    
    // Search for the file in the cloud
    NSMetadataQuery* query = [[NSMetadataQuery alloc] init];
    
    [query setSearchScopes:
     [NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    
    // get all files
    [query setPredicate:[NSPredicate predicateWithFormat:@"%K like %@", 
                         NSMetadataItemFSNameKey, 
                         FileName]];
    
    
    [[NSNotificationCenter defaultCenter] 
     addObserverForName:NSMetadataQueryDidFinishGatheringNotification
     object:query
     queue:nil 
     usingBlock:^(NSNotification* notification) {
         
         [query disableUpdates];
         
         [[NSNotificationCenter defaultCenter] 
          removeObserver:self 
          name:NSMetadataQueryDidFinishGatheringNotification 
          object:query];
         
         [self processQuery:query
                   thenCall:accessHandler];
         
         [query stopQuery];
     }];
    
    [query startQuery];
}

+ (void)processQuery:(NSMetadataQuery*)query 
            thenCall:(historyAccessHandler)accessHandler {
    
    
    NSUInteger count = [query resultCount];
    id result;
    NSURL* url;
    
    switch (count) {
        case 0:
            
            NSLog(@"Creating a cloud document");
            
            url = [self cloudURL];
            
            [self createCloudDocumentAtURL:url
                                  thenCall:accessHandler];
            
            break;
            
        case 1:
            
            NSLog(@"Loading a cloud document");
            
            result = [query resultAtIndex:0]; 
            url = [result valueForAttribute:NSMetadataItemURLKey];
            
            [self loadCloudDocumentAtURL:url
                                thenCall:accessHandler];
            
            break;
            
        default:
            
            // We should never have more than 1 file. If this
            // occurs, it's due to a bug in our code that needs
            // to be fixed.
            
            [NSException 
             raise:NSInternalInconsistencyException 
             format:@"NSMetadata should only find a single file, found %d",  
             count];
            
            break;
    }
}

+ (void)createCloudDocumentAtURL:(NSURL*)url
                        thenCall:(historyAccessHandler)accessHandler{
    
    WeightHistory* history = 
    [[WeightHistory alloc] initWithFileURL:url];
    
    // First create a local copy
    [history saveToURL:[self localURL] 
      forSaveOperation:UIDocumentSaveForCreating 
     completionHandler:^(BOOL success) {
         
         if (!success) {
             accessHandler(success, history);
             return;
         }
         
         // Now move it to the cloud in a background thread
         dispatch_queue_t backgroundQueue = 
         dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         
         dispatch_async(backgroundQueue, ^{
             
             NSFileManager* manager = [NSFileManager defaultManager];
             NSError* error;
             
             BOOL moved = [manager setUbiquitous:YES
                                       itemAtURL:[self localURL] 
                                  destinationURL:url 
                                           error:&error];
             if (!moved) {
                 
                 NSLog(@"Error moving document to the cloud: %@", 
                       [error localizedDescription]);
             }
             
             accessHandler(moved, history);
         });
     }];
}

+ (void)loadCloudDocumentAtURL:(NSURL*)url 
                      thenCall:(historyAccessHandler)accessHandler {
    
    WeightHistory* history = 
    [[WeightHistory alloc] initWithFileURL:url];
    
    [history openWithCompletionHandler:^(BOOL success) {
        accessHandler(success, history);
    }];
}


@end
