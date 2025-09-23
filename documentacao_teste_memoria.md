# PROGRAMA DE TESTE DE MEMÓRIA
## Teste de instruções LW (Load Word) e SW (Store Word)

### OBJETIVO
Este programa testa o armazenamento e carregamento de dados na memória RAM, verificando se as instruções SW e LW funcionam corretamente.

### ANÁLISE DO CÓDIGO BINÁRIO

| Linha | Código Binário | Instrução | Operação | Descrição |
|-------|---------------|-----------|----------|-----------|
| 1 | `10001000000000010000000000000000` | **INPUT** R1 | R1 = switches | Lê primeiro valor dos switches |
| 2 | `10000000000000100000000000000000` | **OUTPUTREG** R1 | Display = R1 | Mostra o valor lido |
| 3 | `01101000000000010000000000000001` | **SW** R1, 1(R0) | MEM[0+1] = R1 | Armazena R1 no endereço 1 |
| 4 | `10001000000001000000000000000000` | **INPUT** R4 | R4 = switches | Lê segundo valor dos switches |
| 5 | `10000000000100000000000000000000` | **OUTPUTREG** R4 | Display = R4 | Mostra o valor lido |
| 6 | `01101000000001000000000000000010` | **SW** R4, 2(R0) | MEM[0+2] = R4 | Armazena R4 no endereço 2 |
| 7 | `01100100000001010000000000000001` | **LW** R5, 1(R0) | R5 = MEM[0+1] | Carrega da memória para R5 |
| 8 | `01100100000001100000000000000010` | **LW** R6, 2(R0) | R6 = MEM[0+2] | Carrega da memória para R6 |
| 9 | `10000000000101000000000000000000` | **OUTPUTREG** R5 | Display = R5 | Mostra valor de R5 (1º valor) |
| 10 | `10000000000110000000000000000000` | **OUTPUTREG** R6 | Display = R6 | Mostra valor de R6 (2º valor) |
| 11 | `00000000101001100001110000000000` | **ADD** R7, R5, R6 | R7 = R5 + R6 | Soma os valores da memória |
| 12 | `10000000000111000000000000000000` | **OUTPUTREG** R7 | Display = R7 | Mostra resultado da soma |
| 13 | `01101000000001110000000000000011` | **SW** R7, 3(R0) | MEM[0+3] = R7 | Armazena resultado na memória |
| 14 | `01100100000010000000000000000011` | **LW** R8, 3(R0) | R8 = MEM[0+3] | Carrega resultado da memória |
| 15 | `10000000001000000000000000000000` | **OUTPUTREG** R8 | Display = R8 | Mostra valor carregado |
| 16 | `01111000000000000000000000000000` | **HALT** | - | Para a execução |

### BREAKDOWN DETALHADO POR INSTRUÇÃO

**Linha 1**: `10001000000000010000000000000000`
- **OPCODE**: `100010` (INPUT)
- **RT**: `000001` (R1)
- **Operação**: R1 = switches (lê primeiro valor)

**Linha 2**: `10000000000000100000000000000000`
- **OPCODE**: `100000` (OUTPUTREG)
- **RS**: `000001` (R1)
- **Operação**: Display = R1 (mostra valor lido)

**Linha 3**: `01101000000000010000000000000001`
- **OPCODE**: `011010` (SW - Store Word)
- **RS**: `000000` (R0 - registrador base)
- **RT**: `000001` (R1 - registrador fonte)
- **OFFSET**: `00000000000001` (1)
- **Operação**: MEM[R0 + 1] = R1 → MEM[1] = valor_inserido_1

**Linha 4**: `10001000000001000000000000000000`
- **OPCODE**: `100010` (INPUT)
- **RT**: `000100` (R4)
- **Operação**: R4 = switches (lê segundo valor)

**Linha 5**: `10000000000100000000000000000000`
- **OPCODE**: `100000` (OUTPUTREG)
- **RS**: `000100` (R4)
- **Operação**: Display = R4 (mostra valor lido)

**Linha 6**: `01101000000001000000000000000010`
- **OPCODE**: `011010` (SW)
- **RS**: `000000` (R0)
- **RT**: `000100` (R4)
- **OFFSET**: `00000000000010` (2)
- **Operação**: MEM[R0 + 2] = R4 → MEM[2] = valor_inserido_2

**Linha 7**: `01100100000001010000000000000001`
- **OPCODE**: `011001` (LW - Load Word)
- **RS**: `000000` (R0)
- **RT**: `000101` (R5)
- **OFFSET**: `00000000000001` (1)
- **Operação**: R5 = MEM[R0 + 1] → R5 = MEM[1] = valor_inserido_1

**Linha 8**: `01100100000001100000000000000010`
- **OPCODE**: `011001` (LW)
- **RS**: `000000` (R0)
- **RT**: `000110` (R6)
- **OFFSET**: `00000000000010` (2)
- **Operação**: R6 = MEM[R0 + 2] → R6 = MEM[2] = valor_inserido_2

**Linhas 9-10**: Exibem os valores carregados da memória no display

**Linha 11**: `00000000101001100001110000000000`
- **OPCODE**: `000000` (ADD)
- **RS**: `000101` (R5)
- **RT**: `000110` (R6)
- **RD**: `000111` (R7)
- **Operação**: R7 = R5 + R6 = valor_1 + valor_2

**Linhas 12-15**: Armazenam e carregam o resultado da soma

### RESULTADO ESPERADO
Se a memória estiver funcionando corretamente, o programa deve:
1. Solicitar primeiro valor via switches e exibi-lo
2. Solicitar segundo valor via switches e exibi-lo
3. Exibir o primeiro valor (carregado da memória)
4. Exibir o segundo valor (carregado da memória)
5. Exibir a soma dos dois valores
6. Exibir a soma novamente (carregada da memória após armazenamento)

### COMO TESTAR
1. **Execute o programa**
2. **Quando solicitar o primeiro valor**: Configure os switches com um valor (ex: 5) e avance
3. **Quando solicitar o segundo valor**: Configure os switches com outro valor (ex: 3) e avance
4. **Observe as saídas**: Deve mostrar 5, 3, 5, 3, 8, 8

### TESTE DE INTEGRIDADE
Este programa verifica:
- **SW (Store Word)**: Se consegue armazenar dados na memória
- **LW (Load Word)**: Se consegue carregar dados da memória
- **Integridade dos dados**: Se os valores permanecem íntegros após armazenamento/carregamento
- **Operações aritméticas com dados da memória**: Se pode operar com valores carregados da memória

### ENDEREÇOS DE MEMÓRIA UTILIZADOS
- **Endereço 1**: Armazena valor 10
- **Endereço 2**: Armazena valor 20  
- **Endereço 3**: Armazena resultado da soma (30)

### REGISTRADORES UTILIZADOS
- **R0**: Registrador base (sempre 0)
- **R1**: Primeiro valor inserido via switches
- **R4**: Segundo valor inserido via switches
- **R5**: Primeiro valor carregado da memória
- **R6**: Segundo valor carregado da memória
- **R7**: Resultado da soma
- **R8**: Resultado carregado da memória para verificação

### PRINCIPAIS CORREÇÕES IMPLEMENTADAS
1. **Adicionado INPUT**: O programa agora usa INPUT para ler valores dos switches
2. **Interatividade**: O usuário pode inserir os valores de teste
3. **Verificação completa**: Testa tanto escrita quanto leitura da memória
4. **Feedback visual**: Mostra cada etapa do processo no display
5. **Codificação correta**: Todas as instruções seguem o formato da documentação
