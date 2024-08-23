function optimal_index = entropy_weight_method(A)  
    % 归一化矩阵  
    [m, n] = size(A);  
    P = A ./ sum(A, 1);  % 每列元素除以该列的和  

    % 计算各个指标的信息熵  
    k = -1 / log(m);  % 常数  
    E = -k * sum(P .* log(P + eps), 1);  % 避免对数0  
   
    % 计算熵权  
    d = 1 - E;  % 权重  
    w = d / sum(d);  % 权重归一化  

    % 计算方案的最终得分  
    s = w * P'; % 得分向量  
    [sorted_scores, sorted_indices] = sort(s, 'descend');  % 按得分降序排列  

    % 返回最优得分对应行在输入矩阵中的索引号  
    optimal_index = sorted_indices(1);  
end  