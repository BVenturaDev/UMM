shader_type spatial;

render_mode blend_mix;
uniform float vertical_height = 0.0;
uniform float alpha = 0.0;
uniform vec4 albedo : hint_color;
uniform sampler2D tile_png : hint_albedo;
uniform vec2 uv1_scale;
uniform bool is_selected = true;

void vertex(){
	VERTEX.y += vertical_height;
	UV=UV*uv1_scale.xy;
}

void fragment(){
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(tile_png,base_uv);
	if(is_selected == false){
		ALPHA = alpha;
	}
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
}