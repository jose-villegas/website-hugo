---
date: "2017-01-12T00:00:00+02:00"
title: "Fur Rendering in Unity"
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1595437703/WebPage/fur.png"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["shaders", "csharp", "unity", "effects"]
---

This is a small shader that implements fur rendering in Unity using shell texturing. The technique is well explained on this [paper](https://research.microsoft.com/~hoppe/fur.pdf). Though easy to implement it was well received on my [GitHub](https://github.com/jose-villegas/FurRendering).
<!--more-->

The technique can be used for simulating fur or grass a well. A basic version of this shader with just 5 layers can provide a good approximation, the algorithm can get heavy once we start to add more layers. Once the technique is implemented all sort of techniques can be used to play with this fur "framework", such as animating or integrating highmaps for example.

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1731416307/68747470733a2f2f692e696d6775722e636f6d2f58524f4d637a652e6a7067_d9loxh.jpg" width="100%">

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1595437703/WebPage/fur.png" width="100%">
