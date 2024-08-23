% 贪婪解码算法  J为参与调度的工件的所有信息  P为调度方案的基于工序编码的染色体 
% M为调度方案的基于机器编码的染色体  N为所选设备在对应可选设备集中的序列号
% part_t为对应工件各工序加工时间信息  mac_t为对应设备各工序加工时间信息
function [part_t,mac_t,t_span]= decode(J,P,M,N)
    part_t=cell(size(J,2));  % 加工零件的加工时间
    mac_t=cell(J(1).num_mac);  % 对应设备加工时间
    [~,total_n]=size(P);  % total_n 为总工序数
    part_n=size(J,2);
    k_part=zeros(1,part_n);  % 记录当前解码过程中工件的工序号
    k_mac=zeros(1, J(1).num_mac);  % 记录当前解码过程中该到工序在该设备中待加工序号
    t_span=cell(1);  % 记录该所有设备加工间隙/待机
    % k_N=zeros(1,part_n);
    for i=1:total_n
        p_var=P(i);  % 工件p_var
        m_var=M(i);  % 第i个工件工序对应的加工设备
        n_var=N(i);  % 该基因所选设备在可选设备集中的序号
        k_part(p_var)=k_part(p_var)+1;
        k_mac(m_var)=k_mac(m_var)+1;
        % m_span{m_var}  % 第m_var台设备当前所存在的加工间隙
        pro_time=J(p_var).t{k_part(p_var)}(n_var);  % 该道工序所需加工时间，每轮循环后更新
        
        % 确定该工序开始的加工时间
        % 基于工件的约束
        if k_part(p_var)>1  % 若>1，则表明当前Oij不是工件i的首道工序
            start_t_p=part_t{p_var}(k_part(p_var)-1,2);  % 查看Oij工序加工时间表中，工件i的上一道工序结束时间 O_(i,j-1)
        else
            start_t_p=0;
        end
        % 基于加工设备的约束
        if k_mac(m_var)>1  % 若>1，则表明当前Oij不是机器k第一次加工的工件
            % start_t_m=mac_t{m_var}(k_mac(m_var)-1,2);  % 查看机器加工时间表中，机器k上一次加工结束时间
            start_t_m = max(mac_t{m_var}(:, 2));  % ！！！！
        else
            start_t_m=0;
        end

        % % 找到第二列的最大值
        % [max_val, maxIndex] = max(mac_t{m_var}(:, 2));
        % % 获取第一列对应的最大值所在的行索引的数值
        % mact_var_max_firt_column_value = mac_t{m_var}(maxIndex, 1);
        % 
        % 
        % if start_t_p < mact_var_max_firt_column
        %     % 考虑插入
        % 
        %     sorted_mac_t = sortrows(mac_t{m_var}, 1);
        %     % 计算下一行第一列元素减去上一行第二列元素
        %     % 第一列第一行元素减0
        %     span_t_ = zeros(size(sorted_mac_t, 1), 1); % 初始化span_t向量
        %     span_t_(1) = sorted_mac_t(1, 1) - 0; % 第一行第一列元素减0
        %     for i = 2:size(sorted_mac_t, 1)
        %         % 下一行第一列元素减去上一行第二列元素
        %         span_t_(i) = sorted_mac_t(i, 1) - sorted_mac_t(i-1, 2);
        %     end
        %     % mac_t和span的顺序很难明确！！！
        %     for i = 1:length(span_t_)  % 从最小的span_t_开始迭代
        %         if (span_t_ >= pro_time)
        %            if (mac_t{m_var}(:,1) >= start_t_p+pro_time)
        %                % 
        % 
        %            end
        %         end
        %     end
        % 
        %     % span=t_span{m_var}(:,2)-t_span{m_var}(:,1);  % 访问 t_span{m_var}(:,1) 第一列元素
        %     req_span=intersect(find(span_t_>=pro_time), find(span_t_{m_var}(:,2)>=start_t_p+pro_time));
        % 
        %     if size(req_span,1)>=1 && size(req_span,2)  % 可以插入加工
        %         var=req_span(1);  % 选择第一个间隙加工
        %         start_t=max(start_t_p, t_span{m_var}(var, 1));  % 比较上一工序的加工结束时间、机器m_var的第var次待机开始时间
        %         % % 更新插入产生的新间隙：插入工序的加工开始+所需时间、机器m_var的第req_span次待机结束时间
        %         % t_span{m_var}(k_mac(m_var),:) = [start_t+pro_time, t_span{m_var}(var,2)]; 
        % 
        %         % ！！！t_span{m_var}(var,2)=start_t;  % 更新插入后对已有间隙的影响：机器m_var的第req_span次待机结束时间=插入工序的开始加工时间start_t
        %         % t_span{m_var}=sortrows(t_span{m_var}, 1);  % 基于t_span第一列中的元素按升序重新排列
        %     else  % 无法插入加工，等机器空闲后，再开始加工
        %         start_t=max_val;
        %         % t_span{m_var}(k_mac(m_var),:) = [！！！mac_t{m_var}(k_mac(m_var)-1,2), start_t];
        %     end
        % else
        %     % 不插入
        %     if start_t_p <= max_val
        %         start_t = max_val
        %         % t_span{m_var}(k_mac(m_var),:)=[start_t_m, start_t];
        %     else
        %         start_t = start_t_p
        %         % t_span{m_var}(k_mac(m_var),:)=[start_t_m, start_t];
        %     end
        % end


        % -----------------------------------------------
        % 判断最终约束 在机器加工间隙插入工件工序
        if start_t_p>=start_t_m  % 如果上一道工序后结束，目标加工机器暂待机，那么不用考虑从机器加工间隙
            start_t=start_t_p;  % 根据先结束的工序加工结束时间计算，本次Oij的开始加工时间
            % 不发生前插时的，更新设备间隙矩阵
            if k_mac(m_var)>1  % 正要被使用的机器之前是否有参与加工
                % t_span{m_var}(k_mac(m_var),:)=[mac_t{m_var}(k_mac(m_var)-1,2),start_t];  % [机器k上一次加工结束时间,本次加工开始时间]
                % [机器k上一次加工结束时间,本次加工开始时间]
                t_span{m_var}(k_mac(m_var),:)=[start_t_m, start_t];
            else
                t_span{m_var}(k_mac(m_var),:)=[0,start_t];  % m_var机器的第k_mac(m_var)次加工记录，0->start_t为待机时间
            end
        else
            % 机器m_var的每次待机时间
            span=t_span{m_var}(:,2)-t_span{m_var}(:,1);  % 访问 t_span{m_var}(:,1) 第一列元素
            %{
            找出两个条件同时满足的索引位置：本次加工能在机器m_var的某次待机/加工间隙中完成
            1、能在待机/加工间隙完成加工 span>=pro_time；2、开始本次加工时间+用时<=另一个工件的加工开始时间
            返回值为机器m_var的第req_span次待机/加工间隙
            %} 
            % req_span=intersect(find(span>=pro_time), find(t_span{m_var}(:,2)>=t_span{m_var}(:,1)+pro_time));
            req_span=intersect(find(span>=pro_time), find(t_span{m_var}(:,2)>=start_t_p+pro_time));
            % req_span=find(span>=pro_time);
            if size(req_span,1)>=1 && size(req_span,2)  % 可以插入加工
                var=req_span(1);  % 选择第一个间隙加工
                start_t=max(start_t_p, t_span{m_var}(var,1));  % 比较上一工序的加工结束时间、机器m_var的第var次待机开始时间
                % 更新插入产生的新间隙：插入工序的加工开始+所需时间、机器m_var的第req_span次待机结束时间
                t_span{m_var}(k_mac(m_var),:)=[start_t+pro_time, t_span{m_var}(var,2)]; 
                t_span{m_var}(var,2)=start_t;  % 更新插入后对已有间隙的影响：机器m_var的第req_span次待机结束时间=插入工序的开始加工时间start_t
                % t_span{m_var}=sortrows(t_span{m_var}, 1);  % 基于t_span第一列中的元素按升序重新排列
            else  % 无法插入加工，等机器空闲后，再开始加工
                start_t=start_t_m;  % 修改了！
                t_span{m_var}(k_mac(m_var),:)=[mac_t{m_var}(k_mac(m_var)-1,2),start_t];
            end
        end
        % -----------------------------------------------


        stop_t=start_t+pro_time;
        part_t{p_var}(k_part(p_var),:)=[start_t,stop_t];
        mac_t{m_var}(k_mac(m_var),:)=[start_t,stop_t];
    end
end

