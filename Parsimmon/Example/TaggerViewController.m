//
//  TaggerViewController.m
//  Example
//
//  Created by Ayaka Nonaka on 10/10/13.
//
//

#import "TaggerViewController.h"
#import "Parsimmon-Swift.h"

@interface TaggerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@property (strong, nonatomic) Tagger *tagger;
@end

@implementation TaggerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tagger = [[Tagger alloc] init];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)parsimmonAction:(id)sender
{
    NSArray *taggedTokens = [self.tagger tagWordsInText:self.inputTextField.text];
    [self.outputTextView setText:[NSString stringWithFormat:@"%@", taggedTokens]];
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
