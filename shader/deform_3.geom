layout (triangles) in;
layout (triangle_strip) out;
layout (max_vertices = 9) out;

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

void main() {

	float noiseMean = 0.;

	vec3 normal = vec3(0.);
	for (int i = 0; i < gl_in.length(); i++) {
		noiseMean += noiseFactor[i];
		normal += vVert[i].normalInWorld;
	}
	noiseMean /= gl_in.length();
	normal /= gl_in.length();

	oNoiseFactor = noiseMean;

	for (int i = 0; i < gl_in.length(); i++) {
		gl_Position = uTDMats[0].proj * uTDMats[0].cam * vVert[i].posInWorld;
		camIndex = cameraIndex[i];
		oVert = vVert[i];

		if (i == 0) {
			oVert.bc = vec3(1.,0,0);
			} else if (i == 1) {
				oVert.bc = vec3(0,1.,0);
				} else if (i == 2) {
					oVert.bc = vec3(0,0,1.);
				}

				EmitVertex();
			}

			EndPrimitive();


		}
