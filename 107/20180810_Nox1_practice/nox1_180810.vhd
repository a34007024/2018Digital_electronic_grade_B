Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logoc_unsigned.all;

entity nox1_180810 is
	port(GCKP43,p2ck1in,p4ck2in:in std_logic;
	DCBAoutputToU6:out integer range 0 to 9;
	p16outputB,p14outputA:out std_logic;
	p3s1CLR:in std_logic
	);
	
end entity;
--==================QwQ======================
architecture main of nox1_180810 is
	--signal area--
	signal p3s1CLRsignal,p2ck1signal,p4ck2signal:
	std_logic_vector(1 downto 0);--2bits的防雜訊處理
	signal N3,N2,N1,N0:integer range 0 to 9;
	--N3千位數，N2百位數，N1十位數，N0個位數
	signal twoBitsCounterOutput:std_logic_vector(1 downto 0);
	--signal area--
begin
	--main process area--
	process(GCKP43)--接收4MHz石英晶體的訊號
	begin
		--============偵測外部訊號===============
		if rising_edge(GCKP43)
			p2ck1signal <= p2ck1signal(0) & p2ck1in;
			p4ck2signal <= p4ck2signal(0) & p4ck2in;
			p3s1CLRsignal <= p3s1CLRsignal(0) & p3s1CLR;
		end if;
		--============偵測外部訊號===============
		
		--=============7SEG正數器==============
		if p3s1CLRsignal == "11"--如果清除鈕確實被按下
			N3<=0;N2<=0;N1<=0,N0<=0;--數字歸零
		elsif rising_edge(p2ck1signal)
			if N0 /= 9 then
				N0<=N0+1;
			elsif N0 = 9 then N0<=0;
				if N1 /= 9 then N1<=N1+1;
				elsif N1 = 9 then N1<=0;
					if N2 /= 9 then N2 <= N2+1;
					elsif N2 = 9 then N2<=0;
						if N3 /= 9 then N3<=N3+1;
						elsif N3 = 9 then
							N3<=0;N2<=0;N1<=0,N0<=0;--數字歸零
						end if;
					end if;
				end if;
			end if;
		end if;
		--=============7SEG正數器==============
		
		--=======7SEG顯示選擇器(選擇讓哪顆亮)======
		if rising_edge(p4ck2signal) then
			twoBitsCounterOutput <= twoBitsCounterOutput + '1';
		end if;
		--=======7SEG顯示選擇器(選擇讓哪顆亮)======
	end process;
	
	p16outputB <= twoBitsCounterOutput(1);
	p14outputA <= twoBitsCounterOutput(0);
	
	with twoBitsCounterOutput select
		DCBAoutputToU6 	<= N3 when "00",
						<= N2 when "01",
						<= N1 when "10",
						<= N0 when others;
	--main process area--
end architecture;














