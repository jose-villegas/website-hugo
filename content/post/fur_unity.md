---
date: "2017-01-12T00:00:00+02:00"
title: "Fur Rendering in Unity"
image: "/img/fur-rendering/hero.jpg"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["shaders", "csharp", "unity", "effects"]
---

This is a small shader that implements fur rendering in Unity using shell texturing. The technique is well explained on this [paper](https://research.microsoft.com/~hoppe/fur.pdf). Though easy to implement it was well received on my [GitHub](https://github.com/jose-villegas/FurRendering).
<!--more-->

The technique works for fur and grass alike. The current version runs on Unity 6 with URP: every shell of a mesh is drawn in one instanced draw call, including the GPU-skinned vertices of an animated character. Strands are generated procedurally, lit with Kajiya-Kay hair shading, and bend with gravity, wind and the motion of the skin.

<img src="/img/fur-rendering/hero.gif" width="100%">

<img src="/img/fur-rendering/hero.jpg" width="100%">
