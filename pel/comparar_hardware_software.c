/*
 *  new_full_search.h
 *  
 *
 *  Created by Alba Sandyra on 29/09/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

//################################################################################*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <malloc.h>
#include <string.h>

#define Altura 176   //Resolucaoo do video Altura
#define Largura 144  //Resolucao do video Largura
#define Pes 32       //Tamanho maximo da area na coluna
#define Blk 8        //Tamanho do bloco
#define MB 16        //Tamanho do macrobloco
#define Frames 1   //Numero de frames para execucao do algoritmo
#define MIN 0           //limite inferior e esquerdo da area de pesquisa
#define MAX (Pes-Ref+1) //limite superior e direito da area de pesquisa


#define LINHA 0
#define COLUNA 1
#define SIZE_VECTOR 8
//##############################################################################

int main(){
	int vetor_x_hw, vetor_x_sw, vetor_y_hw, vetor_y_sw;
	int sad_hw, sad_sw;
	int count_x, count_y, count_sad, total_vetores_dif, total_processado;

	FILE * input_hw, * input_sw, * output_sads_diffs;
	
	count_x = count_y = count_sad = total_vetores_dif = total_processado= 0;
	
	if (( output_sads_diffs = fopen("resultados_sads_diffs.txt", "w")) == NULL) {
		printf("\n\nNao foi possivel abrir o arquivo.\n");
		exit(1);
	}
	
	if (( input_hw = fopen("resultados_hw.txt", "r")) == NULL) {
		printf("\n\nNao foi possivel abrir o arquivo.\n");
		exit(1);
	}
	
	if (( input_sw = fopen("resultados_sw.txt", "r")) == NULL) {
		printf("\n\nNao foi possivel abrir o arquivo.\n");
		exit(1);
	}
	 
	while (!feof(input_hw) && !feof(input_sw)) {
		fscanf(input_hw, "%d ", &vetor_x_hw);
		fscanf(input_hw, "%d ", &vetor_y_hw);
		fscanf(input_hw, "%d ", &sad_hw);
		
		fscanf(input_sw, "%d ", &vetor_x_sw);
		fscanf(input_sw, "%d ", &vetor_y_sw);
		fscanf(input_sw, "%d ", &sad_sw);
	
		if (vetor_x_hw != vetor_x_sw){
			count_x++;
		}
		
		if (vetor_y_hw != vetor_y_sw){
			count_y++;
		}
		
		if (sad_hw != sad_sw){
			count_sad++;
			fprintf(output_sads_diffs, "SW: (%d, %d) - %d\t HW: (%d, %d) - %d\n", vetor_x_sw,vetor_y_sw,sad_sw, vetor_x_hw, vetor_y_hw, sad_hw);
		}
		
		if ( (vetor_x_hw != vetor_x_sw) ||  (vetor_y_hw != vetor_y_sw) ){
			total_vetores_dif++;
		}
		
		total_processado++;
		
	}
	
	printf("TOTAL: %d\nTotal de Vetores Diferentes: %d\nVetores X diferentes: %d \nVetores Y diferentes: %d \nSADs diferentes: %d", total_processado, total_vetores_dif, count_x, count_y, count_sad);
	
	
	
	fclose(input_hw);
	fclose(input_sw);
	fclose(output_sads_diffs);

	return 0;
}
