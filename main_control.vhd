library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity main_control is
    Port ( instr : in STD_LOGIC_VECTOR (2 downto 0);
           reg_dst : out STD_LOGIC;
           branch : out STD_LOGIC;
           jump: out STD_LOGIC;
           ext_op: out STD_LOGIC;
           mem_to_reg : out STD_LOGIC;
           alu_op : out STD_LOGIC_VECTOR(1 downto 0);
           mem_write : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           reg_write : out STD_LOGIC);
end main_control;

architecture Behavioral of main_control is

begin

process(instr)
begin
case instr is
when "000" =>
 reg_dst <= '1';
 reg_write <= '1';
 alu_src <= '0';
 branch <= '0';
 jump <= '0';
 mem_write <= '0';
 mem_to_reg <= '0';
 alu_op <= "10";
 ext_op <= '0';
when "001" =>
 reg_dst <= '0';
 reg_write <= '1';
 alu_src <= '1';
 branch <= '0';
 jump <= '0';
 mem_write <= '0';
 mem_to_reg <= '0';
 alu_op <= "00";
 ext_op <= '1';
when "010" => 
 reg_dst <= '0';
 reg_write <= '1';
 alu_src <= '1';
 branch <= '0';
 jump <= '0';
 mem_write <= '0';
 mem_to_reg <= '1';
 alu_op <= "00";
 ext_op <= '1';
when "011" => 
 reg_dst <= 'X';
 reg_write <= '0';
 alu_src <= '1';
 branch <= '0';
 jump <= '0';
 mem_write <= '1';
 mem_to_reg <= 'X';
 alu_op <= "00";
 ext_op <= '1';
when "100" => 
 reg_dst <= 'X';
 reg_write <= '0';
 alu_src <= '0';
 branch <= '1';
 jump <= '0';
 mem_write <= '0';
 mem_to_reg <= 'X';
 alu_op <= "01";
 ext_op <= '1';
when "101" =>
 reg_dst <= 'X';
 reg_write <= '0';
 alu_src <= '0';
 branch <= '1';
 jump <= '0';
 mem_write <= '0';
 mem_to_reg <= 'X';
 alu_op <= "01";
 ext_op <= '1';
when "110" =>
 reg_dst <= '0';
 reg_write <= '1';
 alu_src <= '0';
 branch <= '0';
 jump <= '0';
 mem_write <= '0';
 mem_to_reg <= '0';
 alu_op <= "01";
 ext_op <= '1';
when "111" =>
 reg_dst <= 'X';
 reg_write <= '0';
 alu_src <= '0';
 branch <= '1';
 jump <= '1';
 mem_write <= '0';
 mem_to_reg <= '0';
 alu_op <= "XX";
 ext_op <= '0';
end case;
end process;

end Behavioral;
