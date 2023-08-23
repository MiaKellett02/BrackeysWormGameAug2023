Shader "Shader Graphs/Trail Test"
{
    Properties
    {
        _Color("Color", Color) = (0, 0, 0, 0)
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue"="Transparent"
            // DisableBatching: <None>
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalSpriteUnlitSubTarget"
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        
          Stencil
          {
              Ref 1
              WriteMask 255
              Comp Greater
              Pass Replace
          }

        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITEUNLIT
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 positionWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Floor_float2(float2 In, out float2 Out)
        {
            Out = floor(In);
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float
        {
        };
        
        void SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float(float3 _UV, float _PixelSize, float _Scale, Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float IN, out float3 UV_Out_0)
        {
        float3 _Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3 = _UV;
        float2 _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2);
        float _Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float = _PixelSize;
        float _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float = _Scale;
        float _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float;
        Unity_Multiply_float_float(_Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float, _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float, _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float);
        float2 _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2;
        Unity_Multiply_float2_float2(_TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2);
        float2 _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2;
        Unity_Floor_float2(_Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2, _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2);
        float2 _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2;
        Unity_TilingAndOffset_float(_Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2, float2 (1, 1), float2 (0, 0), _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2);
        float2 _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2;
        Unity_Divide_float2(_TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2);
        UV_Out_0 = (float3(_Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2, 0.0));
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 Color_6b11a2ae28184a2d91950991225e4742 = IsGammaSpace() ? float4(1, 1, 1, 1) : float4(SRGBToLinear(float3(1, 1, 1)), 1);
            float _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float = 0.4;
            float _Float_baf1d56986154109b4e0906478bb4962_Out_0_Float = _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float;
            float4 _UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4.xy), float2 (1, 1), float2 (-0.5, -0.5), _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2);
            float Integer_2310c7ecfa5f4e949455f1dbd1032214 = 16;
            Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94;
            float3 _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3;
            SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float((float3(_TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2, 0.0)), Integer_2310c7ecfa5f4e949455f1dbd1032214, 1, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3);
            float _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float;
            Unity_Distance_float3(_PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3, float3(0, 0, 0), _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float);
            float _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float;
            Unity_Step_float(_Float_baf1d56986154109b4e0906478bb4962_Out_0_Float, _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float, _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float);
            float _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float;
            Unity_OneMinus_float(_Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float, _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float);
            float _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            Unity_Saturate_float(_OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float, _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float);
            float4 _Multiply_d76e3c8e27a34169b6f1aa7f247f3e4f_Out_2_Vector4;
            Unity_Multiply_float4_float4(Color_6b11a2ae28184a2d91950991225e4742, (_Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float.xxxx), _Multiply_d76e3c8e27a34169b6f1aa7f247f3e4f_Out_2_Vector4);
            surface.BaseColor = (_Multiply_d76e3c8e27a34169b6f1aa7f247f3e4f_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Floor_float2(float2 In, out float2 Out)
        {
            Out = floor(In);
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float
        {
        };
        
        void SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float(float3 _UV, float _PixelSize, float _Scale, Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float IN, out float3 UV_Out_0)
        {
        float3 _Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3 = _UV;
        float2 _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2);
        float _Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float = _PixelSize;
        float _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float = _Scale;
        float _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float;
        Unity_Multiply_float_float(_Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float, _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float, _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float);
        float2 _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2;
        Unity_Multiply_float2_float2(_TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2);
        float2 _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2;
        Unity_Floor_float2(_Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2, _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2);
        float2 _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2;
        Unity_TilingAndOffset_float(_Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2, float2 (1, 1), float2 (0, 0), _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2);
        float2 _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2;
        Unity_Divide_float2(_TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2);
        UV_Out_0 = (float3(_Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2, 0.0));
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float = 0.4;
            float _Float_baf1d56986154109b4e0906478bb4962_Out_0_Float = _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float;
            float4 _UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4.xy), float2 (1, 1), float2 (-0.5, -0.5), _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2);
            float Integer_2310c7ecfa5f4e949455f1dbd1032214 = 16;
            Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94;
            float3 _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3;
            SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float((float3(_TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2, 0.0)), Integer_2310c7ecfa5f4e949455f1dbd1032214, 1, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3);
            float _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float;
            Unity_Distance_float3(_PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3, float3(0, 0, 0), _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float);
            float _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float;
            Unity_Step_float(_Float_baf1d56986154109b4e0906478bb4962_Out_0_Float, _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float, _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float);
            float _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float;
            Unity_OneMinus_float(_Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float, _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float);
            float _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            Unity_Saturate_float(_OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float, _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float);
            surface.Alpha = _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Floor_float2(float2 In, out float2 Out)
        {
            Out = floor(In);
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float
        {
        };
        
        void SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float(float3 _UV, float _PixelSize, float _Scale, Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float IN, out float3 UV_Out_0)
        {
        float3 _Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3 = _UV;
        float2 _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2);
        float _Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float = _PixelSize;
        float _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float = _Scale;
        float _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float;
        Unity_Multiply_float_float(_Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float, _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float, _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float);
        float2 _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2;
        Unity_Multiply_float2_float2(_TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2);
        float2 _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2;
        Unity_Floor_float2(_Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2, _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2);
        float2 _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2;
        Unity_TilingAndOffset_float(_Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2, float2 (1, 1), float2 (0, 0), _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2);
        float2 _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2;
        Unity_Divide_float2(_TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2);
        UV_Out_0 = (float3(_Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2, 0.0));
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float = 0.4;
            float _Float_baf1d56986154109b4e0906478bb4962_Out_0_Float = _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float;
            float4 _UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4.xy), float2 (1, 1), float2 (-0.5, -0.5), _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2);
            float Integer_2310c7ecfa5f4e949455f1dbd1032214 = 16;
            Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94;
            float3 _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3;
            SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float((float3(_TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2, 0.0)), Integer_2310c7ecfa5f4e949455f1dbd1032214, 1, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3);
            float _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float;
            Unity_Distance_float3(_PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3, float3(0, 0, 0), _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float);
            float _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float;
            Unity_Step_float(_Float_baf1d56986154109b4e0906478bb4962_Out_0_Float, _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float, _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float);
            float _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float;
            Unity_OneMinus_float(_Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float, _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float);
            float _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            Unity_Saturate_float(_OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float, _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float);
            surface.Alpha = _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Sprite Unlit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma exclude_renderers d3d11_9x
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SPRITEFORWARD
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 positionWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Color;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Floor_float2(float2 In, out float2 Out)
        {
            Out = floor(In);
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float
        {
        };
        
        void SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float(float3 _UV, float _PixelSize, float _Scale, Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float IN, out float3 UV_Out_0)
        {
        float3 _Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3 = _UV;
        float2 _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Property_57af6502bacf404fbe743ec2f316fd3e_Out_0_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2);
        float _Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float = _PixelSize;
        float _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float = _Scale;
        float _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float;
        Unity_Multiply_float_float(_Property_7948586565894f8aaa3c39af28bf7525_Out_0_Float, _Property_532490ea4c864c878f1aad22ebd941fc_Out_0_Float, _Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float);
        float2 _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2;
        Unity_Multiply_float2_float2(_TilingAndOffset_64f8bc00df104267b442b8ab2ec10a54_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2);
        float2 _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2;
        Unity_Floor_float2(_Multiply_63660b4b62574d9facf1c797f70b7f57_Out_2_Vector2, _Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2);
        float2 _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2;
        Unity_TilingAndOffset_float(_Floor_fff320c1bb8b4989a7ce062e8be3d828_Out_1_Vector2, float2 (1, 1), float2 (0, 0), _TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2);
        float2 _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2;
        Unity_Divide_float2(_TilingAndOffset_2c7dccd968c04cfcaa1b3178cae2a4b2_Out_3_Vector2, (_Multiply_6970ffed27fa4f4287b1d749429b9738_Out_2_Float.xx), _Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2);
        UV_Out_0 = (float3(_Divide_31755f192bcd4022a824bc708864d924_Out_2_Vector2, 0.0));
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 Color_6b11a2ae28184a2d91950991225e4742 = IsGammaSpace() ? float4(1, 1, 1, 1) : float4(SRGBToLinear(float3(1, 1, 1)), 1);
            float _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float = 0.4;
            float _Float_baf1d56986154109b4e0906478bb4962_Out_0_Float = _Float_faf9ea62950e4c60a0db5a53af081ecf_Out_0_Float;
            float4 _UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4 = IN.uv0;
            float2 _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2;
            Unity_TilingAndOffset_float((_UV_9698acade7d04534b6f1640b229d063d_Out_0_Vector4.xy), float2 (1, 1), float2 (-0.5, -0.5), _TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2);
            float Integer_2310c7ecfa5f4e949455f1dbd1032214 = 16;
            Bindings_PixelateUV_87882df7c5a71384496e6b5d0d318257_float _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94;
            float3 _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3;
            SG_PixelateUV_87882df7c5a71384496e6b5d0d318257_float((float3(_TilingAndOffset_db390ca9a6e04ff1a499b9fd4aa08a72_Out_3_Vector2, 0.0)), Integer_2310c7ecfa5f4e949455f1dbd1032214, 1, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94, _PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3);
            float _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float;
            Unity_Distance_float3(_PixelateUV_e744c4b8f6c245868e1adf61b89b7c94_UVOut_0_Vector3, float3(0, 0, 0), _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float);
            float _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float;
            Unity_Step_float(_Float_baf1d56986154109b4e0906478bb4962_Out_0_Float, _Distance_1d918cbfa92a4a01869e1ebd59046910_Out_2_Float, _Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float);
            float _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float;
            Unity_OneMinus_float(_Step_24738dcb44d44610b2c8b952b3c15453_Out_2_Float, _OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float);
            float _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            Unity_Saturate_float(_OneMinus_452b2fd31af84ca78e92f108d8513899_Out_1_Float, _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float);
            float4 _Multiply_d76e3c8e27a34169b6f1aa7f247f3e4f_Out_2_Vector4;
            Unity_Multiply_float4_float4(Color_6b11a2ae28184a2d91950991225e4742, (_Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float.xxxx), _Multiply_d76e3c8e27a34169b6f1aa7f247f3e4f_Out_2_Vector4);
            surface.BaseColor = (_Multiply_d76e3c8e27a34169b6f1aa7f247f3e4f_Out_2_Vector4.xyz);
            surface.Alpha = _Saturate_d6c1848d58374873b1c7ceae0e3946b1_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/2D/ShaderGraph/Includes/SpriteUnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}