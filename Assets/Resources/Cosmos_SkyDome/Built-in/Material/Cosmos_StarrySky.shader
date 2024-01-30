// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cosmos_StarrySky"
{
	Properties
	{
		_Sky("Sky", 2D) = "white" {}
		_StarShine("StarShine", 2D) = "white" {}
		_ShineMin("ShineMin", Range( 0 , 1)) = 0.6
		_ShineMax("ShineMax", Range( 0 , 1)) = 1
		_ShineSpeed("ShineSpeed", Range( 0 , 1)) = 0.4
		_ShootingStar("ShootingStar", 2D) = "white" {}
		_Shoot_Strength("Shoot_Strength", Range( 0 , 1)) = 0.4
		_Shoot_Speed("Shoot_Speed", Range( 0 , 1)) = 0.165
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Sky;
			uniform float4 _Sky_ST;
			uniform sampler2D _ShootingStar;
			uniform float _Shoot_Speed;
			uniform float _Shoot_Strength;
			uniform sampler2D _StarShine;
			uniform float4 _StarShine_ST;
			uniform float _ShineSpeed;
			uniform float _ShineMin;
			uniform float _ShineMax;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Sky = i.ase_texcoord1.xy * _Sky_ST.xy + _Sky_ST.zw;
				float mulTime35 = _Time.y * _Shoot_Speed;
				float smoothstepResult11 = smoothstep( i.ase_texcoord1.zw.y , ( 0.03 + i.ase_texcoord1.zw.y ) , (( 0.0 - 0.03 ) + (( 1.0 - frac( mulTime35 ) ) - 0.0) * (( 1.0 + 0.03 ) - ( 0.0 - 0.03 )) / (1.0 - 0.0)));
				float temp_output_14_0 = ( 1.0 - smoothstepResult11 );
				float2 uv_StarShine = i.ase_texcoord1.xy * _StarShine_ST.xy + _StarShine_ST.zw;
				float mulTime28 = _Time.y * _ShineSpeed;
				float2 texCoord21 = i.ase_texcoord1.xy * float2( 2,2 ) + float2( 0,0 );
				float2 panner23 = ( mulTime28 * float2( 1,0 ) + texCoord21);
				float simplePerlin2D25 = snoise( panner23 );
				
				
				finalColor = ( tex2D( _Sky, uv_Sky ) + ( tex2D( _ShootingStar, i.ase_texcoord1.zw ) * ( temp_output_14_0 - floor( temp_output_14_0 ) ) * _Shoot_Strength ) + ( tex2D( _StarShine, uv_StarShine ) * (_ShineMin + (simplePerlin2D25 - 0.0) * (_ShineMax - _ShineMin) / (1.0 - 0.0)) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18400
21;229;1030;730;2040.427;35.84041;1.286416;True;False
Node;AmplifyShaderEditor.RangedFloatNode;36;-1294.725,379.9322;Float;False;Property;_Shoot_Speed;Shoot_Speed;7;0;Create;True;0;0;False;0;False;0.165;0.1647059;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-1021.724,330.9322;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1112.47,528.8978;Float;False;Constant;_Shoot_Length;Shoot_Length;4;0;Create;True;0;0;False;0;False;0.03;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;37;-845.188,343.6281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-723.6091,526.0417;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-1058.489,673.1199;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-782.4905,824.3488;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-695.043,437.0366;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;22;-1793.865,68.46179;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;29;-1648.263,366.9077;Float;False;Property;_ShineSpeed;ShineSpeed;4;0;Create;True;0;0;False;0;False;0.4;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-587.2123,746.3228;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;8;-527.993,457.9235;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;11;-300.8409,573.2355;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-1459.263,366.9077;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1551.397,84.40497;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;24;-1482.263,230.9077;Float;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;14;-119.4404,565.498;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;23;-1256.761,162.0273;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1224.558,-63.88047;Float;False;Property;_ShineMax;ShineMax;3;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1229.295,11.21184;Float;False;Property;_ShineMin;ShineMin;2;0;Create;True;0;0;False;0;False;0.6;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;13;77.73531,665.8314;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;25;-1045.263,114.9077;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-958.1925,-242.3045;Inherit;True;Property;_StarShine;StarShine;1;0;Create;True;0;0;False;0;False;-1;None;bb262d4ba0d1e61429a55bad085945d6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;43.52847,460.8163;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-450.8894,246.8296;Float;False;Property;_Shoot_Strength;Shoot_Strength;6;0;Create;True;0;0;False;0;False;0.4;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-800.095,126.5901;Inherit;True;Property;_ShootingStar;ShootingStar;5;0;Create;True;0;0;False;0;False;-1;None;a2fa4359e33bf684b8e200a46bd4115b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;34;-640.4663,-67.77463;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-187.5593,119.4723;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-628.507,-393.1975;Inherit;True;Property;_Sky;Sky;0;0;Create;True;0;0;False;0;False;-1;None;e49cf4c481cbf2a4db67dfcd2c4c499e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-376.3463,-94.22885;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-53.23032,-145.8801;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;138.2474,-125.9248;Float;False;True;-1;2;ASEMaterialInspector;0;1;Cosmos_StarrySky;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;35;0;36;0
WireConnection;37;0;35;0
WireConnection;9;1;7;0
WireConnection;10;1;7;0
WireConnection;38;0;37;0
WireConnection;12;0;7;0
WireConnection;12;1;5;2
WireConnection;8;0;38;0
WireConnection;8;3;9;0
WireConnection;8;4;10;0
WireConnection;11;0;8;0
WireConnection;11;1;5;2
WireConnection;11;2;12;0
WireConnection;28;0;29;0
WireConnection;21;0;22;0
WireConnection;14;0;11;0
WireConnection;23;0;21;0
WireConnection;23;2;24;0
WireConnection;23;1;28;0
WireConnection;13;0;14;0
WireConnection;25;0;23;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;3;1;5;0
WireConnection;34;0;25;0
WireConnection;34;3;31;0
WireConnection;34;4;26;0
WireConnection;16;0;3;0
WireConnection;16;1;15;0
WireConnection;16;2;33;0
WireConnection;18;0;4;0
WireConnection;18;1;34;0
WireConnection;17;0;2;0
WireConnection;17;1;16;0
WireConnection;17;2;18;0
WireConnection;1;0;17;0
ASEEND*/
//CHKSM=CF30CFEDB27252698D9F5B14338909B8B1B514A4