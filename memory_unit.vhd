library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity memory_unit is
    Port ( clk : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           mem_write: in STD_LOGIC;
           read_data : out STD_LOGIC_VECTOR (15 downto 0));
end memory_unit;

architecture Behavioral of memory_unit is
type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (X"1010", X"1110", X"0110", X"10F3", X"3F0E", X"015B", X"673F",
                            X"135C", X"239B", X"FF7C", X"0001", X"1CBF", X"3BDD", X"12DC",
                            X"345A", X"1212", others=>X"0000");
                            

begin

process(clk)
begin
if rising_edge(clk) then
if mem_write = '1' then
RAM(conv_integer(address)) <= write_data;
end if;
read_data <= RAM(conv_integer(address));
end if;
end process;

end Behavioral;
