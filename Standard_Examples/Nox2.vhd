--------No:11700-990202--鍵盤掃瞄裝置
Library IEEE;					--零件庫引用
Use IEEE.std_logic_1164.all;	--套件引用
Use IEEE.std_logic_unsigned.all;--套件引用

Entity  NoX2  is	--取檔名;GCKP43:4MHz石英晶體子板已內接於P43
   Port(GCKP43,P14Co,P13Co:in std_logic;		 --U5 U6 4510零值信號
		KeyIn:in std_logic_vector(2 downto 0); 	 --掃瞄輸入,接提升電阻至+3.3V
		KeyScan:out std_logic_vector(3 downto 0);--掃瞄輸出
		KeyCode:out integer range 0 to 15;		 --鍵值輸出
		PE:out std_logic_vector(1 downto 0); 	 --U5 U6 4510並列載入信號
		P1STOP:out std_logic					 --停止
		);
End;

Architecture  A  of  NoX2  is					--取電路名稱A
	--	鍵盤參數
	Signal I:integer range 0 to 3;		   		--按鍵檢查指標
	Signal KN:integer range 0 to 15;			--鍵值
	Signal Ki,Ko:std_logic_vector(3 downto 0);	--鍵盤掃瞄輸入輸出信號
	--	鍵盤重置 有效鍵,鍵盤內部旗標,內部重啟旗標
	Signal K_RESET,KoK,KS:std_logic;
	----------------------------------------------------------
	--除頻器
	Signal F:std_logic_vector(15 downto 0);
	--鍵盤掃瞄系統操做時脈
	Signal KCLK,P1:std_logic;	--停止信號
	--系統參數
	Signal MS:std_logic:='0';	--啟始旗標
	Signal PES:std_logic_vector(1 downto 0);--CD4510下載信號
	--檢測00值Co參數
	Signal P14P13CoS:std_logic_vector(1 downto 0);
Begin
	P1<=P14P13CoS(1) AND P14P13CoS(0);	--零值信號
	P1STOP<=P1;							--停止信號,NL3燈驅動信號輸出
	KeyScan<=Ko;						--掃瞄輸出15,19,16,18
	Ki<='1' & KeyIn;					--掃瞄輸入,接3個提升電阻10,4,2
		
	PE<=PES;							--U5 U6 CD4510_PE 下載信號輸出
	KCLK<=F(13);						--鍵盤掃瞄系統操做時脈
	Process(GCKP43)						--4MHz石英晶體振盪器時脈輸入
	Begin
	--除頻器--主控器
		If  Rising_Edge(GCKP43) Then
	--除頻器
			F<=F+1;	--除頻器
			--因應老舊測試機台問題
			--由10轉成09時,/Co可能的雜訊問題使得應檢人無法通過檢定
			--增列對策如下:
			P14P13CoS<=P14P13CoS(0) & (P14Co Nor P13Co);
			--如果S2於 Power On 失敗時,您就會無法取得乙級證照
			--不要緊由本主控器發出歸零下載信號,讓您保證成功
	--主控器
			--檢定場測試機台頻率特性良好時,以最高頻率運作(4MHz)
			--如遇檢定場測試機台頻率特性不佳時,宜將下載速率降低(2MHz)
			If F(0)='1' Then	--將下載速率降低(4MHz-->2MHz)之用
				If  MS='0' Then			--U5 U6 CD4510 歸零
					KeyCode<=0;			--零
					PES<="11";			--U5 U6啟動載入功能
					MS<=P1;				--等待U5 U6 CD4510 已歸零
				Elsif KoK='1' Then		--等待有效鍵信號
					KeyCode<=KN;		--輸出有效鍵值至U6 CD4510
					PES<="10";			--U6-->U5載入,原個位數載入十位數
					K_RESET<='0';		--重置鍵盤
				Elsif PES=2 Then 		
					PES<="01";			--鍵值-->U6載入
				Else
					PES<="00";			--取消載入功能
					K_RESET<='1';		--鍵盤再啟動
				End IF;
			End IF;				--將下載速率降低(4MHz-->2MHz)之用
		End IF;
	--鍵盤掃瞄
		If K_RESET='0' or KN=10 Then--超過有效鍵時重回預設值
			Ko<="1110";				--預設掃瞄碼
			KoK<='0';				--預設無 有效鍵
			KS<='0';				--預設無按鈕按下內部旗標
			KN<=0;					--預設鍵值為0
			I<=0;					--預設按鍵檢查指標為0
		Elsif Rising_Edge(KCLK) Then
			--已有按鈕按下時
			If KS='1' Then			
				if Ki=15 Then		--測試按鍵是否全放開
					KoK<='1';		--通知主控器處理有效鍵值
				End IF;
			--尚未有按鈕按下
			Elsif Ki(I)='0' Then	--檢查鍵值輸入位元
				KS<='1';			--有按鍵按下
				Ko<="0000";			--偵測所有按鍵0~9
			Else
				KN<=KN+1;					--計算新的鍵值
				Ko<=Ko(2 downto 0) & Ko(3);	--調整掃瞄輸出
				If Ko(3)='0' Then I<=I+1; 	--計算按鍵檢查指標 
				End IF;
			End IF;
		End IF;
	End Process;
End;

