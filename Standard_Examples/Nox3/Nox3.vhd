--------No:11700-990203--�Ʀ�q�l��
Library IEEE;					--�s��w�ޥ�
Use IEEE.std_logic_1164.all;	--�M��ޥ�
Use IEEE.std_logic_unsigned.all;--�M��ޥ�
-----------------------------------
Entity  NoX3  is				--���ɦW
   Port(GCKP43:in std_logic;	--GCKP43:4MHz�ۭ^����l�O�w������P43
		P22CLOCK,P7CKM,P19CKH:in std_logic;--��,��,�� �ɯ߫H����J
		P20S1,P21S2,P5S3:in std_logic;	--S1�վ�/�p�ɼҦ��}��,S2��,S3���վ�				
		H10o:out integer range 0 to 2;	--�ɤQ���X
		H0o	:out integer range 0 to 9;	--�ɭӦ��X

		P4LED,P8CKM:out std_logic;	 	--LED���{�{�H��,���ɯ߫H����X
		P6S10To0:out std_logic		 	--���Q���k�s�H����X
		);
End;

--------------------------------------------------------------------------------
Architecture  A  of  NoX3  is							--���q���W��A
	Signal M0:std_logic_vector(3 downto 0);				--���k�s�X��
	CONSTANT M0S:std_logic_vector(3 downto 0):="0100";	--���k�s���Ƴ]�w
	
	Signal CLOCK,CKHH:std_logic;						--��,��  �ɯ߫H��
		--"��"�i�ɫH��P19CKH�Ʀ��o�i��(�h�����T)
		--�Ш̾��x���T�{�װ��A���]�w(L�i�]�w�d��1~8����)
	CONSTANT L:integer:=4;								--�o�i���Ƴ]�w��
	Signal CKH:std_logic_vector(L downto 0);			--�Ʀ��o�i��
	
	Signal H10S:integer range 0 to 2;					--�� �Q��ƭp�ɾ�
	Signal H0S :integer range 0 to 9;					--�� �Ӧ�ƭp�ɾ�
	
	Signal S1,S2,S3 :std_logic_vector(2 downto 0);		--S1,S2,S3�ϼu��
	Signal FS:std_logic;								--S1,S2,S3�ϼu���ɯ�
	Signal F :std_logic_vector(15 downto 0);			--���W��
Begin
--------------------------------------------------------------------------------
--�֤]������,U14 7490 U13 7492 ��Power On�ɨ�ȷ|�O�s(����),
--���N�L�k���00:00���H�a�ݤF��?�z�N�|�L�k���o�A���ҷ�,
--���n��ѥ��]�p���t��P8CKM�o�X���ɯ߫H��,
--��U13 7492 ��Qd�ܦ�1(��60��),U13 7492 ��Qd=1�|���z�N���k�s
--���ɴN�i�H���00:00���H�a�ݤF,�n�j���k�s�X���i�H�]�w
--���d�ҥ��q���O��C11,R10,D11�i���α�,�p�@�w�n���N������,
--������,�z�i��ݭn�i�{�@�I�зN
--���z���\
--------------------------------------------------------------------------------
P4LED<=CLOCK and not S1(2);			--D1 D2 LED�X�ʫH��

P6S10To0<=P7CKM or S1(2);			--U15�k�s�H��(��10����k�s)

--��� �� �ɯ߫H��,	�j���k�s:GCKP43=4MHz
P8CKM<=GCKP43	When M0<M0S		Else--Power On�Ұʤ��k�s�\��
	   P7CKM	When S1(2)='0'	Else CLOCK and S3(2);
--U14 AI�� �ɯ߫H��	�p��/�վ�Ҧ�	--����νվ��

--��� �� �ɯ߫H��(S1,S2,S3 �ë�,100%�����v�T)
--    ���`�p��	 	�p��/�վ�Ҧ�	--����νվ��
CKHH<=CKH(L) 	When S1(2)='0' 	Else Not CLOCK and  S2(2);
CKH(0)<='1';	--�Ʀ��o�i����l�Ƴ]�w

--24�ɭp�ɾ� ��X
H10o<=H10S;							--�ɤQ��ƿ�X
H0o <=H0S;							--�ɭӦ�ƿ�X
--�˩w�������վ��x����, �Ҧ����s�ζ}���Ҥw�޹Lxxxxxx��
--�z���t�쪺���藍�O�s��,�¾��x�O�_������˦��s�D�ت��n�D���˴��L�~?���n�]���Q���`,
--������,�۱ϯ���p�U�]?
FS<=F(13);	--��S1,S2,S3�ϼu���ɯ�
--------------------------------------------------------------------------------
Process(GCKP43)		--4MHz�ۭ^���鮶�����ɯ߿�J
Begin

--�ҩl�j���k�s:�� �� ��
	If  Rising_Edge(GCKP43)  Then
--���ҩl�ʴ�(100%�����k�s)
		If M0<M0S  Then
		--�˴����k�s����(����o�ʺʴ�)
			M0<=M0+(CKH(L) and F(15));
		Else
			CLOCK<=P22CLOCK;	--CLOCK��J
		End If;
		
--���W��
		F<=F+1;
	End If;

--�� �ɯ�,CKH_P19�˴��� & �Ʀ��o�i���o�����W���T
--(S1,S2,S3 �ë�,100%�����v�T)
--���b�p�ɼҦ���(S1 off),
--�r��S2,S3���s��,(�Ϋ�S3����,�A�r��S2)
--�]S1,S2,S3��C�jR�p���ް_�q����í,
--�Ϥ�(�Q���)U13(74Ls92)��Qd�e���_�ܤ�,
--�P�ϱo"��"���p��,���ӷ|���v�T
	For I in 1 to L Loop		--��L�Ȳ���L���Ʀ��o�i��
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