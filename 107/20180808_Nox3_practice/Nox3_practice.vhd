Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_unsigned.all;

entity Nox3_practice is 
	port(
	GCKP43:in std_logic;
	p22clock,p7ckm,p19ckh:in std_logic;
	p20s1,p21s2,p5s3:in std_logic;
	
	h10o:out integer range 0 to 2;
	h0o:out integer range 0 to 9;
	
	p8ckm,p4led,p6s10to0:out std_logic
	);
end Nox3_practice;
--===========================================
architecture main of Nox3_practice is
	--Signal & costant value define area
	signal m0:std_logic_vector(3 downto 0);
	constant m0s:std_logic_vector(3 downto 0):="0100";
	
	signal clock,ckhh:std_logic;
	
	constant L:integer:=4;
	signal ckh:std_logic_vector(L downto 0);
	
	signal h10s:integer range 0 to 2;
	signal h0s:integer range 0 to 9;
	
	signal s1,s2,s3:std_logic_vector(2 downto 0);
	signal fs:std_logic;
	signal f:std_logic_vector(15 downto 0);
	--Signal & costant value define area
begin
	p4led<=clock and not(s1(2));
	p6s10to0<=p7ckm or s1(2);
	--以上是秒的計數功能
	p8ckm<=	GCKP43 when m0<m0s 		else
			p7ckm  when s1(2)='0'	else
			clock and s3(2);
	--以上是分鐘的計數功能
	ckhh<=	ckh(L)	when s1(2)='0'	else
			(not clock) and s2(2);
	ckh(0)<='1';
	
	h10o<=h10s;
	h0o	<=h0s;
	--以上為小時的計數功能
	fs<=f(13);
	----------------------------------------
	process(GCKP43)
	begin
		if rising_edge(GCKP43) then
			if m0<m0s then
				m0<=m0+(ckh(L) and f(15));
			else 
				clock<=p22clock;
			end if;
			------------------
			f<=f+1;--除頻器
		end if;
		--=================================
		for I in 1 to L loop
			if ckh(I-1)='1' and p19ckh='1' then
				ckh(I)<='1';
			elsif rising_edge(GCKP43) then
				ckh(I)<='0';
			end if;
			
		end loop;
		--==================================
		--s1反彈跳
		if (p20s1 and ckh(0)) = '0' then
			s1 <= "000";
		elsif rising_edge(fs) then
			s1 <= s1 + not(s1(2));
		end if;
		--s2反彈跳
		if p21s2 = '0' or s1(2)='0' then
			s2 <= "000";
		elsif rising_edge(fs) then
			s2 <= s2 + not(s2(2));
		end if;
		--s3反彈跳
		if p5s3 = '0' or s1(2)='0' then
			s3 <= "000";
		elsif rising_edge(fs) then
			s3 <= s3 + not(s3(2));
		end if;
		
		--=============OwO=================
		if m0<m0s then
			h10s<=0;
			h0s<=0;
		elsif rising_edge(ckhh) then
			if h10s<2 then
				if h0s /= 9 then
					h0s<=h0s+1;
				else
					h0s<=0;
					h10s<=h10s+1;
				end if;
			elsif h0s /= 3 then
				h0s<=h0s+1;
			else
				h10s<=0;
				h0s<=0;
			end if;
		end if;
	end process;
	
end main;














