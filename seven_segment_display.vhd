library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity seven_segment_display is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_display;

architecture Behavioral of seven_segment_display is
signal count : STD_LOGIC_VECTOR(15 downto 0) := X"0000";
signal digit_out : STD_LOGIC_VECTOR(3 downto 0);

begin

process(clk)
begin
if(rising_edge(clk)) then
count <= count + '1';
end if;
end process;

with count(15 downto 14) select digit_out <=
digit0 when "00",
digit1 when "01",
digit2 when "10",
digit3 when "11";

with count(15 downto 14) select an <=
"1110" when "00",
"1101" when "01",
"1011" when "10",
"0111" when "11";

with digit_out select cat <=
"0000001" when X"0",
"1001111" when X"1",
"0010010" when X"2",
"0000110" when X"3",
"1001100" when X"4",
"0100100" when X"5",
"0100000" when X"6",
"0001111" when X"7",
"0000000" when X"8",
"0000100" when X"9",
"0001000" when X"A",
"1100000" when X"B",
"0110001" when X"C",
"1000010" when X"D",
"0110000" when X"E",
"0111000" when X"F";

end Behavioral;
