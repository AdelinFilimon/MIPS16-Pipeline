library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity instruction_decode is
    Port ( reg_write : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           reg_dst : in STD_LOGIC;
           ext_op : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           clk : in STD_LOGIC);
end instruction_decode;


architecture Behavioral of instruction_decode is
component register_file is
    Port ( read_address1 : in STD_LOGIC_VECTOR (2 downto 0);
           read_address2 : in STD_LOGIC_VECTOR (2 downto 0);
           write_address : in STD_LOGIC_VECTOR (2 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           reg_write : in STD_LOGIC;
           read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
           read_data2 : out STD_LOGIC_VECTOR(15 downto 0));
end component;

signal write_addr : STD_LOGIC_VECTOR(2 downto 0);
signal sign_ext1: STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
signal sign_ext2: STD_LOGIC_VECTOR(8 downto 0) := (others => '1');

begin

RF: register_file port map (read_address1 => instruction(12 downto 10), read_address2 => instruction(9 downto 7),
                            write_address => write_addr, write_data => write_data, clk => clk, reg_write => reg_write,
                            read_data1 => rd1, read_data2 => rd2);

write_addr <= instruction(9 downto 7) when reg_dst = '0'
              else instruction(6 downto 4);

ext_imm <= sign_ext1 & instruction(6 downto 0) when (ext_op = '0' or (ext_op = '1' and instruction(6) = '0'))
           else sign_ext2 & instruction(6 downto 0);                          

func <= instruction(2 downto 0);
sa <= instruction(3);

end Behavioral;
