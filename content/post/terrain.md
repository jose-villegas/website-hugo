---
date: "2017-06-19T00:00:00+02:00"
title: "Simple Multi-texture Terrain Rendering"
image: "/img/terrain-rendering/banner.jpg"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["opengl", "c++", "effects"]
---

Terrain rendering from heightmaps generated with libnoise, started as a college assignment. It is textured by height, lit through the day by path-traced lightmaps, and drawn with geomipmapping.
<!--more-->

The source code is [on my GitHub](https://github.com/jose-villegas/TerrainRendering), and builds with Visual Studio 2026 with its dependencies included. The time of the day lighting is baked on the CPU with a path tracer: soft sun shadows, sky light and two diffuse bounces. Optional light shafts march through a height fog over the terrain. Geomipmapping draws each chunk of the terrain at the coarsest level its pixel error allows, stitched to its neighbours so the mesh stays watertight; [this page explains how](https://github.com/jose-villegas/TerrainRendering/blob/master/docs/geomipmapping.md).

<img src="/img/terrain-rendering/hero.gif" width="100%">

<img src="/img/terrain-rendering/hero.jpg" width="100%">

<img src="/img/terrain-rendering/light-shafts.jpg" width="100%">
