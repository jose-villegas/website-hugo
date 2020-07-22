---
date: "2015-04-10T00:00:00+02:00"
title: "Simple Multi-texture Terrain Rendering"
image: "https://camo.githubusercontent.com/e162381c407599525985d3e817fa46d2501eb9d0/687474703a2f2f692e696d6775722e636f6d2f6f4a454e6d38352e6a7067"
showonlyimage: true
draft: false
weight: 0
categories: ["graphics"]
tags: ["opengl", "c++", "effects"]
---

This is a simple implementation of terrain rendering using heighmaps. The code uses parallel processing and other optimizations such as lightmaps baking and cheap ambient occlusion using the terrain heighmap.
<!--more-->

The source code can be found here. The project does require a lot of dependencies to compile, it was made using [OGLPlus](https://github.com/matus-chochlik/oglplus), glm, [boost](https://www.boost.org/), [FreeImage](https://freeimage.sourceforge.io/), [ImGui](https://github.com/ocornut/imgui) and Parallel Patterns Library [(ppl)](https://docs.microsoft.com/en-us/cpp/parallel/concrt/parallel-patterns-library-ppl?view=vs-2019).

<img src="https://camo.githubusercontent.com/e162381c407599525985d3e817fa46d2501eb9d0/687474703a2f2f692e696d6775722e636f6d2f6f4a454e6d38352e6a7067" width="100%">


