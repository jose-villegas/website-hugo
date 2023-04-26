---
date: "2014-12-03T00:00:00+01:00"
title: "Computer Graphics Basic Mapping Techniques"
image: "https://res.cloudinary.com/jose-villegas/image/upload/v1595459438/WebPage/cg.png"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["opengl", "c++", "effects"]
---

This was one of my first computer graphics assignments, we implemented different real time rendering techniques in this project, which included: object selection, translations, rotations and scaling, camera translation and rotation, refraction and reflection, point lights, directional lights, spot lights and shadow mapping.
<!--more-->

This was made with C++, using OpenGL, GLEW, SFML, GLM and AntWeakBar for the UI. The source code can be found on [my GitHub here](https://github.com/jose-villegas/NormalShadowRefr-Mapping).

Reflections, Refractions, Object Loading, Color Picking, Bump Mapping, Shadow Mapping, etc. Using old OpenGL (using client states and predefined vertex buffers)

The focus of this project is to explore the implementation of different mapping techniques such as shadow mapping, enviroment / projection mapping for real time reflections and refractions, and normal maps for bumped surfaces

The program loads the scene through obj files, mtl files are used to specify textures and normal maps.

Features:

* Object Selection (using color picking)
* Object Translation / Rotation
* Camera Translation / Rotation
* Refractive / Reflective Objects
* Point / Spot / Direction lights
* Shadow Mapping for Spotlights and Directional Lights

Some screenshots:

<img src="https://camo.githubusercontent.com/d025d7f472501df38ddfbc0a180846b1b45c5f85/687474703a2f2f692e696d6775722e636f6d2f6a464b6b6f4a782e706e67" width="100%">

<img src="https://camo.githubusercontent.com/190c1b1fbafd89c83997853fb3c0f5ff0743d793/687474703a2f2f692e696d6775722e636f6d2f66577a6e6f33372e706e67" width="100%">