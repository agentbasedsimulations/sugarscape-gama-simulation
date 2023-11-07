
<img src= "Imagens/Marca Alto Vale Horizontal Assinatura CMYK-01.jpg">

---
 
 # Simulação Sugar Scape
O objetivo dessa [simulação com agentes](https://sites.google.com/view/simulacoescomagentes/) é estudar a linguagem gama e algumas das suas diversas aplicações. A simulação a seguir considera o exercício SugarScape, desenvolvido por Joshua M. Epstein e Robert Axell em 1996, citado no capítulo 2 do livro "Growing Artificial Societies: Social Science from the Bottom Up". Nessa simulação é criado um **agente artificial** (virtual) para cada formiga. Esses agentes são dotados de habilidades, como: visão (vision), energia (sugar), metabolismo (metabolismo). Além disso, as formigas são capazes de se movimentar por um mapa que possui quantidades determinadas de açúcar; assim que a formiga interage com a região de açúcar, comendo-o, há o crescimento imediato deste.

A simulação foi desenvolvida no âmbito do projeto de pesquisa [Simulação baseada em agentes](https://www.udesc.br/ceavi/pesquisaepos/pesquisa/projetos)
do [Centro de Educação superior do Alto Vale do Itajaí (CEAVI/UDESC)](https://www.udesc.br/ceavi). Os autores da simulação são:

- [Aline Rodrigues Santos](mailto:aline.rodrigues.santoss2@gmail.com) (Aluna de Engenharia de Software e bolsista de pesquisa).
- [Fernando dos Santos](mailto:fernando.santos@udesc.br) (Professor no curso de Engenharia de Sofware).

A simulação apresentada foi uma representação da simulação [SugarScape](https://ccl.northwestern.edu/netlogo/models/Sugarscape1ImmediateGrowback) encontrada na plataforma [NetLogo](https://ccl.northwestern.edu/netlogo/). Adaptada para a plataforma [GAMA](https://gama-platform.org/).

# Sumário
* [Especificação da Simulação](#especificação-da-simulação)
  * [Mapa](#Mapa)



---
# Mapa
O Arquivo para a configuração da grade utilizado na simulação foi obtido da simulação SugarScape do NetLogo, esse que inicialmente encontrava-se em .asc foi modificado para .csv. A principal diferença entre esses dois arquivos encontra-se na separação dos valores, enquanto o .asc ultiliza somente o espaçamento, o .csv ultiliza o “;”. Tal diferença pode ser verificada nas imagens abaixo: 
_O primeiro representa o modelo .asv e o segundo o modelo .cvs_

<img src= "Imagens/Mapa ASV.png">   <img src= "Imagens/Mapa CSV.png">

Bem como no NetLogo, a simulação utiliza um sistema de grade para representar a distribuição de açúcar no espaço por onde os agentes se movimentam. Essa Simulação preserva a configuração original, mantendo uma grade com 50 células de altura e 50 células de largura, totalizando 2 montes de açúcar distribuídos em 2500 células. 



                           

