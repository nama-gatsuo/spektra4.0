uniform float time;

out struct Vert {
	vec4 posInWorld;
	vec4 color;
	vec3 normalInWorld;
} vVert;
out float noiseFactor;
flat out int cameraIndex;

void main() {
	noiseFactor = pow(TDPerlinNoise(P * 3. + time * 0.2) * 1.2 * sin(time), 2.);

	vVert.posInWorld = TDDeform(P);
	vVert.color = TDInstanceColor(Cd);
	vVert.normalInWorld = TDDeformNorm(N);

	cameraIndex = TDCameraIndex();

}
