--------No:11700-990202--��L���˸˸m
Library IEEE;					--�s��w�ޥ�
Use IEEE.std_logic_1164.all;	--�M��ޥ�
Use IEEE.std_logic_unsigned.all;--�M��ޥ�

Entity  NoX2  is	--���ɦW;GCKP43:4MHz�ۭ^����l�O�w������P43
   Port(GCKP43,p14co,p13co:in std_logic;		 --U5 U6 4510�s�ȫH��
		keyin:in std_logic_vector(2 downto 0); 	 --���˿�J,�����ɹq����+3.3V
		keyscan:out std_logic_vector(3 downto 0);--���˿�X
		DCBAout:out integer range 0 to 15;		 --��ȿ�X
		p6p20pe:out std_logic_vector(1 downto 0); 	 --U5 U6 4510�æC���J�H��
		p1stop:out std_logic					 --����
		);
End;

Architecture  A  of  NoX2  is					--���q���W��A
	--	��L�Ѽ�
	Signal I:integer range 0 to 3;		   		--�����ˬd����
	Signal keynum:integer range 0 to 15;			--���
	Signal keyinsignal,keyscansignal:std_logic_vector(3 downto 0);	--��L���˿�J��X�H��
	--	��L���m ������,��L�����X��,�������ҺX��
	Signal K_RESET,keyscansignalK,keypressed:std_logic;
	----------------------------------------------------------
	--���W��
	Signal freqDivider:std_logic_vector(15 downto 0);
	--��L���˨t�ξް��ɯ�
	Signal keyclock,p1signal:std_logic;	--����H��
	--�t�ΰѼ�
	Signal startupReset:std_logic:='0';	--�ҩl�X��
	Signal p6p20peSignal:std_logic_vector(1 downto 0);--CD4510�U���H��
	--�˴�00��Co�Ѽ�
	Signal p1signal4p13coS:std_logic_vector(1 downto 0);
Begin
	p1signal<=p1signal4p13coS(1) AND p1signal4p13coS(0);	--�s�ȫH��
	p1stop<=p1signal;							--����H��,NL3�O�X�ʫH����X
	keyscan<=keyscansignal;						--���˿�X15,19,16,18
	keyinsignal<='1' & keyin;					--���˿�J,��3�Ӵ��ɹq��10,4,2
		
	p6p20pe<=p6p20peSignal;							--U5 U6 CD4510_p6p20pe �U���H����X
	keyclock<=freqDivider(13);						--��L���˨t�ξް��ɯ�
	Process(GCKP43)						--4MHz�ۭ^���鮶�����ɯ߿�J
	Begin
	--���W��--�D����
		If  Rising_Edge(GCKP43) Then
	--���W��
			freqDivider<=freqDivider+1;	--���W��
			--�]�����´��վ��x���D
			--��10�ন09��,/Co�i�઺���T���D�ϱo���ˤH�L�k�q�L�˩w
			--�W�C�ﵦ�p�U:
			p1signal4p13coS<=p1signal4p13coS(0) & (p14co Nor p13co);
			--�p�GS2�� Power On ���Ѯ�,�z�N�|�L�k���o�A���ҷ�
			--���n��ѥ��D�����o�X�k�s�U���H��,���z�O�Ҧ��\
	--�D����
			--�˩w�����վ��x�W�v�S�ʨ}�n��,�H�̰��W�v�B�@(4MHz)
			--�p�J�˩w�����վ��x�W�v�S�ʤ��ή�,�y�N�U���t�v���C(2MHz)
			If freqDivider(0)='1' Then	--�N�U���t�v���C(4MHz-->2MHz)����
				If  startupReset='0' Then			--U5 U6 CD4510 �k�s
					DCBAout<=0;			--�s
					p6p20peSignal<="11";			--U5 U6�Ұʸ��J�\��
					startupReset<=p1signal;				--����U5 U6 CD4510 �w�k�s
				Elsif keyscansignalK='1' Then		--���ݦ�����H��
					DCBAout<=keynum;		--��X������Ȧ�U6 CD4510
					p6p20peSignal<="10";			--U6-->U5���J,��Ӧ�Ƹ��J�Q���
					K_RESET<='0';		--���m��L
				Elsif p6p20peSignal=2 Then 		
					p6p20peSignal<="01";			--���-->U6���J
				Else
					p6p20peSignal<="00";			--�������J�\��
					K_RESET<='1';		--��L�A�Ұ�
				End If;
			End If;				--�N�U���t�v���C(4MHz-->2MHz)����
		End If;
	--��L����
		If K_RESET='0' or keynum=10 Then--�W�L������ɭ��^�w�]��
			keyscansignal<="1110";				--�w�]���˽X
			keyscansignalK<='0';				--�w�]�L ������
			keypressed<='0';				--�w�]�L���s���U�����X��
			keynum<=0;					--�w�]��Ȭ�0
			I<=0;					--�w�]�����ˬd���Ь�0
		Elsif Rising_Edge(keyclock) Then
			--�w�����s���U��
			If keypressed='1' Then			
				if keyinsignal=15 Then		--���ի���O�_����}
					keyscansignalK<='1';		--�q���D�����B�z�������
				End If;
			--�|�������s���U
			Elsif keyinsignal(I)='0' Then	--�ˬd��ȿ�J�줸
				keypressed<='1';			--��������U
				keyscansignal<="0000";			--�����Ҧ�����0~9
			Else
				keynum<=keynum+1;					--�p��s�����
				keyscansignal<=keyscansignal(2 downto 0) & keyscansignal(3);	--�վ㱽�˿�X
				If keyscansignal(3)='0' Then I<=I+1; 	--�p������ˬd���� 
				End If;
			End If;
		End If;
	End Process;
End;

