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

//#define Altura 144   //Resolucaoo do video Altura
//#define Largura 176  //Resolucao do video Largura
#define Altura 576   //Resolucaoo do video Altura
#define Largura 720  //Resolucao do video Largura
#define Pes 32       //Tamanho maximo da area na coluna
#define Blk 8        //Tamanho do bloco
#define MB 16        //Tamanho do macrobloco
#define Frames 5   //Numero de frames para execucao do algoritmo
#define MIN 0           //limite inferior e esquerdo da area de pesquisa
#define MAX (Pes-Ref+1) //limite superior e direito da area de pesquisa


#define LINHA 0
#define COLUNA 1
#define SIZE_VECTOR 8
//##############################################################################

void carrega_referencia(FILE *arq);
void carrega_atual(FILE *arq);
void imprimirMatriz(int m, int n, int matriz[Altura][Largura]);
void imprimirMatrizBlk(int m, int n, int matriz[Blk][Blk]);
void imprimirMatrizPes(int m, int n, int matriz[Pes][Pes]);
int calcSad(int posBPx, int posBPy);
void FullSearchOne();
void dec2bin(int decimal, char *binary, int size);
void imprimirBlocoNxNBin(int m, int n, int matriz[Blk][Blk]);
void imprimirMatrizPesBin(int m, int n, int matriz[Pes][Pes]);
void imprimirLinhaOuColunaMatrizBin(int m, int n, int matriz[Blk][Blk], int linhaOuColuna, int pos);
void imprimirParaValidacao();
void imprimirQuartoMatrizPesBin(int m, int n, int matriz[Pes][Pes]);

int QR[Altura][Largura], QA[Altura][Largura];  //Matrizes que armazenam os frames de referencia e o frame atual
int BP[Pes][Pes], BR[Blk][Blk]; //Matrizes que armazenam a area de pesquisa e o mabrobloco
FILE * output, * motion_vectors, *blk_motion_vectors, *referencia, *entrada_ref, *entrada_blk;

int main()
{
	char bin[SIZE_VECTOR+1];
	//bin = malloc(sizeof(char)*SIZE_VECTOR);

	output = fopen("2011_11_13_futebol_VARIOS_QUADROS_sad_results_dec.txt", "w");
	motion_vectors = fopen("2011_11_13_VARIOS_QUADROS_futebol_motion_vectors_sads.txt", "w");
	blk_motion_vectors = fopen("2011_11_13_src7_ref_futebol_referencia_bloco_vetores.txt", "w");
	referencia = fopen("2011_11_13_futebol_referencia_VARIOS_QUADROS.txt", "w");
	entrada_ref = fopen("entrada_ref.txt", "w");
	entrada_blk = fopen("entrada_bloco.txt", "w");
	
	int mbL=0, mbC=0;
	int temp;
	int loops = 0;
	int xBlk, yBlk, xPes, yPes, xPosPes, yPosPes, i, x, y;
	FILE *pw;
	//pw = fopen("akiyo_qcif.yuv","rb");
	//pw = fopen("foreman_qcif_422.y4m", "rb");
	//pw = fopen("foreman_part_qcif_422.yuv", "rb");
	//pw = fopen("coastguard_qcif.yuv", "rb");
	//pw = fopen("grandma_qcif.yuv", "rb");
	//pw = fopen("bridge-close_qcif.yuv", "rb");
	pw = fopen("src9_ref__625_futebol.yuv", "rb");
	
	carrega_referencia(pw);  //Chama a funcao que carrega o frame de referencia
	carrega_atual(pw);  //Chama a funcao que carrega o frame atual

	//imprimirMatriz(Altura, Largura, QR);
	//printf("\n\n\n\n\n");
	//imprimirMatriz(Altura, Largura, QA);
	
	for (i=0; i<Frames && !feof(pw); i++){
		
		if (i!= 0){
			for(x=0; x<Altura; x++)
				for(y=0; y<Largura; y++)
					QR[x][y] = QA[x][y];
		}
		carrega_atual(pw);
		
		//printf("******** Frame %d ********* \n", i);
		for (mbL=0; mbL <= Altura-Blk; mbL=mbL+Blk){
		
			for (mbC=0; mbC <= Largura-Blk; mbC=mbC+Blk){
				
					fprintf(blk_motion_vectors , "=> MB %d %d\n", mbL, mbC);
					
					//para copiar o valor do bloco atual
					for(xBlk = 0; xBlk < Blk; xBlk++){
						for (yBlk =0; yBlk < Blk; yBlk++) {
							temp = QA[mbL+xBlk][mbC+yBlk];
							BR[xBlk][yBlk] = temp;
							//dec2bin(temp, bin, SIZE_VECTOR);
							//printf("%s\n", bin);						
						}
					}
					//printf("\n");
					
					//  Testes para determinar area de pesquisa////// 
					for (xPes = 0, xPosPes = mbL - ((Pes-Blk)/2) ; xPes < Pes; xPes++, xPosPes++){
						for (yPes = 0, yPosPes = mbC - ((Pes-Blk)/2); yPes< Pes; yPes++, yPosPes++){
							if ( (xPosPes >=0) && (yPosPes >=0) && (xPosPes <= Altura-1) && (yPosPes <= Largura-1)){
								temp = QR[xPosPes][yPosPes];		
								BP[xPes][yPes] = temp;
							}
							else {
								temp = 255;
								BP[xPes][yPes] = temp;
							}
							//dec2bin(temp, bin, SIZE_VECTOR);
							//printf("%s\n", bin);
						}
					}
					imprimirBlocoNxNBin(Blk, Blk, BR);
					
					if (mbC == 0){
						imprimirMatrizPesBin(Pes, Pes, BP);
					}else{
						imprimirQuartoMatrizPesBin(Pes, Pes, BP);
					}
					
					//printf("\tArea de pesquisa Macrobloco: %d %d\n", mbL, mbC );
					//fprintf(output, "SADS Macrobloco %d %d\n", mbL, mbC);
					imprimirParaValidacao();				
					FullSearchOne();
					
				}
				
			}
		//}
	}
		
	
	//printf("\n\n\nMacrobloco %d %d\n", mbL, mbC);
	//imprimirMatrizBlk(Blk, Blk, BR);

	//printf("\n\n\nArea de Pesquisa\n");
	//imprimirMatrizPes(Pes, Pes, BP);

	fclose(pw);
	fclose(output);
	fclose(motion_vectors);
	fclose(blk_motion_vectors);
	fclose(entrada_blk);
	fclose(entrada_ref);

	return 0;
}


void FullSearchOne(){

	int xPosPes, yPosPes;
	int sad = 0, bestSad, i =0, j = 0;
	int bestVectorX = 0, bestVectorY = 0;
	int count = 0;
	char * newBin;
	newBin = malloc(sizeof(char)*(SIZE_VECTOR+1));	

	int Candidato[Blk][Blk];

	bestVectorX = -12; // Inicializando os vetores de movimento
	bestVectorY = -12; // Inicializando os vetores de movimento
	
	for (xPosPes = 0; xPosPes < (Pes-Blk+1); xPosPes++){
		
		if (xPosPes % 2 == 0){
			
			yPosPes = 0;
			
			while (yPosPes < (Pes-Blk+1)){
				
				count++;
				sad = calcSad(xPosPes, yPosPes);
				for(i=0; i<Blk; i++){
					for (j=0; j<Blk; j++){
							Candidato[i][j] =  BP[xPosPes+i][yPosPes+j];            			
					}
				}

				//printf("%d %d\n", xPosPes, yPosPes); 
				//imprimirMatrizBlk(Blk, Blk, Candidato);


				if (xPosPes == 0 && yPosPes == 0){
					bestSad = sad;
					//imprimirBlocoNxNBin(Blk, Blk, Candidato);               				
				}	
				else{
					if (yPosPes==0){
						//imprimirLinhaOuColunaMatrizBin(Blk, Blk, Candidato, LINHA, Blk-1);
					}else{
						//imprimirLinhaOuColunaMatrizBin(Blk, Blk, Candidato, COLUNA, Blk-1);
					}      
				}
				
				if (sad < bestSad){
					bestSad = sad;
					bestVectorX = xPosPes - ((Pes-Blk)/2);
					bestVectorY = yPosPes - ((Pes-Blk)/2);
				}
				//printf("**Parcial BEST SAD: %d ( %d, %d)\n", bestSad, bestVectorY, bestVectorX);
				
				yPosPes++;	
			}
			
		}else{
              			
			yPosPes = Pes-Blk;
			
			while (yPosPes >= 0 ){
				
				count++;
				
				sad = calcSad(xPosPes, yPosPes);

				for(i=0; i<Blk; i++){
					for (j=0; j<Blk; j++){
							Candidato[i][j] =  BP[xPosPes+i][yPosPes+j];            			
					}
				}

				//printf("%d %d\n", xPosPes, yPosPes); 
				//imprimirMatrizBlk(Blk, Blk, Candidato);
                			            
				if (sad < bestSad){
					bestSad = sad;
					bestVectorX = xPosPes - ((Pes-Blk)/2);
					bestVectorY = yPosPes - ((Pes-Blk)/2);
				}
				
				//printf("**Parcial BEST SAD: %d ( %d, %d)\n", bestSad, bestVectorY, bestVectorX);
				//printf("+P%d P%d\n", xPosPes, yPosPes);
				yPosPes--;
			}
			
		}
		
	}

	fprintf(motion_vectors, "%d\n%d\n%d\n", bestVectorY, bestVectorX, bestSad);
	fprintf(blk_motion_vectors, "%d\n%d\n%d\n", bestVectorY, bestVectorX, bestSad);
	 
	free(newBin);
}

int calcSad(int posBPx, int posBPy){

    int Candidato[Blk][Blk];
	char * newBin;
	
	newBin = malloc(sizeof(char)*(14+1));
	int sad = 0;
	int i, j;
	for(i=0; i<Blk; i++){
		for (j=0; j<Blk; j++){
            Candidato[i][j] =  BP[posBPx+i][posBPy+j];
			sad += abs(BR[i][j] - BP[posBPx+i][posBPy+j]);
		}
	}

	dec2bin(sad, newBin, 14);
	
	fprintf(output, "%s\n", newBin);
	free(newBin);
	return sad;
}

//############################################################
//Funcao que carrega o frame atual   
void carrega_atual(FILE * arq)
{
	int i,j, chroma;
	//printf("\n******Carrega atual: ");
	for (i=0; i<Altura; i++)
	{
		for (j=0; j<Largura; j++) 
		{  
			if(!(feof(arq)))
			{
				QA [i][j] = fgetc(arq);    //L� todas as posi��es de mem�ria at� encontrar o fim do arquivo
				//if((j>=320 && j<336) && i>=464)
				//{
				// fprintf(atual, "%d", QP[i][j]);
				// fprintf(atual, "  ");
				//}
			}
			else
			{
				printf("\nFIM DE ARQUIVO: %d %d", i, j);
				j = Altura;
				i = Largura;
			}    
		}
		//fprintf(atual, "\n");
	} 
	
	j = (Altura)*(Largura/2)*2;
	
	for(i=0; i<j; i++)           //Elimina os elementos de cromin�ncia
		chroma = fgetc(arq);
	
}  

//############################################################
//Funcao que carrega o frame de refer�ncia
void carrega_referencia(FILE *arq)
{
	int i,j, chroma;
	
	for (i=0; i<Altura; i++)
	{
		for (j=0; j<Largura; j++) 
		{  
			if(!(feof(arq)))
			{
				QR [i][j] = fgetc(arq);    //L� todas as posi��es de mem�ria at� encontrar o fim do arquivo
				//if((j>=320 && j<336) && i>=464)
				// {
				//  fprintf(referencia, "%d", QR[i][j]);
				//  fprintf(referencia, "  ");
				// }
			}
			else
			{
				j = Altura;
				i = Largura;
			}    
		}
		// fprintf(referencia, "\n");
	}
	
	//j = (Altura/2)*(Largura/2)*2;
	j = Altura*(Largura/2)*2;
	
	for(i=0; i<j; i++)   //Exclui os elementos de cromin�ncia
		chroma = fgetc(arq);
	
}  


void imprimirMatriz(int m, int n, int matriz[Altura][Largura]){
	int i, j;
	for (i = 0; i<m; i++){
		for (j=0; j<n; j++){
			printf(" %d", matriz[i][j]);
		}
		printf("\n");
			
	}
	printf("\n");
}



void imprimirMatrizBlk(int m, int n, int matriz[Blk][Blk]){
	int i, j;
	for (i = 0; i<m; i++){
		for (j=0; j<n; j++){
			printf(" %d", matriz[i][j]);
		}
		printf("\n");
		
	}
	printf("\n");
}


void imprimirBlocoNxNBin(int m, int n, int matriz[Blk][Blk]){
	int i, j;
	char * newBin;
	newBin = malloc(sizeof(char)*(SIZE_VECTOR+1));
	for (i = 0; i<m; i++){
		for (j=0; j<n; j++){
			dec2bin(matriz[i][j], newBin, SIZE_VECTOR );
			fprintf(entrada_blk,"%s\n", newBin);//, matriz[i][j]);
		}
	}
	free(newBin);
}

void imprimirLinhaOuColunaMatrizBin(int m, int n, int matriz[Blk][Blk], int linhaOuColuna, int pos){
	
	int i;
	char * newBin;
    newBin = malloc(sizeof(char)*(SIZE_VECTOR+1));
	
	
	for (i = 0; i<m; i++){
		if (linhaOuColuna == LINHA){
			//printf("*linha*");
			dec2bin(matriz[pos][i], newBin, SIZE_VECTOR );
			//printf("%s %d\n", newBin, matriz[pos][i]);
			printf("%s\n", newBin);
		}else{
			//printf("*coluna*");
			dec2bin(matriz[i][pos], newBin, SIZE_VECTOR);
			//printf("%s %d\n", newBin, matriz[i][pos]);
            printf("%s\n", newBin);
		}	
	}
	
	free(newBin);
}


void imprimirMatrizPes(int m, int n, int matriz[Pes][Pes]){
	int i, j;
	for (i = 0; i<m; i++){
		for (j=0; j<n; j++){
			printf(" %d", matriz[i][j]);
		}
		printf("\n");
		
	}
	printf("\n");
}

void imprimirParaValidacao(){
	
	int i, j;
	for (i = 0; i<Blk; i++){
		for (j=0; j<Blk; j++){
			fprintf(referencia," %d", BR[i][j]);
		}
		fprintf(referencia,"\n");
	}
	fprintf(referencia, "\n\n");
	for (i = 0; i<Pes; i++){
		for (j=0; j<Pes; j++){
			fprintf(referencia," %d", BP[i][j]);
		}
		fprintf(referencia,"\n\n");
	}
}

void imprimirMatrizPesBin(int m, int n, int matriz[Pes][Pes]){
	int i, j;
	char * newBin;
	newBin = malloc(sizeof(char)*(SIZE_VECTOR+1));
	for (i = 0; i<m; i++){
		for (j=0; j<n; j++){
			dec2bin(matriz[i][j], newBin, SIZE_VECTOR );
			fprintf(entrada_ref,"%s\n", newBin);//, matriz[i][j]);
		}
	}
	free(newBin);
}

void imprimirQuartoMatrizPesBin(int m, int n, int matriz[Pes][Pes]){
	int i, j;
	char * newBin;
	newBin = malloc(sizeof(char)*(SIZE_VECTOR+1));
	for (i = 0; i<m; i++){
		for (j=24; j<n; j++){
			dec2bin(matriz[i][j], newBin, SIZE_VECTOR );
			fprintf(entrada_ref,"%s\n", newBin);//, matriz[i][j]);
		}
	}
	free(newBin);
}

void dec2bin(int decimal, char *binary, int size)
{
	int k = 0, n = 0, t =0, u =0;
	int remain;
	int old_decimal; // for test
	char temp[80];
	// take care of negative input
	do{
		old_decimal = decimal; // for test
		remain = decimal % 2;
	
		// whittle down the decimal number
		decimal = decimal / 2;

		// this is a test to show the action
		//printf("%d/2 = %d remainder = %d\n", old_decimal, decimal, remain);
		// converts digit 0 or 1 to character '0' or '1'
		temp[k++] = remain + '0';
	} while (decimal > 0);
	
	// reverse the spellings
	while (k >= 0)
		binary[n++] = temp[--k];
 
	binary[n-1] = 0; // end with NULL
	binary[n] = '\0';
	k = strlen(binary);	
	t = size-k;

	for(n=0; n<t; n++){
		temp[n] = '0';
	}
	for(u=0; u<k; u++, n++){
		temp[n] = binary[u];
	}
	temp[n] = '\0';
	strcpy(binary, temp);
}

