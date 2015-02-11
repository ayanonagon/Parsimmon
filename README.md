Parsimmon
=========

[![Build Status](https://travis-ci.org/ayanonagon/Parsimmon.svg?branch=master)](https://travis-ci.org/ayanonagon/Parsimmon)
[![Coverage Status](https://coveralls.io/repos/ayanonagon/Parsimmon/badge.png?branch=master)](https://coveralls.io/r/ayanonagon/Parsimmon?branch=master)

Parsimmon is a wee Objective-C linguistics toolkit for iOS.


Toolkit
----
Currently available tools:
- Tokenizer
- Tagger
- Lemmatizer
- Naive Bayes Classifier
- Decision Tree (alpha)


Installation
----

The easiest way to get started is to use [CocoaPods](http://cocoapods.org/). Just add the following line to your Podfile:

```ruby
pod 'Parsimmon', '~> 0.3'
```

Examples
----

To start using Parsimmon:
```obj-c
#import <Parsimmon/Parsimmon.h>
```


###Tokenizer

```obj-c
ParsimmonTokenizer *tokenizer = [[ParsimmonTokenizer alloc] init];
NSArray *tokens = [tokenizer tokenizeWordsInText:@"The quick brown fox jumps over the lazy dog"];
NSLog(@"%@", tokens);
```

```
(
The,
quick,
brown,
fox,
jumps,
over,
the,
lazy,
dog
)
```


### Tagger

```obj-c
ParsimmonTagger *tagger = [[ParsimmonTagger alloc] init];
NSArray *taggedTokens = [tagger tagWordsInText:@"The quick brown fox jumps over the lazy dog"];
NSLog(@"%@", taggedTokens);
```

```
(
"('The', Determiner)",
"('quick', Adjective)",
"('brown', Adjective)",
"('fox', Noun)",
"('jumps', Noun)",
"('over', Preposition)",
"('the', Determiner)",
"('lazy', Adjective)",
"('dog', Noun)"
)
```


### Lemmatizer

```obj-c
ParsimmonLemmatizer *lemmatizer = [[ParsimmonLemmatizer alloc] init];
NSArray *lemmatizedTokens = [lemmatizer lemmatizeWordsInText:@"Diane, I'm holding in my hand a small box of chocolate bunnies."];
NSLog(@"%@", lemmatizedTokens);
```

```
(
diane,
i,
hold,
in,
my,
hand,
a,
small,
box,
of,
chocolate,
bunny
)
```


### Naive Bayes Classifier

```obj-c
ParsimmonNaiveBayesClassifier *classifier = [[ParsimmonNaiveBayesClassifier alloc] init];

// Train the classifier with some ham examples.
[classifier trainWithText:@"nom nom ham" category:@"ham"];
[classifier trainWithText:@"make sure to get the ham" category:@"ham"];
[classifier trainWithText:@"please put the eggs in the fridge" category:@"ham"];

// Train the classifier with some spam examples.
[classifier trainWithText:@"spammy spam spam" category:@"spam"];
[classifier trainWithText:@"what does the fox say?" category:@"spam"];
[classifier trainWithText:@"and fish go blub" category:@"spam"];

// Classify some new text. Is it ham or spam?
// In practice, you'd want to train with more examples first.
NSString *firstExample = @"use the eggs in the fridge.";
NSString *secondExample = @"what does the fish say?";
NSLog(@"'%@' => %@", firstExample, [classifier classify:firstExample]);
NSLog(@"'%@' => %@", secondExample, [classifier classify:secondExample]);
```

```
'use the eggs in the fridge.' => ham
'what does the fish say?' => spam
```

License
----

MIT

Contributing
----

We’d love to see your ideas for improving this library! The best way to contribute is by submitting a pull request. We’ll do our best to respond to your patch as soon as possible. You can also submit a [new GitHub issue](https://github.com/ayanonagon/parsimmon/issues/new) if you find bugs or have questions. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!
