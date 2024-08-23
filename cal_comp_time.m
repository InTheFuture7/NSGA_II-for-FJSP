% 计算最大完工时间 part_t 为调度方案所对应的加工时间信息
function max_comp_time = cal_comp_time(part_t)
    max_time=[];  % 记录各工件的最大完工时间
    for i=1:size(part_t,2)
        m=size(part_t{i},1);
        max_time=[max_time, part_t{i}(m,2)];  % 工件i的最大完工时间，并添加到矩阵max_time中
    end
    max_comp_time=max(max_time);
end

