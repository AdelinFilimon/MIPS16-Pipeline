library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mono_pulse_generator is
    Port ( btn : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           enable : out STD_LOGIC_VECTOR (3 downto 0));
end mono_pulse_generator;

architecture Behavioral of mono_pulse_generator is

signal count: STD_LOGIC_VECTOR(15 downto 0) := X"0000";
signal en: STD_LOGIC;
signal q1: STD_LOGIC_VECTOR(3 downto 0);
signal q2: STD_LOGIC_VECTOR(3 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + '1';
        end if;
    end process;

en <= '1' when count=X"FFFF" else '0';

    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                q1 <= btn;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            q2 <= q1;
        end if;
    end process;

enable <= q1 and not q2;

end Behavioral;
