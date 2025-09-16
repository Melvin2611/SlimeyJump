shader_type canvas_item;

// Zugriff auf den Bildschirm
uniform sampler2D screen_tex : hint_screen_texture;

// Stärke einstellbar im Inspector
uniform float blur_size : hint_range(0.5, 20.0, 0.1) = 6.0; // Blur etwas verstärkt
uniform float darkness : hint_range(0.0, 1.0, 0.01) = 0.6; // Faktor für dunkler machen

void fragment() {
    vec2 pixel = blur_size * SCREEN_PIXEL_SIZE;
    vec4 col = vec4(0.0);

    // Verstärkter 4-Richtungs-Blur
    col += texture(screen_tex, SCREEN_UV + vec2(-pixel.x, 0.0)) * 0.3;
    col += texture(screen_tex, SCREEN_UV + vec2(pixel.x, 0.0)) * 0.3;
    col += texture(screen_tex, SCREEN_UV + vec2(0.0, -pixel.y)) * 0.3;
    col += texture(screen_tex, SCREEN_UV + vec2(0.0, pixel.y)) * 0.3;

    // Originalpixel einbeziehen, aber schwächer
    col += texture(screen_tex, SCREEN_UV) * 0.4;

    // Hintergrund dunkler machen
    col.rgb *= darkness;

    COLOR = col;
}
