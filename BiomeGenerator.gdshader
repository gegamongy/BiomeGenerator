shader_type canvas_item;

uniform sampler2D rainfall_map;
uniform sampler2D humidity_map;

uniform bool display_biome_colors;
uniform int biome_weight_image = 0;

//Biome Colors
uniform vec3 lake_color = vec3(0, 0, 1); 
uniform vec3 swamp_color= vec3(0, 0.21, 0.21);
uniform vec3 wetlands_color = vec3(0, 0.55, 0.66);
uniform vec3 rainforest_color = vec3(0, 0.53, 0.23);
uniform vec3 dryforest_color = vec3(0.24, 0.35, 0);
uniform vec3 grasslands_color = vec3(0.74, 0.61, 0);
uniform vec3 tundra_color = vec3(0.9, 0.43, 0.38);
uniform vec3 desert_color = vec3(0.81, 0.38, 0);


uniform float hum_desert_tundra_flag = 0.22;
uniform float hum_tundra_grass_flag = 0.33;
uniform float hum_grass_dryf_flag = 0.55;
uniform float hum_dryf_rainf_flag = 0.77;
uniform float hum_wetland_swamp_flag = 0.55;
uniform float hum_swamp_lake_flag = 0.77;

uniform float rain_water_biome_flag = 0.77;

// Biome thresholds
uniform float desert_rf_min = 0.0;
uniform float desert_rf_max = 0.77;
uniform float desert_hum_min = 0.0;
uniform float desert_hum_max = 0.22;

uniform float tundra_rf_min = 0.0;
uniform float tundra_rf_max = 0.77;
uniform float tundra_hum_min = 0.22;
uniform float tundra_hum_max = 0.33;

uniform float grasslands_rf_min = 0.0;
uniform float grasslands_rf_max = 0.77;
uniform float grasslands_hum_min = 0.33;
uniform float grasslands_hum_max = 0.55;

uniform float dryforest_rf_min = 0.0;
uniform float dryforest_rf_max = 0.77;
uniform float dryforest_hum_min = 0.55;
uniform float dryforest_hum_max = 0.77;

uniform float rainforest_rf_min = 0.0;
uniform float rainforest_rf_max = 0.77;
uniform float rainforest_hum_min = 0.77;
uniform float rainforest_hum_max = 1.0;

uniform float wetlands_rf_min = 0.77;
uniform float wetlands_rf_max = 1.0;
uniform float wetlands_hum_min = 0.0;
uniform float wetlands_hum_max = 0.55;

uniform float swamp_rf_min = 0.77;
uniform float swamp_rf_max = 1.0;
uniform float swamp_hum_min = 0.55;
uniform float swamp_hum_max = 0.77;

uniform float lake_rf_min = 0.77;
uniform float lake_rf_max = 1.0;
uniform float lake_hum_min = 0.77;
uniform float lake_hum_max = 1.0;

uniform float blend_radius = 0.02;




void fragment(){
	
	float rainfall = texture(rainfall_map, UV).r;
	float humidity = texture(humidity_map, UV).r;
	
	vec3 colors[8] = vec3[8](
        desert_color, tundra_color, grasslands_color, dryforest_color, 
        rainforest_color, wetlands_color, swamp_color, lake_color
    );
    
	float min_rf[8] = float[8](
        desert_rf_min, tundra_rf_min, grasslands_rf_min, dryforest_rf_min,
        rainforest_rf_min, rain_water_biome_flag, rain_water_biome_flag, rain_water_biome_flag
    );
    
	float max_rf[8] = float[8](
        rain_water_biome_flag, rain_water_biome_flag, rain_water_biome_flag, rain_water_biome_flag,
        rain_water_biome_flag, wetlands_rf_max, swamp_rf_max, lake_rf_max
    );
    
	float min_hum[8] = float[8](
        desert_hum_min, hum_desert_tundra_flag, hum_tundra_grass_flag, hum_grass_dryf_flag,
       hum_dryf_rainf_flag, wetlands_hum_min, hum_wetland_swamp_flag, hum_swamp_lake_flag
    );
    
	float max_hum[8] = float[8](
        hum_desert_tundra_flag, hum_tundra_grass_flag, hum_grass_dryf_flag, hum_dryf_rainf_flag,
        rainforest_hum_max, hum_wetland_swamp_flag, hum_swamp_lake_flag, lake_hum_max
    );
	
	float weights[8];
	
	for (int i = 0; i < 8; i++) {
		
		float rf_weight = 0.0;
		float hum_weight = 0.0;
		
		if (rainfall < min_rf[i] - blend_radius || rainfall > max_rf[i] + blend_radius || humidity < min_hum[i] - blend_radius || humidity > max_hum[i] + blend_radius) {
			weights[i] = 0.0;
		} else {
			
			if (rainfall < min_rf[i]) {
				rf_weight = smoothstep(min_rf[i] - blend_radius, min_rf[i], rainfall);
			} else if (rainfall > max_rf[i]) {
				rf_weight = smoothstep(max_rf[i] + blend_radius, max_rf[i], rainfall);
			} else {
				rf_weight = 1.0;
			}
			
			if (humidity < min_hum[i]) {
                hum_weight = smoothstep(min_hum[i] - blend_radius, min_hum[i], humidity);
            } else if (humidity > max_hum[i]) {
                hum_weight = smoothstep(max_hum[i] + blend_radius, max_hum[i], humidity);
            } else {
                hum_weight = 1.0;
            }
			
			weights[i] = (rf_weight + hum_weight) / 2.0;
		}
	}
	
	//Normalize weights to a sum of 1.0
	float total_weight = 0.0;
	for (int i = 0; i < 8; i++) {
		total_weight += weights[i];
	}
	if (total_weight > 0.0) {
		for (int i = 0; i < 8; i++) {
			weights[i] /= total_weight;
		}
	}
	
	vec3 blended_color = vec3(0.0);
	for (int i = 0; i < 8; i++) {
		blended_color += colors[i] * weights[i];
	}
	
	vec3 biome_weights_0 = vec3(weights[0], weights[1], weights[2]);
	vec3 biome_weights_1 = vec3(weights[3], weights[4], weights[5]);
	vec3 biome_weights_2 = vec3(weights[6], weights[7], 0.0);
	
	
	if (display_biome_colors) {
		COLOR.rgb = blended_color;
	}
	else if (biome_weight_image == 0) {
		COLOR.rgb = biome_weights_0;
	}
	else if (biome_weight_image == 1) {
		COLOR.rgb = biome_weights_1;
	}
	else if (biome_weight_image == 2) {
		COLOR.rgb = biome_weights_2;
	}
	
	
}

