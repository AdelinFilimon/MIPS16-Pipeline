library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity register_file is
    Port ( read_address1 : in STD_LOGIC_VECTOR (2 downto 0);
           read_address2 : in STD_LOGIC_VECTOR (2 downto 0);
           write_address : in STD_LOGIC_VECTOR (2 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           reg_write : in STD_LOGIC;
           read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
           read_data2 : out STD_LOGIC_VECTOR(15 downto 0));
end register_file;


architecture Behavioral of register_file is
type register_file_memory is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);

signal rfm : register_file_memory := (X"0000", X"1110", X"0110", X"10F3", X"3F0E", X"015B", X"673F",
                            X"0002");
                            
begin

process(clk)
begin
if(rising_edge(clk)) then
if(reg_write = '1') then
rfm(conv_integer(write_address)) <= write_data;
end if;
end if;
end process;

read_data1 <= rfm(conv_integer(read_address1));
read_data2 <= rfm(conv_integer(read_address2));

end Behavioral;
