
<img src= "Imagens/Marca Alto Vale Horizontal Assinatura CMYK-01.jpg">

---
 //todo GAMA em maiusculo em todas as ocorrencias

 # Tutorial: Simulação SugarScape na Plataforma GAMA
O objetivo deste tutorial de [simulação com agentes](https://sites.google.com/view/simulacoescomagentes/) é estudar a linguagem GAMA e algumas das suas diversas aplicações. A simulação a seguir considera o modelo SugarScape, desenvolvido por Joshua M. Epstein e Robert Axell em 1996, citado no capítulo 2 do livro "Growing Artificial Societies: Social Science from the Bottom Up". Esse modelo considera uma população de formigas, que se movimentam pelo ambiente em busca de alimento (açúcar) para se manterem vivas. O alimento pode reaparecer com o passar do tempo.

Na simulação é criado um **agente artificial** (virtual) para cada formiga. Esses agentes são dotados de habilidades, como: visão (_vision_), energia (_sugar_), metabolismo (_metabolism_). Além disso, as formigas são capazes de se movimentar por um mapa. O mapa possui quantidades determinadas de açúcar; assim que a formiga interage com a região de açúcar, comendo-o, há o crescimento imediato deste. //todo explicar que o crescimento nem sempre é imediado; depende do cenário em estudo.

A simulação foi desenvolvida no âmbito do projeto de pesquisa [Simulações baseadas em agentes](https://www.udesc.br/ceavi/pesquisaepos/pesquisa/projetos)
do [Centro de Educação superior do Alto Vale do Itajaí (CEAVI/UDESC)](https://www.udesc.br/ceavi). Os autores da simulação são:

- [Aline Rodrigues Santos](mailto:46759122810@edu.udesc.com) (Aluna de Engenharia de Software e bolsista de pesquisa).
- [Fernando dos Santos](mailto:fernando.santos@udesc.br) (Professor no curso de Engenharia de Software).

A simulação explicada é uma adaptação para a plataforma [GAMA](https://gama-platform.org/) da simulação [SugarScape](https://ccl.northwestern.edu/netlogo/models/Sugarscape1ImmediateGrowback) disponível na plataforma [NetLogo](https://ccl.northwestern.edu/netlogo/). Este tutorial

# Sumário
* [Especificação da Simulação](#especificação-da-simulação)
  * [Mapa](#mapa)
  * [Açucar](#açúcar) //todo revisar acentuações
  * [Formigas](#formigas)
* [Implementação da Simulação](#código)
  * [Grid](#grid)
  * [Experiment](#experiment)
* Versões implementadas
  * Sugarscape1.gaml: explicar
  * Sugarscape2.gaml: explicar
  * Sugarscape3.gaml: explicar



---
## Mapa
O arquivo de configuração da [grade](#grid) utilizado na simulação é derivado da simulação SugarScape do NetLogo. Inicialmente, este arquivo estava no formato [**.asc**](https://en.wikipedia.org/wiki/Esri_grid) e foi posteriormente modificado para o formato **.csv**. A principal diferença entre esses dois formatos reside na forma como os valores são separados: enquanto o .asc utiliza espaçamento, o .csv utiliza ponto e vírgula. Essa distinção pode ser observada na Figura 1 abaixo, sendo a imagem da esquerda representando o modelo .asc e a direita o modelo .csv:
//todo explicar que a conversão foi necessária porque o GAMA não suporta ASC.

<img src= "Imagens/Mapa ASV.png"> <img src= "Imagens/Mapa CSV.png">
>Figura 1: explicar a figura (lado direito e esquerdo)

Assim como no NetLogo, a simulação utiliza um sistema de grade para representar a distribuição de açúcar no espaço no qual os agentes se movimentam. Essa simulação em Gama mantém a configuração original do livro, com uma grade de 50 células de altura e 50 células de largura, totalizando 2500 células e distribuindo-se em dois montes de açúcar. //todo tirar a mençaõ dos montes daqui, pois isso já é explicado depois

## Açúcar
// todo não precisa usar aspas no açúcar/formigas
Na presente simulação, ocorre uma distribuição simples de "açúcar" no mapa, constituindo um recurso essencial para a sobrevivência das "Formigas". No sistema cartesiano mencionado anteriormente, cada coordenada possui uma quantidade específica de açúcar e uma capacidade máxima para armazenamento desse recurso. Em outras palavras, alguns locais apresentam uma grande disponibilidade de açúcar, enquanto outros estão desprovidos desse recurso.

<img src= "Imagens/Mapa picos.jpg">
//todo legenda da figura e menção no texto
//todo fernando parou a revisao aqui

O mapa exibe dois picos de açúcar, localizados nos quadrantes 1 e 3. Na região de maior concentração desses picos, as células possuem a máxima capacidade de açúcar (4). Essa capacidade diminui à medida que se afasta desses quadrantes, podendo atingir valores nulos, como observado nos quadrantes 2 e 4 do plano cartesiano.

Essa estratégica distribuição de açúcar cria um ambiente heterogêneo, desafiando as formigas a procurar recursos em locais mais abundantes e a se adaptarem à disponibilidade de açúcar em sua vizinhança. O comportamento resultante das formigas, ao interagirem com esses gradientes de açúcar, contribui para a dinâmica fascinante da simulação.

## Formigas
A simulação tem início com uma **população inicial de 400 formigas**, que emergem aleatoriamente em diversas células do mapa, independentemente de estas estarem repletas de açúcar ou carentes desse recurso vital. **Cada formiga é singular**, caracterizada por "atributos genéticos" determinados aleatoriamente durante sua criação, sendo que outras características, como a quantidade de energia, variam ao longo da simulação.

A posição de uma formiga é uma variável dinâmica, alterando-se como um par ordenado (X;Y) a cada ciclo. É fundamental ressaltar que dois agentes **não podem coexistir na mesma célula simultaneamente**.

Com o propósito de **introduzir heterogeneidade na população e investigar a seleção natural**, mesmo sem a existência de um processo reprodutivo, são realizadas escolhas aleatórias para os níveis de visão e metabolismo de cada formiga. O metabolismo, que reflete a quantidade de açúcar gasta em atividades como movimentação e alimentação, varia de 1 a 4 e é definido aleatoriamente no início da simulação. Caso a quantidade de açúcar obtida seja inferior ao metabolismo, a formiga sucumbe; caso contrário, ela persiste indefinidamente.

Quanto à visão, distribuída aleatoriamente de 1 a 6, esta não é aplicada diagonalmente. As regras de movimentação incluem:

- Buscar até o valor máximo de visão pelo local com a maior quantidade de açúcar.
- Se encontrar dois locais com mais açúcar do que o atual, movimentar-se para o mais próximo.
- Caso não haja um local com mais açúcar do que o atual, permanecer na posição atual.
- Colete todo o açúcar da nova posição.


---

# Código
**O código** da simulação Sugar Scape é composto por quatro elementos essenciais: a [species global](#espécie-global), a [species ant](#espécie-formiga) (que representa as formigas), a [species do tipo grid](#grid) e, por fim, o [experiment](#experiment), onde estão definidos os gráficos e os parâmetros. Vamos explorar a seguir detalhadamente cada uma dessas partes fundamentais.

## Espécie Global
**A Espécie Global** desempenha um papel essencial na definição de atributos, ações e comportamentos compartilhados entre experimentos ou múltiplos agentes na simulação. Neste contexto, são estabelecidas as características globais das [formigas](#formigas).
``` 
global {
	int vision <- 6;
	int nb_initial_ant <- 400;
	int metabolism <-4;
	int max_sugar <- 25;
	int nb_ant -> {length(ant)};
	float average_vision <- 6.0 update: calculate_average_vision();
	float average_metabolism <- 5.0 update: calculate_average_metabolism();   
  ```

Na segunda etapa da definição global, configuram-se as **características do mapa**. Utilizando um arquivo .csv, é gerada a matriz que será empregada no grid do [mapa](#mapa), e as cores são atribuídas com base nos valores do mapa.

```
csv_file arquivo <- csv_file("../includes/map.csv");

	init {
		create ant number: nb_initial_ant;
		matrix data <- matrix(arquivo);
		ask cell {
			grid_value <- float(data[grid_x, grid_y]);
			sugar <- grid_value;
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
	}

```

Por fim, na última etapa global, são realizados **cálculos essenciais** para o controle da simulação. Os valores médios de visão e metabolismo de todas as formigas presentes são calculados e serão apresentados em forma de gráficos na fase de [experimentação](#experiment).
```
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
```

## Espécie Formiga
**Na Espécie Formiga**, definem-se os atributos exclusivos de cada agente, com valores selecionados aleatoriamente dentro de intervalos específicos. Esses intervalos são determinados pelos valores máximos e mínimos definidos na [espécie global](#espécie-global). 
 ```
 species ant {
 int vision_ant min: 1 <- rnd(vision);
	int matabolism_ant min: 1<- rnd(metabolism);
	int inicial_energy min: 5<- rnd(max_energy);
 ```
 A seguir, é desenvolvida a movimentação do agente, seguindo o padrão (4) de Von Neumann, conforme ilustrado na imagem abaixo:

 <img src= "Imagens/Von Neuman moviment.png">
 
 O código abaixo indica que cada formiga inicia em uma célula aleatória do grid e se move dependendo da quantidade de açúcar e da disponibilidade das células vizinhas. A formiga pode enxergar as células dentro de sua visão limite. Se houver células com mais açúcar e sem outras formigas, a formiga se moverá para a célula mais próxima.

As limitações atuais do Gama exigiram o uso do comando "using topology(cell)", que busca as células vizinhas na configuração do grid, ou seja, de Von Neumann.

 ```
 cell my_cell <- one_of(cell);
	init {
		location <- my_cell.location;
		my_cell <- choose_cell();
	}
	
	cell choose_cell {
		list<cell> available_cells <- my_cell neighbors_at vision_ant using topology(cell) where (empty(ant inside (each)));
		cell cell_with_max_sugar <- available_cells with_max_of (each.sugar);
		if (cell_with_max_sugar.sugar < my_cell.sugar or cell_with_max_sugar.sugar = my_cell.sugar) {
			return my_cell;
		} else {
			return cell_with_max_sugar;
		}
	}
 ```

 Por fim, são definidos dois aspectos nesta espécie. O primeiro aspecto trata da aparência física da formiga, incluindo os atributos mencionados acima. O segundo aspecto determina em quais circunstâncias a formiga deixará de existir.

 ```
    aspect default {
		draw circle(1.0) color: #darkred;
		//draw string (energy with_precision 1 ) size: 3 color: #black;
	}

	reflex end_of_life when: (energy <= 0) {
		do die;
	}
 ```
 
## Grid
**O Grid** desempenha um papel essencial nesta simulação, sendo responsável por definir as características do mapa. Em geral, ele é automaticamente gerado em todas as simulações, mas quando desejamos personalizar o mapa, é necessário criar este agente para especificar as propriedades desejadas. 

 No contexto desta simulação, optou-se por configurar o grid em formato de matriz. Os valores desta matriz foram predefinidos através de um arquivo [.csv](#mapa), detalhe que foi realizado na [espécie global](#espécie-global). Cada número presente na matriz representa uma célula do grid, e o tamanho da matriz é definido no início da criação da espécie grid, adotando, neste caso, as dimensões 50 x 50.

 Junto ao tamanho, teve que definir também a quantidade de células vizinhas para obedecer o modelo de Von Neumann, regra do SugarScape.
Após iniciar a espécie grid, foi necessário definir a quantidade máxima de açúcar de cada célula, baseado no valor da matriz.

```
 grid cell width: 50 height: 50 neighbors: 4 {
	float sugar;
 }
 ```


## Experiment 
A **seção do experimento** define as configurações visuais e interativas da simulação, apresentando informações relevantes por meio de **gráficos e monitores**. Optou-se pelo tipo de experimento **GUI** para permitir a interação do usuário, incluindo a capacidade de ajustar a quantidade inicial de formigas.

- **Configuração de Saída**
1. Simulação em Tempo Real (display_grid):
 Este display oferece uma visualização dinâmica da simulação, mostrando o grid e a distribuição das formigas.

2. Evolução da População (Population):
Um gráfico que representa o número de formigas ao longo do tempo, atualizado a cada 5 ciclos.

3. Visão Média (Vision):
Outro gráfico exibindo a média de visão entre as formigas, permitindo observar como esse atributo se desenvolve ao longo da simulação.

4. Média de Metabolismo (Metabolism):
Um gráfico adicional que calcula e apresenta a média de metabolismo das formigas, destacando as variações ao longo do tempo.

- **Parâmetro Ajustável**
1. Quantidade de Formigas: Um controle interativo na interface gráfica que possibilita a modificação da quantidade inicial de formigas, variando entre 1 e 2500.

-**Monitor**
1. Quantidade de Formigas: 
Um monitor em tempo real exibindo a quantidade atual de formigas na simulação.


```
experiment simulation type: gui {
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

```



























                           

