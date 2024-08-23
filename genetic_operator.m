%{
输入：
    J为参与调度的工件的所有信息
    p_parent_chromosome, m_parent_chromosome记录父一代优胜者个体，内容复制自p_chromosome、m_chromosome
算法：
    交叉为 POX
    变异为多项式变异
输出：
    p_child_matrix, m_child_matrix 
%}
function[p_child_matrix, m_child_matrix] = genetic_operator(J, p_parent_chromosome, m_parent_chromosome)
    [N, M] = size(p_parent_chromosome);  % N是交配池中的个体数量
    % V=4;  % 优化目标数量
    V=2;  % 优化目标数量
    across=0.8;  % 交叉率
    mutation=0.1;  % 变异率
    p_child_matrix=[];
    m_child_matrix=[];
    k=1;  % k记录生成的子代种群的数量，达到pop_size时，跳出循环
    for i = 1 : N  % 这里虽然循环N次，但是每次循环都会有概率产生2个或者1个子代，所以最终产生的子代个体数量大约是2N个？？？？？
        if rand(1) < across  % 交叉概率0.8
            parent_1 =randperm(N,1);  % 生成一个从1-N的整数
            parent_2 =randperm(N,1);
            % 选择参与交叉操作的父代 parent1 和 parent2 不同
            while isequal(p_parent_chromosome(parent_1,:),p_parent_chromosome(parent_2,:))
                parent_2 = randperm(N,1);
            end
            p_parent_1 = p_parent_chromosome(parent_1, 1:M-V-2);  % 不包含目标函数，仅包含工序编码
            m_parent_1 = m_parent_chromosome(parent_1, :);
            p_parent_2 = p_parent_chromosome(parent_2, 1:M-V-2);
            m_parent_2 = m_parent_chromosome(parent_2, :);

            % 进行工序交叉                                                     
            if mod(i, 2)==1  % a 除以 m 后的余数
                J1=[];
                c1_p=zeros(1,M-V-2);  % 子代染色体
                c1_m=zeros(1,M-V-2);
                c2_p=zeros(1,M-V-2);
                c2_m=zeros(1,M-V-2);
                while size(J1,1)==0 && size(J1,2)==0
                    % 返回一个由随机数组成的 1×size(J,2) 的矩阵，四舍五入得到一个0、1向量
                    % 返回向量中1所在的索引，组成J1
                    J1=find(round(rand(1, size(J,2)))==1);
                end
                for j=1:size(p_parent_1, 2)  % 将属于第一个父代染色体中属于J1的工序位置保留下来，同理将第二个父代染色体中不属于J1的工序位置保留下来
                    if ismember(p_parent_1(j), J1)  % 依次遍历A中每个位置的数据，若存在于B中，那么返回1或true
                        c1_p(j)=p_parent_1(j);  % c1_p 存储 p_parent_1(1*28) 中属于工件集 J1 的工序，不属于的存储0元素
                        c1_m(j)=m_parent_1(j);  % c1_m 存储 p_parent_1(1*28) 中属于工件集 J1 工序对应的加工机器
                    end
                    if ~ismember(p_parent_2(j), J1)
                        c2_p(j)=p_parent_2(j);  % c2_p 存储 p_parent_2(1*28) 中不属于工件集 J1 的工序
                        c2_m(j)=m_parent_2(j);
                    end
                end
                index_1_1=find(c1_p==0);  % index_1_1 存储 c1_p==0 的元素索引，不属于工件集J1的工序
                index_1_2=find(c2_p~=0);  % index_1_2 存储 c2_p~=0 的元素索引，不属于工件集J1的工序
                index_2_2=find(c2_p==0);  % index_1_1、2相等；index_2_1、2相等
                index_2_1=find(c1_p~=0);  
                for j=1:size(index_1_1, 2)
                    c1_p(index_1_1(j)) = p_parent_2(index_1_2(j));
                    c1_m(index_1_1(j)) = m_parent_2(index_1_2(j));
                end
                for j=1:size(index_2_2, 2)
                    c2_p(index_2_2(j)) = p_parent_1(index_2_1(j));
                    c2_m(index_2_2(j)) = m_parent_1(index_2_1(j));
                end
    
            else  % 进行设备交叉，只进行设备交叉，工序部分直接复制？
                % 随机将机器编码中的若干个工件的某一道工序做交叉，工件编码不处理？
                c1_p=p_parent_1;
                c1_m=m_parent_1;
                c2_p=p_parent_2;
                c2_m=m_parent_2;
                m_cross_index=find(round(rand(1,M-V-2))==0);  % 随机选择需要进行设备交叉的工序，获取其位置

                for j=1:size(m_cross_index,2)
                    p_var=p_parent_1(m_cross_index(j));  % 选择位置在m_cross_index(j)的工件p_var
                    p_var_index=find(p_parent_1==p_var);  % 工件p_var在第一个父代p_parent_1中的位置
                    p_number=find(p_var_index==m_cross_index(j));  % 确定出该交叉点为p_var号工件的第p_number道工序
                    c2_across_index=find(p_parent_2==p_var);  % 工件p_var在第二个父代中的位置

                    c1_m(m_cross_index(j))=m_parent_2(c2_across_index(p_number));  % 将第二个父代的p_var号工件的第p_number道工序对应的机器，赋值给第一个父代相同的工件工序
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


        % 基于工序和设备变异
        if rand(1)<mutation  % 变异概率
            parent_3 = randperm(N,1);
            parent_4 = randperm(N,1);
            p_parent_3 = p_parent_chromosome(parent_3,1:M-V-2);  % 参与工序变异的染色体
            m_parent_3 = m_parent_chromosome(parent_3,:);  % 参与机器变异的染色体
            p_parent_4 = p_parent_chromosome(parent_4,1:M-V-2);
            m_parent_4 = m_parent_chromosome(parent_4,:);
            c3_p=p_parent_3;
            c3_m=m_parent_3;
            c4_p=p_parent_4;
            c4_m=m_parent_4;
            rand_num_1=randperm(M-V-2,1);  % 基于工序变异的，参与变异的第1个位置
            rand_num_2=randperm(M-V-2,1);  % 基于工序变异的，参与变异的第2个位置
            while isequal(rand_num_1,rand_num_2)  % 确保变异位置不同
                rand_num_2=randperm(M-V-2,1);
            end

            %基于工序变异方法有误，请自行编写
            % c3_p(rand_num_1)=p_parent_3(rand_num_2);
            % c3_m(rand_num_1)=m_parent_3(rand_num_2);
            % c3_p(rand_num_2)=p_parent_3(rand_num_1);
            % c3_m(rand_num_2)=m_parent_3(rand_num_1);
            % p_child_matrix(k,:)=c3_p;
            % m_child_matrix(k,:)=c3_m;
            % k=k+1;

            % 基于设备的变异
            rand_num_3=randperm(M-V-2,1);  % 参与变异的第3个位置
            rand_num_4=randperm(M-V-2,1);  % 参与变异的第4个位置
            while isequal(rand_num_3,rand_num_4)  % 确保变异位置不同
                 rand_num_4=randperm(M-V-2,1);
            end
            p_var_3=p_parent_4(rand_num_3);
            p_var_4=p_parent_4(rand_num_4);
            muta_index_1=find(p_parent_4==p_var_3);  % 变异工件号p_var_3在p_parent_4中的位置索引
            num_of_p_1=find(muta_index_1==rand_num_3);  % 工件p_var的第num_of_1道工序
            muta_index_2=find(p_parent_4==p_var_4);
            num_of_p_2=find(muta_index_2==rand_num_4);

            % 从对应工件工序的可选加工机器集中，随机选择一个机器，替代原先的加工机器
            m1=randperm(size(J(p_var_3).m{num_of_p_1},2),1);
            m2=randperm(size(J(p_var_4).m{num_of_p_2},2),1);
            c4_m(rand_num_3)=J(p_var_3).m{num_of_p_1}(m1);  % 应改为 c4_m 为 c3_m？
            c4_m(rand_num_4)=J(p_var_4).m{num_of_p_2}(m2);

            p_child_matrix(k,:)=c4_p;
            m_child_matrix(k,:)=c4_m;
            k=k+1;
        end
    end 
end
