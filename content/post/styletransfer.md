---
date: "2017-05-14T00:00:00+02:00"
title: "Volume Rendering with Style Transfer Function"
image: "/img/styletransfer/banner.jpg"
showonlyimage: true
draft: false
weight: 0
categories: ["Graphics"]
tags: ["opengl", "c++", "effects"]
---

An interactive volume renderer with style transfer functions, part of a college assignment. Every density range gets a lit sphere image, a "style", along with its color and opacity, so bone, skin or leaves each get their own material. The volume lights itself with soft shadows, ambient occlusion and one bounce of indirect light. The technique is based on this [paper](https://www.cg.tuwien.ac.at/research/publications/2007/bruckner-2007-STF/).
<!--more-->

The source code is [on my GitHub](https://github.com/jose-villegas/StyleTransferFunction), and builds with Visual Studio 2026 with Cinder as a submodule. It is made with C++, OpenGL 4.3 compute and fragment shaders, Cinder, GLM and Dear ImGui. Three volumes come with it: a bonsai, a foot and a skull.

<img src="/img/styletransfer/lighting.gif" width="100%">

<img src="/img/styletransfer/bonsai.jpg" width="100%">

Rays are cast through the volume from the front to the back faces of its bounding box, with jittered start positions to hide banding. Each sample is classified by the transfer function and shaded by looking up its normal in the style's lit sphere. Gradients are central differences, smoothed in compute shaders. They keep their magnitude, so shading can tell a surface from the inside of a homogeneous region.

The lighting is computed in the volume itself, so anything in front of the light shadows what is behind it, at any depth. Two 3D textures hold it, at half the volume's resolution:

- A light volume stores, for every voxel, how much light reaches it through the material between it and the light.
- An ambient volume marches 16 short rays from every voxel. The share that escapes is its ambient occlusion. The lit material the rays run into is reflected back as one bounce of indirect light.

Both are rebuilt in compute shaders only when the light, the volume's rotation or the transfer function change, so moving the camera costs nothing extra. Samples on surfaces get Lambert and a normalized Blinn-Phong highlight. Inside homogeneous material, where the gradient is only noise, they scatter light like a medium instead.

The original lighting, Lambert with screen space shadows and ambient occlusion, is still a toggle, for comparison:

<img src="/img/styletransfer/compare-skull.jpg" width="100%">

<img src="/img/styletransfer/compare-foot.jpg" width="100%">

The transfer function editor places alpha, color and style points over the volume's histogram. Any image can be added as a style, and functions save to files. Every lighting term has its own toggle and strength:

<img src="/img/styletransfer/ui.jpg" width="100%">
