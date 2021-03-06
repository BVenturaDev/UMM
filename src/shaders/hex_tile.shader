shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;

// Border textures
uniform sampler2D b_d_l : hint_albedo;
uniform sampler2D b_d_r : hint_albedo;
uniform sampler2D b_l : hint_albedo;
uniform sampler2D b_r : hint_albedo;
uniform sampler2D b_u_l : hint_albedo;
uniform sampler2D b_u_r : hint_albedo;
// Border bools
uniform bool b_b_d_l = false;
uniform bool b_b_d_r = false;
uniform bool b_b_l = false;
uniform bool b_b_r = false;
uniform bool b_b_u_l = false;
uniform bool b_b_u_r = false;

uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
uniform vec4 highlight_color : hint_color;
uniform vec4 turn_used_color : hint_color;
uniform vec4 undergrowth_color : hint_color;
uniform vec4 enemy_undergrowth_color : hint_color;
uniform vec4 grayed_out_color: hint_color;
uniform float mix_amount = 0.75;
uniform bool is_highlighted = false;
uniform bool is_turn_used = false;
uniform bool is_undergrowth = false;
uniform bool is_enemy_undergrowth = false;
uniform bool is_grayed_out = false;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	
	// Enemy border highlights
	if (b_b_d_l == true) {
		albedo_tex *= texture(b_d_l, base_uv);
	}
	if (b_b_d_r == true) {
		albedo_tex *= texture(b_d_r, base_uv);
	}
	if (b_b_l == true) {
		albedo_tex *= texture(b_l, base_uv);
	}
	if (b_b_r == true) {
		albedo_tex *= texture(b_r, base_uv);
	}
	if (b_b_u_l == true) {
		albedo_tex *= texture(b_u_l, base_uv);
	}
	if (b_b_u_r == true) {
		albedo_tex *= texture(b_u_r, base_uv);
	}
	
	// Apply the tile highlights based on their bools
	if (is_highlighted == true) {
		albedo_tex += (highlight_color * mix_amount);
	}
	else if (is_turn_used == true) {
		albedo_tex *= turn_used_color;
	}
	else if (is_grayed_out == true) {
		albedo_tex = grayed_out_color
	}
	else if (is_undergrowth == true) {
		albedo_tex *= undergrowth_color;
	}
	else if (is_enemy_undergrowth == true) {
		albedo_tex *= enemy_undergrowth_color;
	}
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}