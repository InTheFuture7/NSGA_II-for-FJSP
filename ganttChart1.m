%{ 
    绘制甘特图
%}
function f = ganttChart1(J, P_chromosome, M, mac_t)
    P=P_chromosome(1, 1:(size(P_chromosome,2)-4));  % 如果需修改目标函数个数，那么需要修改4。
    % P=P_chromosome(1:28);  % 如果需修改目标函数个数，那么需要修改4。获得工件编码(1,28)
    % P=P_chromosome(1:50);  % 如果需修改目标函数个数，那么需要修改4。获得工件编码(1,28)

    p_text=[];  % 记录各工件的工序编号信息，比如：工件i的第1个工序记录为1，第2道工序记录为2……
    m_info=[];  % 记录设备的加工信息，比如：机器i的第1次参与加工记录为1，第2次加工记录为2……
    p_color=[];  % 工序与颜色对应，用数字表示工件的颜色
    % color=['#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30', '#A2142F','#4DBEEE','#FFFF00','#F0FFF0','##D3D3D3','#F5DEB3'];
    color=['r','g','b','c','m','y'];
    for i=1:size(J,2)  % 依次迭代所有工件
        p_index=find(P==i);  % 查找工件 i 在工序编码中的位置
        % 工件与颜色对应：1-2，2-3，3-4，4-5，5-6，6-1，7-2，8-3
        color_i=mod(i,6)+1;  % i 除以 6 后的余数 +1
        % color_i=i;  % 对应line9
        for j=1:size(p_index,2)  % 依次遍历工件i的所有工序，从第j道工序开始
            p_var=p_index(j);  % 查看工件i的第j个工序在工序编码P中的位置 p_var
            p_text(p_var)=j;
            p_color(p_var)=color_i;
        end
    end

    for i=1:J(1).num_mac  % 遍历所有机器
        m_index = find(M==i);  % 查找机器 i 在机器编码M中的位置
        if size(m_index,1)>=1 && size(m_index,2)>=1  % 加工中，有使用到第i台机器
            for j=1:size(m_index,2)
                m_var=m_index(j);
                m_info(m_var)=j;
            end
        end
    end

    n_bay_nb=J(1).num_mac;  % 机器总数目
    n_task_nb=length(P);  % 工序总数

    c_time=P_chromosome(size(P,2)+1);  %所需的消耗时间
    % disp(c_time)
    % d_time=P_chromosome(size(P,2)+2);  % 延期时间
    e_load=P_chromosome(size(P,2)+2);  % 设备负荷
    % disp(e_load)
    % e_cons=P_chromosome(size(P,2)+4);  % 能量消耗

    axis([0, P_chromosome(size(P,2)+1)+2, 0, n_bay_nb+0.5]);  % x轴（所需的消耗时间+2） y轴的范围（机器数+2）
    set(gca, 'xtick', 0:2:c_time);  % x轴的增长幅度
    set(gca, 'ytick', 0:1:n_bay_nb+0.5);  % y轴的增长幅度
    xlabel('加工时间'), ylabel('机器号');  % x轴 y轴的名称
    % sche_info=sprintf('最大完工时间:%d  总延期:%d 设备总负载:%d 能耗总量:%.2fKw/h',c_time,d_time,e_load,e_cons)
    sche_info=sprintf('最大完工时间:%d 设备总负载:%d', c_time, e_load)
    title(sche_info);  % 图形的标题
    rec=[0,0,0,0];

    for i=1:n_task_nb  % 依次遍历所有工序
        % 以 (rec(1), rec(2)) 为矩形右下角，水平向右绘制rec(3)单位，向上绘制rec(4)单位
        rec(1) = mac_t{M(i)}(m_info(i),1);  % 第M(i)号机器的第m_info(i)次加工的开始加工时间
        rec(2) = M(i)-0.3;
        rec(3) = mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);  % 矩形的x轴方向的长度
        rec(4) = 0.6;  % 矩形y轴方向长度
        % 将机器号，工序号，加工时间连成字符串
        % 工件P(i)的第p_text(i)道工序，设备加工用时mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1)
        %{
            todo:根据这行代码作修改。工件P(i),工件i的工序数p_text(i),加工机器号M(i),加工时间mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1))
            用变量存储，然后格式化为矩阵。
            格式为：一个矩阵表示一个工件，矩阵中的一行表示一个工序，列为机器，行列交叉为机器k加工工序的用时
        %}

        txt=sprintf('%d p(%d,%d)=%d', i, P(i), p_text(i), mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1));  
        % 在(mac_t{M(i)}(m_info(i),1)+0.2, M(i))位置，增加txt文字说明
        rectangle('Position', rec, 'LineWidth', 0.5, 'LineStyle', '-', 'FaceColor', color(p_color(i)));  %draw every rectangle  
        text(mac_t{M(i)}(m_info(i),1)+0.3, M(i), txt, 'FontWeight', 'Bold', 'FontSize', 8);
        % if i<=28
        %    disp('no attention!')
        % else
        %     disp('!!!!!!!!!!!!')
        % end
    end
    
    proce_time = cell(1, length(J));
    for j = 1:length(J) 
        proce_time{j} = ones(J(j).a(1), J(1).num_mac)*9999;
    end

    for i =1:n_task_nb  % 依次遍历所有工序
        proce_time{P(i)}(p_text(i), M(i)) = mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);        
    end
    save proce_time proce_time;
end

