Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity nox3 is
	port(
		GCKP43:in std_logic;
		p22clock,p7ckm,p19ckh:in std_logic;
		p20s1,p21s2,p5s3:in std_logic;
		h10o:out integer range 0 to 2;
		h0o:out integer range 0 to 9;
		p4led,p8ckm:out std_logic;
		p6s10to0:out std_logic
	);
end entity;
---------------------------------------
architecture main of nox3 is

begin 
	process(GCKP43)
	begin
		
	end process;
end architecture;