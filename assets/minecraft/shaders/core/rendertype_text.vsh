#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec3 pos;
out vec4 lightMapColor;
out vec4 screenPos;

void main() {
    float alpha = texture(Sampler0, UV0).a;
    vec3 newPos = Position;
    if (ProjMat[3][0] != -1 && alpha < 1.0 && alpha > 0.0) {
        newPos += vec3(0.0, 2.0, 0.0);
    }
    gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);
    pos = Position;
    screenPos = ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    vertexColor = Color * lightMapColor;

    texCoord0 = UV0;
}
