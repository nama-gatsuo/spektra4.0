struct Vert {
	vec4 posInWorld;
	vec4 color;
	vec3 normalInWorld;
	vec3 bc;
};
in Vert oVert;

in float oNoiseFactor;
flat in int camIndex;

out vec4 fragColor;

vec3 calcFlatNormal(vec3 p){
	vec3 dx = dFdx(p);
	vec3 dy = dFdy(p);
	vec3 n = normalize(cross(normalize(dx), normalize(dy)));

	return n;
}

void main() {
	TDCheckDiscard();

	if (any(lessThan(mod(oVert.bc, vec3(.5)), vec3(0.1 + oNoiseFactor * 2.)))) {
		vec3 p = oVert.posInWorld.xyz;
		vec3 n = calcFlatNormal(p);

		vec4 outcol = vec4(0.);
		vec3 diffuseSum = vec3(0.);
		vec3 specularSum = vec3(0.);
		// camera position - fragment position in world space
		vec3 viewVec = normalize(uTDMats[camIndex].camInverse[3].xyz - p);

		for (int i = 0; i < TD_NUM_LIGHTS; i++) {
			vec3 diffuseContrib = vec3(0);
			vec3 specularContrib = vec3(0);

			TDLighting(diffuseContrib,specularContrib,i,p,n,1.,vec3(0.5),viewVec,3.9);

			diffuseSum += diffuseContrib;
			specularSum += specularContrib;
		}

		vec3 specular = vec3(1.);
		vec4 diffuse = vec4(0.4,0.5,.6,1.);
		vec3 ambient = vec3(0.4);

		outcol.rgb = diffuseSum * diffuse.rgb * oVert.color.rgb;
		outcol.rgb += specularSum * specular;
		outcol.rgb += uTDGeneral.ambientColor.rgb * ambient * oVert.color.rgb;

		outcol = TDDither(outcol);
		float alpha = diffuse.a * oVert.color.a;
		outcol.rgb *= alpha;
		outcol.a = alpha;

		TDAlphaTest(alpha);
		fragColor = TDOutputSwizzle(outcol);
		} else {
			discard;
		}

	}
