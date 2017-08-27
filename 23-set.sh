#!/bin/bash

function compara_anos {

	echo 
	echo "Processando..."
	sort muculmano.txt > sort_m.dat
	sort judaico.txt > sort_j.dat
	comm -12 sort_m.dat sort_j.dat > comum.dat		

	nro_dias=$(cat comum.dat | wc -l)
	sleep 3
	echo 
	echo "------------------------------------------------------------------------"	
	echo "Foram encontradas $nro_dias DIAS em comúm num periodo de quase 2400 anos -"
	echo "em que o Ano novo judaico cai no mesmo dia do ano novo muçulmano. "
	echo "O arquivo chamado -- ano_novo_comum.txt -- traz essas datas em comúm."
	echo "------------------------------------------------------------------------"
	echo 

	# Criando arquivo para o usuário...
	echo "- Este arquivo contém a lista dos dias em que o Ano Novo Judaico (Festa das Trombetas) cai no mesmo dia do ano novo muçulmano:" > ano_novo_comum.txt
	echo "-" >> ano_novo_comum.txt
	sort -n -k3 comum.dat >> ano_novo_comum.txt
	
	rm *.dat	# limpando tudo
}


function ano_novo {
	clear
	echo "================================="
	echo " 3- ANO NOVO JUDAICO E MUÇULMANO"
	echo "================================="
	echo
	echo "Calculando todos Anos Novos muçulmanos de 622 até 3000..."

	echo "ANO NOVO MUÇULMANO - Muharram (de 622 até 3000):" > muculmano.txt
	for ano in $(seq 1 2452)		# 1439 = 2017
	do 
		resto=$((ano%35))				
		if [[ $resto -eq 0 ]];then echo -n ">";fi	# 

		if [[ $ano -lt 10 ]]
		then
			ano="000"$ano
		elif [[ $ano -lt 100 ]]
		then
			ano="00"$ano
		elif [[ $ano -lt 1000 ]]	
		then	
			ano="0"$ano
		fi

		ano=$ano"0101"			

		dia_m=$(ical -hi $ano -d | grep -Eo "01\/.." | cut -d'/' -f2)
		mes_m=$(ical -hi $ano -d | grep -E "From" | cut -d"/" -f3| cut -d" " -f2)
		ano_m=$(ical -hi $ano -d | grep -E "From" | grep -Eo "[0-9]+)" | cut -d")" -f1)

		echo $dia_m $mes_m $ano_m >> muculmano.txt
	done 

	echo
	echo
	echo "Calculando os dias de Festa das Trombetas dos anos 1 até 3000..."
	
	echo "FESTAS DAS TROMBETAS - Rosh Hashana (do ano 1 ao 3000):" > judaico.txt

	for ano in $(seq 1 3000)
	do
		resto=$((ano%43))				
		if [[ $resto -eq 0 ]];then echo -n ">";fi	 

		hdate -hq $ano | grep " [1-2] Tishrei" | cut -d"," -f2 | sed 's/ //' >> judaico.txt #2>/dev/null
	done

	sed -i 's/Septiembre/September/g; s/Setembro/September/g; s/Agosto/August/g; s/Octubre/October/g; s/Outubro/October/g' judaico.txt	
	
	echo
	echo
	echo "----------------------------------------------------"
	echo "Foram criados 2 arquivos de nomes: --judaico.txt-- e --muculmano.txt--"
	echo "(Neles estão listados as datas em que comemoram seu ano novo)"
	echo "----------------------------------------------------"
	echo
	echo "Pressione ENTER para encontrar datas em comúm entre os dois arquivos!"
	read
	compara_anos		
}



function em_comum {
	echo "========================"
	echo " 2- COMPARAÇÃO DE DATAS "
	echo "========================"
	echo
	echo "O programa vai agora cruzar as informações para encontrar nas -"
	echo "posições desses planetas as datas em que ELES ESTEJAM JUNTOS"
	echo "(Tal como no dia 23/09/2017)"
	echo
	echo "Pressione ENTER para continuar..."
	read	
	
	for arquivo in *.dat
	do
		echo "Preparando e analisando o arquivo: " $arquivo
		cat $arquivo | sort > _$arquivo	
		rm $arquivo			
		mv _$arquivo $arquivo
	done
	clear 			

	planeta=(Jupiter Lua Sol Marte Venus Mercurio todos)	
	arq=(Jupiter_em_Virgo.dat Sol_em_Virgo.dat Marte_em_Leo.dat Venus_em_Leo.dat Mercurio_em_Leo.dat nulo.dat)	
	novo_arq=(Lua_em_Virgo.dat em_comum_JL.dat em_comum_JLS.dat em_comum_JLSM.dat em_comum_JLSMV.dat em_comum_astros.dat nulos.dat)	

	echo "Buscando as LOCALIZAÇÕES EM COMÚM entre os astros: "
	echo -n "Júpiter" 
	for n in $(seq 0 5)
	do
		echo -n " e" ${planeta[$n+1]}	
		comm -12 ${arq[$n]} ${novo_arq[$n]} >> ${novo_arq[$n+1]} 2>/dev/null	
		sleep 1				
	done

	qtos_dias=$(cat em_comum_astros.dat | wc -l)
	echo "."
	echo
	echo "------------------------------------------------------------------------"
	echo " Foram encontrados" $qtos_dias "DIAS em que a posição dos astros estão PARECIDAS" 
	echo " com as do dia 23/09/2017. A lista desses dias está no arquivo chamado: "
	echo " ---em_comum_astros.txt---"
	echo "------------------------------------------------------------------------"

	echo "- Esta é a lista dos dias em que os astros no céu estarão em posição semelhante ao do dia 23-Set-2017:" > em_comum_astros.txt
	echo "- Verifique-os nos programas STELLARIUM ou KSTARS..." >> em_comum_astros.txt
	echo "- Formato: Ano/mes/dia:" >> em_comum_astros.txt
	echo "-" >> em_comum_astros.txt
	cat em_comum_astros.dat | sort -nr -k1 -k2 -k3 >> em_comum_astros.txt
	rm nulo*	
	sleep 5

	echo
	echo "Gostaria de ahora calcular as datas das FESTAS DAS TROMBETAS e dos Anos Novos muçulmanos ??? "
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

	clear
	echo "====================="
	echo " 1- SELEÇÃO DE DADOS "
	echo "====================="
	echo
	echo "Se realizará a filtragem dos arquivos para selecionar apenas as datas"
	echo "em que cada planeta estará nas mesmas constelações como em 23/09/2017."
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

	sed -i 's/\// /g' Jupiter_em_Virgo.dat	# Altera as barras das datas por espaço 
	sed -i 's/\// /g' Sol_em_Virgo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Lua_em_Virgo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Marte_em_Leo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Venus_em_Leo.dat	# Altera as barras das datas por espaço
	sed -i 's/\// /g' Mercurio_em_Leo.dat	# Altera as barras das datas por espaço

	echo
	echo "---------------------------------------------------------------"
	echo "			FILTRAGEM REALIZADA!"
	echo "Em um periodo de 7000 anos, foram separados APENAS os dias que:"
	echo "---------------------------------------------------------------"	
	echo "Jupiter estará em Virgem"
	echo "Lua estará em Virgem"
	echo "Sol estará em Virgem"
	echo "Marte em Leão"
	echo "Venus em Leão"
	echo "e Mercúrio em Leão"
	echo "---------------------------------------------------------------"
	echo
	echo "Pressione ENTER para continuar"
	read
	echo
	em_comum
}

filtra
	# Autor: Helio Giroto
