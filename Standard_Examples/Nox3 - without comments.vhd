--------No:11700-990203--�Ʀ�q�l��
Library IEEE;					
Use IEEE.std_logic_1164.all;	
Use IEEE.std_logic_unsigned.all;
-----------------------------------
Entity  NoX3  is			
   Port(GCKP43:in std_logic;
		P22CLOCK,P7CKM,P19CKH:in std_logic;
		P20S1,P21S2,P5S3:in std_logic;			
		H10o:out integer range 0 to 2;
		H0o	:out integer range 0 to 9;
		P4LED,P8CKM:out std_logic;
		P6S10To0:out std_logic	
		);
End;
-------------------------------------------------------------
Architecture  A  of  NoX3  is							
	Signal M0:std_logic_vector(3 downto 0);				
	CONSTANT M0S:std_logic_vector(3 downto 0):="0100";	
	Signal CLOCK,CKHH:std_logic;					
	CONSTANT L:integer:=4;								
	Signal CKH:std_logic_vector(L downto 0);			
	Signal H10S:integer range 0 to 2;					
	Signal H0S :integer range 0 to 9;					
	Signal S1,S2,S3 :std_logic_vector(2 downto 0);		
	Signal FS:std_logic;								
	Signal F :std_logic_vector(15 downto 0);			
Begin
-------------------------------------------------------------
P4LED<=CLOCK and not S1(2);	
P6S10To0<=P7CKM or S1(2);	
P8CKM<=GCKP43	When M0<M0S		Else
	   P7CKM	When S1(2)='0'	Else CLOCK and S3(2);
CKHH<=CKH(L) 	When S1(2)='0' 	Else Not CLOCK and  S2(2);
CKH(0)<='1';
H10o<=H10S;		
H0o <=H0S;		
FS<=F(13);
--------------------------------------------------------------------------------
Process(GCKP43)
Begin
	If  Rising_Edge(GCKP43)  Then
		If M0<M0S  Then
			M0<=M0+(CKH(L) and F(15));
		Else
			CLOCK<=P22CLOCK;
		End If;
		F<=F+1;
	End If;
	For I in 1 to L Loop
		If CKH(I-1)='1' and P19CKH='1' Then
			CKH(I)<='1';
		Elsif Rising_Edge(GCKP43) Then
			CKH(I)<='0';
		End IF;
	End loop;
--S1�ϼu��
	If (P20S1 and CKH(0))='0' Then
		S1<="000";
	Elsif  Rising_Edge(FS)  Then
		S1<=S1+ not S1(2);
	End IF;
--S2�ϼu��
	If P21S2='0' or S1(2)='0' Then
		S2<="000";
	Elsif  Rising_Edge(FS)  Then
		S2<=S2+ not S2(2);		
	End IF;
--S3�ϼu��
	If P5S3='0' or S1(2)='0' Then
		S3<="000";
	Elsif  Rising_Edge(FS)  Then
		S3<=S3+ not S3(2);
	End IF;
--24�ɭp�ɾ�
	If M0<M0S Then
		H10S<=0;				--�ɤQ����k�s
		H0S<=0;					--�ɭӦ���k�s
	ElsIf  Rising_edge(CKHH)  Then	--�p�ɫH��
		If  H10S<2  Then		--�p��20
			IF H0S/=9 Then		--�ɭӦ�Ƥ�����9
				H0S<=H0S+1;		--�u�n�N�Ӧ�ƥ[1
			Else				--�ɭӦ�Ƶ���9
				H0S<=0;			--�ɭӦ���k�s
				H10S<=H10S+1;	--�ɤQ��ƥ[1
			End IF;
		Elsif H0S/=3 Then		--�j��19 �ήɭӦ줣����3
			H0S<=H0S+1;			--�u�n�N�Ӧ�ƥ[1
		Else					--�w�g��24�p��
			H10S<=0;			--�ɤQ����k�s
			H0S<=0;				--�ɭӦ���k�s
		End IF;
	End IF;
End Process;
End;
