% 计算设备总负荷
function total_load = cal_equ_load(part_t)
    total_load=0;
    for i=1:size(part_t, 2)
        for j=1:size(part_t{i}, 1)
            total_load = total_load + part_t{i}(j,2) - part_t{i}(j,1);
        end
    end
end