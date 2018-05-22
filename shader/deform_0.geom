layout (triangles) in;
layout (triangle_strip) out;
layout (max_vertices = 3) out;

struct Vert {
	vec4 posInWorld;
	vec4 color;
	vec3 normalInWorld;
};

flat in int cameraIndex[];
in float noiseFactor[];
in Vert vVert[];

out Vert oVert;
flat out int camIndex;

void main() {

	float noiseMean = 0.;
	for (int i = 0; i < gl_in.length(); i++) {
		noiseMean += noiseFactor[i];
	}
	noiseMean /= gl_in.length();

	for (int i = 0; i < gl_in.length(); i++) {
		gl_Position = uTDMats[cameraIndex[i]].proj * uTDMats[cameraIndex[i]].cam * (vVert[i].posInWorld + vec4(vVert[i].normalInWorld * noiseMean, 0.));

		camIndex = cameraIndex[i];
		oVert = vVert[i];
		EmitVertex();
	}
	EndPrimitive();
}
