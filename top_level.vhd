library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity top_level is
  Port (   btn : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(7 downto 0);
           led : out STD_LOGIC_VECTOR(7 downto 0);
           seg : out STD_LOGIC_VECTOR(6 downto 0);
           an: out STD_LOGIC_VECTOR(3 downto 0)
           );
           
           
end top_level;

architecture Behavioral of top_level is

component mono_pulse_generator is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           enable : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component seven_segment_display is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component instruction_decode is
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
end component;

component main_control is
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
end component;

component instruction_fetch is
    Port ( clk : in STD_LOGIC;
           branch_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           enable: in STD_LOGIC;
           reset: in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           next_seq_address : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component instruction_execute is
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
end component;

component memory_unit is
    Port ( clk : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (15 downto 0);
           write_data : in STD_LOGIC_VECTOR (15 downto 0);
           mem_write: in STD_LOGIC;
           read_data : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal MPG_en : STD_LOGIC_VECTOR(3 downto 0);
signal ssd_display: STD_LOGIC_VECTOR(15 downto 0);

signal instr : STD_LOGIC_VECTOR(15 downto 0);
signal next_addr: STD_LOGIC_VECTOR(15 downto 0);
signal rd1 : STD_LOGIC_VECTOR(15 downto 0);
signal rd2 : STD_LOGIC_VECTOR(15 downto 0);
signal write_data : STD_LOGIC_VECTOR(15 downto 0);
signal ext_imm : STD_LOGIC_VECTOR(15 downto 0);
signal ALURes: STD_LOGIC_VECTOR(15 downto 0);
signal branch_addr : STD_LOGIC_VECTOR(15 downto 0);
signal jump_addr: STD_LOGIC_VECTOR(15 downto 0);
signal mem_data: STD_LOGIC_VECTOR(15 downto 0);

signal alu_op : STD_LOGIC_VECTOR(1 downto 0);
signal func: STD_LOGIC_VECTOR(2 downto 0);

signal reg_dst : STD_LOGIC;
signal branch : STD_LOGIC;
signal jump: STD_LOGIC;
signal ext_op: STD_LOGIC;
signal mem_to_reg : STD_LOGIC;
signal mem_write : STD_LOGIC;
signal alu_src : STD_LOGIC;
signal reg_write : STD_LOGIC;
signal shift_a : STD_LOGIC;
signal zero: STD_LOGIC;
signal negative: STD_LOGIC;
signal PCSrc: STD_LOGIC;

signal reg1 : STD_LOGIC_VECTOR(31 downto 0);
signal reg2 : STD_LOGIC_VECTOR(75 downto 0);
signal reg3 : STD_LOGIC_VECTOR(53 downto 0);
signal reg4 : STD_LOGIC_VECTOR(33 downto 0);

begin

MPG: mono_pulse_generator port map ( btn => btn, clk => clk, enable => MPG_en(3 downto 0));

INSTR_FETCH: instruction_fetch port map (clk => clk, branch_address => branch_addr, jump_address => jump_addr, 
                                                jump => jump, PCSrc => PCSrc, enable => MPG_en(0), reset => MPG_en(1),
                                                instruction => instr, next_seq_address => next_addr); 

ID: instruction_decode port map (reg_write => reg_write, instruction => reg1(31 downto 16), reg_dst => reg_dst, ext_op => ext_op,
                                    rd1 => rd1, rd2 => rd2, write_data => write_data, ext_imm => ext_imm, func => func,
                                    sa => shift_a, clk => clk);
 
MC: main_control port map (instr => reg1(31 downto 29), reg_dst => reg_dst, branch => branch, jump => jump,
                            ext_op => ext_op, mem_to_reg => mem_to_reg, alu_op => alu_op, mem_write => mem_write,
                            alu_src => alu_src, reg_write => reg_write);

IE: instruction_execute port map (seq_addr => reg2(66 downto 51), rd1 => reg2(50 downto 35), rd2 => reg2(34 downto 19), ext_imm => reg2(18 downto 3), func => reg2(2 downto 0),
                                    sa => reg2(75), ALUSrc => reg2(68), ALUOp => reg2(70 downto 69), branch_addr => branch_addr, 
                                    ALURes => ALURes, negative => negative, zero => zero);                   

SSD: seven_segment_display port map (digit0 => ssd_display(3 downto 0), digit1 => ssd_display(7 downto 4),
                                        digit2 => ssd_display(11 downto 8), digit3 => ssd_display(15 downto 12),
                                        clk => clk, an => an, cat => seg);                             

MU: memory_unit port map (clk => clk, address => reg3(33 downto 18), write_data => reg3(15 downto 0), mem_write => reg3(51),
                            read_data => mem_data);

process(reg4(15 downto 0), reg4(33), reg1(31 downto 29), reg3(16))
begin
if(reg4(33) = '1') then
write_data <= mem_data;
elsif(reg1(31 downto 29) = "110") then
if(reg3(16) = '1') then
write_data <= X"0001";
else write_data <= (others => '0');
end if;
else 
write_data <= reg4(15 downto 0);
end if;
end process;

process(reg3(50), reg3(17))
begin
if(reg1(31 downto 29) = "101") then
PCSrc <= reg3(50) AND NOT reg3(17);
else
PCSrc <= reg3(50) AND reg3(17);
end if;
end process;   

jump_addr <= reg1(15 downto 13) & reg1(28 downto 16);                          

process(sw(0))
begin
if(sw(0) = '0') then                          
led(0) <= reg_dst;
led(1) <= branch;
led(2) <= jump;
led(3) <= ext_op;
led(4) <= mem_to_reg;
led(5) <= mem_write;
led(6) <= alu_src;
led(7) <= reg_write;
else 
led(7 downto 2) <= (others => '0');
led(1 downto 0) <= alu_op;
end if;
end process;      

process(sw(7 downto 5))
begin
case sw(7 downto 5) is
when "000" => ssd_display <= instr;
when "001" => ssd_display <= next_addr;
when "010" => ssd_display <= rd1;
when "011" => ssd_display <= rd2;
when "100" => ssd_display <= ext_imm;
when "101" => ssd_display <= ALURes;
when "110" => ssd_display <= mem_data;
when "111" => ssd_display <= write_data;
end case;
end process;

process(clk)
begin
if(rising_edge(clk)) then
reg1(31 downto 16) <= instr;
reg1(15 downto 0) <= next_addr;
end if;
end process;



process(clk)
begin
if(rising_edge(clk)) then
reg2(75) <= shift_a;
reg2(74) <= mem_to_reg;
reg2(73) <= reg_write;
reg2(72) <= mem_write;
reg2(71) <= branch;
reg2(70 downto 69) <= alu_op;
reg2(68) <= alu_src;
reg2(67) <= reg_dst;
reg2(66 downto 51) <= reg1(15 downto 0);
reg2(50 downto 35) <= rd1;
reg2(34 downto 19) <= rd2;
reg2(18 downto 3) <= ext_imm;
reg2(2 downto 0) <= func;

end if;
end process;

process(clk)
begin
if(rising_edge(clk)) then
reg3(53) <= reg2(74);
reg3(52) <= reg2(73);
reg3(51) <= reg2(72);
reg3(50) <= reg2(71);
reg3(49 downto 34) <= branch_addr;
reg3(33 downto 18) <= ALURes;
reg3(17) <= zero;
reg3(16) <= negative;
reg3(15 downto 0) <= reg2(40 downto 25);
end if;
end process;

process(clk)
begin
if(rising_edge(clk)) then
reg4(33 downto 32) <= reg3(53 downto 52);
reg4(31 downto 16) <= mem_data;
reg4(15 downto 0) <= reg3(33 downto 18);
end if;
end process;



                                                                     
end Behavioral;
