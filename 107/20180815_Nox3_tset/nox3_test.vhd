library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity nox3_test is
	Port(GCKP43:in std_logic;
		P22CLOCK,P7CKM,P19CKH:in std_logic;--秒,分,時 時脈信號輸入
		P20S1,P21S2,P5S3:in std_logic;	--S1調整/計時模式開關,S2時,S3分調整				
		H10o:out integer range 0 to 2;	--時十位輸出
		H0o	:out integer range 0 to 9;	--時個位輸出
		P4LED,P8CKM:out std_logic;	 	--LED秒閃爍信號,分時脈信號輸出
		P6S10To0:out std_logic		 	--秒十位歸零信號輸出
		);
end entity;

architecture main of nox3_test is
	Signal M0:std_logic_vector(3 downto 0);				--分歸零旗標
	CONSTANT M0S:std_logic_vector(3 downto 0):="0100";	--分歸零次數設定
	Signal CLOCK,CKHH:std_logic;						--秒,時  時脈信號
	CONSTANT L:integer:=4;								--濾波階數設定值
	Signal CKH:std_logic_vector(L downto 0);			--數位濾波器
	Signal H10S:integer range 0 to 2;					--時 十位數計時器
	Signal H0S :integer range 0 to 9;					--時 個位數計時器
	Signal S1,S2,S3 :std_logic_vector(2 downto 0);		--S1,S2,S3反彈跳
	Signal FS:std_logic;								--S1,S2,S3反彈跳時脈
	Signal F :std_logic_vector(15 downto 0);			--除頻器
begin
	P4LED<=CLOCK and not S1(2);			--D1 D2 LED驅動信號
	P6S10To0<=P7CKM or S1(2);			--U15歸零信號(秒10位數歸零)
	P8CKM<=	GCKP43	When M0<M0S		Else--Power On啟動分歸零功能
			P7CKM	When S1(2)='0'	Else CLOCK and S3(2);
	CKHH<=	CKH(L) 	When S1(2)='0' 	Else Not CLOCK and  S2(2);
	CKH(0)<='1';	--數位濾波器初始化設定
	H10o<=H10S;							--時十位數輸出
	H0o <=H0S;							--時個位數輸出
	FS<=F(13);	--供S1,S2,S3反彈跳時脈
	Process(GCKP43)		--4MHz石英晶體振盪器時脈輸入
	Begin
		If  Rising_Edge(GCKP43)  Then
			If M0<M0S  Then
			--檢測分歸零次數(延後發動監測)
				M0<=M0+(CKH(L) and F(15));
			Else
				CLOCK<=P22CLOCK;	--CLOCK輸入
			End If;
			F<=F+1;	--除頻器
		End If;
		For I in 1 to L Loop		--依L值產生L階數位濾波器
			If CKH(I-1)='1' and P19CKH='1' 	Then
				CKH(I)<='1';
			Elsif Rising_Edge(GCKP43) 		Then
				CKH(I)<='0';
			End IF;
		End loop;
	--S1反彈跳
		If (P20S1 and CKH(0))='0' 	Then
			S1<="000";
		Elsif  Rising_Edge(FS)  	Then
			S1<=S1+ not S1(2);
		End IF;
	--S2反彈跳
		If P21S2='0' or S1(2)='0' 	Then
			S2<="000";
		Elsif  Rising_Edge(FS)  	Then
			S2<=S2+ not S2(2);		
		End IF;
	--S3反彈跳
		If P5S3='0' or S1(2)='0' 	Then
			S3<="000";
		Elsif  Rising_Edge(FS)  	Then
			S3<=S3+ not S3(2);
		End IF;
	--24時計時器
		If M0<M0S Then
			H10S<=0;				--時十位數歸零
			H0S<=0;					--時個位數歸零
		ElsIf  Rising_edge(CKHH)  Then	--計時信號
			If  H10S<2  	Then		--小於20
				IF H0S/=9 	Then		--時個位數不等於9
					H0S<=H0S+1;		--只要將個位數加1
				Else				--時個位數等於9
					H0S<=0;			--時個位數歸零
					H10S<=H10S+1;	--時十位數加1
				End IF;
			Elsif H0S/=3 	Then	--大於19 及時個位不等於3
				H0S<=H0S+1;			--只要將個位數加1
			Else					--已經滿24小時
				H10S<=0;			--時十位數歸零
				H0S<=0;				--時個位數歸零
			End IF;
		End IF;
	End Process;
end architecture;











