#!/bin/bash

# Para compreender esse código vá até a última linha e siga as funções que são chamadas...

function compara_anos {

	echo 
	echo "Processando..."
	sort muculmano.txt > sort_m.dat				
	sort judaico.txt > sort_j.dat
	comm -12 sort_m.dat sort_j.dat > comum.dat		# Antes de achar os dados em COMM-úm, é necessário ordenar (ver as 2 linhas acima)	

	nro_dias=$(cat comum.dat | wc -l)				# Número de ocorrências em comúm encontradas.
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
	sort -n -k3 comum.dat >> ano_novo_comum.txt		# Ordena Numericamente pela 3a. coluna (ano) 
	
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
		if [[ $resto -eq 0 ]];then echo -n ">";fi	# Só para que imprima um ">" de 35 em 35 anos (conforme o laço vai "girando")

		if [[ $ano -lt 10 ]]		
		then
			ano="000"$ano			# Coloca 000 antes do ano que só tem um digito. P. Ex.: 0001 - Senão dará erro no formato de data que será passado ao ical!
		elif [[ $ano -lt 100 ]]
		then
			ano="00"$ano			# Coloca 00 antes do ano que só tem dois digitos. P. Ex.: 0012 - Senão dará erro no formato de data que será passado ao ical!
		elif [[ $ano -lt 1000 ]]	
		then	
			ano="0"$ano				# Coloca 0 antes do ano que só tem três digitos. P. Ex.: 0999 - Senão dará erro no formato de data que será passado ao ical!
		fi

		data=$ano"0101"				# Define o formato de data para 1o. dia do 1o. mês do ano XXXX...

		dia_m=$(ical -hi $data -d | grep -Eo "01\/.." | cut -d'/' -f2)						# Capturará o dia (ocidental) do calor devolvido pelo ical
		mes_m=$(ical -hi $data -d | grep -E "From" | cut -d"/" -f3| cut -d" " -f2)			# Capturará o mês
		ano_m=$(ical -hi $data -d | grep -E "From" | grep -Eo "[0-9]+)" | cut -d")" -f1)	# Capturará o ano (ocidental)

		echo $dia_m $mes_m $ano_m >> muculmano.txt										# Imprime esses valores no arquivo muculmano.txt
	done 

	echo
	echo
	echo "Calculando os dias de Festa das Trombetas dos anos 1 até 3000..."
	
	echo "FESTAS DAS TROMBETAS - Rosh Hashana (do ano 1 ao 3000):" > judaico.txt

	for ano in $(seq 1 3000)		# O hdate dá erro ao converter um ano maior que 3000 ! 
	do
		resto=$((ano%43))			# Efeito estético igual à linha 41, 42		
		if [[ $resto -eq 0 ]];then echo -n ">";fi	 

		hdate -hq $ano | grep " [1-2] Tishrei" | cut -d"," -f2 | sed 's/ //' >> judaico.txt #2>/dev/null	# Suprime qquer erro... 
	done

	sed -i 's/Septiembre/September/g; s/Setembro/September/g; s/Agosto/August/g; s/Octubre/October/g; s/Outubro/October/g' judaico.txt	
	# Talvez na linha acima seria melhor substituir nome para número - ????
	
	echo
	echo
	echo "----------------------------------------------------"
	echo "Foram criados 2 arquivos de nomes: --judaico.txt-- e --muculmano.txt--"
	echo "(Neles estão listados as datas em que comemoram seu ano novo)"
	echo "----------------------------------------------------"
	echo
	echo "Pressione ENTER para encontrar datas em comúm entre os dois arquivos!"
	read
	compara_anos		# Cham última função para cruzar as datas e encontrar dias em comúm entre os dois.
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
	
	for arquivo in *.dat			# Cada arq. gerado pela função anterior 
	do
		echo "Preparando e analisando o arquivo: " $arquivo
		cat $arquivo | sort > _$arquivo							# Deve ser ordenado para que funcione o COMM
		rm $arquivo												# Deleta anterior
		mv _$arquivo $arquivo									# Renomeia novo para o nome do antigo
	done
	clear 			

	planeta=(Jupiter Lua Sol Marte Venus Mercurio todos)		# Array com nomes dos planetas
	arq=(Jupiter_em_Virgo.dat Sol_em_Virgo.dat Marte_em_Leo.dat Venus_em_Leo.dat Mercurio_em_Leo.dat nulo.dat)		# Array com nomes dos arquivos a serem comparados
	novo_arq=(Lua_em_Virgo.dat em_comum_JL.dat em_comum_JLS.dat em_comum_JLSM.dat em_comum_JLSMV.dat em_comum_astros.dat nulos.dat)		# Array com nomes dos arquivos que serão gerados com resultados das comparações
	# Nas 2 arrays acima há o item nulo(s).dat para que não tenha problema com a 6a repetição. Mas todo .dat será deletado.
	
	echo "Buscando as LOCALIZAÇÕES EM COMÚM entre os astros: "
	echo -n "Júpiter" 		# Efeito estético. 
	for n in $(seq 0 5)		# Laço com 6 repetições
	do
		echo -n " e" ${planeta[$n+1]}		# Aqui imprime na mesma linha (anterior - sem quebra) o nome do seguinte planeta do array planeta
		comm -12 ${arq[$n]} ${novo_arq[$n]} >> ${novo_arq[$n+1]} 2>/dev/null		# COMM-para a 1a array com a 2a. e envia o resultado para o item seguinte da 2a array!!!
		sleep 1								# Efeito estético
	done

	qtos_dias=$(cat em_comum_astros.dat | wc -l)	# Armazena em variável o número de dias em comum...
	echo "."		# Só mesmo para colocar um ponto final na linha que virá o nome do array de planetas.
	echo
	echo "------------------------------------------------------------------------"
	echo " Foram encontrados" $qtos_dias "DIAS em que a posição dos astros estão PARECIDAS" 
	echo " com as do dia 23/09/2017. A lista desses dias está no arquivo chamado: "
	echo " ---em_comum_astros.txt---"
	echo "------------------------------------------------------------------------"

	# Abaixo: Imprime um cabeçalho para o arquivo em_comum_astros.TXT
	echo "- Esta é a lista dos dias em que os astros no céu estarão em posição semelhante ao do dia 23-Set-2017:" > em_comum_astros.txt
	echo "- Verifique-os nos programas STELLARIUM ou KSTARS..." >> em_comum_astros.txt
	echo "- Formato: Ano/mes/dia:" >> em_comum_astros.txt
	echo "-" >> em_comum_astros.txt
	cat em_comum_astros.dat | sort -nr -k1 -k2 -k3 >> em_comum_astros.txt 	# Depois de feito o cabeçalho, transfere todo resultado do arquivo final das comparações para este .txt
	# Acima está ordenando de forma Numérica (-n) e de maneira Descendente (-r, reversa). Pelo primeiro campo (ano) depois 2o. (mês), e por fim pelo 3o. campo (dia) - Formato americano.
	rm nulo*		# Creio que essa linha já é desnecessária já que se deletará todos .dat
	sleep 5

	echo
	echo "Gostaria de ahora calcular as datas das FESTAS DAS TROMBETAS e dos Anos Novos muçulmanos ??? "
	echo -n "(S/N): "
	read resp
	if [[ "$resp" == "s" || "$resp" == "S" || "$resp" == "" ]]
	then
		ano_novo	# Chama função ano_novo
	else
		rm *.dat	# Limpa de arquivos já processados. Todos os ".dat" caso queira sair do prgm.
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

	cat Jupiter.csv | awk -F';' '/Virgo/{print $1}' | awk -F' ' '{print $1}' >> Jupiter_em_Virgo.dat	# Filtra linhas em que o planeta estará nessa constelação
	cat Sol.csv | awk -F';' '/Virgo/{print $1}' | awk -F' ' '{print $1}' >> Sol_em_Virgo.dat			# Mesmo filtro
	cat Lua.csv | awk -F';' '/Virgo/{print $1}' | awk -F' ' '{print $1}' >> Lua_em_Virgo.dat			# Mesmo filtro
	cat Marte.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Marte_em_Leo.dat			# Mesmo filtro
	cat Venus.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Venus_em_Leo.dat			# Mesmo filtro
	cat Mercurio.csv | awk -F';' '/Leo/{print $1}' | awk -F' ' '{print $1}' >> Mercurio_em_Leo.dat		# Mesmo filtro

	sed -i 's/\// /g' Jupiter_em_Virgo.dat		# Altera as barras das datas por espaço 
	sed -i 's/\// /g' Sol_em_Virgo.dat			# 
	sed -i 's/\// /g' Lua_em_Virgo.dat			# 
	sed -i 's/\// /g' Marte_em_Leo.dat			# 
	sed -i 's/\// /g' Venus_em_Leo.dat			# 
	sed -i 's/\// /g' Mercurio_em_Leo.dat		# 

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
	em_comum			# chama função em_comum
}

function instalador {
	echo
	echo "É A 1a. VEZ QUE VC ABRE ESSE PROGRAMA!"
	echo
	echo "Por isso, precisam ser baixados dois programas necessários para que esse este funcione..."
	echo "...E talvez o computador peça a sua senha."
	echo
	echo "Você já está conectado na internet? (s/n)?"
	read resp

	if test "$resp" == "s" || test "$resp" == "S"
	then
		echo "Começando a instalação..."
		sleep 3
		sudo apt-get install -y hdate
		sudo apt-get install -y itools
		sed -i 's/^instalador/#instalador/' 23-set.sh		# Nome desse script.
		echo
	else
		echo
		echo "Saindo do programa... Não se pode instalar!"
		exit
	fi
}

instalador		# Antes de tudo executará essa função para instalar os pacotes necessários para funcionar o pgm.

# Caso essa linha acima apareça comentada, é porque o esse programa já foi executado e o hdate e ical (itools) foram instalados.
# Se necessite re-instalar descomente a linha de cima (239) se estiver comentada!

filtra			# A partir da 2a execução desse script, essa será a primeira linha a ser executada. Ignorando a função instalador.
# Autor: Helio Giroto
