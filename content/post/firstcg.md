---
date: "2014-12-03T00:00:00+01:00"
title: "Computer Graphics Basic Mapping Techniques"
image: "/img/firstcg/banner.jpg"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["opengl", "c++", "effects"]
---

One of my first computer graphics assignments: a real time scene with shadow mapping, reflections and refractions from cube maps, normal and parallax occlusion mapping, and physically based shading, with object selection and transforms through the UI.
<!--more-->

The source code is [on my GitHub](https://github.com/jose-villegas/NormalShadowRefr-Mapping), and builds with Visual Studio 2026 with its dependencies included. It is made with C++, old OpenGL (client states and the fixed function matrices) with GLSL shaders, GLEW, GLFW, GLM and AntTweakBar for the UI. The scene is loaded from obj files, and mtl files give each object its textures, normal map, height map and material.

<img src="/img/firstcg/hero.gif" width="100%">

<img src="/img/firstcg/hero.jpg" width="100%">

The objects turn and bob, and two coloured spot lights orbit them, each casting its own soft shadow (3x3 PCF).

The floor uses parallax occlusion mapping. It marches the view ray through a height map in tangent space, so the paving stones occlude each other and keep their depth at grazing angles, where normal mapping alone looks flat.

<img src="/img/firstcg/parallax.jpg" width="100%">

Shading is Cook-Torrance with a GGX distribution, Smith-Schlick geometry and Schlick Fresnel, in the metallic and roughness workflow, read from the mtl PBR keys (`Pm`, `Pr`, `map_Pr`). The output is tone mapped and gamma corrected. Reflections and refractions sample a mipmapped cube map, rougher surfaces reading blurrier levels, with a procedural sky around the scene. Blinn-Phong shading is a toggle in the UI.

<img src="/img/firstcg/shading.jpg" width="100%">

The UI selects an object to move, rotate, scale or change its material, and toggles every effect:

<img src="/img/firstcg/ui.jpg" width="100%">
