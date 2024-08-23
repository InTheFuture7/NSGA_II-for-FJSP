%% �Գ�ʼ��Ⱥ��ʼ���� ���ٷ�֧������
% ʹ�÷�֧���������Ⱥ�������򡣸ú�������ÿ�������Ӧ������ֵ��ӵ�����룬��һ�����еľ���  
% ��������ֵ��ӵ��������ӵ�Ⱦɫ�������
% x�����߾���  M���Ż�Ŀ������ V�����߱�������

%{
���룺pro_matrixΪ���и���Ĺ�������+������Ŀ�꺯��ֵ��mac_matrixΪ���и���Ļ������롣��������ÿ��һһ��Ӧ
�㷨������Ŀ�꺯���������֧��⼯���Լ�֧�伯�е�ӵ������
�����p_matrix��¼ÿ������������֧�伯�ȼ��Լ�ӵ������ֵ��������֧�伯�ȼ�����m_matrix��¼��p_matrix�������Ӧ�Ļ�������
%}
function [p_matrix,m_matrix] = non_domination_sort_mod(pro_matrix, mac_matrix)
    [N, ~] = size(pro_matrix);  % NΪ����x��������Ҳ����Ⱥ������
    % M=4;  % �Ż�Ŀ������
    M=2;  % �Ż�Ŀ������
    V=size(pro_matrix, 2)-M;  % ���߱���������Oij�ĸ���
    front = 1;
    F(front).f = [];  % ��¼pareto�⼯�ȼ�Ϊfront���ĸ��弯��
    individual = [];  % ���ڴ�ű�ĳ������֧��ĸ��弯��

    % ���ٷ�֧������
    % ��һ���֣��ҳ��ȼ���ߵķ�֧��⼯
    for i = 1 : N
        individual(i).n = 0;  % n�Ǹ���i��֧��ĸ�������
        individual(i).p = [];  % p�Ǳ�����i֧��ĸ��弯��
        for j = 1 : N
            dom_less = 0;
            dom_equal = 0;
            dom_more = 0;
            for k = 1 : M  % ����M��Ŀ�꺯����ԽСԽ�ã����жϸ���i�͸���j��֧���ϵ��
                if (pro_matrix(i,V + k) < pro_matrix(j,V + k))  
                    dom_less = dom_less + 1;
                elseif (pro_matrix(i,V + k) == pro_matrix(j,V + k))
                    dom_equal = dom_equal + 1;
                else
                    dom_more = dom_more + 1;
                end
            end
            if dom_less == 0 && dom_equal ~= M  % ˵��i��Ŀ�꺯���Ͼ����ڵ���j��i��j֧�䣬��Ӧ��n��1
                individual(i).n = individual(i).n + 1;
            elseif dom_more == 0 && dom_equal ~= M  % ˵��i֧��j,��j����i��֧��ϼ���
                individual(i).p = [individual(i).p j];
            end
        end   

        if individual(i).n == 0  % ����i��֧��ȼ�������ߣ����ڵ�ǰ���Ž⼯����Ӧ��Ⱦɫ����Я����������������Ϣ
            pro_matrix(i,M + V + 1) = 1;  % ����һ�У���ֵΪ1�����Ϊrank=1
            F(front).f = [F(front).f i];  % �ȼ�Ϊ1�ķ�֧��⼯
        end
    end

    % �ڶ����֣��ҳ������ȼ��ķ�֧��⼯
    while ~isempty(F(front).f)
       Q = [];  % �����һ��front����
       for i = 1 : length(F(front).f)  % ѭ����ǰ֧��⼯�еĸ���
           if ~isempty(individual(F(front).f(i)).p)  % ����i���Լ���֧��Ľ⼯
                for j = 1 : length(individual(F(front).f(i)).p)  % ѭ������i��֧��⼯�еĸ���
                    individual(individual(F(front).f(i)).p(j)).n = ...  %...��ʾ��������һ�д����������ģ������ʾ����j�ı�֧�������1
                        individual(individual(F(front).f(i)).p(j)).n - 1;
                    if individual(individual(F(front).f(i)).p(j)).n == 0  % ���q�Ƿ�֧��⼯������뼯��Q��
                        pro_matrix(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;  % ����Ⱦɫ���м���ּ���Ϣ
                        Q = [Q individual(F(front).f(i)).p(j)];
                    end
                end
           end
       end
       front = front + 1;
       F(front).f = Q;  % �����һ���������while�ж�ʱ����Ϊ~isempty(F(front).f)=true����Q=[]������F�ж�һ����Ԫ��
    end
    
    % Fÿ�б�ʾÿ��ǰ�����еĸ���

    % �����и���Ĵ�������ȼ�����������������������temp Ϊ������ɵ��У�index_of_fronts��ʾ������ֵ��Ӧԭ��������
    [temp, index_of_fronts] = sort(pro_matrix(:, M + V + 1));  
    for i = 1 : length(index_of_fronts)
        % sorted_based_on_front��m_matrix�д�ŵ��� pro_matrix��mac_matrix��X�� ����������ȼ����������ľ���
        sorted_based_on_front(i,:) = pro_matrix(index_of_fronts(i),:);  
        m_matrix(i,:)=mac_matrix(index_of_fronts(i),:);
    end
    % m_matrix ����ǰ����ȼ��������֧�伶���ν��ͣ�����mac_matrixԪ����������Ľ��


    %% Crowding distance ����ÿ�������ӵ����
    % �Ӹ��弯������ȡÿ��ǰ���漯�ϣ��Ե�front��ǰ���棬����ÿ��Ŀ�꺯��ֵ�ò�ֵ-��һ��-��ͣ�����p_matrix
    current_index = 0;
    for front = 1:(length(F) - 1)  % Line60 F(front).f = Q��F�е����һ��Ԫ��Ϊ�գ�����һ����length(F)-1������ȼ�
        distance = 0;
        y = [];
        previous_index = current_index + 1;
        for i = 1:length(F(front).f)
            y(i,:) = sorted_based_on_front(current_index + i,:);  % y �д�ŵ�������ȼ�Ϊfront�ļ��Ͼ���
            % z(i,:) = mac_sorted_based(current_index+i,:);  %z�д���ǵȼ�Ϊfront�Ķ�Ӧ�ļӹ��豸���Ͼ���
        end
        current_index = current_index + i;  %current_index =i
        sorted_based_on_objective = [];  %��Ż���ӵ����������ľ���
        for i = 1 : M
            % sorted_based_on_objective�洢 y �а��� i ��Ŀ�꺯��ֵ������¾���
            % index_of_objectivesΪ y ���յ� i ��Ŀ�꺯������󣬴�С������ж�Ӧ������
            [sorted_based_on_objective, index_of_objectives] = sort(y(:,V + i));  %����Ŀ�꺯��ֵ����
            sorted_based_on_objective = [];
            for j = 1 : length(index_of_objectives)
                sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);  % sorted_based_on_objective��Ű���Ŀ�꺯��ֵ������x����
                % mac_sorted_matrix(j,:)=z(index_of_objectives(j),:)
            end
            % fmaxΪĿ�꺯�����ֵ fminΪĿ�꺯����Сֵ
            f_max = sorted_based_on_objective(length(index_of_objectives), V + i);  
            f_min = sorted_based_on_objective(1, V + i);
            % �������ĵ�һ����������һ������ľ�����Ϊ�����
            y(index_of_objectives(length(index_of_objectives)), M + V + 1 + i)=inf; 
            y(index_of_objectives(1), M + V + 1 + i) = inf;
            for j = 2 : length(index_of_objectives) - 1  % ѭ�������г��˵�һ�������һ���ĸ��� 2 3 4
                next_obj = sorted_based_on_objective(j + 1, V + i);
                previous_obj = sorted_based_on_objective(j - 1, V + i);
                if (f_max - f_min == 0)
                    y(index_of_objectives(j), M + V + 1 + i) = inf;
                else
                    y(index_of_objectives(j), M + V + 1 + i) = (next_obj - previous_obj)/(f_max - f_min);
                end
            end
        end
        distance = [];
        distance(:,1) = zeros(length(F(front).f),1);
        for i = 1 : M
            distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
        end
        y(:,M + V + 2) = distance;
        y = y(:,1 : M + V + 2);
        p_matrix(previous_index:current_index, :) = y;
    end
end