---
date: "2017-06-19T00:00:00+02:00"
title: "Simple Multi-texture Terrain Rendering"
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1731415831/687474703a2f2f692e696d6775722e636f6d2f6f4a454e6d38352e6a7067_l4kszz.jpg"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["opengl", "c++", "effects"]
---

This is a simple implementation of terrain rendering using heighmaps, part of a college assignment. The code has some optimizations such as parallel processing to bake lightmaps and cheap ambient occlusion using the terrain heighmap.
<!--more-->

The source code can be found [here on my GitHub](https://github.com/jose-villegas/TerrainRendering). The project does require a lot of dependencies to compile, it was made using [OGLPlus](https://github.com/matus-chochlik/oglplus), glm, [boost](https://www.boost.org/), [FreeImage](https://freeimage.sourceforge.io/), [ImGui](https://github.com/ocornut/imgui) and Parallel Patterns Library [(ppl)](https://docs.microsoft.com/en-us/cpp/parallel/concrt/parallel-patterns-library-ppl?view=vs-2019).

<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1731415831/687474703a2f2f692e696d6775722e636f6d2f6f4a454e6d38352e6a7067_l4kszz.jpg" width="100%">


