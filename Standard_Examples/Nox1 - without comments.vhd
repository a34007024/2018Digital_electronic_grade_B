--------No:11700-990201----------
Library IEEE;					
Use IEEE.std_logic_1164.all;	
Use IEEE.std_logic_unsigned.all;

Entity  NoX1  is
	Port(GCKP43,P2CK1,P3S1,P4CK2:in std_logic;
		 DCBA:out integer range 0 to 9;		
		 ba:out integer range 0 to 3);		
End;

Architecture  A  of  NoX1  is				 
	Signal CK1,CK2: std_logic;
	Signal N3,N2,N1,N0: integer range 0 to 9;
	Signal S: integer range 0 to 3;			 
	Signal CLR: std_logic_vector(1 downto 0);
Begin

Process(GCKP43)
Begin
	If  Rising_Edge(GCKP43)  Then
		CK1<=P2CK1;		
		CK2<=P4CK2;		
		CLR<=CLR(0) & P3S1;
	End IF;
	
	If	CLR=3  Then							 
		N3<=0; N2<=0; N1<=0; N0<=0;			 
	Elsif  Rising_Edge(CK1)  Then			 
		If   N0/=9  Then	N0<=N0+1;		 
		Else	N0<=0;						 
			If  N1/=9  Then	N1<=N1+1;		 
			Else	N1<=0;					 
				If  N2/=9  Then	N2<=N2+1;	 
				Else	N2<=0;				 
					If  N3/=9  Then	N3<=N3+1;
					Else	N3<=0;			 
	End IF;End IF;End IF;End IF;End If;		 
	
	If  Rising_Edge(CK2)  Then
		S<=S+1;
	End IF;

End Process;
	ba<=S;
	With S Select
		DCBA <=	N3 When 0,	
			 	N2 When 1,	
			 	N1 When 2,	
			 	N0 When oThers;
End;

