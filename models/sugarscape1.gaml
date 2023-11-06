/**
* Name: sugarscape1
* Based on the internal empty template. 
* Author: Aline Santos
* Tags: 
*/
model sugarscape1

global {
		
	
	int vision <- 6;
	int nb_initial_ant <- 400;
	int metabolism <-4;
	int max_sugar <- 25;
	int nb_ant -> {length(ant)};
	float average_vision <- 6.0 update: calculate_average_vision();
	float average_metabolism <- 5.0 update: calculate_average_metabolism();
	
	float calculate_average_vision {
    float totalVision <- 0.0;
    ask ant {
        totalVision <- totalVision + vision_ant;
    }
    return totalVision /nb_ant;
}
   
   
   float calculate_average_metabolism {
    float totalmetabolism <- 0.0;
    ask ant {
        totalmetabolism <- totalmetabolism + matabolism_ant;
    }
    return totalmetabolism / nb_ant;
}
	
	
	csv_file arquivo <- csv_file("../includes/map.csv");
	

    init{
    	create ant number: nb_initial_ant;
    	matrix data <- matrix(arquivo);
    	ask cell {
    		grid_value <- float(data[grid_x,grid_y]);
    		max_psugar <- grid_value;
    		pSugar <- grid_value;
    	}
    	}
    	
    	   
}

species ant{
	//cell espaco;
	int vision_ant min:1  <-  rnd (vision);
	cell my_cell <- one_of(cell);
	int matabolism_ant min: 1<- rnd(metabolism);
	int inicial_energy min: 5<- rnd(max_sugar);
	float sugar min: 0 <- inicial_energy update: sugar - matabolism_ant + my_cell.pSugar;
	
	init{
		location <- choose_cell().location;
	}

	
	cell choose_cell {
		
    list<cell> avaliable_cell <- my_cell.neighbours[vision_ant] where (empty(ant inside (each)));
     cell cell_with_max_sugar <-    avaliable_cell with_max_of (each.pSugar);
     
 
   if (my_cell = nil){
    	return one_of(my_cell.neighbors);}
   if (cell_with_max_sugar.pSugar < my_cell.pSugar or cell_with_max_sugar.pSugar = my_cell.pSugar) {
			return my_cell;
		} else {
			return cell_with_max_sugar;}
    
} 
 
	
	aspect default {
		draw circle(1.0) color: #darkred;
		//draw string (sugar with_precision 1 ) size: 3 color: #black;
	}
	
	reflex end_of_life when: (sugar <= 0)  {
		do die;
	}
	
}


grid cell width: 50 height: 50 neighbors:4{
	
	float max_psugar;
	float sugarGrowthRate <- 0.0;
	float pSugar ;
	map<int,list<cell>> neighbours;
	//list<cell> neighbours2 <- (self neighbors_at vision_ant );
	 
	  reflex updateColor{
    	if (pSugar = 1){
    		color <- rgb(250,250,210) ;
    	}  else 
		      if (pSugar = 2){
			  color <- rgb(247,246,167) ;
		} else
		      if (pSugar = 3){
			  color <- rgb(243,242,126) ;	  
		} else
		      if (pSugar = 4){
		      	color <- rgb(240,241,50 ) ; 
		 }else
		       if (pSugar = 0){
		      	color <- rgb(254,254,251);
		      	} 	
    }
    init {
			loop i from: 1 to: vision {
				neighbours[i] <- self neighbors_at i; 
			}
		}
	 
 
  




}

experiment simulation type: gui {
	parameter "Visão: " var: vision min: 1 max: 25 category: "Ant";
	parameter "Quantida formiga: " var: nb_initial_ant min: 1 max: 2500 category: "Ant";
	output{ 
		display display_grid {
           grid cell;
           species ant aspect: default;	
           		
	}
	display "my_display"  {
        chart "my_chart" type: histogram {
        datalist (distribution_of(ant collect each.sugar,20, ant min_of each.sugar,ant max_of each.sugar) at "legend") 
            value:(distribution_of(ant collect each.sugar,10,0,200) at "values");      
        }
    }
	display Population refresh: every(5#cycles)  type: 2d {
			chart "Population" type: series size: {1,0.5} position: {0, 0} {
				data "Quantidade de Formigas" value: nb_ant  color: #black;
				
				}}
	
	display Vision refresh: every(5#cycles)  type: 2d {
			chart "Average Vision" type: series size: {1,0.5} position: {0, 0} {
				data "Vision" value: average_vision  color: #black;
				}}
				
	display Metabolism refresh: every(5#cycles)  type: 2d {
			chart "Average Metabolism" type: series size: {1,0.5} position: {0, 0} {
				data "metabolism" value: average_metabolism   color: #black;
				}}
	monitor "Quantidade de formiga" value: nb_ant;}
}

