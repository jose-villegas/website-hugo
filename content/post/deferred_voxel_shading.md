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

Deferred voxel shading is a four-step real-time global illumination technique inspired by voxel cone tracing and deferred rendering. This approach enables us to obtain an accurate approximation of a plethora of indirect illumination effects including: indirect diffuse, specular reflectance, color-blending, emissive materials, indirect shadows and ambient occlusion. The steps that comprehend this technique are described below.

<table style="width:100%">
  <tr>
    <th>Technique Overview</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497489937/dvsgi_overview_vlucdk.svg" style="width: 100%;"/></td>
  </tr>
</table>

### 1. Voxelization

The first step is to voxelize the scene, my implemention voxelizes scene albedo, normal and emission to approximate emissive materials. For this conservative voxelization and atomic operations on 3D textures are used as described [here](https://www.seas.upenn.edu/~pcozzi/OpenGLInsights/OpenGLInsights-SparseVoxelization.pdf).

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

| Scene | Average Albedo | Average Normal | Average Emission |
|-------|----------------|----------------|------------------|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323827/DVSGI/scene_culelk.png" style="width: 100%;"/>|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323820/DVSGI/v_albedo_qtc4ov.png" style="width: 100%;"/>|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323804/DVSGI/v_normal_ryzmrh.png" style="width: 100%;"/>|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323828/DVSGI/v_emission_aibyaf.png" style="width: 100%;"/>

### 1.1 Voxel Structure

My voxel structure is inspired by deferred rendering, where a G-Buffer contains relevant data to later be used in a separate light pass. Normal, albedo and emission values are stored in voxels during the voxelization process, every attribute has its own 3D texture associated. This information is sufficient to calculate the diffuse reflectance and normal attenuation on a separate light pass where, instead of computing the lighting per pixel it is done per voxel. The structure can be extended to support a more complicated reflectance model but this may imply a higher memory consumption to store additional data.

Furthermore, another structure is used for the voxel cone tracing pass. The resulting values of the lighting computations per voxel are stored in another 3D texture which we will call *radiance volume*. To approximate the incrementing diameter of the cone, and its sampling volume, levels of detail of the voxelized scene are used. For anisotropic voxels six 3D textures at half resolution of the radiance volume are required, one per every axis direction positive and negative, the levels of details are stored within the mipmap levels of these textures which we will call *directional volumes*. 

The radiance volume represents the maximum level of detail for the voxelized scene, this texture is separated from the directional volumes. To bind these two structures, linear interpolation is used between samples of both structures when the mipmap level required for the diameter of the cone ranges between, the maximum level and the first filtered level of detail.

<table style="width:100%">
  <tr>
    <th>A visualization of the voxel structure</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497571454/voxel_structure_dsmsvc.svg" style="width: 60%;"/></td>
  </tr>
</table>

### 2. Voxel Illumination

The second step is voxel illumination, for this we calculate the outgoing radiance per voxel using the data stored from the voxelization step. For this we only need the voxel normal, and its position which can be easily extracted by projecting the voxel 3D coordinates in world-space, then we can calculate the direct lighting per voxel. This is all done in a compute shader.

One of the advantages of this technique is that it's compatible with all standard light types like point, spot and directional lights, another is that we don't need shadow maps, though they can help greatly with precision specially for directional lights. Other techniques calculate the voxel radiance per light's shadow map, meaning that for every shadow-mapped light that wants to contribute to the voxel radiance the illumination step has to be repeated.

| Scene | Voxel Direct Lighting |
|:-----:|:---------------------:|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323827/DVSGI/scene_culelk.png" style="width: 50%"/>|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323829/DVSGI/v_direct_vrnajc.png" style="width: 50%"/>

#### 2.1. Normal-Weighted Attenuation

A disvantage of this technique is the loss of precision averaging all the geometry normals within a voxel. The resulting averaged normal may end up pointing towards a non-convenient direction. This problem is notable when the normal vectors within the space of a voxel are uneven:

<center>
![](http://res.cloudinary.com/jose-villegas/image/upload/v1497413810/DVSGI/uneven_normals_n3klcb.svg)
</center>

To reduce this issue my proposal utilizes a normal-weighted attenuation, where first the normal attenuation is calculated per every face of the voxel as follows:

\begin{equation}
D_\{x,y,z\} = (\hat{i}\cdot\Psi, \hat{j}\cdot\Psi, \hat{k}\cdot\Psi)
\end{equation}

Then three dominant faces are selected depending on the axes sign of the voxel averaged normal vector:

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

| Normal Attenuation | Normal-weighted Attenuation |
|--------------------|-----------------------------|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497414410/DVSGI/shading_standard_e7vzft.png" style="width: 99%;"/>&nbsp;|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497414410/DVSGI/shading_directional_uwyxxw.png" style="width: 99%;"/>&nbsp;

#### 2.2. Voxel Occlusion

To generate accurate results during the cone tracing step the voxels need to be occluded, otherwise voxelized geometry that is supposed to have little to no outgoing radiance will contribute to the indirect lighting calculations.

The classic shadow mapping or alike techniques can be used to compute the voxels occlusion. The position of the voxel is projected in light space and the depth of the projected point is compared with the stored depth from the shadow map to determine if the voxel is occluded. A simple improvement over this technique is: instead of using the voxel center position \\(V\_p\\), the position is translated along the normal vector of the voxel by half voxel size \\(V\_\{size\}\\) as \\(V\_{p} = V\_{p} + N\times V_{size}\times 0.5\\), this exposes the voxel position further in case the center position may be occluded by geometry near the voxel.

My proposal also computes occlusion using raycasting within a volume. Any of the resulting volumes from the voxelization process can be used since the algorithm only needs to determine if a voxel exists at a certain position. To determine occlusion of a voxel, a ray is traced from the position of voxel in the direction of the light, the volume is sampled to determine if at the position of the ray there is a voxel, if this condition is true then the voxel is occluded.

##### 2.2.1 Soft Voxel Shadows

Instead of stopping the ray as soon a voxel is found, soft shadows can be approximated with a single ray accumulating a value \\(\kappa\\) per collision and dividing by the traced distance \\(t\\), i.e. \\(\nu = \nu + (1 - \nu)\kappa\div t\\), where \\(1 - \nu\\) represents the occlusion value after the accumulation is finished. This technique exploits the observation that, from the light point of view, the number of collisions will usually be higher for the rays that pass through the borders of the voxelized geometry.

| Hard Voxel Shadows | Soft Voxel Shadows |
|:------------------:|:------------------:|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500701/DVSGI/hard_voxel_shadows_ovj32i.svg" style="width: 49%;"/>&nbsp;|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500702/DVSGI/soft_voxel_shadows_gcmlzm.svg" style="width: 49%;"/>&nbsp;
&nbsp;|&nbsp;
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500851/DVSGI/hard_traced_takadd.png" style="width: 99%;"/>&nbsp;|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500853/DVSGI/soft_traced_upabyg.png" style="width: 99%;"/>&nbsp;

#### 2.3. Emission

Adding to the final radiance value the emission term can be used approximate emissive surfaces such as area lights, neon lights, digital screens, etc., this provides a crude approximation of the emission term the rendering equation. After the direct illumination value is obtained the emission term from the voxelization process is added to this value per voxel. During the cone tracing step, these voxels will appear to be bright even on occluded areas, hence indirect light is accumulated per cone from these regions of the voxelized scene.

### 3. Anisotropic Voxels

### 4. Voxel Cone Tracing

#### 4.1 Indirect Illumination

#### 4.2 Ambient Occlusion

#### 4.3 Soft Shadows

### Voxel Indirect Diffuse