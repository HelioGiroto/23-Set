#!/bin/bash

function compara_anos {
	echo	
	echo "Fazendo o cruzamento das datas..."
	sed 's/Septiembre/9/g; s/Agosto/8/g; s/Octubre/10/g' judaico.txt > judaico.dat
	cat judaico.dat | awk -F' ' '{print $3" "$2" "$1}' > _judaico.dat
	sort _judaico.dat > sort_judaico.dat
	comm -12 alinhamentos.dat sort_judaico.dat > comum.dat		

	nro_dias=$(cat comum.dat | wc -l)
	cat comum.dat | sort -nr -k1 -k2 -k3 > sinal.txt
	sleep 2
	rm *.dat	# limpando tudo
	sleep 7
	clear 
	echo "====================="
	echo "   RESULTADO FINAL   "
	echo "====================="
	echo 
	echo "Em um periodo de mais de 3000 anos foram encontrados $nro_dias DIAS em que os"
	echo "alinhamentos possíveis caem exatamente no dia de Festa das Trombetas!"
	echo
	echo "------------------------------------------------------------------------"
	echo
	echo "Pressione ENTER para ver os resultados:"
	read
	echo
	cat sinal.txt
	echo "------------------------------------------------------------------------"
	echo 
	echo "O arquivo chamado -- sinal.txt -- tem essas informações"
	echo
}


function ano_novo {
	clear
	echo "=============================================="
	echo " 3- CALCULANDO OS DIAS DE FESTA DAS TROMBETAS"
	echo "=============================================="
	echo
	echo "Periodo: Do ano 1 até 3000..."
	
	echo "FESTAS DAS TROMBETAS - Rosh Hashana (do ano 1 ao 3000):" > judaico.txt
	for ano in $(seq 1 3000)
	do
		resto=$((ano%43))				
		if [[ $resto -eq 0 ]];then echo -n ">";fi	 

		hdate -hq $ano | grep " [1-2] Tishrei" | cut -d"," -f2 | sed 's/ //' >> judaico.txt #2>/dev/null
	done

	echo
	echo
#	echo "----------------------------------------------------"
	echo "Foi criado um arquivo chamado: --judaico.txt--"
	echo "(Nele estão listadas as datas em se que comemora o ano novo judaico)"
#	echo "----------------------------------------------------"
	echo
	compara_anos		
}





function em_comum {
	echo "========================"
	echo " 2- COMPARAÇÃO DE DATAS "
	echo "========================"
	echo
	echo "Nessa fase do programa vamos cruzar as informações para saber quando"
	echo "esses planetas ESTIVERAM (OU ESTARÃO) JUNTOS formando o alinhamento!"
	echo
	echo "Pressione ENTER para continuar..."
	read	
	
	for arquivo in *.dat		# Todo esse laço é para ordenar todos arquivos .dat para funcionar o COMM.
	do
		echo "Preparando e analisando o arquivo: " $arquivo
		cat $arquivo | sort > _$arquivo	
		rm $arquivo			
		mv _$arquivo $arquivo
	done
	clear 			

	echo "Em 7000 mil anos..."

	# Comparando grupos em Virgem:

	# "Buscando as LOCALIZAÇÕES EM COMÚM entre os astros que estariam em Virgem: Jupiter, Lua e Sol."
	arq=(Jupiter_em_Virgo.dat Sol_em_Virgo.dat)	
	novo_arq=(Lua_em_Virgo.dat JL.dat JLS.dat)	
	for n in $(seq 0 1)
	do
		comm -12 ${arq[$n]} ${novo_arq[$n]} >> ${novo_arq[$n+1]} #2>/dev/null	
	done

	tot=$(cat JLS.dat | wc -l)
	echo "- Apenas em $tot dias Júpiter, Sol e Lua estiveram JUNTOS em Virgem;"
	

	# Comparando grupos em Leo (serão 4 grupos possíveis de combinação entre 3 planetas):
		# Grupo 1 - Marte + Mercurio + Venus 	(todos em Leo) - MMV (fica fora S)  
		# Grupo 2 - Marte + Mercurio + Saturno	(todos em Leo) - MMS (fica fora V)  
		# Grupo 3 - Marte + Saturno + Venus 	(todos em Leo) - MSV (fica fora Mrc) 
		# Grupo 4 - Saturno + Mercurio + Venus 	(todos em Leo) - SMV (fica fora Mrt) 

	# Buscando as LOCALIZAÇÕES EM COMÚM entre os astros que estariam em Leão: Marte, Mercúrio, Vênus e Saturno 
	# mas em grupos de 3 para - formar as 12 estrelas (9 + 3) à cabeça de Virgem!


	# Grupo 1 - MMV - Marte + Mercurio + Venus (todos em Leo)
	arq=(Marte_em_Leo.dat Venus_em_Leo.dat)	
	novo_arq=(Mercurio_em_Leo.dat MM.dat MMV.dat)	
	for n in $(seq 0 1)
	do
		comm -12 ${arq[$n]} ${novo_arq[$n]} > ${novo_arq[$n+1]} #2>/dev/null	
	done

	tot=$(cat MMV.dat | wc -l)
	echo "- Apenas em $tot dias Marte, Mercúrio e Vênus estiveram JUNTOS em Leão;"


	# Grupo 2 - MMS - Marte + Mercurio + Saturno (todos em Leo)
	arq=(Marte_em_Leo.dat Saturno_em_Leo.dat)	
	novo_arq=(Mercurio_em_Leo.dat MM.dat MMS.dat)	
	for n in $(seq 0 1)
	do
		comm -12 ${arq[$n]} ${novo_arq[$n]} > ${novo_arq[$n+1]} #2>/dev/null	
	done

	tot=$(cat MMS.dat | wc -l)
	echo "- Apenas em $tot dias Marte, Mercúrio e Saturno estiveram JUNTOS em Leão;"


	# Grupo 3 - MSV - Marte + Saturno + Venus (todos em Leo)
	arq=(Marte_em_Leo.dat Venus_em_Leo.dat)	
	novo_arq=(Saturno_em_Leo.dat MS.dat MSV.dat)	
	for n in $(seq 0 1)
	do
		comm -12 ${arq[$n]} ${novo_arq[$n]} > ${novo_arq[$n+1]} #2>/dev/null	
	done

	tot=$(cat MSV.dat | wc -l)
	echo "- Apenas em $tot dias Marte, Saturno e Vênus estiveram JUNTOS em Leão;"


	# Grupo 4 - SMV - Saturno + Mercurio + Venus 	(todos em Leo)
	arq=(Saturno_em_Leo.dat Venus_em_Leo.dat)	
	novo_arq=(Mercurio_em_Leo.dat SM.dat SMV.dat)	
	for n in $(seq 0 1)
	do
		comm -12 ${arq[$n]} ${novo_arq[$n]} > ${novo_arq[$n+1]} #2>/dev/null	
	done

	tot=$(cat SMV.dat | wc -l)
	echo "- Apenas em $tot dias Marte, Saturno e Vênus estiveram JUNTOS em Leão."

	# Uma vez criados os 2 grupos de astros localizados em Virgem e o outro em Leão,
	# agora, faremos o cruzamento dessas combinações todas para encontrar o sinal de Apocalipse 12!!!

	# Lembrar sempre -> 1o.: Ordena para funcionar o COMM e só depois executa o COMM
	for arquivo in *.dat
	do
		sort $arquivo > _$arquivo
		rm $arquivo 
		mv _$arquivo $arquivo
	done

	# 2o.: Executa o COMM - i.é, acha linhas em comúm. COMM-úm!
	comm -12 JLS.dat MMV.dat >> JLSMMV.dat
	comm -12 JLS.dat MMS.dat >> JLSMMS.dat
	comm -12 JLS.dat MSV.dat >> JLSMSV.dat
	comm -12 JLS.dat SMV.dat >> JLSSMV.dat

	JLSMMV=$(cat JLSMMV.dat | wc -l)
	JLSMMS=$(cat JLSMMS.dat | wc -l)
	JLSMSV=$(cat JLSMSV.dat | wc -l)
	JLSSMV=$(cat JLSSMV.dat | wc -l)

	echo
	echo
	echo "Pressione ENTER para receber os resultados finais..."
	read

	# Concatena todos os possívei alinhamentos:
	cat JLSMMV.dat JLSMMS.dat JLSMSV.dat JLSSMV.dat > todos_alinhamentos.dat
	sort todos_alinhamentos.dat > alinhamentos.dat

	sort -nru -k1 -k2 -k3 alinhamentos.dat > alinhamentos.txt
	tot=$(cat alinhamentos.txt | wc -l)

	echo
	echo "	------------------------------------"
	echo "	 RESULTADOS FINAIS DOS ALINHAMENTOS"
	echo "	------------------------------------"
	echo
	echo "Num periodo de 7000 anos todos os possíveis alinhamentos "
	echo "conforme Apocalipse 12 totalizam $tot dias, sendo que:"
	echo
	echo "Alinhamentos Jupiter, Sol, Lua, Marte, Mercúrio, Vênus:	  $JLSMMV"
	echo "Alinhamentos Jupiter, Sol, Lua, Marte, Mercúrio, Saturno: $JLSMMS" 
	echo "Alinhamentos Jupiter, Sol, Lua, Marte, Saturno, Vênus:	  $JLSMSV"
	echo "Alinhamentos Jupiter, Sol, Lua, Saturno, Mercúrio, Vênus: $JLSSMV"
	echo 

	echo
	echo "Tecle ENTER para ver a lista:"
	read 

	cat alinhamentos.txt
	echo
	echo " Toda essa lista, está gravada no arquivo: alinhamentos.txt "

	echo
	echo "- Gostaria de saber quais desses dias serão FESTAS DAS TROMBETAS ??? -"
	echo -n "(S/N): "
	read resp
	if [[ "$resp" == "s" || "$resp" == "S" || "$resp" == "" ]]
	then
		ano_novo
	else
		rm *.dat
		exit
	fi
}



function filtra {

	tot=$(cat Jupiter.csv | wc -l)

	clear
	echo "====================="
	echo " 1- SELEÇÃO DE DADOS "
	echo "====================="
	echo
	echo "Você já tem os arquivos com as posições de todos os planetas" 
	echo "que são visíveis desde a Terra num periodo de 7000 anos!"
	echo
	echo "Dá um total de $tot dias em que a posição de cada um será analisada!"
	echo
	echo "Selecionaremos, agora, apenas os dias que em esses astros"
	echo "deverão estar numa posição semelhante à visão de Apocalipse 12..."
	echo
	echo "Digite ENTER para continuar!"
	read

	echo "Processando..."
	echo

	cat Jupiter.csv | awk -F';' '/Virgo/{print $1}' | awk -F' ' '{print $1}' >> Jupiter_em_Virgo.dat
	cat Sol.csv | awk -F';' '/Virgo/{print $1}' | awk -F' ' '{print $1}' >> Sol_em_Virgo.dat
	cat Lua.csv | awk -F';' '/Virgo/{print $1}' | awk -F' ' '{print $1}' >> Lua_em_Virgo.dat 
	cat Marte.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Marte_em_Leo.dat
	cat Venus.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Venus_em_Leo.dat
	cat Mercurio.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Mercurio_em_Leo.dat
	cat Saturno.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Saturno_em_Leo.dat

	sed -i 's/\// /g' Jupiter_em_Virgo.dat	# Altera as barras das datas por espaço 
	sed -i 's/\// /g' Sol_em_Virgo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Lua_em_Virgo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Marte_em_Leo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Venus_em_Leo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Mercurio_em_Leo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Saturno_em_Leo.dat	# Altera as barras das datas dos espaço

	JV=$(cat Jupiter_em_Virgo.dat | wc -l)
	SV=$(cat Sol_em_Virgo.dat | wc -l)
	LV=$(cat Lua_em_Virgo.dat | wc -l)
	M1L=$(cat Marte_em_Leo.dat | wc -l)
	M2L=$(cat Mercurio_em_Leo.dat | wc -l)
	VL=$(cat Venus_em_Leo.dat | wc -l)
	SL=$(cat Saturno_em_Leo.dat | wc -l)

	echo
	echo "---------------------------------------------------------------"
	echo "			FILTRAGEM REALIZADA!"
	echo "Em um periodo de 7000 anos, foram separados APENAS os dias que:"
	echo "---------------------------------------------------------------"	
	echo "	Jupiter esteve em Virgem:	$JV dias"
	echo "	Lua esteve em Virgem....:	$LV dias"
	echo "	Sol esteve em Virgem....:	$SV dias"
	echo "	Marte em Leão...........:	$M1L dias"
	echo "	Venus em Leão...........:	$VL dias"
	echo "	Mercúrio em Leão........:	$M2L dias"
	echo "	Saturno em Leão.........:	$SL dias"
	echo "---------------------------------------------------------------"
	echo
	sleep 10
	echo
	em_comum
}


filtra
	# Autor: Helio Giroto
