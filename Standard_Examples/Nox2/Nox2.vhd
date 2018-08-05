--------No:11700-990202--��L���˸˸m
Library IEEE;					--�s��w�ޥ�
Use IEEE.std_logic_1164.all;	--�M��ޥ�
Use IEEE.std_logic_unsigned.all;--�M��ޥ�

Entity  NoX2  is	--���ɦW;GCKP43:4MHz�ۭ^����l�O�w������P43
   Port(GCKP43,P14Co,P13Co:in std_logic;		 --U5 U6 4510�s�ȫH��
		KeyIn:in std_logic_vector(2 downto 0); 	 --���˿�J,�����ɹq����+3.3V
		KeyScan:out std_logic_vector(3 downto 0);--���˿�X
		KeyCode:out integer range 0 to 15;		 --��ȿ�X
		PE:out std_logic_vector(1 downto 0); 	 --U5 U6 4510�æC���J�H��
		P1STOP:out std_logic					 --����
		);
End;

Architecture  A  of  NoX2  is					--���q���W��A
	--	��L�Ѽ�
	Signal I:integer range 0 to 3;		   		--�����ˬd����
	Signal KN:integer range 0 to 15;			--���
	Signal Ki,Ko:std_logic_vector(3 downto 0);	--��L���˿�J��X�H��
	--	��L���m ������,��L�����X��,�������ҺX��
	Signal K_RESET,KoK,KS:std_logic;
	----------------------------------------------------------
	--���W��
	Signal F:std_logic_vector(15 downto 0);
	--��L���˨t�ξް��ɯ�
	Signal KCLK,P1:std_logic;	--����H��
	--�t�ΰѼ�
	Signal MS:std_logic:='0';	--�ҩl�X��
	Signal PES:std_logic_vector(1 downto 0);--CD4510�U���H��
	--�˴�00��Co�Ѽ�
	Signal P14P13CoS:std_logic_vector(1 downto 0);
Begin
	P1<=P14P13CoS(1) AND P14P13CoS(0);	--�s�ȫH��
	P1STOP<=P1;							--����H��,NL3�O�X�ʫH����X
	KeyScan<=Ko;						--���˿�X15,19,16,18
	Ki<='1' & KeyIn;					--���˿�J,��3�Ӵ��ɹq��10,4,2
		
	PE<=PES;							--U5 U6 CD4510_PE �U���H����X
	KCLK<=F(13);						--��L���˨t�ξް��ɯ�
	Process(GCKP43)						--4MHz�ۭ^���鮶�����ɯ߿�J
	Begin
	--���W��--�D����
		If  Rising_Edge(GCKP43) Then
	--���W��
			F<=F+1;	--���W��
			--�]�����´��վ��x���D
			--��10�ন09��,/Co�i�઺���T���D�ϱo���ˤH�L�k�q�L�˩w
			--�W�C�ﵦ�p�U:
			P14P13CoS<=P14P13CoS(0) & (P14Co Nor P13Co);
			--�p�GS2�� Power On ���Ѯ�,�z�N�|�L�k���o�A���ҷ�
			--���n��ѥ��D�����o�X�k�s�U���H��,���z�O�Ҧ��\
	--�D����
			--�˩w�����վ��x�W�v�S�ʨ}�n��,�H�̰��W�v�B�@(4MHz)
			--�p�J�˩w�����վ��x�W�v�S�ʤ��ή�,�y�N�U���t�v���C(2MHz)
			If F(0)='1' Then	--�N�U���t�v���C(4MHz-->2MHz)����
				If  MS='0' Then			--U5 U6 CD4510 �k�s
					KeyCode<=0;			--�s
					PES<="11";			--U5 U6�Ұʸ��J�\��
					MS<=P1;				--����U5 U6 CD4510 �w�k�s
				Elsif KoK='1' Then		--���ݦ�����H��
					KeyCode<=KN;		--��X������Ȧ�U6 CD4510
					PES<="10";			--U6-->U5���J,��Ӧ�Ƹ��J�Q���
					K_RESET<='0';		--���m��L
				Elsif PES=2 Then 		
					PES<="01";			--���-->U6���J
				Else
					PES<="00";			--�������J�\��
					K_RESET<='1';		--��L�A�Ұ�
				End IF;
			End IF;				--�N�U���t�v���C(4MHz-->2MHz)����
		End IF;
	--��L����
		If K_RESET='0' or KN=10 Then--�W�L������ɭ��^�w�]��
			Ko<="1110";				--�w�]���˽X
			KoK<='0';				--�w�]�L ������
			KS<='0';				--�w�]�L���s���U�����X��
			KN<=0;					--�w�]��Ȭ�0
			I<=0;					--�w�]�����ˬd���Ь�0
		Elsif Rising_Edge(KCLK) Then
			--�w�����s���U��
			If KS='1' Then			
				if Ki=15 Then		--���ի���O�_����}
					KoK<='1';		--�q���D�����B�z�������
				End IF;
			--�|�������s���U
			Elsif Ki(I)='0' Then	--�ˬd��ȿ�J�줸
				KS<='1';			--��������U
				Ko<="0000";			--�����Ҧ�����0~9
			Else
				KN<=KN+1;					--�p��s�����
				Ko<=Ko(2 downto 0) & Ko(3);	--�վ㱽�˿�X
				If Ko(3)='0' Then I<=I+1; 	--�p������ˬd���� 
				End IF;
			End IF;
		End IF;
	End Process;
End;

