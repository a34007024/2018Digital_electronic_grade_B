Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity nox1_test is 
	port(p2ck1in,p4ck2in,GCKP43:in std_logic;
	p3s1in:in std_logic;
	p14p16ba:out std_logic_vector(1 downto 0);
	DCBAout:out integer range 0 to 9);
end entity;

architecture main of nox1_test is
	signal ck1signal,ck2signal:std_logic;
	signal p3s1signal:std_logic_vector(1 downto 0);
	signal N3,N2,N1,N0:integer range 0 to 9;
	signal p14p16baSignal:std_logic_vector(1 downto 0);
begin
	process(GCKP43)
	begin
		if rising_edge(GCKP43) then
			ck1signal<=p2ck1in;
			ck2signal<=p4ck2in;
			p3s1signal <= p3s1signal(0) & p3s1in;
		end if;
		
		if p3s1signal = "11" then
			N3<=0;N2<=0;N1<=0;N0<=0;
		elsif rising_edge(ck1signal) then
			if N0/=9 then N0<=N0+1;
			else N0<=0;
				if N1/=9 then N1<=N1+1;
				else N1<=0;
					if N2/=9 then N2<=N2+1;
					else N2<=0;
						if N3/=9 then N3<=N3+1;
						else N3<=0;N2<=0;N1<=0;N0<=0;
						end if;
					end if;
				end if;
			end if;
		end if;
		
		if rising_edge(ck2signal) then
			p14p16baSignal <= p14p16baSignal+1;
		end if;
		
		end process;
		p14p16ba<=p14p16baSignal;
		
		with p14p16baSignal select
		DCBAout <= 	N3 when "00",
					N2 when "01", 
					N1 when "10",
					N0 when others;
	
end architecture;













