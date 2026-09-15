# question2 task1

Compression ratio (token/charecter):
8,192 vocab size: 0.26788685524126454
32,768 vocab size: 0.22462562396006655

sequence length(token amount):
8,192 vocab size: 483
32,768 vocab size: 405

how it is split:
8,192:
|“|The| United| States| has| prom|ised| to| be| v|ig|il|ant|

32,768:
|“The| United| States| has| promised| to| be| vigilant|

This shows that a larger vocabulary reduces sequence length by allowing for larger words in the vocabulary.

# failures and artifacts
For 8,192 vocab size:
1. Tokens are often smaller than for 32,768 and words are thus split into more tokens.

For 32,768 vocab size:


For both vocab size:
1. numbers get split into tokens of 2 or 1 numbers (|20|25|, |70|0|)
2. No space character at the start of a sentence and simultaniously no space at the start of a token that is a sub word, such as: Bro|oke.
3. | Y|esterday|, is wierd idk?
4. CO|�|� represents: CO₂ when seperated, showing artifacts. 

