// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Eole/URP/Tree Leaf"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_SecondWindSmoothstep("Wind Smoothstep", Vector) = (0,1,0,0)
		_FlattenVertexNormal("Flatten Vertex Normal", Range( 0 , 1)) = 1
		[HideInInspector][Toggle(_DEBUGWIND_ON)] _DebugWind("Debug Wind", Float) = 1
		[Toggle(_USETRANSLUCENCY_ON)] _UseTranslucency("UseTranslucency", Float) = 1
		_TranslucencyDirect("Direct", Range( 0 , 10)) = 2.5
		_TranslucencyShadows("Shadows", Range( 0 , 10)) = 5
		_TranslucencyDotViewPower("Dot View Power", Range( 1 , 1000)) = 85
		_ColorMapFadeContrast("Fade Hardness", Float) = 0
		_ColorMapBlendOffset("Fade Offset", Float) = 0
		[Toggle(_USECOLORMAP_ON)] _UseColormap("Use Colormap", Float) = 1
		_CrushBrightness("Crush Brightness", Range( 0 , 1)) = 0.5
		[Space(10)]_WindBrightness("Wind Brightness", Range( 0 , 2)) = 0.5
		[NoScaleOffset][SingleLineTexture]_BaseMap("Base Map", 2D) = "white" {}
		[NoScaleOffset][SingleLineTexture]_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Float) = 1
		_AlphaThreshold("Alpha Threshold", Range( 0 , 1)) = 0.5
		_VariantOffset("Variant Blend Offset", Float) = 0
		_VariantContrast("Variant Blend Hardness", Float) = 1
		[HDR]_MainBaseColor("Base Color", Color) = (0.1019608,0.3098039,0,0)
		[HDR]_VariantBaseColor("Variant Color", Color) = (0.7882353,0.8,0.4,0.2)
		_SimpleWindyYOffset("Windy Y Offset", Float) = -0.5
		_SimpleWindDisplacement("Displacement", Float) = 1
		_UseTreeBend("UseTreeBend", Float) = 0
		[Header(Mask)][Space(5)]_TreeBendMaskDistanceOffset("Distance Offset", Float) = 0.3
		_TreeBendMaskFalloff("Falloff", Float) = 3
		[Header(Frequency)][Space(5)]_TreeBendFrequency("Frequency", Float) = 0.15
		_TreeBendFrequencySpeed("Frequency Speed", Float) = 10
		[Header(Angle)][Space(5)]_TreeBendMinAngle("Min Angle (Rad)", Range( -3.14 , 3.14)) = -0.1745329
		_TreeBendMaxAngle("Max Angle (Rad)", Range( 0 , 3.14)) = 0.1745329
		_TreeBendFrequencyOffsetRandomn("Randomness", Float) = 0.2
		[HideInInspector][Toggle(_DEBUGDISABLEWINDDPO_ON)] _DebugDisableWindDPO("DebugDisableWindDPO", Float) = 1
		[Toggle(_WIND_SIMPLE)] _Wind_Simple("Use Wind (Simple)", Float) = 1
		_TurbulenceDisplacement("Displacement", Float) = 0.03
		_TurbulenceSmoothstepMax("Smoothstep", Range( 0 , 1)) = 1
		_TurbulenceSpeed("Speed", Float) = 0.2
		_TurbulenceFrequency("Frequency", Range( 0.01 , 10)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector][ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[HideInInspector][ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Lit" }

		Cull Off
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
		
			
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _FORWARD_PLUS

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma multi_compile_local_fragment __ _DEBUGWIND_ON
			#pragma shader_feature_local _USETRANSLUCENCY_ON
			#pragma shader_feature_local _USECOLORMAP_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;
			int DebugWind;
			int DebugWindTurbulence;
			sampler2D _NormalMap;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord8 = v.positionOS;
				o.ase_texcoord9.xy = v.texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normalOS = lerpResult3_g2558;
				v.tangentOS = v.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( v.normalOS, v.tangentOS );

				o.tSpace0 = float4( normalInput.normalWS, vertexInput.positionWS.x );
				o.tSpace1 = float4( normalInput.tangentWS, vertexInput.positionWS.y );
				o.tSpace2 = float4( normalInput.bitangentWS, vertexInput.positionWS.z );

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( vertexInput.positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.positionCS);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float In1_g3661 = ( IN.ase_texcoord8.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord9.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord8.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				float4 _translucency_inColor32_g3668 = temp_output_529_0_g3660;
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b );
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float3 temp_cast_2 = (ase_lightColor.a).xxx;
				float3 blendOpSrc15_g3668 = temp_cast_2;
				float3 blendOpDest15_g3668 = (_translucency_inColor32_g3668).rgb;
				float3 normalizeResult19_g3668 = normalize( ( _WorldSpaceCameraPos - WorldPosition ) );
				float dotResult20_g3668 = dot( normalizeResult19_g3668 , -_MainLightPosition.xyz );
				float saferPower25_g3668 = abs( ( ( dotResult20_g3668 + 1.0 ) / 2.0 ) );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float lerpResult3_g3668 = lerp( _TranslucencyShadows , _TranslucencyDirect , ase_lightAtten);
				float3 lerpBlendMode15_g3668 = lerp(blendOpDest15_g3668,2.0f*blendOpDest15_g3668*blendOpSrc15_g3668 + blendOpDest15_g3668*blendOpDest15_g3668*(1.0f - 2.0f*blendOpSrc15_g3668),( saturate( pow( saferPower25_g3668 , _TranslucencyDotViewPower ) ) * lerpResult3_g3668 ));
				float4 appendResult30_g3668 = (float4(( saturate( lerpBlendMode15_g3668 )) , (_translucency_inColor32_g3668).a));
				#ifdef _USETRANSLUCENCY_ON
				float4 staticSwitch31_g3668 = appendResult30_g3668;
				#else
				float4 staticSwitch31_g3668 = _translucency_inColor32_g3668;
				#endif
				float4 albedo109_g3669 = staticSwitch31_g3668;
				int isDebugWind98_g3669 = ( DebugWind + DebugWindTurbulence );
				int debugWindTurbulence103_g3669 = DebugWindTurbulence;
				int debugWind105_g3669 = DebugWind;
				half4 color126_g3669 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
				Gradient gradient82_g3669 = NewGradient( 0, 7, 2, float4( 0.5, 0.5, 0.5, 0 ), float4( 0, 0.716, 0, 0.06471352 ), float4( 1, 1, 0, 0.2205844 ), float4( 1, 0.5698085, 0, 0.5470665 ), float4( 1, 0.3047979, 0, 0.7499962 ), float4( 1, 0, 0, 0.9411765 ), float4( 0.5626073, 0, 1, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float4 temp_output_106_0_g3669 = ( (float)debugWind105_g3669 == 1.0 ? SampleGradient( gradient82_g3669, windMask397_g3660 ) : albedo109_g3669 );
				float4 ifLocalVar131_g3669 = 0;
				if( debugWindTurbulence103_g3669 <= debugWind105_g3669 )
				ifLocalVar131_g3669 = temp_output_106_0_g3669;
				else
				ifLocalVar131_g3669 = color126_g3669;
				half4 color64_g3669 = IsGammaSpace() ? half4(1,1,1,0) : half4(1,1,1,0);
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + IN.ase_texcoord8.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * IN.ase_texcoord9.xy.y );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float temp_output_544_85_g3670 = ( temp_output_99_0_g3674 * temp_output_153_0_g3674 );
				#ifdef _WIND_SIMPLE
				float staticSwitch442_g3670 = temp_output_544_85_g3670;
				#else
				float staticSwitch442_g3670 = 0.0;
				#endif
				float4 lerpResult62_g3669 = lerp( ifLocalVar131_g3669 , color64_g3669 , ( (float)debugWindTurbulence103_g3669 == 1.0 ? saturate( ( staticSwitch442_g3670 * 20.0 ) ) : 0.0 ));
				#ifdef _DEBUGWIND_ON
				float4 staticSwitch134_g3669 = ( (float)isDebugWind98_g3669 >= 1.0 ? lerpResult62_g3669 : albedo109_g3669 );
				#else
				float4 staticSwitch134_g3669 = albedo109_g3669;
				#endif
				
				float2 uv_NormalMap71_g3660 = IN.ase_texcoord9.xy;
				float3 unpack71_g3660 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap71_g3660 ), _NormalStrength );
				unpack71_g3660.z = lerp( 1, unpack71_g3660.z, saturate(_NormalStrength) );
				float3 lerpResult417_g3660 = lerp( half3(0,0,1) , unpack71_g3660 , saturate( ( coord_mask88_g3660 * 3.0 ) ));
				

				float3 BaseColor = (staticSwitch134_g3669).xyz;
				float3 Normal = lerpResult417_g3660;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.0;
				float Occlusion = 1;
				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.positionCS.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.positionCS, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma shader_feature_local _USECOLORMAP_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 positionWS : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD2;
				#endif				
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			

			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.ase_texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord3 = v.positionOS;
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;

				float3 positionWS = TransformObjectToWorld( v.positionOS.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.normalOS);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
				#else
					positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float In1_g3661 = ( IN.ase_texcoord3.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord4.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord3.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				

				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma shader_feature_local _USECOLORMAP_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 positionWS : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.ase_texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord3 = v.positionOS;
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = vertexInput.positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float In1_g3661 = ( IN.ase_texcoord3.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord4.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord3.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				

				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma multi_compile_local_fragment __ _DEBUGWIND_ON
			#pragma shader_feature_local _USETRANSLUCENCY_ON
			#pragma shader_feature_local _USECOLORMAP_ON
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ _FORWARD_PLUS


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 positionWS : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;
			int DebugWind;
			int DebugWindTurbulence;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.texcoord0.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord4 = v.positionOS;
				o.ase_texcoord5.xy = v.texcoord0.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;

				float3 positionWS = TransformObjectToWorld( v.positionOS.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = positionWS;
				#endif

				o.positionCS = MetaVertexPosition( v.positionOS, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.positionOS.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float In1_g3661 = ( IN.ase_texcoord4.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord5.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord4.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				float4 _translucency_inColor32_g3668 = temp_output_529_0_g3660;
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b );
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float3 temp_cast_2 = (ase_lightColor.a).xxx;
				float3 blendOpSrc15_g3668 = temp_cast_2;
				float3 blendOpDest15_g3668 = (_translucency_inColor32_g3668).rgb;
				float3 normalizeResult19_g3668 = normalize( ( _WorldSpaceCameraPos - WorldPosition ) );
				float dotResult20_g3668 = dot( normalizeResult19_g3668 , -_MainLightPosition.xyz );
				float saferPower25_g3668 = abs( ( ( dotResult20_g3668 + 1.0 ) / 2.0 ) );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float lerpResult3_g3668 = lerp( _TranslucencyShadows , _TranslucencyDirect , ase_lightAtten);
				float3 lerpBlendMode15_g3668 = lerp(blendOpDest15_g3668,2.0f*blendOpDest15_g3668*blendOpSrc15_g3668 + blendOpDest15_g3668*blendOpDest15_g3668*(1.0f - 2.0f*blendOpSrc15_g3668),( saturate( pow( saferPower25_g3668 , _TranslucencyDotViewPower ) ) * lerpResult3_g3668 ));
				float4 appendResult30_g3668 = (float4(( saturate( lerpBlendMode15_g3668 )) , (_translucency_inColor32_g3668).a));
				#ifdef _USETRANSLUCENCY_ON
				float4 staticSwitch31_g3668 = appendResult30_g3668;
				#else
				float4 staticSwitch31_g3668 = _translucency_inColor32_g3668;
				#endif
				float4 albedo109_g3669 = staticSwitch31_g3668;
				int isDebugWind98_g3669 = ( DebugWind + DebugWindTurbulence );
				int debugWindTurbulence103_g3669 = DebugWindTurbulence;
				int debugWind105_g3669 = DebugWind;
				half4 color126_g3669 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
				Gradient gradient82_g3669 = NewGradient( 0, 7, 2, float4( 0.5, 0.5, 0.5, 0 ), float4( 0, 0.716, 0, 0.06471352 ), float4( 1, 1, 0, 0.2205844 ), float4( 1, 0.5698085, 0, 0.5470665 ), float4( 1, 0.3047979, 0, 0.7499962 ), float4( 1, 0, 0, 0.9411765 ), float4( 0.5626073, 0, 1, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float4 temp_output_106_0_g3669 = ( (float)debugWind105_g3669 == 1.0 ? SampleGradient( gradient82_g3669, windMask397_g3660 ) : albedo109_g3669 );
				float4 ifLocalVar131_g3669 = 0;
				if( debugWindTurbulence103_g3669 <= debugWind105_g3669 )
				ifLocalVar131_g3669 = temp_output_106_0_g3669;
				else
				ifLocalVar131_g3669 = color126_g3669;
				half4 color64_g3669 = IsGammaSpace() ? half4(1,1,1,0) : half4(1,1,1,0);
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + IN.ase_texcoord4.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * IN.ase_texcoord5.xy.y );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float temp_output_544_85_g3670 = ( temp_output_99_0_g3674 * temp_output_153_0_g3674 );
				#ifdef _WIND_SIMPLE
				float staticSwitch442_g3670 = temp_output_544_85_g3670;
				#else
				float staticSwitch442_g3670 = 0.0;
				#endif
				float4 lerpResult62_g3669 = lerp( ifLocalVar131_g3669 , color64_g3669 , ( (float)debugWindTurbulence103_g3669 == 1.0 ? saturate( ( staticSwitch442_g3670 * 20.0 ) ) : 0.0 ));
				#ifdef _DEBUGWIND_ON
				float4 staticSwitch134_g3669 = ( (float)isDebugWind98_g3669 >= 1.0 ? lerpResult62_g3669 : albedo109_g3669 );
				#else
				float4 staticSwitch134_g3669 = albedo109_g3669;
				#endif
				

				float3 BaseColor = (staticSwitch134_g3669).xyz;
				float3 Emission = 0;
				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma multi_compile_local_fragment __ _DEBUGWIND_ON
			#pragma shader_feature_local _USETRANSLUCENCY_ON
			#pragma shader_feature_local _USECOLORMAP_ON
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ _FORWARD_PLUS


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 positionWS : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;
			int DebugWind;
			int DebugWindTurbulence;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.ase_texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord2 = v.positionOS;
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = vertexInput.positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float In1_g3661 = ( IN.ase_texcoord2.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord3.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				float4 _translucency_inColor32_g3668 = temp_output_529_0_g3660;
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b );
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float3 temp_cast_2 = (ase_lightColor.a).xxx;
				float3 blendOpSrc15_g3668 = temp_cast_2;
				float3 blendOpDest15_g3668 = (_translucency_inColor32_g3668).rgb;
				float3 normalizeResult19_g3668 = normalize( ( _WorldSpaceCameraPos - WorldPosition ) );
				float dotResult20_g3668 = dot( normalizeResult19_g3668 , -_MainLightPosition.xyz );
				float saferPower25_g3668 = abs( ( ( dotResult20_g3668 + 1.0 ) / 2.0 ) );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float lerpResult3_g3668 = lerp( _TranslucencyShadows , _TranslucencyDirect , ase_lightAtten);
				float3 lerpBlendMode15_g3668 = lerp(blendOpDest15_g3668,2.0f*blendOpDest15_g3668*blendOpSrc15_g3668 + blendOpDest15_g3668*blendOpDest15_g3668*(1.0f - 2.0f*blendOpSrc15_g3668),( saturate( pow( saferPower25_g3668 , _TranslucencyDotViewPower ) ) * lerpResult3_g3668 ));
				float4 appendResult30_g3668 = (float4(( saturate( lerpBlendMode15_g3668 )) , (_translucency_inColor32_g3668).a));
				#ifdef _USETRANSLUCENCY_ON
				float4 staticSwitch31_g3668 = appendResult30_g3668;
				#else
				float4 staticSwitch31_g3668 = _translucency_inColor32_g3668;
				#endif
				float4 albedo109_g3669 = staticSwitch31_g3668;
				int isDebugWind98_g3669 = ( DebugWind + DebugWindTurbulence );
				int debugWindTurbulence103_g3669 = DebugWindTurbulence;
				int debugWind105_g3669 = DebugWind;
				half4 color126_g3669 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
				Gradient gradient82_g3669 = NewGradient( 0, 7, 2, float4( 0.5, 0.5, 0.5, 0 ), float4( 0, 0.716, 0, 0.06471352 ), float4( 1, 1, 0, 0.2205844 ), float4( 1, 0.5698085, 0, 0.5470665 ), float4( 1, 0.3047979, 0, 0.7499962 ), float4( 1, 0, 0, 0.9411765 ), float4( 0.5626073, 0, 1, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float4 temp_output_106_0_g3669 = ( (float)debugWind105_g3669 == 1.0 ? SampleGradient( gradient82_g3669, windMask397_g3660 ) : albedo109_g3669 );
				float4 ifLocalVar131_g3669 = 0;
				if( debugWindTurbulence103_g3669 <= debugWind105_g3669 )
				ifLocalVar131_g3669 = temp_output_106_0_g3669;
				else
				ifLocalVar131_g3669 = color126_g3669;
				half4 color64_g3669 = IsGammaSpace() ? half4(1,1,1,0) : half4(1,1,1,0);
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + IN.ase_texcoord2.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * IN.ase_texcoord3.xy.y );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float temp_output_544_85_g3670 = ( temp_output_99_0_g3674 * temp_output_153_0_g3674 );
				#ifdef _WIND_SIMPLE
				float staticSwitch442_g3670 = temp_output_544_85_g3670;
				#else
				float staticSwitch442_g3670 = 0.0;
				#endif
				float4 lerpResult62_g3669 = lerp( ifLocalVar131_g3669 , color64_g3669 , ( (float)debugWindTurbulence103_g3669 == 1.0 ? saturate( ( staticSwitch442_g3670 * 20.0 ) ) : 0.0 ));
				#ifdef _DEBUGWIND_ON
				float4 staticSwitch134_g3669 = ( (float)isDebugWind98_g3669 >= 1.0 ? lerpResult62_g3669 : albedo109_g3669 );
				#else
				float4 staticSwitch134_g3669 = albedo109_g3669;
				#endif
				

				float3 BaseColor = (staticSwitch134_g3669).xyz;
				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;

				half4 color = half4(BaseColor, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma shader_feature_local _USECOLORMAP_ON


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float4 worldTangent : TEXCOORD2;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 positionWS : TEXCOORD3;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD4;
				#endif
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_color : COLOR;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _NormalMap;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.ase_texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord5.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				o.ase_texcoord6 = v.positionOS;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;
				v.tangentOS = v.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				float3 normalWS = TransformObjectToWorldNormal( v.normalOS );
				float4 tangentWS = float4( TransformObjectToWorldDir( v.tangentOS.xyz ), v.tangentOS.w );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.positionWS = vertexInput.positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			void frag(	VertexOutput IN
						, out half4 outNormalWS : SV_Target0
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.positionWS;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_NormalMap71_g3660 = IN.ase_texcoord5.xy;
				float3 unpack71_g3660 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap71_g3660 ), _NormalStrength );
				unpack71_g3660.z = lerp( 1, unpack71_g3660.z, saturate(_NormalStrength) );
				float coord_mask88_g3660 = IN.ase_color.r;
				float3 lerpResult417_g3660 = lerp( half3(0,0,1) , unpack71_g3660 , saturate( ( coord_mask88_g3660 * 3.0 ) ));
				
				float In1_g3661 = ( IN.ase_texcoord6.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord5.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord6.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				

				float3 Normal = lerpResult417_g3660;
				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ DOTS_INSTANCING_ON
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
		
			
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif
			
			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#include "Packages/com.unity.shadergraph/ShaderGraphLibrary/Functions.hlsl"
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma multi_compile_local_fragment __ _DEBUGWIND_ON
			#pragma shader_feature_local _USETRANSLUCENCY_ON
			#pragma shader_feature_local _USECOLORMAP_ON
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _FORWARD_PLUS


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;
			int DebugWind;
			int DebugWindTurbulence;
			sampler2D _NormalMap;


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"

			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			
			float4 SampleGradient( Gradient gradient, float time )
			{
				float3 color = gradient.colors[0].rgb;
				UNITY_UNROLL
				for (int c = 1; c < 8; c++)
				{
				float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, gradient.colorsLength-1));
				color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
				}
				#ifndef UNITY_COLORSPACE_GAMMA
				color = SRGBToLinear(color);
				#endif
				float alpha = gradient.alphas[0].x;
				UNITY_UNROLL
				for (int a = 1; a < 8; a++)
				{
				float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, gradient.alphasLength-1));
				alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
				}
				return float4(color, alpha);
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord8 = v.positionOS;
				o.ase_texcoord9.xy = v.texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;
				v.tangentOS = v.tangentOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( v.normalOS, v.tangentOS );

				o.tSpace0 = float4( normalInput.normalWS, vertexInput.positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, vertexInput.positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, vertexInput.positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.positionCS = vertexInput.positionCS;
				o.clipPosV = vertexInput.positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.tangentOS = v.tangentOS;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.positionCS );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.positionCS);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float In1_g3661 = ( IN.ase_texcoord8.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord9.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (WorldPosition).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord8.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				float4 _translucency_inColor32_g3668 = temp_output_529_0_g3660;
				float ase_lightIntensity = max( max( _MainLightColor.r, _MainLightColor.g ), _MainLightColor.b );
				float4 ase_lightColor = float4( _MainLightColor.rgb / ase_lightIntensity, ase_lightIntensity );
				float3 temp_cast_2 = (ase_lightColor.a).xxx;
				float3 blendOpSrc15_g3668 = temp_cast_2;
				float3 blendOpDest15_g3668 = (_translucency_inColor32_g3668).rgb;
				float3 normalizeResult19_g3668 = normalize( ( _WorldSpaceCameraPos - WorldPosition ) );
				float dotResult20_g3668 = dot( normalizeResult19_g3668 , -_MainLightPosition.xyz );
				float saferPower25_g3668 = abs( ( ( dotResult20_g3668 + 1.0 ) / 2.0 ) );
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float lerpResult3_g3668 = lerp( _TranslucencyShadows , _TranslucencyDirect , ase_lightAtten);
				float3 lerpBlendMode15_g3668 = lerp(blendOpDest15_g3668,2.0f*blendOpDest15_g3668*blendOpSrc15_g3668 + blendOpDest15_g3668*blendOpDest15_g3668*(1.0f - 2.0f*blendOpSrc15_g3668),( saturate( pow( saferPower25_g3668 , _TranslucencyDotViewPower ) ) * lerpResult3_g3668 ));
				float4 appendResult30_g3668 = (float4(( saturate( lerpBlendMode15_g3668 )) , (_translucency_inColor32_g3668).a));
				#ifdef _USETRANSLUCENCY_ON
				float4 staticSwitch31_g3668 = appendResult30_g3668;
				#else
				float4 staticSwitch31_g3668 = _translucency_inColor32_g3668;
				#endif
				float4 albedo109_g3669 = staticSwitch31_g3668;
				int isDebugWind98_g3669 = ( DebugWind + DebugWindTurbulence );
				int debugWindTurbulence103_g3669 = DebugWindTurbulence;
				int debugWind105_g3669 = DebugWind;
				half4 color126_g3669 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
				Gradient gradient82_g3669 = NewGradient( 0, 7, 2, float4( 0.5, 0.5, 0.5, 0 ), float4( 0, 0.716, 0, 0.06471352 ), float4( 1, 1, 0, 0.2205844 ), float4( 1, 0.5698085, 0, 0.5470665 ), float4( 1, 0.3047979, 0, 0.7499962 ), float4( 1, 0, 0, 0.9411765 ), float4( 0.5626073, 0, 1, 1 ), 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
				float4 temp_output_106_0_g3669 = ( (float)debugWind105_g3669 == 1.0 ? SampleGradient( gradient82_g3669, windMask397_g3660 ) : albedo109_g3669 );
				float4 ifLocalVar131_g3669 = 0;
				if( debugWindTurbulence103_g3669 <= debugWind105_g3669 )
				ifLocalVar131_g3669 = temp_output_106_0_g3669;
				else
				ifLocalVar131_g3669 = color126_g3669;
				half4 color64_g3669 = IsGammaSpace() ? half4(1,1,1,0) : half4(1,1,1,0);
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + IN.ase_texcoord8.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * IN.ase_texcoord9.xy.y );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float temp_output_544_85_g3670 = ( temp_output_99_0_g3674 * temp_output_153_0_g3674 );
				#ifdef _WIND_SIMPLE
				float staticSwitch442_g3670 = temp_output_544_85_g3670;
				#else
				float staticSwitch442_g3670 = 0.0;
				#endif
				float4 lerpResult62_g3669 = lerp( ifLocalVar131_g3669 , color64_g3669 , ( (float)debugWindTurbulence103_g3669 == 1.0 ? saturate( ( staticSwitch442_g3670 * 20.0 ) ) : 0.0 ));
				#ifdef _DEBUGWIND_ON
				float4 staticSwitch134_g3669 = ( (float)isDebugWind98_g3669 >= 1.0 ? lerpResult62_g3669 : albedo109_g3669 );
				#else
				float4 staticSwitch134_g3669 = albedo109_g3669;
				#endif
				
				float2 uv_NormalMap71_g3660 = IN.ase_texcoord9.xy;
				float3 unpack71_g3660 = UnpackNormalScale( tex2D( _NormalMap, uv_NormalMap71_g3660 ), _NormalStrength );
				unpack71_g3660.z = lerp( 1, unpack71_g3660.z, saturate(_NormalStrength) );
				float3 lerpResult417_g3660 = lerp( half3(0,0,1) , unpack71_g3660 , saturate( ( coord_mask88_g3660 * 3.0 ) ));
				

				float3 BaseColor = (staticSwitch134_g3669).xyz;
				float3 Normal = lerpResult417_g3660;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = 0.0;
				float Occlusion = 1;
				float Alpha = (temp_output_529_0_g3660).a;
				float AlphaClipThreshold = _AlphaThreshold;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.positionCS;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.positionCS,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma shader_feature_local _USECOLORMAP_ON


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.ase_texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord2.xyz = ase_worldPos;
				
				o.ase_texcoord = v.positionOS;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;

				float3 positionWS = TransformObjectToWorld( v.positionOS.xyz );

				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float In1_g3661 = ( IN.ase_texcoord.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord1.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float3 ase_worldPos = IN.ase_texcoord2.xyz;
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (ase_worldPos).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				

				surfaceDescription.Alpha = (temp_output_529_0_g3660).a;
				surfaceDescription.AlphaClipThreshold = _AlphaThreshold;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			#define ASE_FOG 1
			#define _NORMAL_DROPOFF_TS 1
			#define _ALPHATEST_ON 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile_local __ _DEBUGDISABLEWINDDPO_ON
			#pragma shader_feature_local _WIND_SIMPLE
			#pragma shader_feature_local _USECOLORMAP_ON


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			half4 _VariantBaseColor;
			half4 _MainBaseColor;
			float2 _SecondWindSmoothstep;
			half _UseTreeBend;
			half _TranslucencyDirect;
			half _TranslucencyShadows;
			half _TranslucencyDotViewPower;
			half _CrushBrightness;
			half _WindBrightness;
			half _ColorMapFadeContrast;
			half _ColorMapBlendOffset;
			half _VariantContrast;
			half _VariantOffset;
			float _FlattenVertexNormal;
			half _TurbulenceDisplacement;
			half _TurbulenceFrequency;
			half _TurbulenceSpeed;
			half _TurbulenceSmoothstepMax;
			half _SimpleWindDisplacement;
			half _SimpleWindyYOffset;
			half _TreeBendMaxAngle;
			half _TreeBendMinAngle;
			half _TreeBendFrequencyOffsetRandomn;
			half _TreeBendFrequency;
			half _TreeBendFrequencySpeed;
			half _TreeBendMaskFalloff;
			half _TreeBendMaskDistanceOffset;
			half _NormalStrength;
			half _AlphaThreshold;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			float3 WindDirection;
			float WindOffsetSpeed;
			float WindTillingSize;
			half WindAmplitude;
			float2 WindSmoothstep;
			sampler2D WindMap;
			half DebugDisableWPO;
			sampler2D _BaseMap;
			sampler2D ColorMap;
			float2 ColorMapOffset;
			float2 ColorMapTillingSize;


			float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
			{
				original -= center;
				float C = cos( angle );
				float S = sin( angle );
				float t = 1 - C;
				float m00 = t * u.x * u.x + C;
				float m01 = t * u.x * u.y - S * u.z;
				float m02 = t * u.x * u.z + S * u.y;
				float m10 = t * u.x * u.y + S * u.z;
				float m11 = t * u.y * u.y + C;
				float m12 = t * u.y * u.z - S * u.x;
				float m20 = t * u.x * u.z - S * u.y;
				float m21 = t * u.y * u.z + S * u.x;
				float m22 = t * u.z * u.z + C;
				float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
				return mul( finalMatrix, original ) + center;
			}
			
			float CheapContrast1_g3661( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			
			float CheapContrast1_g3663( float In, float Value )
			{
				float A = 0 - Value;
				float B = 1 + Value;
				return clamp(0,1, lerp(A,B,In));
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 worldToObjDir141_g2754 = normalize( mul( GetWorldToObjectMatrix(), float4( WindDirection, 0 ) ).xyz );
				float3 wpo_wind_direction306_g3670 = worldToObjDir141_g2754;
				float _wind_amplitude116_g3677 = WindAmplitude;
				float3 ase_worldPos = TransformObjectToWorld( (v.positionOS).xyz );
				float3 worldToObj8_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 worldToObj43_g3676 = mul( GetWorldToObjectMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float mulTime45_g3676 = _TimeParameters.x * _TreeBendFrequencySpeed;
				float4 transform69_g3676 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float temp_output_4_0_g3676 = ( _wind_amplitude116_g3677 * saturate( ( ( worldToObj8_g3676.y - _TreeBendMaskDistanceOffset ) / _TreeBendMaskFalloff ) ) * (-_TreeBendMinAngle + (cos( ( ( ( worldToObj43_g3676.y + mulTime45_g3676 ) * _TreeBendFrequency ) + length( ( transform69_g3676 * _TreeBendFrequencyOffsetRandomn ) ) ) ) - -1.0) * (-_TreeBendMaxAngle - -_TreeBendMinAngle) / (1.0 - -1.0)) );
				float wpo_CoordMask184_g3670 = v.ase_color.r;
				half3 _RelativeUp = half3(0,1,0);
				float3 temp_output_26_0_g3673 = wpo_wind_direction306_g3670;
				float dotResult7_g3673 = dot( temp_output_26_0_g3673 , _RelativeUp );
				float lerpResult10_g3673 = lerp( -1.570796 , 1.570796 , ( ( dotResult7_g3673 * 0.5 ) + 0.5 ));
				float3 rotatedValue17_g3673 = RotateAroundAxis( float3( 0,0,0 ), temp_output_26_0_g3673, normalize( cross( _RelativeUp , temp_output_26_0_g3673 ) ), lerpResult10_g3673 );
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( v.positionOS.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2Dlod( WindMap, float4( ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ), 0, 0.0) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float wpo_wind_rawMask497_g3670 = temp_output_2250_0;
				float debug_disableWPO486_g3670 = DebugDisableWPO;
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float staticSwitch479_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? 0.0 : wpo_wind_rawMask497_g3670 );
				#else
				float staticSwitch479_g3670 = wpo_wind_rawMask497_g3670;
				#endif
				float wpo_wind_mask302_g3670 = staticSwitch479_g3670;
				float temp_output_25_0_g3673 = wpo_wind_mask302_g3670;
				float lerpResult21_g3673 = lerp( 0.0 , _SimpleWindyYOffset , temp_output_25_0_g3673);
				float3 appendResult23_g3673 = (float3(0.0 , lerpResult21_g3673 , 0.0));
				float3 temp_output_499_0_g3670 = ( wpo_CoordMask184_g3670 * ( ( rotatedValue17_g3673 + appendResult23_g3673 ) * _SimpleWindDisplacement * temp_output_25_0_g3673 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch425_g3670 = temp_output_499_0_g3670;
				#else
				float3 staticSwitch425_g3670 = float3( 0,0,0 );
				#endif
				float3 out_wpo_windy423_g3670 = staticSwitch425_g3670;
				float3 out_wpo_crush432_g3670 = out_wpo_windy423_g3670;
				float smoothstepResult112_g3674 = smoothstep( 0.0 , _TurbulenceSmoothstepMax , wpo_wind_rawMask497_g3670);
				float temp_output_153_0_g3674 = saturate( smoothstepResult112_g3674 );
				float4 transform119_g3674 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float mulTime95_g3674 = _TimeParameters.x * _TurbulenceSpeed;
				float3 ase_objectScale = float3( length( GetObjectToWorldMatrix()[ 0 ].xyz ), length( GetObjectToWorldMatrix()[ 1 ].xyz ), length( GetObjectToWorldMatrix()[ 2 ].xyz ) );
				float temp_output_99_0_g3674 = ( cos( ( ( ( ( ( transform119_g3674.x * 100.0 ) + ( transform119_g3674.z * 33.0 ) ) - mulTime95_g3674 ) + v.positionOS.xyz.y ) / _TurbulenceFrequency ) ) * _TurbulenceDisplacement * ase_objectScale.y * v.ase_texcoord.y );
				float3 temp_output_88_0_g3674 = wpo_wind_direction306_g3670;
				float3 temp_output_544_0_g3670 = ( out_wpo_crush432_g3670 + ( temp_output_153_0_g3674 * temp_output_99_0_g3674 * temp_output_88_0_g3674 ) );
				#ifdef _WIND_SIMPLE
				float3 staticSwitch440_g3670 = temp_output_544_0_g3670;
				#else
				float3 staticSwitch440_g3670 = float3( 0,0,0 );
				#endif
				float3 wpo_out_turbulence508_g3670 = staticSwitch440_g3670;
				float3 worldToObj35_g3676 = mul( GetWorldToObjectMatrix(), float4( ase_worldPos, 1 ) ).xyz;
				float3 rotatedValue2_g3676 = RotateAroundAxis( float3( 0,0,0 ), ( wpo_out_turbulence508_g3670 + worldToObj35_g3676 ), normalize( cross( wpo_wind_direction306_g3670 , float3( 0,1,0 ) ) ), temp_output_4_0_g3676 );
				#ifdef _DEBUGDISABLEWINDDPO_ON
				float3 staticSwitch466_g3670 = ( debug_disableWPO486_g3670 == 1.0 ? out_wpo_crush432_g3670 : ( rotatedValue2_g3676 - worldToObj35_g3676 ) );
				#else
				float3 staticSwitch466_g3670 = ( rotatedValue2_g3676 - worldToObj35_g3676 );
				#endif
				
				float3 lerpResult3_g2558 = lerp( v.normalOS , float3(0,1,0) , _FlattenVertexNormal);
				
				o.ase_texcoord2.xyz = ase_worldPos;
				
				o.ase_texcoord = v.positionOS;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = staticSwitch466_g3670;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				v.normalOS = lerpResult3_g2558;

				float3 positionWS = TransformObjectToWorld( v.positionOS.xyz );
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 normalOS : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.positionOS;
				o.normalOS = v.normalOS;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.positionOS = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.positionOS.xyz - patch[i].normalOS * (dot(o.positionOS.xyz, patch[i].normalOS) - dot(patch[i].vertex.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				o.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float In1_g3661 = ( IN.ase_texcoord.xyz.y + _VariantOffset );
				float Value1_g3661 = _VariantContrast;
				float localCheapContrast1_g3661 = CheapContrast1_g3661( In1_g3661 , Value1_g3661 );
				float4 lerpResult350_g3660 = lerp( _MainBaseColor , _VariantBaseColor , saturate( localCheapContrast1_g3661 ));
				float4 appendResult442_g3660 = (float4((lerpResult350_g3660).rgb , 1.0));
				float2 uv_BaseMap53_g3660 = IN.ase_texcoord1.xy;
				float4 tex2DNode53_g3660 = tex2D( _BaseMap, uv_BaseMap53_g3660 );
				float4 _baseMap50_g3660 = tex2DNode53_g3660;
				float4 temp_output_428_0_g3660 = ( appendResult442_g3660 * _baseMap50_g3660 );
				float4 temp_output_124_0_g3662 = temp_output_428_0_g3660;
				float3 temp_output_125_0_g3662 = (temp_output_124_0_g3662).rgb;
				float _colormap_baseMap_Alpha146_g3662 = (temp_output_124_0_g3662).a;
				float4 appendResult132_g3662 = (float4(temp_output_125_0_g3662 , _colormap_baseMap_Alpha146_g3662));
				float3 ase_worldPos = IN.ase_texcoord2.xyz;
				float coord_mask88_g3660 = IN.ase_color.r;
				float In1_g3663 = ( coord_mask88_g3660 - _ColorMapBlendOffset );
				float Value1_g3663 = _ColorMapFadeContrast;
				float localCheapContrast1_g3663 = CheapContrast1_g3663( In1_g3663 , Value1_g3663 );
				float3 lerpResult97_g3662 = lerp( (tex2D( ColorMap, ( ( (ase_worldPos).xz + ColorMapOffset ) / ColorMapTillingSize ) )).rgb , temp_output_125_0_g3662 , saturate( ( (lerpResult350_g3660).a * localCheapContrast1_g3663 ) ));
				float3 break65_g3662 = lerpResult97_g3662;
				float4 appendResult64_g3662 = (float4(break65_g3662.x , break65_g3662.y , break65_g3662.z , _colormap_baseMap_Alpha146_g3662));
				#ifdef _USECOLORMAP_ON
				float4 staticSwitch128_g3662 = appendResult64_g3662;
				#else
				float4 staticSwitch128_g3662 = appendResult132_g3662;
				#endif
				float4 temp_output_23_0_g3665 = staticSwitch128_g3662;
				float3 objToWorld183_g2754 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord.xyz, 1 ) ).xyz;
				float3 break153_g2754 = -objToWorld183_g2754;
				float2 appendResult155_g2754 = (float2(break153_g2754.x , break153_g2754.z));
				float2 _wind_UVs106_g2754 = appendResult155_g2754;
				float mulTime137_g2754 = _TimeParameters.x * ( WindOffsetSpeed / 10.0 );
				float3 break187_g2754 = WindDirection;
				float2 appendResult188_g2754 = (float2(break187_g2754.x , break187_g2754.z));
				float2 _wind_direction110_g2754 = appendResult188_g2754;
				float4 tex2DNode144_g2754 = tex2D( WindMap, ( ( _wind_UVs106_g2754 / WindTillingSize ) + ( mulTime137_g2754 * _wind_direction110_g2754 ) ) );
				float smoothstepResult53_g2754 = smoothstep( WindSmoothstep.x , WindSmoothstep.y , tex2DNode144_g2754.r);
				float smoothstepResult170_g2754 = smoothstep( _SecondWindSmoothstep.x , _SecondWindSmoothstep.y , smoothstepResult53_g2754);
				float _wind_amplitude116_g2754 = WindAmplitude;
				float temp_output_2250_0 = ( smoothstepResult170_g2754 * _wind_amplitude116_g2754 );
				float windMask397_g3660 = temp_output_2250_0;
				float lerpResult71_g3665 = lerp( 1.0 , _WindBrightness , windMask397_g3660);
				float lerpResult78_g3665 = lerp( lerpResult71_g3665 , _CrushBrightness , 0.0);
				float lerpResult83_g3665 = lerp( 1.0 , lerpResult78_g3665 , saturate( ( coord_mask88_g3660 * 2.0 ) ));
				float4 appendResult29_g3665 = (float4((saturate( ( temp_output_23_0_g3665 * lerpResult83_g3665 ) )).rgb , (temp_output_23_0_g3665).a));
				float4 temp_output_529_0_g3660 = appendResult29_g3665;
				

				surfaceDescription.Alpha = (temp_output_529_0_g3660).a;
				surfaceDescription.AlphaClipThreshold = _AlphaThreshold;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
						clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "EoleEditor.EoleShaderGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;275;-4704.417,1666.835;Inherit;False;1805.295;741.9374;Turbulence;21;360;359;358;357;356;354;353;311;310;309;308;307;306;305;304;303;302;301;300;299;298;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;278;-5493.687,1678.743;Inherit;False;830;358;dir mask;6;355;287;286;285;284;283;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;7;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;8;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;9;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.PowerNode;283;-5011.687,1856.743;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;284;-5262.887,1779.943;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,1,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;285;-5406.887,1779.943;Inherit;False;Property;_VectorUp;VectorUp;78;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;286;-5246.887,1939.943;Inherit;False;mask_falloff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-5374.887,1939.943;Inherit;False;Property;_Falloff;Falloff;76;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;298;-4058.962,2024.953;Inherit;False;Property;_FaceWindDir_YOffset;FaceWindDir_YOffset;82;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;299;-4112.419,2202.522;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;300;-3968.42,2202.522;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;-4250.98,2177.569;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;302;-4219.986,2292.771;Inherit;False;Property;_FaceWindDir_MaskFalloff;FaceWindDir_MaskFalloff;80;0;Create;True;0;0;0;False;0;False;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;303;-4478.417,2104.522;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;1,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;304;-4512.417,2253.522;Inherit;False;Property;_FaceWindDir_MaskOffset;FaceWindDir_MaskOffset;81;0;Create;True;0;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;305;-3348.693,1812.491;Inherit;False;World;Object;False;Fast;False;1;0;FLOAT3;0,1,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;306;-3476.694,1812.491;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-3061.124,1843.449;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;-4003.049,1807.114;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;309;-4221.784,1798.245;Inherit;False;Property;_Displacement;Displacement;77;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-4228.296,1716.835;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;353;-3355.544,2200.8;Inherit;False;Property;_TurbulenceAmplitude;Turbulence Amplitude;79;0;Create;True;0;0;0;False;0;False;0.1;0.081;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;356;-3799.728,1809.15;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;357;-3661.009,1807.844;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;360;-3730.644,2020.615;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;359;-3345.749,1983.984;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;310;-4226.26,1875.942;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;354;-4652.757,2104.522;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;358;-3332.643,2115.452;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;355;-4869.887,1850.943;Inherit;False;orientationMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-1056,-199;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-1246,-199;Float;False;True;-1;2;EoleEditor.EoleShaderGUI;0;12;Eole/URP/Tree Leaf;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;21;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;40;Workflow;1;0;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;0;638230317498301728;Fragment Normal Space,InvertActionOnDeselection;0;638230655385304850;Forward Only;0;638321175276553279;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;638230656084483976;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;638321167393435485;  Use Shadow Threshold;0;638247781250880195;GPU Instancing;1;0;LOD CrossFade;0;638310703111111206;Built-in Fog;1;0;_FinalColorxAlpha;0;638284217944558478;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;1;638385106186663958;Tessellation;0;638297056075012657;  Phong;0;0;  Strength;0.5,False,;0;  Type;1;638231173992364264;  Tess;16,False,;638246721166583659;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;638284286690914353;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.FunctionNode;2248;-1529.624,68.30841;Inherit;False;Flatten Vertex Normal;3;;2558;89489359c96a5cf41b0229f019cfd1c8;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;2250;-2223.625,-226.6916;Inherit;False;Wind System;0;;2754;04c8c7036a454954194d751ad91ea181;4,171,1,184,0,186,0,140,1;0;4;FLOAT;197;FLOAT;0;FLOAT;139;FLOAT3;24
Node;AmplifyShaderEditor.FunctionNode;2292;-1656.624,-203.6916;Inherit;False;Foliage Color & Shading;5;;3660;f4505f717c4abe64b899f0eb94054985;5,360,1,501,1,503,0,148,1,458,3;6;457;FLOAT;0;False;480;FLOAT;0;False;466;FLOAT;0;False;161;FLOAT;0;False;147;FLOAT;1;False;426;FLOAT;0;False;5;FLOAT3;0;FLOAT3;70;FLOAT;251;FLOAT;1;FLOAT;273
Node;AmplifyShaderEditor.FunctionNode;2290;-1993.624,-11.69159;Inherit;False;Foliage Vertex Offset;37;;3670;0fe3090401650924eb84218df3d02dc9;8,177,2,28,1,435,1,437,1,507,1,117,0,65,0,583,0;3;421;FLOAT;0;False;422;FLOAT3;0,0,0;False;176;FLOAT;1;False;3;FLOAT3;0;FLOAT;61;FLOAT;109
WireConnection;283;0;284;2
WireConnection;283;1;286;0
WireConnection;284;0;285;0
WireConnection;286;0;287;0
WireConnection;299;0;301;0
WireConnection;300;0;299;0
WireConnection;300;1;302;0
WireConnection;301;0;303;2
WireConnection;301;1;304;0
WireConnection;303;0;354;0
WireConnection;305;0;306;0
WireConnection;306;0;357;0
WireConnection;307;0;305;0
WireConnection;307;1;359;2
WireConnection;307;2;358;0
WireConnection;307;3;353;0
WireConnection;308;0;311;0
WireConnection;308;1;310;0
WireConnection;356;0;308;0
WireConnection;357;0;356;0
WireConnection;357;1;360;0
WireConnection;357;2;356;2
WireConnection;360;1;298;0
WireConnection;360;2;300;0
WireConnection;355;0;283;0
WireConnection;1;0;2292;0
WireConnection;1;1;2292;70
WireConnection;1;4;2292;251
WireConnection;1;6;2292;1
WireConnection;1;7;2292;273
WireConnection;1;8;2290;0
WireConnection;1;10;2248;0
WireConnection;2292;457;2250;0
WireConnection;2292;466;2290;61
WireConnection;2292;161;2290;109
WireConnection;2290;421;2250;0
WireConnection;2290;422;2250;24
ASEEND*/
//CHKSM=04D241F161FFDC4507F1AB32D5060C68B9705D14