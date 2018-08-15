library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity nox3_test is
	Port(GCKP43:in std_logic;
		P22CLOCK,P7CKM,P19CKH:in std_logic;--��,��,�� �ɯ߫H����J
		P20S1,P21S2,P5S3:in std_logic;	--S1�վ�/�p�ɼҦ��}��,S2��,S3���վ�				
		H10o:out integer range 0 to 2;	--�ɤQ���X
		H0o	:out integer range 0 to 9;	--�ɭӦ��X
		P4LED,P8CKM:out std_logic;	 	--LED��{�{�H��,���ɯ߫H����X
		P6S10To0:out std_logic		 	--��Q���k�s�H����X
		);
end entity;

architecture main of nox3_test is
	Signal M0:std_logic_vector(3 downto 0);				--���k�s�X��
	CONSTANT M0S:std_logic_vector(3 downto 0):="0100";	--���k�s���Ƴ]�w
	Signal CLOCK,CKHH:std_logic;						--��,��  �ɯ߫H��
	CONSTANT L:integer:=4;								--�o�i���Ƴ]�w��
	Signal CKH:std_logic_vector(L downto 0);			--�Ʀ��o�i��
	Signal H10S:integer range 0 to 2;					--�� �Q��ƭp�ɾ�
	Signal H0S :integer range 0 to 9;					--�� �Ӧ�ƭp�ɾ�
	Signal S1,S2,S3 :std_logic_vector(2 downto 0);		--S1,S2,S3�ϼu��
	Signal FS:std_logic;								--S1,S2,S3�ϼu���ɯ�
	Signal F :std_logic_vector(15 downto 0);			--���W��
begin
	P4LED<=CLOCK and not S1(2);			--D1 D2 LED�X�ʫH��
	P6S10To0<=P7CKM or S1(2);			--U15�k�s�H��(��10����k�s)
	P8CKM<=	GCKP43	When M0<M0S		Else--Power On�Ұʤ��k�s�\��
			P7CKM	When S1(2)='0'	Else CLOCK and S3(2);
	CKHH<=	CKH(L) 	When S1(2)='0' 	Else Not CLOCK and  S2(2);
	CKH(0)<='1';	--�Ʀ��o�i����l�Ƴ]�w
	H10o<=H10S;							--�ɤQ��ƿ�X
	H0o <=H0S;							--�ɭӦ�ƿ�X
	FS<=F(13);	--��S1,S2,S3�ϼu���ɯ�
	Process(GCKP43)		--4MHz�ۭ^���鮶�����ɯ߿�J
	Begin
		If  Rising_Edge(GCKP43)  Then
			If M0<M0S  Then
			--�˴����k�s����(����o�ʺʴ�)
				M0<=M0+(CKH(L) and F(15));
			Else
				CLOCK<=P22CLOCK;	--CLOCK��J
			End If;
			F<=F+1;	--���W��
		End If;
		For I in 1 to L Loop		--��L�Ȳ���L���Ʀ��o�i��
			If CKH(I-1)='1' and P19CKH='1' 	Then
				CKH(I)<='1';
			Elsif Rising_Edge(GCKP43) 		Then
				CKH(I)<='0';
			End IF;
		End loop;
	--S1�ϼu��
		If (P20S1 and CKH(0))='0' 	Then
			S1<="000";
		Elsif  Rising_Edge(FS)  	Then
			S1<=S1+ not S1(2);
		End IF;
	--S2�ϼu��
		If P21S2='0' or S1(2)='0' 	Then
			S2<="000";
		Elsif  Rising_Edge(FS)  	Then
			S2<=S2+ not S2(2);		
		End IF;
	--S3�ϼu��
		If P5S3='0' or S1(2)='0' 	Then
			S3<="000";
		Elsif  Rising_Edge(FS)  	Then
			S3<=S3+ not S3(2);
		End IF;
	--24�ɭp�ɾ�
		If M0<M0S Then
			H10S<=0;				--�ɤQ����k�s
			H0S<=0;					--�ɭӦ���k�s
		ElsIf  Rising_edge(CKHH)  Then	--�p�ɫH��
			If  H10S<2  	Then		--�p��20
				IF H0S/=9 	Then		--�ɭӦ�Ƥ�����9
					H0S<=H0S+1;		--�u�n�N�Ӧ�ƥ[1
				Else				--�ɭӦ�Ƶ���9
					H0S<=0;			--�ɭӦ���k�s
					H10S<=H10S+1;	--�ɤQ��ƥ[1
				End IF;
			Elsif H0S/=3 	Then	--�j��19 �ήɭӦ줣����3
				H0S<=H0S+1;			--�u�n�N�Ӧ�ƥ[1
			Else					--�w�g��24�p��
				H10S<=0;			--�ɤQ����k�s
				H0S<=0;				--�ɭӦ���k�s
			End IF;
		End IF;
	End Process;
end architecture;











