#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 lightMapColor;
in float pos;
in float isGui;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * ColorModulator;
    bool isEmoji = (color.rgb != vec3(1.0)); // changed all emoji white colors to be slightly non white
    float depth = pos;
    if (color.a < 0.05) { // if you only cut out alpha values of 0, some of the super transparent parts look ugly. best not to think about it.
        discard;
    }
    if (!isEmoji) {
        color *= vertexColor; // basically tint everything that isn't an emoji with what it would be tinted in vanilla
//                               book text                                                                                                       subtitle                                             mcpvp victory title  mcpvp action bars
//               chat text        & input       emoji selector      shown chat        cp chat text       cp shown chat         tooltips           & title            bossbar              tab           (idk what else)     (idk what else)      action bar      scoreboard
    } else if (depth == 50.0 || depth == 0.0 || depth == 350.0 || depth == 4250.0 || depth == 0.001 || depth == 4200.001 || depth == 400.0 || depth == 4000.0 || depth == 2000.0 || depth == 4400.0 || depth == 3000.004 || depth == 2800.0 || depth == 3800 || depth == 3600 ) { 
        if (depth != 0.0) { // as long as its not book text, input text, resource selection screen text, or emoji selection text
            color *= vec4(vec3(62.0/252.0), vertexColor.a) * lightMapColor; // darken it the vanilla text shadow amount
        }
    } else if (depth == 0.03) { // normal non shadow text for books, chat input, resource selection screen, and emoji selection screen
        discard;
    } else { // if it's not text shadow
        color.a *= vertexColor.a;
        color *= lightMapColor;
    }
    if (isGui != -1) { // if it's a sign
        // fake the transparency by mixing transparent colors with a dark version of themselves then making it opaque
        color.rgb = mix(color.rgb * vec3(5.0 / 6.0), color.rgb, color.a);
        color.a = 1.0;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}