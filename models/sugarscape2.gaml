/**
* Name: sugarscape1
* Based on the internal empty template. 
* Author: Aline Santos
* Tags: 
*/
model sugarscape1

global {
	//  definition of maximum values for some ant attributes
	int vision <- 6;
	int nb_initial_ant <- 400;
	int metabolism <-4;
	// A maximum energy value has been set to make the histogram graph work
	float max_energy <- 200.0;
	// counts the number of live ants
	int nb_ant -> {length(ant)};
	// calculates the averages of the specific characteristics of living agents
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
// Open and configure a CSV file
	csv_file arquivo <- csv_file("../includes/map.csv");
	init {
		create ant number: nb_initial_ant;
		matrix data <- matrix(arquivo);
		ask cell {
			grid_value <- float(data[grid_x, grid_y]);
			sugar <- grid_value;
		}
	}
}


species ant {
	// Sets the random values ​​of each agent's attributes
	int vision_ant min: 1 <- rnd(vision);
	cell my_cell <- one_of(cell);
	int matabolism_ant min: 1<- rnd(metabolism);
	float inicial_energy min: 5.0<- rnd(max_energy);
	// Updates energy quantity based on metabolic rates
	float energy min: 0.0 <- inicial_energy update: energy - matabolism_ant + my_cell.sugar max: max_energy;
	// agent movement
	init {
		location <- my_cell.location;
		my_cell <- choose_cell();
	}
	cell choose_cell {
		list<cell> available_cells <- my_cell.neighbours[vision_ant] where (empty(ant inside (each)));
		cell cell_with_max_sugar <- available_cells with_max_of (each.sugar);
		if (cell_with_max_sugar.sugar < my_cell.sugar or cell_with_max_sugar.sugar = my_cell.sugar) {
			return my_cell;
		} else {
			return cell_with_max_sugar;
			}
	}
	// appearance of agents
	aspect default {
		draw circle(1.0) color: #darkred;
	}
	// define the end of agents´ life
	reflex end_of_life when: (energy <= 0) {
		do die;
	}
}

	//setting the size and appearance of the grid
grid cell width: 50 height: 50 neighbors: 4 {
	float sugar;
	map<int, list<cell>> neighbours;
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
		} 
			}
		
		// A way to deal with neighbours bug
	init {
		loop i from: 1 to: vision {
			neighbours[i] <- self neighbors_at i;
		}
			}
				 }
	// Definition of graphs and the visual simulation represetation
experiment simulation type: gui {
	parameter "Max values of vision: " var: vision min: 1 max: 25 category: "Ant";
	parameter "Initial number of ants: " var: nb_initial_ant min: 1 max: 2500 category: "Ant";
	output {
		display display_grid {
			grid cell;
			species ant aspect: default;
		}
		
		 display "my_display" {
	    chart "my_chart" type: histogram {
		datalist (distribution_of(ant collect each.energy,10,0,200) at "legend") 
		    value:(distribution_of(ant collect each.energy,10,0,200) at "values");		
	    }
	}

		display Population refresh: every(5 #cycles) type: 2d {
			chart "Population" type: series size: {1, 0.5} position: {0, 0} {
				data "Number of ants" value: nb_ant color: #black;
			}
		}

		display Vision refresh: every(5 #cycles) type: 2d {
			chart "Vision" type: series size: {1, 0.5} position: {0, 0} {
				data "Vision average" value: average_vision color: #black;
			}
		}
		display Metabolism refresh: every(5 #cycles) type: 2d {
			chart "Metabolism" type: series size: {1, 0.5} position: {0, 0} {
				data "Metabolism average" value: average_metabolism color: #black;
			}
		}

		monitor "number of ant" value: nb_ant;
	}
}

