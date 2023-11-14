
<img src= "Imagens/Marca Alto Vale Horizontal Assinatura CMYK-01.jpg">

---
 
 # Simulação Sugar Scape
O objetivo dessa [simulação com agentes](https://sites.google.com/view/simulacoescomagentes/) é estudar a linguagem gama e algumas das suas diversas aplicações. A simulação a seguir considera o exercício SugarScape, desenvolvido por Joshua M. Epstein e Robert Axell em 1996, citado no capítulo 2 do livro "Growing Artificial Societies: Social Science from the Bottom Up". Nessa simulação é criado um **agente artificial** (virtual) para cada formiga. Esses agentes são dotados de habilidades, como: visão (vision), energia (sugar), metabolismo (metabolismo). Além disso, as formigas são capazes de se movimentar por um mapa que possui quantidades determinadas de açúcar; assim que a formiga interage com a região de açúcar, comendo-o, há o crescimento imediato deste.

A simulação foi desenvolvida no âmbito do projeto de pesquisa [Simulação baseada em agentes](https://www.udesc.br/ceavi/pesquisaepos/pesquisa/projetos)
do [Centro de Educação superior do Alto Vale do Itajaí (CEAVI/UDESC)](https://www.udesc.br/ceavi). Os autores da simulação são:

- [Aline Rodrigues Santos](mailto:46759122810@edu.udesc.com) (Aluna de Engenharia de Software e bolsista de pesquisa).
- [Fernando dos Santos](mailto:fernando.santos@udesc.br) (Professor no curso de Engenharia de Sofware).

A simulação apresentada foi uma representação da simulação [SugarScape](https://ccl.northwestern.edu/netlogo/models/Sugarscape1ImmediateGrowback) encontrada na plataforma [NetLogo](https://ccl.northwestern.edu/netlogo/). Adaptada para a plataforma [GAMA](https://gama-platform.org/).

# Sumário
* [Especificação da Simulação](#especificação-da-simulação)
  * [Mapa](#mapa)
  * [Açucar](#açúcar)
  * [Formigas](#formigas)
* [Explicação do Código](#código)
  * [Gride]()



---
## Mapa
O Arquivo para a configuração da grade utilizado na simulação foi obtido da simulação SugarScape do NetLogo, esse que inicialmente encontrava-se em .asc foi modificado para .csv. A principal diferença entre esses dois arquivos encontra-se na separação dos valores, enquanto o **.asc** ultiliza somente o espaçamento, o **.csv** ultiliza o “;”. Tal diferença pode ser verificada nas imagens abaixo: 
_O primeiro representa o modelo .asv e o segundo o modelo .cvs_

<img src= "Imagens/Mapa ASV.png">   <img src= "Imagens/Mapa CSV.png">

Bem como no NetLogo, a simulação utiliza um sistema de grade para representar a distribuição de açúcar no espaço por onde os agentes se movimentam. Essa Simulação em Gama preserva a configuração original do livro, mantendo uma grade com 50 células de altura e 50 células de largura, totalizando 2 montes de açúcar distribuídos em 2500 células. 

## Açúcar
Nessa simulação há uma simples distribuição de “açúcar” no mapa, um recurso único no qual os agentes “Formigas” devem comer para sobreviver. O espaço cartesiano citado anteriormente, cada coordenada há tanto uma quantidade atual de açúcar, quanto a capacidade máxima que esse local pode ter. Ou seja, enquanto alguns lugares há uma grande disponibilidade, há outro que não possui nada de açúcar.

No mapa há dois picos de açúcar, no quadrante 1 e 3, na área de maior concentração dos picos há células com a maior capacidade de açúcar (4) e esta vai diminuindo à medida que se afasta do centro do pico de açúcar, podendo assumir valores nulos, como verificados nos quadrantes 2 e 4 do plano cartesiano.

## Formigas
A simulação inicia com uma **população inicial de 400 formigas**, que podem nascer aleatoriamente em qualquer célula do mapa, seja em áreas abundantes em açúcar ou em regiões desprovidas desse recurso. Cada agente é caracterizado por atributos "genéticos" determinados aleatoriamente durante sua criação, enquanto outras características, como a quantidade de energia, variam ao longo da simulação.

A posição de um agente é uma variável dinâmica, podendo assumir um par ordenado (X;Y) diferente a cada ciclo. É crucial ressaltar que dois agentes não podem ocupar simultaneamente a mesma célula.

Para introduzir heterogeneidade na população e investigar a seleção natural, mesmo sem reprodução, são realizadas escolhas aleatórias para o nível de visão e metabolismo de cada formiga. O metabolismo, que representa a quantidade de açúcar gasta em atividades como movimentação e alimentação, varia de 1 a 4 e é escolhido aleatoriamente no início da simulação. Se a quantidade de açúcar obtida for inferior ao metabolismo, a formiga morre; caso contrário, ela sobrevive indefinidamente.

Quanto à visão, também uma distribuição aleatória de 1 a 6, esta não é aplicada diagonalmente. As regras de movimentação são as seguintes:

- Busque até o valor máximo da visão pelo local com a maior quantidade de açúcar.
- Se encontrar dois locais com mais açúcar do que o atual, mova-se para o mais próximo.
- Caso não haja um local com mais açúcar do que o atual, permaneça na posição atual.
- Colete todo o açúcar da nova posição.

Na imagem abaixo, retirada do capítulo 2 do livro "Growing Artificial Societies: Social Science from the Bottom Up", na página 24. Essa imagem representa a visão de um agente com 3 níveis de visão e o retângulo escuro ilustra a incapacidade da visão diagonal. 

<img src= "Imagens/Visão formiga.png">

---

# Código
 No esqueleto básico dessa simulação envolve: Espécie Global, Espécie Ant (representando as formigas), Espécie do tipo grid e por fim o experimento (onde encontra-se os gráficos e os parâmetros). A seguir, será desenvolvido e explicado as partes fundamentais desse esqueleto.

## Espécie Global
A espécie global é a primeira a ser declarada, nela deverá definir os atributos, ações e comportamentos que são comuns com experiment ou com mais de dois agentes.

Durante a primeira etapa do global foi definido as caracteristícas das formigas que poderam ser alteradas através do "parameter", definido na parte de experiment. 
``` 
global {
	int vision <- 6;
	int nb_initial_ant <- 400;
	int metabolism <-4;
	int max_sugar <- 25;
	int nb_ant -> {length(ant)};
	float average_vision <- 6.0 update: calculate_average_vision();
	float average_metabolism <- 5.0 update: calculate_average_metabolism();
	int minDeathAge <- 60;
	int maxDeathAge <- 100;
	bool replace <- true;
  ```

Durante a segunda etapa do global foi definido as caracteristícas do mapa, onde através de um arquivo .csv foi definida a matriz que é usada no [grid do mapa](#mapa).

```
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

```

Por fim, na última etapa global encontra-se cálculos (o valor médio tanto da visão, quanto do metabolismo de todas formigas presentes) que são necessários para o controle da simulação, posteriormente esses dados serão apresentados em forma de gráficos, definidos na fase de experiment. 
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













                           

