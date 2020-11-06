library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branch_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           enable: in STD_LOGIC;
           reset: in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           next_seq_address : out STD_LOGIC_VECTOR (15 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is

type rom_memory is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);

signal instruction_memory : rom_memory := ( 
                             B"000_100_101_010_0_000", -- add $2, $4, $5 X"12A0"
                             B"000_110_111_011_0_001", -- sub $3, $6, $7 X"1BB1"
                             B"000_000_101_100_1_010", -- sll $4, $5 X"02CA"
                             B"000_000_101_001_1_011", -- srl $1, $5 X"029B"
                             B"000_000_000_000_0_000", -- NoOp
                             B"101_110_100_0000001",   -- bne $6, $4, 1 X"BA01"
                             B"000_010_011_101_0_100", -- and $5, $2, $3 X"1EB4"
                             B"000_100_011_010_0_101", -- or $2, $4, $3 X"11A5"
                             B"000_000_000_000_0_000", -- NoOp
                             B"000_000_000_000_0_000", -- NoOp
                             B"000_010_011_100_0_110", -- xor $4, $2, $3 X"09C6"
                             B"000_000_101_110_1_111", -- sra $6, $5 X"02EF"
                             B"001_011_101_000_0_001", -- addi $5, $2 1 X"2E81"
                             B"010_111_001_0000010",   -- lw $1, 2($7) X"5C82"
                             B"000_000_000_000_0_000", -- NoOp
                             B"000_000_000_000_0_000", -- NoOp
                             B"011_101_000_0000000",   -- sw $5, 0($1) X"7400"
                             B"100_100_111_0000010",   -- beq $7, $4, 2 X"9382"
                             B"110_011_010_0000100",   -- slti $2, $3, 4 X"CD04"
                             B"111_0000000000010",     -- j 2 "E002"
                             others => X"0000" 
                            );
                            
signal program_counter : STD_LOGIC_VECTOR(15 downto 0) := X"0000";                          

begin


              
process(clk)
begin
if(rising_edge(clk)) then
if(reset = '1') then
program_counter <= X"0000";

elsif(enable = '1') then
if(jump = '1') then
program_counter <= jump_address;
elsif(PCSrc = '1') then
program_counter <= branch_address;
else
program_counter <= program_counter + '1';
end if;
end if;
end if;
end process;

next_seq_address <= program_counter + '1';

instruction <= instruction_memory(conv_integer(program_counter));

end Behavioral;
