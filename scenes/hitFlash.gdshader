shader_type canvas_item;


uniform float amount : hint_range(0, 1);
uniform vec4 hurtColor : source_color = vec4(1.0);

float lerp(float a, float b,float t){
	return  a + (b - a) * t;
}

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	
	vec4 adjustedColor = vec4(lerp(previous_color.r,hurtColor.r,amount), lerp(previous_color.g,hurtColor.g,amount), lerp(previous_color.b,hurtColor.b,amount), previous_color.a);
	
	
	COLOR = adjustedColor;
}


