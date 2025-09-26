shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 wind_velocity = vec2(0.5, 0.0); // Windgeschwindigkeit und -richtung in x- und y-Richtung
uniform float wind_strength = 0.03; // Stärke der Verzerrung
uniform float wind_frequency = 1.5; // Frequenz der Windbewegung
uniform float noise_scale = 2.0; // Skalierung des Noise für Zufälligkeit
uniform float center_strength = 0.4; // Reichweite und Stärke des Gradienten (0.2 = sanfter, 0.5 = schärfer)

// Einfache 2D-Noise-Funktion für Zufälligkeit
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Perlin-ähnlicher Noise für sanfte Übergänge
float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(random(i + vec2(0.0, 0.0)), random(i + vec2(1.0, 0.0)), u.x),
               mix(random(i + vec2(0.0, 1.0)), random(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Zeitbasierte Windanimation
    float time_factor = TIME * wind_frequency;
    
    // Noise für Zufälligkeit, skaliert mit Bildschirmposition und Zeit
    float noise_value = noise(uv * noise_scale + vec2(time_factor * wind_velocity.x, time_factor * wind_velocity.y));
    
    // Verzerrung basierend auf Windrichtung und Noise
    vec2 offset = wind_velocity * wind_strength * (0.5 + noise_value * 0.5);
    
    // Leichte Wellenbewegung hinzufügen
    offset += vec2(
        sin(time_factor + uv.y * 3.0) * wind_velocity.x * wind_strength * 0.2,
        cos(time_factor + uv.x * 3.0) * wind_velocity.y * wind_strength * 0.2
    );
    
    // Radialer Gradient: Verzerrung in der Mitte maximal, an den Rändern exakt null
    vec2 centered_uv = uv - 0.5; // Zentrierte UV-Koordinaten
    float distance_to_center = length(centered_uv); // Entfernung zur Mitte
    // Smoothstep für nahtlosen Übergang, erreicht exakt 0.0 am Rand
    float gradient_factor = smoothstep(0.5, 0.5 - center_strength * 0.5, distance_to_center);
    gradient_factor = pow(gradient_factor, 2.0); // Quadratischer Abfall für sanfteren Übergang
    
    // Verzerrung mit Gradienten multiplizieren
    offset *= gradient_factor;
    
    // Verzerrte UV-Koordinaten
    vec2 distorted_uv = uv + offset;
    
    // Farbe aus der Bildschirmtextur holen
    COLOR = texture(SCREEN_TEXTURE, distorted_uv);
}