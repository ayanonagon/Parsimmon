Parsimmon
=========

Parsimmon is a wee Objective-C linguistics toolkit for iOS.


Toolkit
----

The Parsimmon toolkit currently consists of three components: tokenizer, tagger, and stemmer.

To start using Parsimmon:
<pre><code>#import "Parsimmon.h"</code></pre>

###Tokenizer

<pre><code>ParsimmonTokenizer *tokenizer = [[ParsimmonTokenizer alloc] init];
NSArray *tokens = [tokenizer tokenizeWordsInText:@"The quick brown fox jumps over the lazy dog"];
NSLog(@"%@", tokens);
</code></pre>

<pre><code>(
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
</code></pre>


###Tagger

<pre><code>ParsimmonTagger *tagger = [[ParsimmonTagger alloc] init];
NSArray *taggedTokens = [tagger tagWordsInText:@"The quick brown fox jumps over the lazy dog"];
NSLog(@"%@", taggedTokens);
</code></pre>

<pre><code>(
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
</code></pre>


### Stemmer
<pre><code>ParsimmonStemmer *stemmer = [[ParsimmonStemmer alloc] init];
NSArray *stemmedTokens = [stemmer stemWordsInText:@"Diane, I'm holding in my hand a small box of chocolate bunnies."];
NSLog(@"%@", stemmedTokens);
</code></pre>

<pre><code>(
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
</code></pre>


Version
----

0.1.0


License
----

MIT
