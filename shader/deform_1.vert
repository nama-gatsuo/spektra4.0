uniform float time;

out struct Vert {
	vec4 posInWorld;
	vec4 color;
	vec3 normalInWorld;
} vVert;
out float noiseFactor;
flat out int cameraIndex;

void main() {
	noiseFactor = clamp(TDSimplexNoise(vec3(uv[0].xy*10., time*0.1)), 0., 1.);

	vVert.posInWorld = TDDeform(P);
	vVert.color = TDInstanceColor(Cd);
	vVert.normalInWorld = TDDeformNorm(N);

	cameraIndex = TDCameraIndex();

}
