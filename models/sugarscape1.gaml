/**
* Name: sugarscape1
* Based on the internal empty template. 
* Author: Aline Santos
* Tags: 
*/
model sugarscape1

global {
	int vision <- 6;
	int nb_initial_ant <- 1;
	float metabolism <- 5.0;
	float max_energy <- 25.0;
	int nb_ant -> {length(ant)};
	float average_vision <- 6.0 update: calculate_average_vision();
	float average_metabolism <- 5.0 update: calculate_average_metabolism();
	float calculate_average_vision {
		float totalVision <- 0.0;
		ask ant {
			totalVision <- totalVision + vision_ant;
		}

		return totalVision / nb_ant;
	}

	float calculate_average_metabolism {
		float totalmetabolism <- 0.0;
		ask ant {
			totalmetabolism <- totalmetabolism + matabolism_ant;
		}

		return totalmetabolism / nb_ant;
	}

	csv_file arquivo <- csv_file("../includes/map.csv");

	init {
		create ant number: nb_initial_ant;
		matrix data <- matrix(arquivo);
		ask cell {
			grid_value <- float(data[grid_x, grid_y]);
			max_sugar <- grid_value;
			sugar <- grid_value;
		}

	}

}

species ant {
//cell espaco;
	int vision_ant min: 1 <- rnd(vision);
	cell my_cell <- one_of(cell);
	float matabolism_ant <- rnd(metabolism);
	float inicial_energy min: 5.0 <- rnd(max_energy);
	float energy min: 0.0 <- inicial_energy update: energy - matabolism_ant max: max_energy;

	init {
		location <- my_cell.location;
	}

	reflex basic_move {
		energy <- energy + my_cell.sugar;
		my_cell <- choose_cell();
		location <- my_cell.location;
	}

	cell choose_cell {
		list<cell> available_cells <- my_cell.neighbours[vision_ant] where (empty(ant inside (each)));
		cell cell_with_max_sugar <- available_cells with_max_of (each.sugar);
		if (cell_with_max_sugar.sugar > my_cell.sugar) {
			return cell_with_max_sugar;
		} else {
			return my_cell;
		}

	}

	aspect default {
		draw circle(1.0) color: #darkred;
		//draw string (energy with_precision 1 ) size: 3 color: #black;
	}

	reflex end_of_life when: (energy <= 0) {
		do die;
	}

}

grid cell width: 50 height: 50 neighbors: 4 {
	float max_sugar;
	float sugarGrowthRate <- 0.0;
	float sugar update: sugar + sugarGrowthRate max: max_sugar;
	map<int, list<cell>> neighbours;
	//list<cell> neighbours2 <- (self neighbors_at vision_ant );
	reflex updateColor {
		if (sugar = 1) {
			color <- rgb(250, 250, 210);
		} else if (sugar = 2) {
			color <- rgb(247, 246, 167);
		} else if (sugar = 3) {
			color <- rgb(243, 242, 126);
		} else if (sugar = 4) {
			color <- rgb(240, 241, 50);
		} else if (sugar = 0) {
			color <- rgb(254, 254, 251);
		} }

	init {
		loop i from: 1 to: vision {
			neighbours[i] <- self neighbors_at i;
		}

	} }

experiment simulation type: gui {
	parameter "Visão: " var: vision min: 1 max: 25 category: "Ant";
	parameter "Quantida formiga: " var: nb_initial_ant min: 1 max: 2500 category: "Ant";
	output {
		display display_grid {
			grid cell;
			species ant aspect: default;
		}

		display Population refresh: every(5 #cycles) type: 2d {
			chart "Population" type: series size: {1, 0.5} position: {0, 0} {
				data "Quantidade de Formigas" value: nb_ant color: #black;
			}

		}

		display Vision refresh: every(5 #cycles) type: 2d {
			chart "Vision" type: series size: {1, 0.5} position: {0, 0} {
				data "Média visão" value: average_vision color: #black;
			}

		}

		display Metabolism refresh: every(5 #cycles) type: 2d {
			chart "Metabolism" type: series size: {1, 0.5} position: {0, 0} {
				data "Média metabolismo" value: average_metabolism color: #black;
			}

		}

		monitor "Quantidade de formiga" value: nb_ant;
	}

}

