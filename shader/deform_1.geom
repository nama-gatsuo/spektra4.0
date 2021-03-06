layout (triangles) in;
layout (triangle_strip) out;
layout (max_vertices = 9) out;

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

void createFace(in vec3 center, ivec2 i) {

	gl_Position = uTDMats[0].proj * uTDMats[0].cam * vVert[i.x].posInWorld;
	camIndex = cameraIndex[i.x];
	oVert = vVert[i.x];
	EmitVertex();

	gl_Position = uTDMats[0].proj * uTDMats[0].cam * vec4(center, 1.);
	oVert.posInWorld = vec4(center, 1.);
	EmitVertex();

	gl_Position = uTDMats[0].proj * uTDMats[0].cam * vVert[i.y].posInWorld;
	camIndex = cameraIndex[i.y];
	oVert = vVert[i.y];
	EmitVertex();

	EndPrimitive();
}

void main() {

	float noiseMean = 0.;
	vec3 center = vec3(0.);
	vec3 normal = vec3(0.);
	for (int i = 0; i < gl_in.length(); i++) {
		noiseMean += noiseFactor[i];
		center += vVert[i].posInWorld.xyz;
		normal += vVert[i].normalInWorld;
	}
	noiseMean /= gl_in.length();
	center /= gl_in.length();
	normal /= gl_in.length();

	center += normal * noiseMean * 0.4;

	createFace(center, ivec2(0,1));
	createFace(center, ivec2(1,2));
	createFace(center, ivec2(2,0));
	EndPrimitive();
}
