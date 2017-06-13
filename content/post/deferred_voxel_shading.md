+++
date = "2017-06-10T19:11:07-04:00"
title = "Deferred Voxel Shading for Real Time Global Illumination"
image = "img/dvsgi/dvsgi.png"
showonlyimage = true
draft = false
weight = 0
categories = [ "Portfolio", "Graphics" ]
+++

Computing indirect illumination is a challenging and complex problem for real-time rendering in 3D applications. This global illumination approach computes indirect lighting in real time utilizing a simpliﬁed version of the outgoing radiance and the scene stored in voxels.
<!--more-->

Deferred voxel shading is a four-step real-time global illumination technique inspired by voxel cone tracing and deferred rendering. This approach enables us to approximate 2-bounce indirect diffuse, specular reflectance, emissive materials, indirect shadows and ambient occlusion.

The first step is voxelize the scene, my implemention voxelizes scene albedo, normal and emission to approximate emissive materials. For this atomic operations on 3D textures are used as described [here](https://www.seas.upenn.edu/~pcozzi/OpenGLInsights/OpenGLInsights-SparseVoxelization.pdf); the average albedo, normal and emission of all the geometry within a voxel is stored in 3D volumes, these volumes are later used to calculate voxel illumination. Unlike other approaches that store radiance directly into the voxel structure I utilize the 3D volumes as deferred rendering does with its geometry buffer for a separate stage for lighting calculations, this has the advantage of being generally faster but requires more memory.

```c
...
layout(binding = 0, r32ui) uniform volatile coherent uimage3D voxelAlbedo;
layout(binding = 1, r32ui) uniform volatile coherent uimage3D voxelNormal;
layout(binding = 2, r32ui) uniform volatile coherent uimage3D voxelEmission;
...
// average normal per fragments sorrounding the voxel volume
imageAtomicRGBA8Avg(voxelNormal, position, normal);
// average albedo per fragments sorrounding the voxel volume
imageAtomicRGBA8Avg(voxelAlbedo, position, albedo);
// average emission per fragments sorrounding the voxel volume
imageAtomicRGBA8Avg(voxelEmission, position, emissive);
...
```

Scene | Average Albedo | Average Normal | Average Emission
:-:|:-:|:-:|:-:
![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323827/scene_culelk.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323820/v_albedo_qtc4ov.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323804/v_normal_ryzmrh.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323828/v_emission_aibyaf.png)








