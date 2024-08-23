%{ 
输入：
    p_chromosome,m_chromosome 为根据patro解集排好序的种群工序、机器编码
    pool_size锦标赛比赛的场次；tour_size 每场锦标赛的参赛选手个数
算法：
    因为设定 pop_f=100，而初始种群数为 200，所以进行100轮比赛，每次两两比较。
    每次随机选择两个个体，优先选择排序等级高的个体。
    如果排序等级一样，优先选择拥挤度大的个体，如果拥挤度相同则选序号小的那一个
    
    ！！！注意：这里是随机选择两个个体，可能会被重复选择
输出：
    p_parent_chromosome、m_parent_chromosome 记录优胜者个体，内容复制自p_chromosome、m_chromosome
%} 
function [p_parent_chromosome,m_parent_chromosome] = tournament_selection(p_chromosome,m_chromosome ,pool_size, tour_size)
    [pop, variables] = size(p_chromosome);  % 获得种群的个体数量和决策变量数量 pop种群数量 
    rank = variables - 1;  % 个体向量中排序值所在位置
    distance = variables;  % 个体向量中拥挤度所在位置
    for i = 1 : pool_size
        for j = 1 : tour_size
            candidate(j) = round(pop*rand(1));  % 随机选择参赛个体，用candidate存储
            if candidate(j) == 0  % 避免round()选择了0
                candidate(j) = 1;
            end
            if j > 1
                while ~isempty(find(candidate(1 : j - 1) == candidate(j)))  % 防止两个参赛个体是同一个
                    % 当两个参赛个体为同一个，则执行以下代码。不断循环，直到两个个体不同
                    candidate(j) = round(pop*rand(1));  % 重新选择参赛个体
                    if candidate(j) == 0  % 避免round()选择了0
                        candidate(j) = 1;
                    end
                end
            end
        end

        for j = 1 : tour_size  % 记录每个参赛者的排序等级、拥挤度
            c_obj_rank(j) = p_chromosome(candidate(j), rank);
            c_obj_distance(j) = p_chromosome(candidate(j),distance);
        end
        % 选择排序等级较小的参赛者，并返回该参赛者在参赛者集合中的索引号
        min_candidate = find(c_obj_rank == min(c_obj_rank));
        if length(min_candidate) ~= 1  % 如果两个参赛者的排序等级相等，则优先选择拥挤度大的个体
            % 选择拥挤距离较大的参赛者，并返回该参赛者在参赛者集合中的索引号
            max_candidate = find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
            if length(max_candidate) ~= 1  % 如果两个拥挤距离也相等，那么选择下标小的
                max_candidate = max_candidate(1);
            end
            p_parent_chromosome(i,:) = p_chromosome(candidate(min_candidate(max_candidate)),:);
            m_parent_chromosome(i,:) = m_chromosome(candidate(min_candidate(max_candidate)),:);   
        else  % 如果两个参赛者的排序等级不相等，则选择等级靠前的
            p_parent_chromosome(i,:) = p_chromosome(candidate(min_candidate(1)),:);
            m_parent_chromosome(i,:) = m_chromosome(candidate(min_candidate(1)),:);
        end
end