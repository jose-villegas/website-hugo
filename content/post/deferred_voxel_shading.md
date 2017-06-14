+++
date = "2017-06-10T19:11:07-04:00"
title = "Deferred Voxel Shading for Real Time Global Illumination"
image = "http://res.cloudinary.com/jose-villegas/image/upload/v1497325463/DVSGI/dvsgi_x6b8eu.png"
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
![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323827/DVSGI/scene_culelk.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323820/DVSGI/v_albedo_qtc4ov.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323804/DVSGI/v_normal_ryzmrh.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323828/DVSGI/v_emission_aibyaf.png)

The next step is voxel illumination, for this we calculate the outgoing radiance per voxel using the data stored from the voxelization step. For this we only need the voxel normal, and its position which can be easily extracted by projecting the voxel 3D coordinates in world-space, then we calculate direct lighting per voxel and add the voxel's emissive value.

Scene | Voxel Direct Lighting
:-:|:-:
![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323827/DVSGI/scene_culelk.png)|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_195/v1497323829/DVSGI/v_direct_vrnajc.png)

A disvantage of this technique is the loss of precision averaging all the geometry normals within a voxel. The resulting averaged normal may end up pointing towards a non-convenient direction. This problem is notable when the normal vectors within the space of a voxel are uneven.

![](http://res.cloudinary.com/jose-villegas/image/upload/v1497413810/DVSGI/uneven_normals_n3klcb.svg)

To reduce this issue my proposal utilizes a normal-weighted attenuation, where first the normal attenuation is calculated per every face of the voxel as follows:

\begin{equation}
D_\{x,y,z\} = (\hat{i}\cdot\Psi, \hat{j}\cdot\Psi, \hat{k}\cdot\Psi)
\end{equation}

Then three dominant faces are selected depending on the axes sign of the averaged normal:

\begin{equation}
D_{\omega} =
\begin{cases}
max\\{D\_\omega, 0\\}, & N\_\omega>0\\\ 
max\\{-D\_\omega, 0\\}, & \text{otherwise}
\end{cases}
\end{equation}

And finally, the resulting attenuation is the product of every dominant face normal attenuation, multiplied with the weight per axis of the averaged normal vector of the voxel, the resulting reflectance model is computed as follows:

\begin{equation}
\begin{split}
W &= N^2\\\ 
V_\{r\} &= L\_\{i\}\frac{\rho}{\pi}(W_x D_x + W_y D_y + W_z D_z)
\end{split}
\end{equation}
where \\(L_i\\) is the light source intensity, \\(\rho\\) the voxel albedo, \\(N\\) the normal vector of the voxel and \\(\Psi\\) the light direction.

Normal attenuation | Normal-weighted attenuation
:-:|:-:
![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_450/v1497414410/DVSGI/shading_standard_e7vzft.png)&nbsp;|![](http://res.cloudinary.com/jose-villegas/image/upload/c_scale,w_450/v1497414410/DVSGI/shading_directional_uwyxxw.png)
