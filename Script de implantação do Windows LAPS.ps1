## Script de implanta��o do Windows LAPS - Cr�ditos Gabriel Luiz - www.gabrielluiz.com #



#Atualiza o esquema do Active Directory do Windows Server.

Update-LapsADSchema



<# 

Informa��es:

O esquema do Active Directory do Windows Server deve ser atualizado antes de usar o Windows LAPS. 

Essa a��o � executada usando o comando. � uma opera��o �nica para toda a floresta.


#>


# Conceder permiss�o ao dispositivo gerenciado para atualizar sua senha.


Set-LapsADComputerSelfPermission -Identity NewLaps


<# 

Informa��es:

O dispositivo gerenciado precisa receber permiss�o para atualizar sua senha.

Essa a��o � executada definindo permiss�es herd�veis na Unidade Organizacional (UO) em que o dispositivo se encontra. 


#>


# Remover permiss�es de Direitos Estendidos


Find-LapsADExtendedRights -Identity newlaps


<# 

Informa��es:

Alguns usu�rios ou grupos j� podem receber permiss�o de Direitos Estendidos na UO do dispositivo gerenciado. 

Essa permiss�o � problem�tica porque concede a capacidade de ler atributos confidenciais (todos os atributos de senha do Windows LAPS s�o marcados como confidenciais). 

Uma maneira de verificar quem recebe essas permiss�es � usando este comando.

#>



# Use este comando para iniciar uma rota��o imediata de senhas. 

Reset-LapsPassword


<# 

Informa��es:

Comando deve ser executado no computador que e gerenciado pelo LAPS.

#>


# User este comando para atualizar o tempo de expira��o da senha do Windows LAPS de um computador no Active Directory do Windows Server.


Set-LapsADPasswordExpirationTime -Identity DESKTOP-WIN11


<# 

Informa��es:

O Windows LAPS l� o tempo de expira��o da senha do Active Directory do Windows Server durante cada ciclo de processamento de diretiva. 

Se a senha tiver expirado, uma nova senha ser� gerada e armazenada imediatamente.

Em algumas situa��es (por exemplo, ap�s uma viola��o de seguran�a ou para testes ad-hoc), conv�m girar a senha antecipadamente. 

Para for�ar manualmente uma rota��o de senha, voc� pode usar o comando Reset-LapsPassword.

Voc� pode usar o comando para definir o tempo de expira��o da senha agendada conforme armazenado no Active Directory do Windows Server.

Na pr�xima vez que o Windows LAPS for ativado para processar a diretiva atual, ele ver� o tempo de expira��o da senha modificada e girar� a senha.

Se voc� n�o quiser esperar, poder� executar o comando Invoke-LapsPolicyProcessing.


#>


# Use para iniciar um ciclo de processamento de diretiva.


Invoke-LapsPolicyProcessing



<# 

Informa��es:

Na pr�xima vez que a LAPS do Windows acordar para processar a pol�tica atual, ele visualizar� o tempo de expira��o da senha modificada e girar� a senha.

Caso n�o queira esperar, poder� executar o comando Invoke-LapsPolicyProcessing.

#>


# For�a a atualiza��o para processar a pol�tica de computadores.


gpupdate /target:computer /force




# Verificar a senha vigente do computador.

Get-LapsADPassword -Identity lapsAD2 -AsPlainText



# Importa o m�dulo do LAPS.


Import-Module LAPS



# Verifica todos os comando do Windows LAPS



gcm -Module LAPS



<# 

Refer�ncias:


https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-management-powershell?WT.mc_id=5003815

https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview?WT.mc_id=5003815


#>

