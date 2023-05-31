struct PS_INPUT
{
	float4 pos : SV_POSITION;
	float3 worldNormal: WORLDNORMAL;
	float3 worldPosition: WORLDPOSITION;
	float3 tex0 : LIGHTMAP;
};

cbuffer cbPerFrame
{
	float4 uLightColor;
	float4 uLightDirection;
};

float4 main(PS_INPUT input) : SV_TARGET
{
	float NdotL = max(dot(input.worldNormal, uLightDirection.xyz), 0.0);
	float4 directionalLightColor = NdotL * uLightColor;
	return float4(directionalLightColor.rgb, 1.0);
}