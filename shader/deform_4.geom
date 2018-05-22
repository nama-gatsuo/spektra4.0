layout (triangles) in;
layout (triangle_strip) out;
layout (max_vertices = 27) out;

struct Vert {
	vec4 posInWorld;
	vec4 color;
	vec3 normalInWorld;
	vec3 bc; // bary centric
};

flat in int cameraIndex[];
in float noiseFactor[];
in Vert vVert[];

out Vert oVert;
out float oNoiseFactor;
flat out int camIndex;

void create(in vec3 v1, in vec3 v2, in vec3 v3){
	oVert.posInWorld = vec4(v1, 1.);
	oVert.bc = vec3(1.,0,0);
	gl_Position = uTDMats[0].proj * uTDMats[0].cam * vec4(v1, 1.);
	EmitVertex();

	oVert.posInWorld = vec4(v2, 1.);
	oVert.bc = vec3(0,1.,0);
	gl_Position = uTDMats[0].proj * uTDMats[0].cam * vec4(v2, 1.);
	EmitVertex();

	oVert.posInWorld = vec4(v3, 1.);
	oVert.bc = vec3(0,0,1.);
	gl_Position = uTDMats[0].proj * uTDMats[0].cam * vec4(v3, 1.);
	EmitVertex();

	EndPrimitive();
}

void sub2(in vec3 v1, in vec3 v2, in vec3 v3){

	vec3 center = (v1 + v2 + v3) / 3.;
	vec3 n = - normalize(cross(v2-v1, v3-v1)) * oNoiseFactor * .1;

	create(v1, n + center, v2);
	create(v2, n + center, v3);
	create(v3, n + center, v1);

}

void sub1(in vec3 v1, in vec3 v2, in vec3 v3){

	vec3 center = (v1 + v2 + v3) / 3.;
	vec3 n = - normalize(cross(v2-v1, v3-v1)) * oNoiseFactor * .2;

	sub2(v1, n + center, v2);
	sub2(v2, n + center, v3);
	sub2(v3, n + center, v1);

}

void main() {

	float noiseMean = 0.;

	vec3 normal = vec3(0.);
	for (int i = 0; i < gl_in.length(); i++) {
		noiseMean += noiseFactor[i];
		normal += vVert[i].normalInWorld;
	}
	noiseMean /= float(gl_in.length());
	normal /= gl_in.length();

	oNoiseFactor = noiseMean;
	oVert = vVert[0];
	camIndex = cameraIndex[0];

	sub1(vVert[0].posInWorld.xyz, vVert[1].posInWorld.xyz, vVert[2].posInWorld.xyz);

}
