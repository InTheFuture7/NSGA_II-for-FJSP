%{
���룺
    JΪ������ȵĹ�����������Ϣ
    p_parent_chromosome, m_parent_chromosome��¼��һ����ʤ�߸��壬���ݸ�����p_chromosome��m_chromosome
�㷨��
    ����Ϊ POX
    ����Ϊ����ʽ����
�����
    p_child_matrix, m_child_matrix 
%}
function[p_child_matrix, m_child_matrix] = genetic_operator(J, p_parent_chromosome, m_parent_chromosome)
    [N, M] = size(p_parent_chromosome);  % N�ǽ�����еĸ�������
    % V=4;  % �Ż�Ŀ������
    V=2;  % �Ż�Ŀ������
    across=0.8;  % ������
    mutation=0.1;  % ������
    p_child_matrix=[];
    m_child_matrix=[];
    k=1;  % k��¼���ɵ��Ӵ���Ⱥ���������ﵽpop_sizeʱ������ѭ��
    for i = 1 : N  % ������Ȼѭ��N�Σ�����ÿ��ѭ�������и��ʲ���2������1���Ӵ����������ղ������Ӵ�����������Լ��2N������������
        if rand(1) < across  % �������0.8
            parent_1 =randperm(N,1);  % ����һ����1-N������
            parent_2 =randperm(N,1);
            % ѡ����뽻������ĸ��� parent1 �� parent2 ��ͬ
            while isequal(p_parent_chromosome(parent_1,:),p_parent_chromosome(parent_2,:))
                parent_2 = randperm(N,1);
            end
            p_parent_1 = p_parent_chromosome(parent_1, 1:M-V-2);  % ������Ŀ�꺯�����������������
            m_parent_1 = m_parent_chromosome(parent_1, :);
            p_parent_2 = p_parent_chromosome(parent_2, 1:M-V-2);
            m_parent_2 = m_parent_chromosome(parent_2, :);

            % ���й��򽻲�                                                     
            if mod(i, 2)==1  % a ���� m �������
                J1=[];
                c1_p=zeros(1,M-V-2);  % �Ӵ�Ⱦɫ��
                c1_m=zeros(1,M-V-2);
                c2_p=zeros(1,M-V-2);
                c2_m=zeros(1,M-V-2);
                while size(J1,1)==0 && size(J1,2)==0
                    % ����һ�����������ɵ� 1��size(J,2) �ľ�����������õ�һ��0��1����
                    % ����������1���ڵ����������J1
                    J1=find(round(rand(1, size(J,2)))==1);
                end
                for j=1:size(p_parent_1, 2)  % �����ڵ�һ������Ⱦɫ��������J1�Ĺ���λ�ñ���������ͬ���ڶ�������Ⱦɫ���в�����J1�Ĺ���λ�ñ�������
                    if ismember(p_parent_1(j), J1)  % ���α���A��ÿ��λ�õ����ݣ���������B�У���ô����1��true
                        c1_p(j)=p_parent_1(j);  % c1_p �洢 p_parent_1(1*28) �����ڹ����� J1 �Ĺ��򣬲����ڵĴ洢0Ԫ��
                        c1_m(j)=m_parent_1(j);  % c1_m �洢 p_parent_1(1*28) �����ڹ����� J1 �����Ӧ�ļӹ�����
                    end
                    if ~ismember(p_parent_2(j), J1)
                        c2_p(j)=p_parent_2(j);  % c2_p �洢 p_parent_2(1*28) �в����ڹ����� J1 �Ĺ���
                        c2_m(j)=m_parent_2(j);
                    end
                end
                index_1_1=find(c1_p==0);  % index_1_1 �洢 c1_p==0 ��Ԫ�������������ڹ�����J1�Ĺ���
                index_1_2=find(c2_p~=0);  % index_1_2 �洢 c2_p~=0 ��Ԫ�������������ڹ�����J1�Ĺ���
                index_2_2=find(c2_p==0);  % index_1_1��2��ȣ�index_2_1��2���
                index_2_1=find(c1_p~=0);  
                for j=1:size(index_1_1, 2)
                    c1_p(index_1_1(j)) = p_parent_2(index_1_2(j));
                    c1_m(index_1_1(j)) = m_parent_2(index_1_2(j));
                end
                for j=1:size(index_2_2, 2)
                    c2_p(index_2_2(j)) = p_parent_1(index_2_1(j));
                    c2_m(index_2_2(j)) = m_parent_1(index_2_1(j));
                end
    
            else  % �����豸���棬ֻ�����豸���棬���򲿷�ֱ�Ӹ��ƣ�
                % ��������������е����ɸ�������ĳһ�����������棬�������벻����
                c1_p=p_parent_1;
                c1_m=m_parent_1;
                c2_p=p_parent_2;
                c2_m=m_parent_2;
                m_cross_index=find(round(rand(1,M-V-2))==0);  % ���ѡ����Ҫ�����豸����Ĺ��򣬻�ȡ��λ��

                for j=1:size(m_cross_index,2)
                    p_var=p_parent_1(m_cross_index(j));  % ѡ��λ����m_cross_index(j)�Ĺ���p_var
                    p_var_index=find(p_parent_1==p_var);  % ����p_var�ڵ�һ������p_parent_1�е�λ��
                    p_number=find(p_var_index==m_cross_index(j));  % ȷ�����ý����Ϊp_var�Ź����ĵ�p_number������
                    c2_across_index=find(p_parent_2==p_var);  % ����p_var�ڵڶ��������е�λ��

                    c1_m(m_cross_index(j))=m_parent_2(c2_across_index(p_number));  % ���ڶ���������p_var�Ź����ĵ�p_number�������Ӧ�Ļ�������ֵ����һ��������ͬ�Ĺ�������
                    c2_m(c2_across_index(p_number))=m_parent_1(m_cross_index(j));
                end      
            end
            p_child_matrix(k,:)=c1_p;
            m_child_matrix(k,:)=c1_m;
            k=k+1;
            p_child_matrix(k,:)=c2_p;
            m_child_matrix(k,:)=c2_m;
            k=k+1;
        end


        % ���ڹ�����豸����
        if rand(1)<mutation  % �������
            parent_3 = randperm(N,1);
            parent_4 = randperm(N,1);
            p_parent_3 = p_parent_chromosome(parent_3,1:M-V-2);  % ���빤������Ⱦɫ��
            m_parent_3 = m_parent_chromosome(parent_3,:);  % ������������Ⱦɫ��
            p_parent_4 = p_parent_chromosome(parent_4,1:M-V-2);
            m_parent_4 = m_parent_chromosome(parent_4,:);
            c3_p=p_parent_3;
            c3_m=m_parent_3;
            c4_p=p_parent_4;
            c4_m=m_parent_4;
            rand_num_1=randperm(M-V-2,1);  % ���ڹ������ģ��������ĵ�1��λ��
            rand_num_2=randperm(M-V-2,1);  % ���ڹ������ģ��������ĵ�2��λ��
            while isequal(rand_num_1,rand_num_2)  % ȷ������λ�ò�ͬ
                rand_num_2=randperm(M-V-2,1);
            end

            %���ڹ�����췽�����������б�д
            % c3_p(rand_num_1)=p_parent_3(rand_num_2);
            % c3_m(rand_num_1)=m_parent_3(rand_num_2);
            % c3_p(rand_num_2)=p_parent_3(rand_num_1);
            % c3_m(rand_num_2)=m_parent_3(rand_num_1);
            % p_child_matrix(k,:)=c3_p;
            % m_child_matrix(k,:)=c3_m;
            % k=k+1;

            % �����豸�ı���
            rand_num_3=randperm(M-V-2,1);  % �������ĵ�3��λ��
            rand_num_4=randperm(M-V-2,1);  % �������ĵ�4��λ��
            while isequal(rand_num_3,rand_num_4)  % ȷ������λ�ò�ͬ
                 rand_num_4=randperm(M-V-2,1);
            end
            p_var_3=p_parent_4(rand_num_3);
            p_var_4=p_parent_4(rand_num_4);
            muta_index_1=find(p_parent_4==p_var_3);  % ���칤����p_var_3��p_parent_4�е�λ������
            num_of_p_1=find(muta_index_1==rand_num_3);  % ����p_var�ĵ�num_of_1������
            muta_index_2=find(p_parent_4==p_var_4);
            num_of_p_2=find(muta_index_2==rand_num_4);

            % �Ӷ�Ӧ��������Ŀ�ѡ�ӹ��������У����ѡ��һ�����������ԭ�ȵļӹ�����
            m1=randperm(size(J(p_var_3).m{num_of_p_1},2),1);
            m2=randperm(size(J(p_var_4).m{num_of_p_2},2),1);
            c4_m(rand_num_3)=J(p_var_3).m{num_of_p_1}(m1);  % Ӧ��Ϊ c4_m Ϊ c3_m��
            c4_m(rand_num_4)=J(p_var_4).m{num_of_p_2}(m2);

            p_child_matrix(k,:)=c4_p;
            m_child_matrix(k,:)=c4_m;
            k=k+1;
        end
    end 
end
