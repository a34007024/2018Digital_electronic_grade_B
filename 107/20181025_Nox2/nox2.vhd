Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--==================================
entity nox2 is
	port(
		GCKP43,P13co,P14co:in std_logic;
		D,C,B,A:out integer range 0 to 15;
	);
end entity;
--==================================
architecture main of nox2 is
signal freq:std_logic_vector(15 downto 0);

begin
	process(GCKP43)
	begin
		if rising_edge(GCKP43)	then
			freq <= freq + 1;
		end if;
		
	end process;
end architecture;







