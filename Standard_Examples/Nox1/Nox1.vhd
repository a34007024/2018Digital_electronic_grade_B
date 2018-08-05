--------No:11700-990201----------
Library IEEE;					--零件庫引用
Use IEEE.std_logic_1164.all;	--套件引用
Use IEEE.std_logic_unsigned.all;--套件引用

Entity  NoX1  is	--取檔名;GCKP43:4MHz石英晶體子板內接於P43
	Port(GCKP43,P2CK1,P3S1,P4CK2:in std_logic;	--CK1,CLR,CK2
		 DCBA:out integer range 0 to 9;			--U6 D,C,B,A
		 ba:out integer range 0 to 3);			--U5 a,b
End;

Architecture  A  of  NoX1  is				 	--取電路名稱
	Signal CK1,CK2: std_logic;
	Signal N3,N2,N1,N0: integer range 0 to 9;	--千百十個 位數
	Signal S: integer range 0 to 3;			 	--掃瞄信號
	Signal CLR: std_logic_vector(1 downto 0);	--S1防雜訊用
Begin

Process(GCKP43)			--4MHz石英晶體振盪器時脈輸入
Begin

--時脈檢入器
	If  Rising_Edge(GCKP43)  Then
		CK1<=P2CK1;			--CK1計數時脈輸入,防雜訊
		CK2<=P4CK2;			--CK2掃瞄時脈輸入,防雜訊
		CLR<=CLR(0) & P3S1;	--S1輸入,防雜訊
	End IF;

--4位BCD碼計數器
	If	CLR=3  Then							 --S1歸零按鈕已確實按下
		N3<=0; N2<=0; N1<=0; N0<=0;			 --計數值歸零
	Elsif  Rising_Edge(CK1)  Then			 --計數時脈,正緣觸發
		If   N0/=9  Then	N0<=N0+1;		 --個位不等於9,個位+1就好
		Else	N0<=0;						 --個位等於9,個位歸零
			If  N1/=9  Then	N1<=N1+1;		 --十位不等於9,十位+1就好
			Else	N1<=0;					 --十位等於9,十位歸零
				If  N2/=9  Then	N2<=N2+1;	 --百位不等於9,百位+1就好
				Else	N2<=0;				 --百位等於9,百位歸零
					If  N3/=9  Then	N3<=N3+1;--千位不等於9,千位+1就好
					Else	N3<=0;			 --千位等於9,千位歸零
	End IF;End IF;End IF;End IF;End If;		 --共5個End If;

--掃瞄產生器	
	If  Rising_Edge(CK2)  Then
		S<=S+1;
	End IF;

End Process;

--產生掃瞄碼
	ba<=S;
--篩選計數值
	With S Select
		DCBA <=	N3 When 0,		--取千位數
			 	N2 When 1,		--取百位數
			 	N1 When 2,		--取十位數
			 	N0 When oThers;	--取個位數

End;

