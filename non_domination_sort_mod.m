%% 对初始种群开始排序 快速非支配排序
% 使用非支配排序对种群进行排序。该函数返回每个个体对应的排序值和拥挤距离，是一个两列的矩阵。  
% 并将排序值和拥挤距离添加到染色体矩阵中
% x：决策矩阵  M：优化目标数量 V：决策变量个数

%{
输入：pro_matrix为所有个体的工件编码+若干列目标函数值；mac_matrix为所有个体的机器编码。两个编码每行一一对应
算法：根据目标函数，计算各支配解集，以及支配集中的拥挤距离
输出：p_matrix记录每个个体所属的支配集等级以及拥挤距离值，并按照支配集等级排序；m_matrix记录与p_matrix各行相对应的机器编码
%}
function [p_matrix,m_matrix] = non_domination_sort_mod(pro_matrix, mac_matrix)
    [N, ~] = size(pro_matrix);  % N为矩阵x的行数，也是种群的数量
    % M=4;  % 优化目标数量
    M=2;  % 优化目标数量
    V=size(pro_matrix, 2)-M;  % 决策变量个数，Oij的个数
    front = 1;
    F(front).f = [];  % 记录pareto解集等级为front级的个体集合
    individual = [];  % 用于存放被某个个体支配的个体集合

    % 快速非支配排序
    % 第一部分：找出等级最高的非支配解集
    for i = 1 : N
        individual(i).n = 0;  % n是个体i被支配的个体数量
        individual(i).p = [];  % p是被个体i支配的个体集合
        for j = 1 : N
            dom_less = 0;
            dom_equal = 0;
            dom_more = 0;
            for k = 1 : M  % 根据M个目标函数（越小越好），判断个体i和个体j的支配关系。
                if (pro_matrix(i,V + k) < pro_matrix(j,V + k))  
                    dom_less = dom_less + 1;
                elseif (pro_matrix(i,V + k) == pro_matrix(j,V + k))
                    dom_equal = dom_equal + 1;
                else
                    dom_more = dom_more + 1;
                end
            end
            if dom_less == 0 && dom_equal ~= M  % 说明i在目标函数上均大于等于j，i受j支配，相应的n加1
                individual(i).n = individual(i).n + 1;
            elseif dom_more == 0 && dom_equal ~= M  % 说明i支配j,把j加入i的支配合集中
                individual(i).p = [individual(i).p j];
            end
        end   

        if individual(i).n == 0  % 个体i非支配等级排序最高，属于当前最优解集，相应的染色体中携带代表排序数的信息
            pro_matrix(i,M + V + 1) = 1;  % 新增一列，赋值为1，标记为rank=1
            F(front).f = [F(front).f i];  % 等级为1的非支配解集
        end
    end

    % 第二部分：找出其他等级的非支配解集
    while ~isempty(F(front).f)
       Q = [];  % 存放下一个front集合
       for i = 1 : length(F(front).f)  % 循环当前支配解集中的个体
           if ~isempty(individual(F(front).f(i)).p)  % 个体i有自己所支配的解集
                for j = 1 : length(individual(F(front).f(i)).p)  % 循环个体i所支配解集中的个体
                    individual(individual(F(front).f(i)).p(j)).n = ...  %...表示的是与下一行代码是相连的，这里表示个体j的被支配个数减1
                        individual(individual(F(front).f(i)).p(j)).n - 1;
                    if individual(individual(F(front).f(i)).p(j)).n == 0  % 如果q是非支配解集，则放入集合Q中
                        pro_matrix(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;  % 个体染色体中加入分级信息
                        Q = [Q individual(F(front).f(i)).p(j)];
                    end
                end
           end
       end
       front = front + 1;
       F(front).f = Q;  % 在最后一层排序进入while判断时，因为~isempty(F(front).f)=true，但Q=[]，所以F中多一个空元素
    end
    
    % F每行表示每层前沿面中的个体

    % 对所有个体的代表排序等级的列向量，进行升序排序，temp 为排序完成的列；index_of_fronts表示排序后的值对应原来的索引
    [temp, index_of_fronts] = sort(pro_matrix(:, M + V + 1));  
    for i = 1 : length(index_of_fronts)
        % sorted_based_on_front、m_matrix中存放的是 pro_matrix、mac_matrix（X） 矩阵按照排序等级升序排序后的矩阵
        sorted_based_on_front(i,:) = pro_matrix(index_of_fronts(i),:);  
        m_matrix(i,:)=mac_matrix(index_of_fronts(i),:);
    end
    % m_matrix 根据前沿面等级（从最高支配级依次降低），对mac_matrix元素重新排序的结果


    %% Crowding distance 计算每个个体的拥挤度
    % 从个体集中依次取每个前沿面集合，对第front个前沿面，计算每个目标函数值得差值-归一化-求和，存至p_matrix
    current_index = 0;
    for front = 1:(length(F) - 1)  % Line60 F(front).f = Q，F中的最后一个元素为空，所以一共有length(F)-1个排序等级
        distance = 0;
        y = [];
        previous_index = current_index + 1;
        for i = 1:length(F(front).f)
            y(i,:) = sorted_based_on_front(current_index + i,:);  % y 中存放的是排序等级为front的集合矩阵
            % z(i,:) = mac_sorted_based(current_index+i,:);  %z中存放是等级为front的对应的加工设备集合矩阵
        end
        current_index = current_index + i;  %current_index =i
        sorted_based_on_objective = [];  %存放基于拥挤距离排序的矩阵
        for i = 1 : M
            % sorted_based_on_objective存储 y 中按第 i 个目标函数值排序的新矩阵
            % index_of_objectives为 y 按照第 i 个目标函数排序后，从小到大的行对应的索引
            [sorted_based_on_objective, index_of_objectives] = sort(y(:,V + i));  %按照目标函数值排序
            sorted_based_on_objective = [];
            for j = 1 : length(index_of_objectives)
                sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);  % sorted_based_on_objective存放按照目标函数值排序后的x矩阵
                % mac_sorted_matrix(j,:)=z(index_of_objectives(j),:)
            end
            % fmax为目标函数最大值 fmin为目标函数最小值
            f_max = sorted_based_on_objective(length(index_of_objectives), V + i);  
            f_min = sorted_based_on_objective(1, V + i);
            % 对排序后的第一个个体和最后一个个体的距离设为无穷大
            y(index_of_objectives(length(index_of_objectives)), M + V + 1 + i)=inf; 
            y(index_of_objectives(1), M + V + 1 + i) = inf;
            for j = 2 : length(index_of_objectives) - 1  % 循环集合中除了第一个和最后一个的个体 2 3 4
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