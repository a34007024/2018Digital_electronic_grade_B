Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity nox2_test is
	port(GCKP43,p13co,p14co:in std_logic;
	p6u5pe,p20u6pe,p1reset:out std_logic;
	--p1reset是用於十位數及個位數計數至0時停止計數的
	--p1reset是否要動作的判別訊號為p13co及p14co
	DCBAout,keyscan:out std_logic_vector(3 downto 0);
	keyin:in std_logic_vector(2 downto 0)
	);
end entity;

architecture main of nox2_test is
	--signal area
	signal keyinsignal:std_logic_vector(2 downto 0);
	signal p13cosignal,p14cosignal:std_logic_vector(1 downto 0);
	signal p1signal:std_logic;
	signal keynum:integer range 0 to 15;
	signal keyscansignal: std_logic_vector(3 downto 0);
	signal p6pesignal,p20pesignal:std_logic;
	signal freqDivider:std_logic_vector(15 downto 0);
	signal keyclock:std_logic;
	signal scanI:integer range 0 to 3;
	signal keyok,keyreset:std_logic;
	signal startupReset:std_logic:=0;
	--signal area
begin
	p1reset <= p13cosignal and p14cosignal;
	p20u6pe <= p20pesignal;
	p6u5pe 	<= p6pesignal;
	process(GCKP43)
	begin
		if rising_edge(GCKP43) then
			freqDivider <= freqDivider + 1;
			keyclock <= freqDivider(13);
			p13cosignal<=p13cosignal(0)&p13co;
			p14cosignal<=p14cosignal(0)&p14co;
		end if;
		
		if freqDivider(0)='1' then
			if startupReset = '0' then
				keynum<=0;
				p6pesignal<='1';
				p20pesignal<='1';
				startupReset <= p1reset;
			elsif keyok='1' then			
				
			elsif  then
			
			
			end if;
		end if;
	end process;
	
end architecture;














