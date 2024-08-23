%主函数
function nsga2_scheduling
    clear all;
    clc;
    pop = 200;  % 种群数量
    gen = 30;  % 迭代次数
    pop_f=150;  % 父代种群数量
    data_mac;  % 载入车间设备信息
    data_pro;  % 载入待加工工件信息
    pro_matrix=[];  % 包含工序及目标函数值得决策矩阵
    mac_matrix=[];  % 包含设备染色体信息的决策矩阵

    for i=1:pop_f  %生成初始种群
        [P,M,N]=initPop(J);
        [part_t, mac_t, ~]=decode(J,P,M,N);  % part_t为对应工件各工序加工时间信息  mac_t为对应设备各工序加工时间信息
        
        % 2个目标函数都是越小越好
        c_time=cal_comp_time(part_t);  % 计算最大完工时间 part_t 为调度方案所对应的加工时间信息
        % d_time=cal_def_time(J,part_t);  % 计算总延期时长，删掉
        t_load=cal_equ_load(part_t);  % 计算设备总负荷
        % t_cons=cal_ene_consu(Mac,mac_t,P,M,c_time);  % 计算调度方案的总能耗 Time为最大完工时间，删掉

        pro_matrix(i,:)=[P, c_time, t_load];
        mac_matrix(i,:)=M;
    end
    
    for i = 1 : gen  % gen 迭代次数
        pool = round(pop/2);  % round() 四舍五入取整 交配池大小
        tour = 2;  % 锦标赛  参赛选手个数
        % 返回每个个体对应的排序值和拥挤距离，是一个两列的矩阵
        [p_matrix, m_matrix]= non_domination_sort_mod(pro_matrix, mac_matrix);  % 种群进行非支配快速排序和拥挤度计算
        clear pro_matrix;
        clear mac_matrix;
        [p_parent_chromosome, m_parent_chromosome] = tournament_selection(p_matrix, m_matrix, pool, tour);  % 竞标赛选择适合繁殖的父代

        % 交叉变异生成子代种群
        [p_child_matrix, m_child_matrix]=genetic_operator(J, p_parent_chromosome, m_parent_chromosome);

        % 根据父类和子类总种群，进行非支配快速排序，选取出下一代的父代种群
        for j=1:size(p_child_matrix,1)
            P=p_child_matrix(j,:);
            M=m_child_matrix(j,:);
            N=machine_index(J,P,M);
            [part_t,mac_t, ~]=decode(J,P,M,N);

            c_time=cal_comp_time(part_t);
            % d_time=cal_def_time(J,part_t);
            t_load=cal_equ_load(part_t);
            % t_cons=cal_ene_consu(Mac,mac_t,P,M,c_time);
        
            pro_matrix(j,:)=[P, c_time, t_load];
            mac_matrix(j,:)=M;
        end
        n_p_m=size(pro_matrix,1);
        pro_matrix(n_p_m+1:n_p_m+10, :)=p_matrix(1:10, 1:size(pro_matrix,2));  % 保留10个精英染色体到子代种群中
        mac_matrix(n_p_m+1:n_p_m+10, :)=m_matrix(1:10, :);
    end

    [p_matrix,m_matrix]= non_domination_sort_mod(pro_matrix,mac_matrix);
    num_of_level_1=length(find(p_matrix(:, size(p_matrix,2)-1)==1));  % 找出支配度等级为1的行个数
    target_p_matrix = p_matrix(1:num_of_level_1,:);  % 取出支配度等级为 1 的行，工序编码
    target_m_matrix = m_matrix(1:num_of_level_1,:);
    % best_p = target_p_matrix(1,:);  % 选取第一个作为最优解，可根据需求，选择AHP和熵权法或模糊决策法，选出最优解
    % best_m = target_m_matrix(1,:);

    % 使用 熵权法（不带时间维度的） 选出最优解
    %disp(target_p_matrix)  % 选取第 51、52
    optimal_index = entropy_weight_method(target_p_matrix(:, [51, 52]));
    save target_p_matrix target_p_matrix;

    best_p = target_p_matrix(optimal_index,:);
    best_m = target_m_matrix(optimal_index,:);

    P = best_p(1:length(best_p)-4);  % 取出最优解的28道工序编码，注意，如果修改目标函数数，则修改这里的4
    M = best_m;
    N = machine_index(J,P,M);
    [part_t, mac_t, t_span]=decode(J,P,M,N);
    % save P P;
    save M M;
    % save N N;
    % save mac_t mac_t;
    % save part_t part_t;
    save best_p;
    ganttChart1(J, best_p, M, mac_t);
    % disp(best_p)
end

