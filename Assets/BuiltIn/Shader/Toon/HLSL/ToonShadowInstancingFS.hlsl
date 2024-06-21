// File Generated by Assets/BuildShader.py - source: [ToonFS.d.hlsl : SHADOW,INSTANCING]
Texture2D uTexDiffuse : register(t0);
SamplerState uTexDiffuseSampler : register(s0);
Texture2D uTexRamp : register(t1);
SamplerState uTexRampSampler : register(s1);
Texture2DArray uShadowMap : register(t2);
SamplerState uShadowMapSampler : register(s2);
struct PS_INPUT
{
	float4 pos : SV_POSITION;
	float2 tex0 : TEXCOORD0;
	float3 worldNormal: WORLDNORMAL;
	float3 worldViewDir: WORLDVIEWDIR;
	float3 worldPos: WORLDPOSITION;
	float3 depth: DEPTH;
	float4 color: COLOR;
};
cbuffer cbPerFrame
{
	float4 uLightDirection;
	float4 uLightColor;
	float4 uShadowColor;
	float2 uWrapFactor;
	float3 uSpecular;
	float4 uSHConst[4];
	float3 uShadowDistance;
	float4x4 uShadowMatrix[3];
};
static const float gamma = 2.2;
static const float invGamma = 1.0 / 2.2;
float3 sRGB(float3 color)
{
	return pow(color, gamma);
}
float3 linearRGB(float3 color)
{
	return pow(color, invGamma);
}
float shadow(const float4 shadowCoord[3], const float shadowDistance[3], const float farDistance)
{
	int id = 0;
	float visible = 1.0;
	const float bias[3] = {0.0001, 0.0002, 0.0006};
	float depth = 0.0;
	float result = 0.0;
	if (farDistance < shadowDistance[0])
		id = 0;
	else if (farDistance < shadowDistance[1])
		id = 1;
	else if (farDistance < shadowDistance[2])
		id = 2;
	else
		return 1.0;
	float3 shadowUV = shadowCoord[id].xyz / shadowCoord[id].w;
	depth = shadowUV.z;
	depth -= bias[id];
	float2 uv = shadowUV.xy;
	float size = 1.0/2048;
	float2 off;
	float2 rand;
	const float2 kRandom1 = float2(12.9898,78.233);
	const float kRandom2 = 43758.5453;
	const float kRandom3 = 0.00047;
	{off = float2(-1, -1) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(0, -1) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(1, -1) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(-1, 0) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(0, 0) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(1, 0) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(-1, 1) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(0, 1) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	{off = float2(1, 1) * size;rand = uv + off;rand += (float2(frac(sin(dot(rand.xy, kRandom1)) * kRandom2), frac(sin(dot(rand.yx, kRandom1)) * kRandom2)) * kRandom3);result += (step(depth, uShadowMap.SampleLevel(uShadowMapSampler, float3(rand, id), 0).r));}
	return result / 9.0;
}
static const float PI = 3.1415926;
float4 main(PS_INPUT input) : SV_TARGET
{
	float4 diffuse = uTexDiffuse.Sample(uTexDiffuseSampler, input.tex0);
	float3 diffuseMap = sRGB(diffuse.rgb);
	float3 color = sRGB(input.color.rgb);
	float shadowIntensity = input.color.a;
	float3 shadowColor = sRGB(uShadowColor.rgb);
	float3 lightColor = sRGB(uLightColor.rgb);
	float visibility = 1.0;
	float depth = length(input.depth);
	float4 shadowCoord[3];
	shadowCoord[0] = mul(float4(input.worldPos, 1.0), uShadowMatrix[0]);
	shadowCoord[1] = mul(float4(input.worldPos, 1.0), uShadowMatrix[1]);
	shadowCoord[2] = mul(float4(input.worldPos, 1.0), uShadowMatrix[2]);
	float shadowDistance[3];
	shadowDistance[0] = uShadowDistance.x;
	shadowDistance[1] = uShadowDistance.y;
	shadowDistance[2] = uShadowDistance.z;
	visibility = shadow(shadowCoord, shadowDistance, depth);
	float3 ambientLighting = uSHConst[0].xyz +
		uSHConst[1].xyz * input.worldNormal.y +
		uSHConst[2].xyz * input.worldNormal.z +
		uSHConst[3].xyz * input.worldNormal.x;
	ambientLighting = sRGB(ambientLighting * 0.9);
	float NdotL = max((dot(input.worldNormal, uLightDirection.xyz) + uWrapFactor.x) / (1.0 + uWrapFactor.x), 0.0);
	float3 rampMap = uTexRamp.Sample(uTexRampSampler, float2(NdotL, NdotL)).rgb;
	float3 ramp = lerp(color, shadowColor, shadowIntensity * (1.0 - visibility));
	ramp = lerp(ramp, color, rampMap);
	float3 h = normalize(uLightDirection.xyz + input.worldViewDir);
	float NdotH = max(0, dot(input.worldNormal, h));
	float spec = pow(NdotH, uSpecular.x*128.0) * uSpecular.y;
	spec = smoothstep(0.5-uSpecular.z*0.5, 0.5+uSpecular.z*0.5, spec);
	return float4(diffuseMap * lightColor * ramp * (visibility * (1.0 - uWrapFactor.y)) + lightColor * spec * visibility + uWrapFactor.y * diffuseMap * ambientLighting / PI, diffuse.a);
}
