Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.std_logic_unsigned.all;

Entity Nox2_practice is
	port(
	GCKP43,p14co,p13co:in std_logic;
	keyin:in std_logic_vector(2 downto 0);--接收鍵盤按下資訊，利用keyscan送出的編碼+keyin收到的編碼來判斷是哪個鍵被按下了
	keyscan:out std_logic_vector(3 downto 0);
--分別送出訊號給不同列的鍵盤，以偵測鍵盤是否按下
	keycode:out integer range 0 to 15;--把按鍵值以BCD碼輸出給機台
	pe:out std_logic_vector(1 downto 0);--U5 U6 4510並列載入預設信號的Enable觸發接腳，在設定7SEG數字狀態及把7SEG變為00時會用到
	p1stop:out std_logic--偵測停止按鈕是否按下
	);
	
end Nox2_practice;


Architecture main of Nox2_practice is
	-----Signal Define Area-----
	--鍵盤參數
	Signal I:integer range 0 to 3;
	--儲存keyscan掃瞄到第幾行
	Signal kn:integer range 0 to 15;--接收到的按鍵數值
	Signal ki,ko:std_logic_vector(3 downto 0);
	--
	Signal k_reset,kok,ks:std_logic;
	----------------------
	--除頻器
	Signal f:std_logic_vector(15 downto 0);
	--
	Signal kclk,p1:std_logic;
	--
	Signal ms:std_logic:='0';
	Signal pes:std_logic_vector(1 downto 0);
	--
	Signal p14p13cos:std_logic_vector(1 downto 0);
	-----Signal Define Area-----
begin
	p1 <= p14p13cos(1) and p14p13cos(0);
	p1stop <= p1;
	keyscan<=ko;
	ki<='1'&keyin;
	pe<=pes;
	kclk<=f(13);
	process(GCKP43)
	begin
	--除頻器--主控器
		--除頻器
		If rising_edge(GCKP43) then
			f<=f+1;
			--
			p14p13cos<=p14p13cos(0) & (p14co nor p13co);
		--主控器
			If f(0) = '0' then
				If ms='0'then
					keycode<=0;
					pes<="11";
					ms<=p1;
				Elsif kok = '1' then
					keycode <= kn;
					pes<="10";
					k_reset<='0';
				Elsif pes=2 then
					pes<="01";
				Else
					pes<="00";
					k_reset<='1';
				End if;
			End if;
		End if;
		--鍵盤掃描
		If k_reset ='0' or kn=10 then
			ko<="1110";
			kok<='0';
			ks<='0';
			kn<=0;
			I<=0;
		elsif rising_edge(kclk) then
			if ks='1' then
				if ki=15 then
					kok<='1';
				end if;
			elsif ki(I)='0' then
				ks<='1';
				ko<="0000";
			else
				kn<=kn+1;
				ko<=ko(2 downto 0) & ko(3);
				if ko(3)='0' then
					I<=I+1;
				end if;
			end if;
		end if;
	end process;
end main;






















