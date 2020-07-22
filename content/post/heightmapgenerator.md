---
date: "2015-03-15T00:00:00+01:00"
title: "Heightmap Generator"
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1595447241/WebPage/noise.png"
showonlyimage: true
draft: false
weight: 0
categories: ["graphics"]
tags: ["image processing", "csharp"]
---

A simple height map generator utizling different noise generation techniques to obtain height maps that can be used for terrain generators or other applications. 
<!--more-->

The project is made using C# and the source code can be found on my [GitHub](https://github.com/jose-villegas/HeightmapGenerator).

The technique uses different algorithms such as DLA, Simplex Noise, Perlin Noise, Blur, etc to produce noise and play with their parameters, these results can be used in game engines to generate terrain meshes.

<img src="https://raw.githubusercontent.com/jose-villegas/HeightmapGenerator/master/HeightmapGenerator/Resources/perlin_1.BMP" width="100%">

<img src="https://raw.githubusercontent.com/jose-villegas/HeightmapGenerator/master/HeightmapGenerator/Resources/dla_1.BMP" width="100%">

<img src="https://raw.githubusercontent.com/jose-villegas/HeightmapGenerator/master/HeightmapGenerator/Resources/dla_3.BMP" width="100%">

<img src="https://raw.githubusercontent.com/jose-villegas/HeightmapGenerator/master/HeightmapGenerator/Resources/dla_5.BMP" width="100%">