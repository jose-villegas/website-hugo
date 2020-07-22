---
date: "2017-01-12T00:00:00+02:00"
title: "Fur Rendering in Unity"
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1595437703/WebPage/fur.png"
showonlyimage: true
draft: false
weight: 0
categories: ["graphics"]
tags: ["shaders", "csharp", "unity", "effect"]
---

This is a small shader that implements fur rendering in Unity using shell texturing. The technique is well explained on this [paper](http://hhoppe.com/fur.pdf). Though easy to implement it was well received on my [GitHub](https://github.com/jose-villegas/FurRendering).
<!--more-->

The technique can be used for simulating fur or grass a well. A basic version of this shader with just 5 layers can provide a good approximation, the algorithm can get heavy once we start to add more layers. Once the technique is implemented all sort of techniques can be used to play with this fur "framework", such as animating or integrating highmaps for example.

<img src="https://camo.githubusercontent.com/0742d463bc83da64ad7256fcbbd16d02d344993d/68747470733a2f2f692e696d6775722e636f6d2f78514b7948746d2e6a7067" width="100%">

<img src="https://camo.githubusercontent.com/b14cfce0073c8782d6afd8aed91ffef5d7849475/68747470733a2f2f692e696d6775722e636f6d2f58524f4d637a652e6a7067" width="100%">
