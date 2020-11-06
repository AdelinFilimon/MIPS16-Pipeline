library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 



entity instruction_execute is
    Port ( seq_addr : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
           branch_addr : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           negative: out STD_LOGIC;
           zero : out STD_LOGIC);
end instruction_execute;


architecture Behavioral of instruction_execute is
signal ALUControl : STD_LOGIC_VECTOR(2 downto 0);
signal second_op : STD_LOGIC_VECTOR(15 downto 0);
signal ALUOut : STD_LOGIC_VECTOR(15 downto 0);

begin

branch_addr <= seq_addr + ext_imm;

second_op <= rd2 when ALUSrc = '0' else ext_imm;



process(ALUOp)
begin
case ALUOp is
when "10" => ALUControl <= func;
when "00" => ALUControl <= "000";
when "01" => ALUControl <= "001";
when "11" => ALUControl <= "000";
end case;
end process;

process(ALUControl)
begin
case ALUControl is
when "000" =>
ALUOut <= rd1 + second_op;
when "001" =>
ALUOut <= rd1 - second_op;
when "010" =>
if(sa = '1') then
ALUOut <= second_op(14 downto 0) & '0';
else 
ALUOut <= second_op;
end if;
when "011" =>
if(sa = '1') then
ALUOut <= '0' & second_op(15 downto 1);
else
ALUOut <= second_op;
end if;
when "100" =>
ALUOut <= rd1 AND second_op;
when "101" =>
ALUOut <= rd1 OR second_op;
when "110" =>
ALUOut <= rd1 XOR second_op;
when "111" =>
ALUOut <= second_op(0) & second_op(15 downto 1);
end case;
end process;

ALURes <= ALUOut;
zero <= '1' when ALUOut = X"0000" else '0';
negative <= '1' when signed(ALUOut) < 0 else '0';

end Behavioral;
