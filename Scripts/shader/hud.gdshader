shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;

// Einstellbare Parameter
uniform float blur_size : hint_range(0.5, 20.0, 0.1) = 6.0;       // Grundstärke des Blurs
uniform float darkness : hint_range(0.0, 1.0, 0.01) = 0.6;        // Abdunkelung
uniform float radial_strength : hint_range(-2.0, 2.0, 0.05) = 0.4; // Stärke des radialen Drifts
uniform float wobble_strength : hint_range(0.0, 2.0, 0.05) = 0.6;  // Stärke der Sinus-Wellenbewegung
uniform float time_speed : hint_range(0.0, 5.0, 0.1) = 1.2;        // Geschwindigkeit der Animation

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 pixel = SCREEN_PIXEL_SIZE * blur_size;
    vec2 center = vec2(0.5);
    vec2 dir = uv - center;

    // Radialer Drift (Atmungseffekt)
    float radial_offset = sin(TIME * time_speed) * 0.02 * radial_strength;
    uv += dir * radial_offset;

    // Sinus-Wobble-Offset basierend auf Bildschirmposition + Zeit
    float wobble_x = sin(uv.y * 30.0 + TIME * time_speed) * SCREEN_PIXEL_SIZE.x * wobble_strength * blur_size;
    float wobble_y = cos(uv.x * 30.0 + TIME * time_speed) * SCREEN_PIXEL_SIZE.y * wobble_strength * blur_size;

    // Blur mit Wobble-Offsets in mehrere Richtungen
    vec4 col = vec4(0.0);
    col += texture(screen_tex, uv + vec2(-pixel.x + wobble_x, 0.0 + wobble_y)) * 0.25;
    col += texture(screen_tex, uv + vec2(pixel.x + wobble_x, 0.0 - wobble_y)) * 0.25;
    col += texture(screen_tex, uv + vec2(0.0 + wobble_x, -pixel.y + wobble_y)) * 0.25;
    col += texture(screen_tex, uv + vec2(0.0 - wobble_x, pixel.y - wobble_y)) * 0.25;

    // Originalpixel leicht beigemischt
    col += texture(screen_tex, uv) * 0.4;

    // Abdunkelung
    col.rgb *= darkness;

    COLOR = col;
}
