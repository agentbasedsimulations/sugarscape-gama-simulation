/**
* Name: sugarscape1
* Based on the internal empty template. 
* Author: Aline Santos
* Tags: 
*/
model sugarscape1

global {
	float crescimentoAcucar <- 1.0;
	float valorMaximoAcucar;
	int visao <- 6;
	int nb_initial_ant <- 400;
	float max_metabolism <- 5.0;
	float max_energy <- 25.0;
	
	int quantidade_formiga -> {length(ant)};
	float mediaVisao <- 6.0 update: calcularMediaVisao();
	float mediaMetabolism <- 5.0 update: calcularMediaVisao();
	
	float calcularMediaVisao {
    float totalVisao <- 0.0;
    ask ant {
        totalVisao <- totalVisao + vision;
    }
    return totalVisao / quantidade_formiga;
}
   
   float calcularMediaMetabolismo {
    float totalmetabolismo;
    ask ant {
        totalmetabolismo <- totalmetabolismo + matabolism;
    }
    return totalmetabolismo / quantidade_formiga;
   
}
	
	
	csv_file arquivo <- csv_file("../includes/map.csv");
	

    init{
    	create ant number: nb_initial_ant;
    	matrix data <- matrix(arquivo);
    	ask cell {
    		grid_value <- float(data[grid_x,grid_y]);
    		valorMaximoAcucar <- grid_value;
    		sugar <- grid_value;
    		//write data[grid_x,grid_y];
    	}
    	}
    	
    	   
}

species ant{
	//cell espaco;
	int vision min:0 <- rnd(visao);
	cell my_cell <- one_of(cell);
	float matabolism min:0.0 <- rnd (max_metabolism);
	float energy min:0.0 <- rnd (max_energy)   ;
	

   reflex basic_move {
   	    energy <- energy - matabolism + my_cell.sugar;
   	    my_cell.sugar <- 0.0;
		my_cell <- choose_cell();
		location <- my_cell.location;
	}
	
	cell choose_cell {
    list<cell> available_cells <- (my_cell.neighbours2) where (empty(ant inside (each)));
    cell cell_with_max_sugar <- available_cells with_max_of (each.sugar);
    
    if (cell_with_max_sugar.sugar > my_cell.sugar){
    	return cell_with_max_sugar;
    } 
    else if (cell_with_max_sugar.sugar = 0 and my_cell.sugar = 0  ) {
    	return one_of(available_cells);
    }
    else if (cell_with_max_sugar.sugar <= my_cell.sugar){
    	return my_cell;
    } 
}
	
	aspect default {
		draw circle(0.5) color: #darkred;
		draw string (matabolism with_precision 1 ) size: 3 color: #black;
	}
	
	reflex end_of_life when: (energy <= 0)  {
		do die;
	}
	
}


grid cell width: 50 height: 50{
	int vision <- visao;
	float valorMaximoAcucar;
	float sugarGrowthRate <- crescimentoAcucar;
	float sugar  update: sugar + sugarGrowthRate max: valorMaximoAcucar;
	map<int,list<cell>> neighbours;
	list<cell> neighbours2 <- (self neighbors_at vision);
	 
	  reflex updateColor{
    	if (sugar = 1){
    		color <- rgb(250,250,210) ;
    	}  else 
		      if (sugar = 2){
			  color <- rgb(247,246,167) ;
		} else
		      if (sugar = 3){
			  color <- rgb(243,242,126) ;	  
		} else
		      if (sugar = 4){
		      	color <- rgb(240,241,50 ) ; 
		 }else
		       if (sugar = 0){
		      	color <- rgb(254,254,251);
		      	} 	
    }
	 
 
  




}

experiment arte type: gui {
	parameter "Visão: " var: visao min: 1 max: 25 category: "Ant";
	parameter "Quantida formiga: " var: nb_initial_ant min: 1 max: 2500 category: "Ant";
	output{ 
		display display_grid {
           grid cell;
           species ant aspect: default;	
           		
	}
	display Population refresh: every(5#cycles)  type: 2d {
			chart "Population" type: series size: {1,0.5} position: {0, 0} {
				data "Quantidade de Formigas" value: quantidade_formiga  color: #black;
				
				}}
	
	display Vision refresh: every(5#cycles)  type: 2d {
			chart "Vision" type: series size: {1,0.5} position: {0, 0} {
				data "Média visão" value: mediaVisao  color: #black;
				}}
				
	display Metabolism refresh: every(5#cycles)  type: 2d {
			chart "Metabolism" type: series size: {1,0.5} position: {0, 0} {
				data "Média metabolismo" value: mediaMetabolism  color: #black;
				}}
	monitor "Quantidade de formiga" value: quantidade_formiga;}
}