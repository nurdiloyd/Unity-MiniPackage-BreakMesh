// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "wine_dissolve"
{
	Properties
	{
		_FresnelScale("Fresnel Scale", Float) = 1
		_EmissionMultiplier("Emission Multiplier", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 6
		_Fresnel_color("Fresnel_color", Color) = (0.3773585,0.3773585,0.3773585,0)
		_CellScale("Cell Scale", Range( 0 , 5)) = 4.088258
		_CellSharpness("Cell Sharpness", Range( 0.01 , 1)) = 0.01
		_FresnelAmount("Fresnel Amount", Range( 0 , 1)) = 0
		_CellAmount("Cell Amount", Range( 0 , 1)) = 1
		_BaseColor("Base Color", Color) = (1,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Emission_Color_contribute("Emission_Color_contribute", Range( 0 , 1)) = 1
		_Float2("Float 2", Float) = 1
		_DissolveRange("Dissolve Range", Float) = 0.07
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0.4007607
		_DissolveColor("Dissolve Color", Color) = (1,0.5613208,0.5613208,0)
		_EmissionRange("Emission Range", Float) = 0.2
		_EmissionAmount("Emission Amount", Float) = 0
		_DissolveDisplace("Dissolve Displace", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _DissolveAmount;
		uniform float _DissolveRange;
		uniform float _Float2;
		uniform float _DissolveDisplace;
		uniform float4 _Fresnel_color;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _BaseColor;
		uniform float _Emission_Color_contribute;
		uniform float _CellSharpness;
		uniform float _CellScale;
		uniform float _CellAmount;
		uniform float _EmissionMultiplier;
		uniform float _FresnelAmount;
		uniform float _EmissionRange;
		uniform float4 _DissolveColor;
		uniform float _EmissionAmount;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float lerpResult134 = lerp( -1.0 , 2.0 , _DissolveAmount);
			float Dissolve135 = lerpResult134;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float smoothstepResult129 = smoothstep( Dissolve135 , ( Dissolve135 + _DissolveRange ) , ( _Float2 * abs( ase_vertex3Pos.x ) ));
			float clampResult126 = clamp( smoothstepResult129 , 0.0 , 1.0 );
			v.vertex.xyz += ( ( ase_vertexNormal * ( 1.0 - clampResult126 ) ) * _DissolveDisplace );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV32 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode32 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV32, _FresnelPower ) );
			float smoothstepResult44 = smoothstep( 0.01 , 0.11 , fresnelNode32);
			float4 temp_output_34_0 = ( _Fresnel_color * smoothstepResult44 );
			float Emission_Multiplier113 = _Emission_Color_contribute;
			float4 temp_output_33_0 = ( temp_output_34_0 + ( _BaseColor * ( 1.0 - Emission_Multiplier113 ) ) );
			float4 Diffuse54 = temp_output_33_0;
			o.Albedo = Diffuse54.rgb;
			float4 Albedo110 = _BaseColor;
			float4 temp_output_106_0 = ( Albedo110 * _Emission_Color_contribute );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult74 = dot( ase_worldNormal , ase_worldlightDir );
			float smoothstepResult81 = smoothstep( 1.0 , ( 1.0 - _CellSharpness ) , ( dotResult74 * _CellScale ));
			float4 Emission57 = ( temp_output_34_0 * _EmissionMultiplier );
			float4 temp_output_88_0 = ( ( ( 1.0 - smoothstepResult81 ) * _CellAmount ) + ( Emission57 * _FresnelAmount ) );
			float4 temp_cast_1 = (1.0).xxxx;
			float4 lerpResult99 = lerp( ( temp_output_88_0 + Emission57 ) , temp_cast_1 , temp_output_88_0);
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_cast_2 = (0.5).xxx;
			float lerpResult134 = lerp( -1.0 , 2.0 , _DissolveAmount);
			float Dissolve135 = lerpResult134;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult129 = smoothstep( Dissolve135 , ( Dissolve135 + _DissolveRange ) , ( _Float2 * abs( ase_vertex3Pos.x ) ));
			float clampResult126 = clamp( smoothstepResult129 , 0.0 , 1.0 );
			float3 temp_cast_3 = (clampResult126).xxx;
			o.Emission = ( ( ( temp_output_106_0 + lerpResult99 ) * ase_lightColor ) + ( ( saturate( ( 1.0 - ( ( distance( temp_cast_2 , temp_cast_3 ) - _EmissionRange ) / max( 0.0 , 1E-05 ) ) ) ) * _DissolveColor ) * _EmissionAmount ) ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = clampResult126;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2024;33;1685;774;-4503.409;507.5178;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;36;-1406.165,39.08712;Inherit;False;Property;_FresnelPower;Fresnel Power;2;0;Create;True;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1403.869,-36.49871;Inherit;False;Property;_FresnelScale;Fresnel Scale;0;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;32;-1157.396,-74.66151;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;15.16;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;62;1297.642,-1057.901;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;82;1236.94,-826.953;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;45;-923.7664,-309.7269;Inherit;False;Property;_Fresnel_color;Fresnel_color;3;0;Create;True;0;0;False;0;False;0.3773585,0.3773585,0.3773585,0;0.3773585,0.3773585,0.3773585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;44;-806.7316,22.31692;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;4968.222,-105.7856;Inherit;False;Property;_DissolveAmount;Dissolve Amount;13;0;Create;True;0;0;False;0;False;0.4007607;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1603.351,-411.0466;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;74;1540.768,-792.0029;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;1254.297,-650.2227;Inherit;False;Property;_CellScale;Cell Scale;4;0;Create;True;0;0;False;0;False;4.088258;1.679853;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-194.9485,32.87444;Inherit;True;Property;_EmissionMultiplier;Emission Multiplier;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-578.3167,-74.71841;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;84;1448.094,-538.0249;Inherit;False;Property;_CellSharpness;Cell Sharpness;5;0;Create;True;0;0;False;0;False;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;1893.368,-844.3062;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;134;5304.819,-151.6857;Inherit;False;3;0;FLOAT;-1;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;271.0287,-69.60459;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;1889.95,-563.5461;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;122;4990.202,-578.9154;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;81;2296.006,-787.6517;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.36;False;2;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;540.5894,-67.19176;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;5519.683,-127.7869;Inherit;False;Dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;3292.974,-730.91;Inherit;False;Property;_Emission_Color_contribute;Emission_Color_contribute;10;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;5456,-320;Inherit;False;Property;_DissolveRange;Dissolve Range;12;0;Create;True;0;0;False;0;False;0.07;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;127;5172.202,-567.9154;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;4903.804,-707.1156;Inherit;False;Property;_Float2;Float 2;11;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;5387.683,-467.7869;Inherit;False;135;Dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;120;2507.088,-750.0876;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;2139.59,-447.3733;Inherit;True;57;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;2279.227,-249.5705;Inherit;False;Property;_FresnelAmount;Fresnel Amount;6;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;2308.069,-573.6096;Inherit;False;Property;_CellAmount;Cell Amount;7;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;2650.511,-382.9327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;95;-1545.502,-471.3796;Inherit;False;Property;_BaseColor;Base Color;8;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;2634.487,-711.4379;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;5664,-336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;3676.01,-1091.317;Inherit;False;Emission_Multiplier;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;5318.202,-657.9154;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;129;5817.917,-503.2608;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;3295.219,-320.4683;Inherit;False;57;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;2862.725,-610.4011;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-1073.629,-554.5924;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1022.685,-707.5808;Inherit;False;113;Emission_Multiplier;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;3421.438,-568.6997;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;144;5753.704,-1192.284;Inherit;False;Property;_EmissionRange;Emission Range;15;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;5745.385,-1310.806;Inherit;False;Constant;_Float3;Float 3;14;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;115;-770.7383,-692.1241;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;3320.969,-978.1247;Inherit;True;110;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;2925.728,-227.5339;Inherit;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;126;6074.899,-613.6954;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;137;6019.332,-1317.481;Inherit;True;Color Mask;-1;;1;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.38;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;99;3781.755,-664.6686;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;142;6068.923,-1579.932;Inherit;False;Property;_DissolveColor;Dissolve Color;14;0;Create;True;0;0;False;0;False;1,0.5613208,0.5613208,0;1,0.5613208,0.5613208,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-574.4365,-447.9059;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;3656.065,-867.0294;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;117;4435.377,-966.989;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;6371.692,-1366.295;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;146;6381.704,-1014.284;Inherit;False;Property;_EmissionAmount;Emission Amount;16;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;147;6497.509,-483.688;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;149;6390.697,-434.2623;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-402.0706,-447.2412;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;4421.575,-854.9538;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;6690.393,-573.504;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;151;6831.51,-615.9849;Inherit;False;Property;_DissolveDisplace;Dissolve Displace;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-49.66076,-607.2598;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;4689.481,-865.3475;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;6473.704,-1299.284;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;4438.052,-470.142;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;100;2947.847,-357.6456;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;119;1880.487,-324.9879;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;4412.792,-1184.9;Inherit;True;54;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;6670.315,-1248.147;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;5261.551,-389.0856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;6685.725,-873.8419;Inherit;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;6981.577,-637.0878;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-122.5806,-278.6184;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;7311.796,-1012.289;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;wine_dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;2;39;0
WireConnection;32;3;36;0
WireConnection;44;0;32;0
WireConnection;74;0;62;0
WireConnection;74;1;82;0
WireConnection;34;0;45;0
WireConnection;34;1;44;0
WireConnection;86;0;74;0
WireConnection;86;1;87;0
WireConnection;134;2;133;0
WireConnection;48;0;34;0
WireConnection;48;1;38;0
WireConnection;85;0;83;0
WireConnection;85;1;84;0
WireConnection;81;0;86;0
WireConnection;81;1;83;0
WireConnection;81;2;85;0
WireConnection;57;0;48;0
WireConnection;135;0;134;0
WireConnection;127;0;122;1
WireConnection;120;0;81;0
WireConnection;90;0;56;0
WireConnection;90;1;91;0
WireConnection;89;0;120;0
WireConnection;89;1;92;0
WireConnection;132;0;136;0
WireConnection;132;1;130;0
WireConnection;113;0;108;0
WireConnection;123;0;125;0
WireConnection;123;1;127;0
WireConnection;129;0;123;0
WireConnection;129;1;136;0
WireConnection;129;2;132;0
WireConnection;88;0;89;0
WireConnection;88;1;90;0
WireConnection;110;0;95;0
WireConnection;105;0;88;0
WireConnection;105;1;104;0
WireConnection;115;0;114;0
WireConnection;126;0;129;0
WireConnection;137;1;126;0
WireConnection;137;3;139;0
WireConnection;137;4;144;0
WireConnection;99;0;105;0
WireConnection;99;1;101;0
WireConnection;99;2;88;0
WireConnection;116;0;95;0
WireConnection;116;1;115;0
WireConnection;106;0;55;0
WireConnection;106;1;108;0
WireConnection;141;0;137;0
WireConnection;141;1;142;0
WireConnection;147;0;126;0
WireConnection;33;0;34;0
WireConnection;33;1;116;0
WireConnection;111;0;106;0
WireConnection;111;1;99;0
WireConnection;148;0;149;0
WireConnection;148;1;147;0
WireConnection;54;0;33;0
WireConnection;118;0;111;0
WireConnection;118;1;117;0
WireConnection;145;0;141;0
WireConnection;145;1;146;0
WireConnection;102;0;99;0
WireConnection;102;1;106;0
WireConnection;140;0;118;0
WireConnection;140;1;145;0
WireConnection;128;1;125;0
WireConnection;150;0;148;0
WireConnection;150;1;151;0
WireConnection;46;0;33;0
WireConnection;46;1;34;0
WireConnection;0;0;112;0
WireConnection;0;2;140;0
WireConnection;0;4;96;0
WireConnection;0;9;126;0
WireConnection;0;11;150;0
ASEEND*/
//CHKSM=E39E80811887C10AAA6A16EAD7A1333B692B6324