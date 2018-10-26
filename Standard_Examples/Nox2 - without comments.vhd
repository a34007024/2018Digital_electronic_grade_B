--------No:11700-990202--¡‰ΩL±Ω∫À∏À∏m
Library IEEE;					
Use IEEE.std_logic_1164.all;	
Use IEEE.std_logic_unsigned.all;

Entity  NoX2  is
   Port(GCKP43,P14Co,P13Co:in std_logic;		 
		KeyIn:in std_logic_vector(2 downto 0); 	 
		KeyScan:out std_logic_vector(3 downto 0);
		KeyCode:out integer range 0 to 15;		 
		PE:out std_logic_vector(1 downto 0); 	 
		P1STOP:out std_logic					 
		);
End;

Architecture  A  of  NoX2  is				
	Signal I:integer range 0 to 3;		   	
	Signal KN:integer range 0 to 15;		
	Signal Ki,Ko:std_logic_vector(3 downto 0);
	Signal K_RESET,KoK,KS:std_logic;
	----------------------------------------
	Signal F:std_logic_vector(15 downto 0);
	Signal KCLK,P1:std_logic;
	Signal MS:std_logic:='0';
	Signal PES:std_logic_vector(1 downto 0);
	Signal P14P13CoS:std_logic_vector(1 downto 0);
Begin
	P1<=P14P13CoS(1) AND P14P13CoS(0);
	P1STOP<=P1;						
	KeyScan<=Ko;					
	Ki<='1' & KeyIn;
	PE<=PES;						
	KCLK<=F(13);
	Process(GCKP43)					
	Begin
		If  Rising_Edge(GCKP43) Then
			F<=F+1;	
			P14P13CoS<=P14P13CoS(0) & (P14Co Nor P13Co);
			If F(0)='1' Then
				If  MS='0' Then			
					KeyCode<=0;			
					PES<="11";			
					MS<=P1;				
				Elsif KoK='1' Then		
					KeyCode<=KN;		
					PES<="10";	
					K_RESET<='0';		
				Elsif PES=2 Then 		
					PES<="01";			
				Else
					PES<="00";			
					K_RESET<='1';		
				End IF;
			End IF;	
		End IF;
		If K_RESET='0' or KN=10 Then
			Ko<="1110";				
			KoK<='0';				
			KS<='0';				
			KN<=0;					
			I<=0;					
		Elsif Rising_Edge(KCLK) Then
			If KS='1' Then			
				if Ki=15 Then
					KoK<='1';
				End IF;
			Elsif Ki(I)='0' Then
				KS<='1';		
				Ko<="0000";		
			Else
				KN<=KN+1;				
				Ko<=Ko(2 downto 0) & Ko(3);
				If Ko(3)='0' Then I<=I+1; 
				End IF;
			End IF;
		End IF;
	End Process;
End;

