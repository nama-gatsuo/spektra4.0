uniform float time;

out struct Vert {
	vec4 posInWorld;
	vec4 color;
	vec3 normalInWorld;
	vec3 bc; // bary centric
} vVert;

out float noiseFactor;
flat out int cameraIndex;

void main() {
	noiseFactor = pow(TDPerlinNoise(P * 3. + time * 0.1) * 0.5 * (sin(time) + 1.0),2.);

	vVert.posInWorld = TDDeform(P);
	vVert.color = TDInstanceColor(Cd);
	vVert.normalInWorld = TDDeformNorm(N);
	vVert.bc = vec3(1.);

	cameraIndex = TDCameraIndex();

}
