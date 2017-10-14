def edita():
	fonte = open('datas_comuns_bruto.txt').read()
	saida = open('DATAS_COMUNS.txt', 'w')

	texto = str(fonte)

	modifica1 = texto.replace("'", "")
	modifica2 = modifica1.replace("{", "")
	modifica3 = modifica2.replace("}", "")
	resultado = modifica3.replace(r"\n", "")

	saida.write(resultado)
	saida.close()



def compara():

	jup = open('Jupiter_filtrado.txt', 'r')
	mar = open('Marte_filtrado.txt', 'r')
	mer = open('Mercurio_filtrado.txt', 'r')
	ven = open('Venus_filtrado.txt', 'r')
	sat = open('Saturno_filtrado.txt', 'r')
	sol = open('Sol_filtrado.txt', 'r')
	lua = open('Lua_filtrado.txt', 'r')

	comm = set(jup) & set(mar) & set(mer) & set (ven) & set (sol) & set(lua)

	texto = str(comm)

	saida = open('datas_comuns_bruto.txt', 'a')
	saida.write(texto)
	saida.close()

	edita()


def filtra():

	planetas = ["Marte", "Jupiter", "Mercurio", "Venus", "Saturno", "Sol", "Lua"]
	localiza = ["Leo", "Virgo", "Leo", "Leo", "Leo", "Virgo", "Virgo"] 
	nro = 0

	for planeta in planetas:
		arq1 = planeta+".txt"
		arq2 = planeta+"_filtrado.txt"

		arqFonte = open(arq1, 'r')
		arqSaida = open(arq2, 'a')

		for cada_linha in arqFonte:
			dia = cada_linha.split('-')[0]
			constelacao = cada_linha.split('-')[1]

			if constelacao == localiza[nro]+'\n':
				arqSaida.write(dia + '\n')
				print('Encontrado!', cada_linha)
		arqSaida.close()
		nro += 1

	print('Terminado')

	compara()




def corta():

	planetas=["Marte", "Jupiter", "Mercurio", "Venus", "Saturno", "Sol", "Lua"]

	for planeta in planetas:
	
		arqCSV=planeta+".csv"			# Concatena variável para formar nome dos arquivos
		arqTXT=planeta+".txt"

	#	arqFonte='Marte.csv'
	#	arqSaida=open('marte.txt', 'a')

		arqFonte=open(arqCSV, 'r')
		arqSaida=open(arqTXT, 'a')

		for linha in arqFonte:
			corte1=linha.split(';')[0]	# Pega primeira coluna
			corte2=corte1.split(' ')[0]	# Faz outro corte do que já cortei acima
			corteA=linha.split(';')[1]	# Pega segunda coluna
			corteB=corteA.split("'")[3]	# Faz outro corte na linha acima - Ver *OBS

			print(corte2, corteB)		# Imprime na tela ao mesmo tempo que grava em arquivo. Ver abaixo:
			arqSaida.write(corte2 + '-' + corteB + '\n')

		arqSaida.close()				# Fecha arquivo de escrita (de saida)
		#arqFonte.close() - Nao precisa fechar arq aberto para leitura!!! Dá erro.

	filtra()

	"""

	(*) OBS - Este é o modelo de cada linha do arqFonte:

	2017/10/12 00:00:00;('Vir', 'Virgo');13:53:23.08;-10:32:04.1;13:54:17.90;-10:37:02.8

	"""



corta()
