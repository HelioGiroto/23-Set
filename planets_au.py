import ephem			# Instalar este módulo com PIP - Ver: https://pypi.python.org/pypi/ephem/
import time

planeta = ephem.Venus()		# Objeto (planeta) a ser pesuisado)
nome = "venus"			# Só para ter nome do arquivo e para efeito de imprimir o nome em pt-br
anos = 40			# qtde de anos que será pesquisado	(40 anos após 1o. Jan de 2000)
dias = 366			# Quantidade de dias (366 para anos bissextos)
dia = ephem.Date('2000/01/01')	# data convertida em aaaa/mm/dd

print()
print('Distancias entre Vênus e o planeta Terra:')
# print()

arq=open(nome+".csv", "a+")	# Cria arquivo venus.csv para escrever (append) os dados...

for rep in range(int(anos)):		
	for i in range(int(dias)):	
		data = ephem.Date(dia)					# Para não imprimir em data Linux, mas em formato aaaa/m/d		
		constelacao = ephem.constellation(ephem.Venus(dia))	# Nome da constelação em que o planeta será visto
		au = ephem.Venus(dia).earth_distance			# UA - distância da terra.
		
		# Se quiser imprimir num ARQUIVO use essas 2 linhas abaixo, senão comente-as
		arq.write(str(data) + str(";") + str(constelacao) + str(";") + str(au))
		arq.write('\n')

		# Se quiser imprimir na TELA descomente essa abaixo:
		# print(data, "- Constel.:", constelacao, "Distância da Terra (UA):", au)

		dia += 1	# Avança um dia e volta a realizar o laço de dias e anos até atingir o limite.

print('HOJE, Vênus está em:', ephem.constellation(ephem.Venus(ephem.now())), 'à', ephem.Venus(ephem.now()).earth_distance, 'UA da Terra.') 
print()
# $ cat Venus.csv | sort -t';' -k3 | head -n50 | cat -n		# Para ver lista das 50 maiores aproximações de Vênus da Terra.

# Autor: Helio Giroto
