## Passing data to G-Buffers (10 points)
From `standard-frag.glsl`:
* Camera-space depth of the fragment
* World-space surface normal of the fragment
* Albedo (base color) of the fragment.

## Basic scene shading (10 points)
In `deferred-render.glsl`,
* Lambertian surface reflection 
* Ambient lighting, so areas that would be very dark are slightly lit.
* Directional or point light illumination by at least one light source.
* a time-offset noise-based image. 
* Used fbm for noise

## HDR Tone Mapping (5 points)
In `tonemap-frag.glsl`, implemented reinhard from [Filmic Worlds blog](http://filmicworlds.com/blog/filmic-tonemapping-operators/).

## Post-process effects (75 points)
three of the effects listed below to receive full credit for this assignment. 

* __Bloom:__ As a 32-bit HDR effect, find and isolate areas of the image with a value higher than 1, then apply a blur effect and add that to the original image to apply a bloom effect. You may implement any of the blurring effects we've discussed. Since bloom requires storing frame data in two frame buffers at the same time, you will very likely have to modify the provided rendering pipeline to not use a `for` loop over the set of `post32Pass`es, since this ping-pongs data between two buffers alternately.
* __Approximated depth of field:__ Choose a "focal length" for your virtual camera and compare the camera-space Z coordinate of your fragments to that distance. The farther the Z coordinate is from that length, the stronger a blur effect you should apply to that fragment. We recommend using a Gaussian blur for best visual results, but you are free to implement any blur you want.
* __God rays:__ This effect requires an "occlusion pre-pass" as the input framebuffer. This means rendering all geometry as black ( (0, 0, 0), representing occlusion of light source ) and light source as you normally would, which should yield a framebuffer looking something like [this](http://fabiensanglard.net/lightScattering/tutorial1LightAndOccluder.JPG). The godRay shader (different from the occlusion pre-pass shader) then computes a screen-space direction from a given fragment towards the light source(s). Repeatedly sample your image n times, stepping some amount along the light direction, accumulating the sampled color to effectively perform a blur. That should yield something like [this](http://fabiensanglard.net/lightScattering/tutorial2LightScattering.JPG). From there, you must blend these blurred rays with the framebuffer containing your actual rendered scene. Additionally, you can find a GPU Gem on this effect [here](https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch13.html) and the linked reference images were taken from [here](http://fabiensanglard.net/lightScattering/). Also, this technique breaks when the light source is not in view. We don't require you to handle this but you should use blending techniques to smoothly blend in and out of the state where the camera can see the light source.

* __Motion blur:__ Output some velocity value into a G-Buffer and use it to apply
a directional blur to your scene. This will necessitate adding some motion to your
3D scene, even if it's as simple as using sine/cosine curves to move your model
around. You should also account for the motion of the camera when you output velocity into your G-Buffer. Consider storing information somewhere about where your model and camera were positioned last frame to compute velocity vectors.

* __Artistic effect:__ Implement a shader that artistically transforms the scene in some manner. Below is a list of ideas, but you can implement any effect you want provided it's about as complex as the items listed:
   * Pointilism with dots of varying size
   * Pencil sketch overlay shading
   * Oil painting, as seen in [The Witcher 3](https://gameitecture.files.wordpress.com/2015/10/887492_10205878896945699_541624563347038791_o.jpg)
   * Browse through ShaderToy and find something inspirational
   * Invent your own! Just make sure you run it by Adam and the TAs first.

## Extra credit (30 points max)
* Use Dat.GUI to make some element(s) of your post-processes interactive, even something as simple as being able to activate and deactivate a process. (5 - 15 points)
* Implement an additional feature from the set listed above (15 points)
* [FXAA](http://developer.download.nvidia.com/assets/gamedev/files/sdk/11/FXAA_WhitePaper.pdf) (7 points)
* Shadow mapping (25 points)
* Custom 3D scene with new OBJs and textures (5 - 10 points)
* Screen-space ambient occlusion (30 points)
