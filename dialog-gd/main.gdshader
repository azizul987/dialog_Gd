shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture :
    hint_screen_texture,
    repeat_disable,
    filter_nearest;

uniform vec2 virtual_resolution = vec2(160.0, 144.0);
uniform float color_levels = 32.0;
uniform float contrast = 1.03;
uniform float saturation = 0.95;
uniform float brightness = 0.01;
uniform float dither_strength = 0.006;
const float BAYER_4X4[16] = float[16](
    0.0,  8.0,  2.0, 10.0,
    12.0, 4.0, 14.0,  6.0,
    3.0, 11.0,  1.0,  9.0,
    15.0, 7.0, 13.0,  5.0
);

float bayer4(vec2 p) {
    ivec2 ip = ivec2(mod(p, 4.0));
    return BAYER_4X4[ip.y * 4 + ip.x] / 16.0;
}

void fragment() {
    vec2 uv = SCREEN_UV;

    // Pixel snap
    vec2 pixel_pos = floor(uv * virtual_resolution);
    vec2 snapped_uv = (pixel_pos + 0.5) / virtual_resolution;
    vec3 col = texture(screen_texture, snapped_uv).rgb;

    // Brightness
    col += brightness;
    col = clamp(col, 0.0, 1.0);

    // Contrast
    col = (col - 0.5) * contrast + 0.5;
    col = clamp(col, 0.0, 1.0);

    // Saturation
    float gray = dot(col, vec3(0.299, 0.587, 0.114));
    col = mix(vec3(gray), col, saturation);
    col = clamp(col, 0.0, 1.0);

    // Dithering ringan (Bayer 4x4), bukan noise hijau-hijauan
    float d = (bayer4(pixel_pos) - 0.5) * dither_strength;
    col += vec3(d);
    col = clamp(col, 0.0, 1.0);

    // Color reduction ala game klasik
    // pakai (levels - 1) biar putih murni tetap kepake & banding lebih rata
    float levels = max(color_levels - 1.0, 1.0);
    col = round(col * levels) / levels;

    COLOR = vec4(col, 1.0);
}
