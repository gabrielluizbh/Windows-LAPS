## Script de implantação do Windows LAPS - Créditos Gabriel Luiz - www.gabrielluiz.com #



#Atualiza o esquema do Active Directory do Windows Server.

Update-LapsADSchema



<# 

Informações:

O esquema do Active Directory do Windows Server deve ser atualizado antes de usar o Windows LAPS. 

Essa ação é executada usando o comando. É uma operação única para toda a floresta.


#>


# Conceder permissão ao dispositivo gerenciado para atualizar sua senha.


Set-LapsADComputerSelfPermission -Identity NewLaps


<# 

Informações:

O dispositivo gerenciado precisa receber permissão para atualizar sua senha.

Essa ação é executada definindo permissões herdáveis na Unidade Organizacional (UO) em que o dispositivo se encontra. 


#>


# Remover permissões de Direitos Estendidos


Find-LapsADExtendedRights -Identity newlaps


<# 

Informações:

Alguns usuários ou grupos já podem receber permissão de Direitos Estendidos na UO do dispositivo gerenciado. 

Essa permissão é problemática porque concede a capacidade de ler atributos confidenciais (todos os atributos de senha do Windows LAPS são marcados como confidenciais). 

Uma maneira de verificar quem recebe essas permissões é usando este comando.

#>



# Use este comando para iniciar uma rotação imediata de senhas. 

Reset-LapsPassword


<# 

Informações:

Comando deve ser executado no computador que e gerenciado pelo LAPS.

#>


# User este comando para atualizar o tempo de expiração da senha do Windows LAPS de um computador no Active Directory do Windows Server.


Set-LapsADPasswordExpirationTime -Identity DESKTOP-WIN11


<# 

Informações:

O Windows LAPS lê o tempo de expiração da senha do Active Directory do Windows Server durante cada ciclo de processamento de diretiva. 

Se a senha tiver expirado, uma nova senha será gerada e armazenada imediatamente.

Em algumas situações (por exemplo, após uma violação de segurança ou para testes ad-hoc), convém girar a senha antecipadamente. 

Para forçar manualmente uma rotação de senha, você pode usar o comando Reset-LapsPassword.

Você pode usar o comando para definir o tempo de expiração da senha agendada conforme armazenado no Active Directory do Windows Server.

Na próxima vez que o Windows LAPS for ativado para processar a diretiva atual, ele verá o tempo de expiração da senha modificada e girará a senha.

Se você não quiser esperar, poderá executar o comando Invoke-LapsPolicyProcessing.


#>


# Use para iniciar um ciclo de processamento de diretiva.


Invoke-LapsPolicyProcessing



<# 

Informações:

Na próxima vez que a LAPS do Windows acordar para processar a política atual, ele visualizará o tempo de expiração da senha modificada e girará a senha.

Caso não queira esperar, poderá executar o comando Invoke-LapsPolicyProcessing.

#>


# Força a atualização para processar a política de computadores.


gpupdate /target:computer /force




# Verificar a senha vigente do computador.

Get-LapsADPassword -Identity lapsAD2 -AsPlainText



# Importa o módulo do LAPS.


Import-Module LAPS



# Verifica todos os comando do Windows LAPS



gcm -Module LAPS



<# 

Referências:


https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-management-powershell?WT.mc_id=5003815

https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview?WT.mc_id=5003815


#>

