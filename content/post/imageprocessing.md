---
date: "2015-02-28T00:00:00+01:00"
title: "Image Processing"
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1595448912/WebPage/l66KH4Y.jpg"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["image processing", "csharp"]
---

This program implements multiple image processing algorithms, such as edge detection, noise reduction, sharpening, morphological operations, etc, part of a college assignment.
<!--more-->

Image loader and processor focused on edge detection, using C# and image loading functions provided by Windows System, UI using Windows Forms. The source code for this project can be found [on my GitHub.](https://github.com/jose-villegas/Morphological-Operations)

Edge Detection Kernels:

* Sobel (3x3, 5x5, 7x7, 9x9) <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448584/WebPage/yuUzb6i.png" width="100%">
* Roberts Cross (3x3) <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448718/WebPage/Y8dsx0F.png" width="100%">
* Prewitt (3x3, 5x5, 7x7) <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448787/WebPage/vvFzfEZ.png" width="100%">
* Laplacian Gaussian (3x3, 5x5, 7x7, 9x9) <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448814/WebPage/E4gj3tQ.png" width="100%">

Personal Kernel: Modified Sharpen Kernel <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448843/WebPage/GM0mfKq.jpg" width="100%">

Noise Reduction:

* Average <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448878/WebPage/98xGhRz.jpg" width="100%">
* Median <img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448912/WebPage/l66KH4Y.jpg" width="100%">

Image Scaling:

* Bilinear
* Nearest Neighbor
* Bicubic

Other Options:

* Free Rotation
* Horizontal / Vertical Mirror
* Brigthness and Contrast
* Negative
* Threshold
* RGB Histograms

UI:

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448455/WebPage/Oxv3Qgj.png" width="100%">

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448471/WebPage/5u7w8WZ.png" width="100%">

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448493/WebPage/k8uHGba.png" width="100%">

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595448515/WebPage/bYAJXQb.png" width="100%">
