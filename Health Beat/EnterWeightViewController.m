//
//  HWMainViewController.h
//  Super Health
//
//  Created by Jaxon Stevens on 2013-01-20.
//  Copyright (c) 2013 Jaxon Stevens. All rights reserved.
//

#import "EnterWeightViewController.h"
#import "WeightEntry.h"

static NSString* const UNIT_SELECTOR_SEGUE = @"Unit Selector Segue";

@interface EnterWeightViewController()

@property (nonatomic, strong) NSDate* currentDate;
@property (nonatomic, strong) NSNumberFormatter* numberFormatter;

- (void)updateSaveAndEditStatus;

@end



@implementation EnterWeightViewController

@synthesize weightTextField = _weightTextField;
@synthesize dateLabel = _dateLabel;
@synthesize unitsButton=_unitsButton;
@synthesize saveWarningLabel = _saveWarningLabel;

@synthesize currentDate = _currentDate;
@synthesize numberFormatter = _numberFormatter;

@synthesize document = _document;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter  setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.numberFormatter  setMinimum:[NSNumber numberWithFloat:0.0f]];
    
    self.unitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unitsButton.frame = CGRectMake(0.0f, 0.0f, 25.0f, 17.0f);
    self.unitsButton.backgroundColor = [UIColor clearColor];
    
    self.unitsButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.unitsButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [self.unitsButton setTitle:@"lbs"
                      forState:UIControlStateNormal];
    
    [self.unitsButton setTitleColor:[UIColor redColor]
                           forState:UIControlStateNormal];
    
    [self.unitsButton setTitleColor:[UIColor blackColor]
                           forState:UIControlStateHighlighted];
    
    
    [self.unitsButton addTarget:self
                         action:@selector(changeUnits:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.weightTextField.rightView = self.unitsButton;
    self.weightTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.saveWarningLabel.alpha = 0.0f;
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSUserDefaultsDidChangeNotification
     object:[NSUserDefaults standardUserDefaults]
     queue:nil
     usingBlock:^(NSNotification *note) {
         
         NSString* title = [WeightEntry stringForUnit:getDefaultUnits()];
         
         [self.unitsButton setTitle:title
                           forState:UIControlStateNormal];
     }];
    
}


- (void)viewDidUnload
{
    [self setWeightTextField:nil];
    [self setDateLabel:nil];
    self.unitsButton = nil;
    self.numberFormatter = nil;
    
    [self setSaveWarningLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Sets the current time and date.
    self.currentDate = [NSDate date];
    
    self.dateLabel.text =
    [NSDateFormatter localizedStringFromDate:self.currentDate
                                   dateStyle:NSDateFormatterLongStyle
                                   timeStyle:NSDateFormatterShortStyle];
    
    // Clear the text field.
    self.weightTextField.text = @"";
    [self.weightTextField becomeFirstResponder];
    
    [self.unitsButton
     setTitle:[WeightEntry stringForUnit:getDefaultUnits()]
     forState:UIControlStateNormal];
    
    [super viewWillAppear:animated];
}

#pragma mark - Action Methods

- (IBAction)saveWeight:(id)sender {
    
    CGFloat weight =
    [[self.numberFormatter
      numberFromString:self.weightTextField.text]
     floatValue];
    
    
    if (getDefaultUnits() != LBS) {
        
        weight = [WeightEntry convertKgToLbs:weight];
    }
    
    // This creates a new weight entry and adds
    // it to our document's managed object context
    [WeightEntry addEntryToDocument:self.document
                   usingWeightInLbs:weight
                               date:self.currentDate];
    
    // Automatically move to the second tab.
    // Should be the graph view.
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeUnits:(id)sender {
    
    [self performSegueWithIdentifier:UNIT_SELECTOR_SEGUE sender:self];
}

- (IBAction)handleDownwardSwipe:(id)sender {
    
    // Get rid of the keyboard.
    [self.weightTextField resignFirstResponder];
}

- (IBAction)handleUpwardSwipe:(id)sender {
    
    // display keyboard
    [self.weightTextField becomeFirstResponder];
}

#pragma mark - Delegate Methods

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    // It’s OK to hit return.
    if ([string isEqualToString:@"\n"]) return YES;
    
    
    NSString* changedString =
    [textField.text stringByReplacingCharactersInRange:range
                                            withString:string];
    
    // It's OK to delete everything.
    if ([changedString isEqualToString:@""]) return YES;
    
    NSNumber* number =
    [self.numberFormatter numberFromString:changedString];
    
    // Filter out invalid number formats.
    if (number == nil) {
        
        // We might want to add an alert sound here.
        return NO;
        
    }
    
    return YES;
}

#pragma mark - Unit Selector Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:UNIT_SELECTOR_SEGUE]) {
        
        UnitSelectorViewController* unitSelectorController =
        segue.destinationViewController;
        
        unitSelectorController.delegate = self;
        unitSelectorController.defaultUnit =
        getDefaultUnits();
        
    }
}

-(void)unitSelector:(UnitSelectorViewController*) sender
       changedUnits:(WeightUnit)unit {
    
    setDefaultUnits(unit);
    
    [self.unitsButton setTitle: [WeightEntry stringForUnit:unit]
                      forState:UIControlStateNormal];
}

-(void)unitSelectorDone:(UnitSelectorViewController*) sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Custom Accessor

- (void)setDocument:(UIManagedDocument *)document {
    
    NSNotificationCenter* notificationCenter =
    [NSNotificationCenter defaultCenter];
    
    // if we're assiging the same history, don't do anything.
    if ([_document isEqual:document]) {
        return;
    }
    
    // clear any notifications for the old history, if any
    if (_document != nil) {
        
        [notificationCenter
         removeObserver:self
         forKeyPath:UIDocumentStateChangedNotification];
    }
    
    _document = document;
    
    // add new notifications for the new history, if any
    // and set the view's values.
    if (_document != nil) {
        
        // register for notifications
        [notificationCenter
         addObserver:self
         selector:@selector(updateSaveAndEditStatus)
         name:UIDocumentStateChangedNotification
         object:_document];
        
        // update our save and edit status
        [self updateSaveAndEditStatus];
    }
}

#pragma mark - Private Methods

- (void)updateSaveAndEditStatus {
    
    if (self.document == nil) {
        
        // disable editing
        [self.weightTextField resignFirstResponder];
        self.weightTextField.enabled = NO;
        return;
    }
    
    UIDocumentState state =
    self.document.documentState;
    
    if (state & UIDocumentStateSavingError) {
        
        // display save warning
        [UIView
         animateWithDuration:0.25f
         animations:^{
             
             self.saveWarningLabel.alpha = 1.0f;
         }];
        
    } else {
        
        // hide save warning
        [UIView
         animateWithDuration:0.25f
         animations:^{
             
             self.saveWarningLabel.alpha = 0.0f;
         }];
        
    }
    
    if (state & UIDocumentStateEditingDisabled) {
        
        // disable editing
        [self.weightTextField resignFirstResponder];
        self.weightTextField.enabled = NO;
        
    } else {
        
        // enable editing
        self.weightTextField.enabled = YES;
        [self.weightTextField becomeFirstResponder];
        
        // sets the current time and date
        self.currentDate = [NSDate date];
        
        self.dateLabel.text =
        [NSDateFormatter
         localizedStringFromDate:self.currentDate
         dateStyle:NSDateFormatterLongStyle
         timeStyle:NSDateFormatterShortStyle];
        
    }
}

#pragma mark IAD Delegate Methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
    
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
    
}








@end
