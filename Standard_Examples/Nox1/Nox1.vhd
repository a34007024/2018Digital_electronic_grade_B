--------No:11700-990201----------
Library IEEE;					--�s��w�ޥ�
Use IEEE.std_logic_1164.all;	--�M��ޥ�
Use IEEE.std_logic_unsigned.all;--�M��ޥ�

Entity  NoX1  is	--���ɦW;GCKP43:4MHz�ۭ^����l�O������P43
	Port(GCKP43,P2CK1,P3S1,P4CK2:in std_logic;	--CK1,CLR,CK2
		 DCBA:out integer range 0 to 9;			--U6 D,C,B,A
		 ba:out integer range 0 to 3);			--U5 a,b
End;

Architecture  A  of  NoX1  is				 	--���q���W��
	Signal CK1,CK2: std_logic;
	Signal N3,N2,N1,N0: integer range 0 to 9;	--�d�ʤQ�� ���
	Signal S: integer range 0 to 3;			 	--���˫H��
	Signal CLR: std_logic_vector(1 downto 0);	--S1�����T��
Begin

Process(GCKP43)			--4MHz�ۭ^���鮶�����ɯ߿�J
Begin

--�ɯ��ˤJ��
	If  Rising_Edge(GCKP43)  Then
		CK1<=P2CK1;			--CK1�p�Ʈɯ߿�J,�����T
		CK2<=P4CK2;			--CK2���ˮɯ߿�J,�����T
		CLR<=CLR(0) & P3S1;	--S1��J,�����T
	End IF;

--4��BCD�X�p�ƾ�
	If	CLR=3  Then							 --S1�k�s���s�w�T����U
		N3<=0; N2<=0; N1<=0; N0<=0;			 --�p�ƭ��k�s
	Elsif  Rising_Edge(CK1)  Then			 --�p�Ʈɯ�,���tĲ�o
		If   N0/=9  Then	N0<=N0+1;		 --�Ӧ줣����9,�Ӧ�+1�N�n
		Else	N0<=0;						 --�Ӧ쵥��9,�Ӧ��k�s
			If  N1/=9  Then	N1<=N1+1;		 --�Q�줣����9,�Q��+1�N�n
			Else	N1<=0;					 --�Q�쵥��9,�Q���k�s
				If  N2/=9  Then	N2<=N2+1;	 --�ʦ줣����9,�ʦ�+1�N�n
				Else	N2<=0;				 --�ʦ쵥��9,�ʦ��k�s
					If  N3/=9  Then	N3<=N3+1;--�d�줣����9,�d��+1�N�n
					Else	N3<=0;			 --�d�쵥��9,�d���k�s
	End IF;End IF;End IF;End IF;End If;		 --�@5��End If;

--���˲��;�	
	If  Rising_Edge(CK2)  Then
		S<=S+1;
	End IF;

End Process;

--���ͱ��˽X
	ba<=S;
--�z��p�ƭ�
	With S Select
		DCBA <=	N3 When 0,		--���d���
			 	N2 When 1,		--���ʦ��
			 	N1 When 2,		--���Q���
			 	N0 When oThers;	--���Ӧ��

End;

