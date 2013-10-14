//
//  TaggerViewController.m
//  Example
//
//  Created by Ayaka Nonaka on 10/10/13.
//
//

#import "TaggerViewController.h"
#import "Parsimmon.h"

@interface TaggerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@property (strong, nonatomic) ParsimmonTagger *tagger;
@end

@implementation TaggerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tagger = [[ParsimmonTagger alloc] init];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
