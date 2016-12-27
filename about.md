---
title: About
permalink: /about/
---


 


This site contains the code for the examples from the paper (*Superheat: An R package for  creating
beautiful heatmaps for visualizing complex data* by Rebecca L Barter
and Bin Yu) for the
[superheat](https://github.com/rlbarter/superheat) R package.

This paper contains three open source examples, each of which is based on a publicly available dataset. These examples are

* Case study I: combining data sources to explore global organ
transplantation trends

* Case study II: uncovering correlations in language using word2vec

* Case study III: predicting the brain's response to visual stimuli using fMRI

Each case study is described breifly below, and is accompanied by a reproducibility rating that describes how easy it would be for you to reproduce the results yourself. It is basically a reflection of how publicly available the data is.



### Case Study I: combining data sources to explore global organ transplantation trends

The data for this example comes from two sources. The first is from the Global Observatory on Donation and Transplantation database curated by WHO which can be downloaded from [here](http://www.transplant-observatory.org/export-database/). The second dataset comes from the United Nations Development Program's Human Development Reports which can be downloaded from [here](http://hdr.undp.org/en/data#).

> **Reproducibility: easy** (simply download the data into the same directory)



### Case study II: uncovering correlations in language using word2vec


Word2Vec is an extremely popular group of models for embedding words into high dimensional spaces such that their relative distances to one another convey semantic meaning. These models are quite remarkable and are an exciting step towards teaching machines to understand language.

In 2013, Google published pre-trained vectors trained on part of the Google News dataset which consists of around 100 billion words. The model contains 300-dimensional vectors for 3 million words and phrases and these vectors can be downloaded from [here](https://code.google.com/archive/p/word2vec/).

The original file is `GoogleNews-vectors-negative300.bin.gz`, and the `convert_word2vec.py` file  (adapted from suggestions from [this stack overflow post](http://stackoverflow.com/questions/27324292/convert-word2vec-bin-file-to-text)) in the `/word2vec` folder of this repository contains code to convert the original  file to a .csv format. An R version has been generated and is called `GoogleNews.RData`.

> **Reproducibility: medium** (need to download the large Google News dataset and then convert it to csv using a separate convert_word2vec.py)


## Case study III: predicting the brain's response to visual stimuli using fMRI


This case study aims to evaluate the performance of a number of models of the brain's response to visual stimuli. The study is based on data collected from a functional Magnetic Resonance Imaging (fMRI) experiment performed on a single individual by the Gallant neuroscience lab at UC Berkeley. fMRI measures oxygenated blood flow in the brain which can be considered as an indirect measure of neural activity (the two processes are highly correlated). The measurements obtained from an fMRI experiment correspond to the aggregated response of hundreds of thousands of neurons within cube-like voxels of the brain, where the segmentation of the brain into 3D voxels is analogous to the segmentation of an image into 2D pixels.

The data itself is hosted on the Collaborative Research in Computational Neuroscience (CRCNS) Data Sharing repository and can be found [here](https://crcns.org/data-sets/vc/vim-1). However, this repository only contains the voxel responses and the raw images. It does not contain the Gabor wavelet transformations.

> **Reproducibility: hard** (the data repository unfortunately does not contain the Gabor wavelet features, and some of the code chunks were run using 24 cores of a computer cluster)


