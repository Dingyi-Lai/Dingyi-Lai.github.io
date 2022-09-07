---
layout: post
author: Dingyi Lai
---

# Machine Translation, an application of Seq2Seq Model
Language modeling enables us to predict the next word/charactor based on previous words/character. Machine translation can be viewed as such a prediction used to generate text. One generalized benefits from this kind of prediction task is, knowledge in language model could be used for other NLP task, e.g. machine translation.

The formal definition of machine translation could be task of translating a sentence x from one language (the source language) to a sentence y in another language (the target language). Although there are many parallel corporas building such a model, such as Europarl [Koehn, 2005] (European Parliament speeches translated into 28 EU languages), MultiUN [Eisele and Chen, 2010] (official United Nations documents translated into 6 languages), ParaCrawl [Banon et al., 2020] (translated web pages) etc., tough challenges still exist, like ambiguities and semantic difference between languages.

Current machine translation systems apply a sequence-to-sequence neural network architecture (aka seq2seq). It involves two networks (RNNs or transformers):
- one encoder that reads the source text
    - (green) only learns to predict a final encoder hidden state
    - produces hidden state that is input to decoder
- one decoder that predicts the target text:
    - (blue) trained with a language modeling objective, conditioned on final encoder state
    - step by step and use previous predictions as input into next step

![Seq2Seq](https://raw.githubusercontent.com/Dingyi-Lai/Dingyi-Lai.github.io/main/_images/[MT]Seq2seqPrediction.png)

While being trained, loss is computed for the task of next symbol prediction on the task language sentence. Since decoder RNN is conditioned on output of encoder RNN, the gradient is backpropagated and the entire network is learnt “end-to-end”.

Codes for  in [this repo](https://github.com/Dingyi-Lai/Data-Science/blob/main/%5BProject%5DTaichung_Gastronomy_Map.Rmd)

# Result
[MT]WithoutAttention

[MT]WithAttention

# Procedure
1. Clean the platform
2. Change the directory
3. Read the data
4. Change columns name
5. Observe the structure of data
6. Install necessary packages
7. Clean data, limit the latitude and longitude and store it as new
8. Kmeans clustering
9. Store the results into new
10. Observe result of clustering
11. Clustering Visualization
