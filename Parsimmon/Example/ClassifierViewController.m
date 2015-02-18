//
//  ClassifierViewController.m
//  Parsimmon
//
//  Created by Ayaka Nonaka on 10/13/13.
//
//

#import "ClassifierViewController.h"
#import "Parsimmon.h"
#import "Parsimmon-Swift.h"

@interface ClassifierViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NaiveBayesClassifier *classifier;
@end

@implementation ClassifierViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self train];
}


#pragma mark - Training

- (void)train
{
    NSArray *hams = @[@"Hi, how was work?",
                      @"What's the weather like tomorrow?",
                      @"Please take the dogs out for a walk."];
    NSArray *spams = @[@"Get your free copy of AOL today!",
                       @"Get a free pink iPhone by clicking HERE",
                       @"Spam spam spam spam."];
    [self feedHams:hams];
    [self feedSpams:spams];
}

- (void)feedHams:(NSArray *)hams
{
    for (NSString *ham in hams) {
        [self.classifier trainWithText:ham category:@"ham"];
    }
}

- (void)feedSpams:(NSArray *)spams
{
    for (NSString *spam in spams) {
        [self.classifier trainWithText:spam category:@"spam"];
    }
}


#pragma mark - Actions

- (IBAction)spamOrHamAction:(id)sender
{
    NSString *category = [self.classifier classify:self.messageTextField.text];
    [self.resultLabel setText:category];
}


#pragma mark - Properties

- (NaiveBayesClassifier *)classifier
{
    if (!_classifier) {
        _classifier = [[NaiveBayesClassifier alloc] init];
    }
    return _classifier;
}


@end
