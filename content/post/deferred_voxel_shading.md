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

# Overview

Deferred voxel shading is a four-step real-time global illumination technique inspired by voxel cone tracing and deferred rendering. This approach enables us to obtain an accurate approximation of a plethora of indirect illumination effects including: indirect diffuse, specular reflectance, color-blending, emissive materials, indirect shadows and ambient occlusion. The steps that comprehend this technique are described below.

<table style="width:100%">
  <tr>
    <th>Technique Overview</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497489937/dvsgi_overview_vlucdk.svg" style="width: 100%;"/></td>
  </tr>
</table>

## 1. Voxelization

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

### 1.1. Voxel Structure

My voxel structure is inspired by deferred rendering, where a G-Buffer contains relevant data to later be used in a separate light pass. Normal, albedo and emission values are stored in voxels during the voxelization process, every attribute has its own 3D texture associated. This information is sufficient to calculate the diffuse reflectance and normal attenuation on a separate light pass where, instead of computing the lighting per pixel it is done per voxel. The structure can be extended to support a more complicated reflectance model but this may imply a higher memory consumption to store additional data.

Furthermore, another structure is used for the voxel cone tracing pass. The resulting values of the lighting computations per voxel are stored in another 3D texture which we will call *radiance volume*. To approximate the incrementing diameter of the cone, and its sampling volume, levels of detail of the voxelized scene are used. For anisotropic voxels six 3D textures at half resolution of the radiance volume are required, one per every axis direction positive and negative, the levels of details are stored within the mipmap levels of these textures which we will call *directional volumes*. 

The radiance volume represents the maximum level of detail for the voxelized scene, this texture is separated from the directional volumes. To bind these two structures, linear interpolation is used between samples of both structures when the mipmap level required for the diameter of the cone ranges between, the maximum level and the first filtered level of detail.

<table style="width:100%">
  <tr>
    <th>A visualization of the voxel structure</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497571454/DVSGI/voxel_structure_dsmsvc.svg" style="width: 60%;"/></td>
  </tr>
</table>

## 2. Voxel Illumination

The second step is voxel illumination, for this we calculate the outgoing radiance per voxel using the data stored from the voxelization step. For this we only need the voxel normal, and its position which can be easily extracted by projecting the voxel 3D coordinates in world-space, then we can calculate the direct lighting per voxel. This is all done in a compute shader.

One of the advantages of this technique is that it's compatible with all standard light types like point, spot and directional lights, another is that we don't need shadow maps, though they can help greatly with precision specially for directional lights. Other techniques calculate the voxel radiance per light's shadow map, meaning that for every shadow-mapped light that wants to contribute to the voxel radiance the illumination step has to be repeated.

| Scene | Voxel Direct Lighting |
|:-----:|:---------------------:|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323827/DVSGI/scene_culelk.png" style="width: 50%"/>|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497323829/DVSGI/v_direct_vrnajc.png" style="width: 50%"/>

### 2.1. Normal-Weighted Attenuation

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

### 2.2. Voxel Occlusion

To generate accurate results during the cone tracing step the voxels need to be occluded, otherwise voxelized geometry that is supposed to have little to no outgoing radiance will contribute to the indirect lighting calculations.

The classic shadow mapping or alike techniques can be used to compute the voxels occlusion. The position of the voxel is projected in light space and the depth of the projected point is compared with the stored depth from the shadow map to determine if the voxel is occluded. A simple improvement over this technique is: instead of using the voxel center position \\(V\_p\\), the position is translated along the normal vector of the voxel by half voxel size \\(V\_\{size\}\\) as \\(V\_{p} = V\_{p} + N\times V_{size}\times 0.5\\), this exposes the voxel position further in case the center position may be occluded by geometry near the voxel.

My proposal also computes occlusion using raycasting within a volume. Any of the resulting volumes from the voxelization process can be used since the algorithm only needs to determine if a voxel exists at a certain position. To determine occlusion of a voxel, a ray is traced from the position of voxel in the direction of the light, the volume is sampled to determine if at the position of the ray there is a voxel, if this condition is true then the voxel is occluded.

#### 2.2.1. Soft Voxel Shadows

Instead of stopping the ray as soon a voxel is found, soft shadows can be approximated with a single ray accumulating a value \\(\kappa\\) per collision and dividing by the traced distance \\(t\\), i.e. \\(\nu = \nu + (1 - \nu)\kappa\div t\\), where \\(1 - \nu\\) represents the occlusion value after the accumulation is finished. This technique exploits the observation that, from the light point of view, the number of collisions will usually be higher for the rays that pass through the borders of the voxelized geometry.

| Hard Voxel Shadows | Soft Voxel Shadows |
|:------------------:|:------------------:|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500701/DVSGI/hard_voxel_shadows_ovj32i.svg" style="width: 49%;"/>&nbsp;|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500702/DVSGI/soft_voxel_shadows_gcmlzm.svg" style="width: 49%;"/>&nbsp;
&nbsp;|&nbsp;
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500851/DVSGI/hard_traced_takadd.png" style="width: 99%;"/>&nbsp;|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497500853/DVSGI/soft_traced_upabyg.png" style="width: 99%;"/>&nbsp;

### 2.3. Emission

Adding to the final radiance value the emission term can be used approximate emissive surfaces such as area lights, neon lights, digital screens, etc., this provides a crude approximation of the emission term the rendering equation. After the direct illumination value is obtained the emission term from the voxelization process is added to this value per voxel. During the cone tracing step, these voxels will appear to be bright even on occluded areas, hence indirect light is accumulated per cone from these regions of the voxelized scene.

## 3. Anisotropic Voxels

For more precise results during the cone tracing step anisotropic voxels are used. The mipmapping levels, as seen in the *directional volumes* in the voxel structure, will store per every voxel six directional values, one per every directional axis positive and negative. Each cone has an origin, aperture angle and direction, this last factor determines which three volumes are sampled. The directional sample is obtained by linearly interpolating the three samples obtained from the selected directional volumes.

To generate the anisotropic voxels I use the process detailed by Crassin [here](http://maverick.inria.fr/Publications/2011/CNSGE11b/). To compute a directional value a step of volumetric integration is done in depth and the directional values are averaged to obtain the resulting value for a certain direction. In my approach this is done using compute shaders, executing a thread per every voxel at the mipmap level that is going to be filtered using the values from the previous level, this process is done per every mipmap level.

<table style="width:100%">
  <tr>
    <th>Process to generate anisotropic voxels</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497576308/DVSGI/aniso_cropped_aekdhv.png" style="width: 40%;"/></td>
  </tr>
</table>

## 4. Voxel Cone Tracing

Voxel cone tracing is similar to ray marching, the cone advances a certain length every step, except that the sampling volume increases along the diameter of the cone. The mipmap levels in the directional volumes are used to approximate the expansion of the sampling volume during the cone trace, to ensure smooth variation between samples quadrilinear interpolation is used which is natively supported with graphics hardware for 3D textures.

The shape of the cone is meant to exploit the spatial and directional coherence of the many rays packed within the space of a cone. This behavior is used in many approaches such as packet ray-tracing.

<table style="width:100%">
  <tr>
    <th>Visual representation of a cone used for cone tracing</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497581558/DVSGI/cone_oyxusj.svg" style="width: 80%;"/></td>
  </tr>
</table>

As seen in the figure above each cone is defined by an origin \\(C\_o\\), a direction \\(C\_d\\) and an aperture angle \\(\theta\\). During the cone steps the diameter of the cone is defined by \\(d\\), this value can be extracted using the traced distance \\(t\\) with the following equation: \\(d=2t\times\tan(\theta\div 2)\\). Which mipmap level should be sampled depending on the diameter of the cone can be obtained using the following equation: \\(V\_\{level\} = log\_2(d\div V\_\{size\})\\), where \\(V\_\{size\}\\) is the size of a voxel at the maximum level of detail.

As described by Crassin [here](http://maverick.inria.fr/Publications/2011/CNSGE11b/), for each cone trace we keep track of the occlusion value \\(\alpha\\) and the color value \\(c\\) which represents the indirect light towards the cone origin \\(C\_o\\). In each step we retrieve from the voxel structure the occlusion value \\(\alpha_2\\) and the outgoing radiance \\(c_2\\). Then the \\(c\\) and \\(\alpha\\) values are updated using volumetric front-to-back accumulation as follows: \\(c =\alpha c + (1-\alpha)\alpha\_2c\_2\\) and \\(\alpha=\alpha+(1-\alpha)\alpha\_2\\). 

To ensure good integration quality between samples the distance \\(d'\\) between steps is modified by a factor \\(\beta\\). With \\(\beta = 1\\) the value of \\(d'\\) is equivalent to the current diameter \\(d\\) of the cone, values less than \\(1\\) produce higher quality results but require more samples which reduces the performance.

### 4.1. Indirect Illumination

Indirect lighting is approximated with a crude Monte Carlo approximation. The hemisphere region for the integral in the rendering equation can be partitioned into a sum of integrals. For a regular partition, each partitioned region resembles a cone. For each cone their contribution is approximated using voxel cone tracing, the resulting values are then weighted to obtain the accumulated contribution at the cones origin.

The distribution of the cones matches the shape of the BRDF, for a Blinn-Phong material a few large cones distributed over the normal oriented hemisphere estimate the diffuse reflection, while a single cone in the reflected direction, where its aperture depends on the specular exponent, approximates the specular reflection.

| Diffuse Cones | Specular Cone | BRDF |
|:-------------:|:-------------:|:----:|
<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497581804/DVSGI/diffuse_cones_oo7hsx.svg" style="width: 60%;"/>|<img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497581807/DVSGI/specular_cones_faycaz.svg" style="width: 60%;"/>|<img src="https://res.cloudinary.com/jose-villegas/image/upload/v1497581810/DVSGI/brdf_cones_b4hmdk.svg" style="width: 60%;"/>

### 4.2. Ambient Occlusion

Ambient occlusion can be approximated using the same cones used for the diffuse reflection for efficiency. For the ambient occlusion term \\(\delta\\) we only accumulate the occlusion value \\(\alpha\_2\\), at each step the accumulated value is multiplied with the weighting function \\(f\(r\) = \frac\{1\}\{1+\lambda r\}\\), where \\(r\\) is the current radius of the cone and \\(\lambda\\) an user defined value which controls how fast \\(f\(r\)\\) decays along the traced distance. At each cone step the ambient occlusion term is updated as: \\(\delta = \delta + (1-\delta)\alpha\_2f\(r\)\\).

### 4.3. Soft Shadows

Cone tracing can also be used to achieve soft shadows tracing a cone from the surface point \\(x\\) towards the direction of the light The cone aperture controls how soft and scattered the resulting shadow is. For soft shadows with cones we only accumulate the occlusion value \\(\alpha\_2\\) at each step.

<table style="width:100%">
  <tr>
    <th>Cone Soft Shadows</th>
  </tr>
  <tr>
    <td align="center"><img src="http://res.cloudinary.com/jose-villegas/image/upload/v1497585029/DVSGI/cone_shadow_jwx9pd.svg" style="width: 40%;"/></td>
  </tr>
</table>

## Voxel Indirect Diffuse
To calculate the diffuse reflection over a surface point using voxel cone tracing we need its normal vector, albedo and the incoming radiance at that point. Since we voxelize the geometry normal vectors and the albedo into 3D textures, all the needed information for the indirect diffuse term is available after calculating the voxel direct illumination. In my approach I perform voxel cone tracing per voxel using compute shaders to calculate the first bounce of indirect diffuse at each voxel. This step is done after the outgoing radiance values from the voxel direct illumination pass are anisotropically filtered. 

For each voxel we use its averaged normal vector to generate a set of cones around the normal oriented hemisphere to calculate the indirect diffuse at the position of the voxel. The weighted result from all the cones is then multiplied by the albedo of the voxel and added to the direct illumination value. The resulting outgoing radiance for the radiance volume now stores the direct illumination, and the first bounce of indirect diffuse. The anisotropic filtering process needs be repeated for the new values. This enables us to approximate the second bounce of indirect lighting during the final voxel cone tracing step per pixel. This can be extended to support multiple bounces.

# Results