shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float distortion_strength : hint_range(0.0, 0.1) = 0.01;
uniform float speed : hint_range(0.1, 10.0) = 1.0;
uniform float noise_scale : hint_range(1.0, 50.0) = 10.0;
uniform float intensity_falloff : hint_range(0.0, 1.0) = 0.5; // Reduziert den Effekt nach oben/unten für "bodennahe" Hitze

// Einfache Hash-Noise-Funktion für Zufälligkeit
float hash(vec2 p) {
    p = fract(p * vec2(5.3983, 5.4427));
    p += dot(p.yx, p.xy + vec2(21.5351, 14.3137));
    return fract(p.x * p.y * 95.4337);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    float time = TIME * speed;
    
    // Noise-basierte Verzerrung berechnen
    float n1 = noise(uv * noise_scale + vec2(time * 0.5, time * 0.3));
    float n2 = noise(uv * noise_scale + vec2(time * 0.3, time * 0.5));
    
    vec2 distortion = vec2(n1 - 0.5, n2 - 0.5) * distortion_strength;
    
    // Falloff für intensiveren Effekt am Boden (optional, basierend auf y-Koordinate)
    float falloff = pow(1.0 - uv.y, intensity_falloff);
    distortion *= falloff;
    
    // Textur mit Verzerrung sampeln
    COLOR = texture(SCREEN_TEXTURE, uv + distortion);
}