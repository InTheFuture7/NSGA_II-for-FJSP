% ̰�������㷨  JΪ������ȵĹ�����������Ϣ  PΪ���ȷ����Ļ��ڹ�������Ⱦɫ�� 
% MΪ���ȷ����Ļ��ڻ��������Ⱦɫ��  NΪ��ѡ�豸�ڶ�Ӧ��ѡ�豸���е����к�
% part_tΪ��Ӧ����������ӹ�ʱ����Ϣ  mac_tΪ��Ӧ�豸������ӹ�ʱ����Ϣ
function [part_t,mac_t,t_span]= decode(J,P,M,N)
    part_t=cell(size(J,2));  % �ӹ�����ļӹ�ʱ��
    mac_t=cell(J(1).num_mac);  % ��Ӧ�豸�ӹ�ʱ��
    [~,total_n]=size(P);  % total_n Ϊ�ܹ�����
    part_n=size(J,2);
    k_part=zeros(1,part_n);  % ��¼��ǰ��������й����Ĺ����
    k_mac=zeros(1, J(1).num_mac);  % ��¼��ǰ��������иõ������ڸ��豸�д��ӹ����
    t_span=cell(1);  % ��¼�������豸�ӹ���϶/����
    % k_N=zeros(1,part_n);
    for i=1:total_n
        p_var=P(i);  % ����p_var
        m_var=M(i);  % ��i�����������Ӧ�ļӹ��豸
        n_var=N(i);  % �û�����ѡ�豸�ڿ�ѡ�豸���е����
        k_part(p_var)=k_part(p_var)+1;
        k_mac(m_var)=k_mac(m_var)+1;
        % m_span{m_var}  % ��m_var̨�豸��ǰ�����ڵļӹ���϶
        pro_time=J(p_var).t{k_part(p_var)}(n_var);  % �õ���������ӹ�ʱ�䣬ÿ��ѭ�������
        
        % ȷ���ù���ʼ�ļӹ�ʱ��
        % ���ڹ�����Լ��
        if k_part(p_var)>1  % ��>1���������ǰOij���ǹ���i���׵�����
            start_t_p=part_t{p_var}(k_part(p_var)-1,2);  % �鿴Oij����ӹ�ʱ����У�����i����һ���������ʱ�� O_(i,j-1)
        else
            start_t_p=0;
        end
        % ���ڼӹ��豸��Լ��
        if k_mac(m_var)>1  % ��>1���������ǰOij���ǻ���k��һ�μӹ��Ĺ���
            % start_t_m=mac_t{m_var}(k_mac(m_var)-1,2);  % �鿴�����ӹ�ʱ����У�����k��һ�μӹ�����ʱ��
            start_t_m = max(mac_t{m_var}(:, 2));  % ��������
        else
            start_t_m=0;
        end

        % % �ҵ��ڶ��е����ֵ
        % [max_val, maxIndex] = max(mac_t{m_var}(:, 2));
        % % ��ȡ��һ�ж�Ӧ�����ֵ���ڵ�����������ֵ
        % mact_var_max_firt_column_value = mac_t{m_var}(maxIndex, 1);
        % 
        % 
        % if start_t_p < mact_var_max_firt_column
        %     % ���ǲ���
        % 
        %     sorted_mac_t = sortrows(mac_t{m_var}, 1);
        %     % ������һ�е�һ��Ԫ�ؼ�ȥ��һ�еڶ���Ԫ��
        %     % ��һ�е�һ��Ԫ�ؼ�0
        %     span_t_ = zeros(size(sorted_mac_t, 1), 1); % ��ʼ��span_t����
        %     span_t_(1) = sorted_mac_t(1, 1) - 0; % ��һ�е�һ��Ԫ�ؼ�0
        %     for i = 2:size(sorted_mac_t, 1)
        %         % ��һ�е�һ��Ԫ�ؼ�ȥ��һ�еڶ���Ԫ��
        %         span_t_(i) = sorted_mac_t(i, 1) - sorted_mac_t(i-1, 2);
        %     end
        %     % mac_t��span��˳�������ȷ������
        %     for i = 1:length(span_t_)  % ����С��span_t_��ʼ����
        %         if (span_t_ >= pro_time)
        %            if (mac_t{m_var}(:,1) >= start_t_p+pro_time)
        %                % 
        % 
        %            end
        %         end
        %     end
        % 
        %     % span=t_span{m_var}(:,2)-t_span{m_var}(:,1);  % ���� t_span{m_var}(:,1) ��һ��Ԫ��
        %     req_span=intersect(find(span_t_>=pro_time), find(span_t_{m_var}(:,2)>=start_t_p+pro_time));
        % 
        %     if size(req_span,1)>=1 && size(req_span,2)  % ���Բ���ӹ�
        %         var=req_span(1);  % ѡ���һ����϶�ӹ�
        %         start_t=max(start_t_p, t_span{m_var}(var, 1));  % �Ƚ���һ����ļӹ�����ʱ�䡢����m_var�ĵ�var�δ�����ʼʱ��
        %         % % ���²���������¼�϶�����빤��ļӹ���ʼ+����ʱ�䡢����m_var�ĵ�req_span�δ�������ʱ��
        %         % t_span{m_var}(k_mac(m_var),:) = [start_t+pro_time, t_span{m_var}(var,2)]; 
        % 
        %         % ������t_span{m_var}(var,2)=start_t;  % ���²��������м�϶��Ӱ�죺����m_var�ĵ�req_span�δ�������ʱ��=���빤��Ŀ�ʼ�ӹ�ʱ��start_t
        %         % t_span{m_var}=sortrows(t_span{m_var}, 1);  % ����t_span��һ���е�Ԫ�ذ�������������
        %     else  % �޷�����ӹ����Ȼ������к��ٿ�ʼ�ӹ�
        %         start_t=max_val;
        %         % t_span{m_var}(k_mac(m_var),:) = [������mac_t{m_var}(k_mac(m_var)-1,2), start_t];
        %     end
        % else
        %     % ������
        %     if start_t_p <= max_val
        %         start_t = max_val
        %         % t_span{m_var}(k_mac(m_var),:)=[start_t_m, start_t];
        %     else
        %         start_t = start_t_p
        %         % t_span{m_var}(k_mac(m_var),:)=[start_t_m, start_t];
        %     end
        % end


        % -----------------------------------------------
        % �ж�����Լ�� �ڻ����ӹ���϶���빤������
        if start_t_p>=start_t_m  % �����һ������������Ŀ��ӹ������ݴ�������ô���ÿ��Ǵӻ����ӹ���϶
            start_t=start_t_p;  % �����Ƚ����Ĺ���ӹ�����ʱ����㣬����Oij�Ŀ�ʼ�ӹ�ʱ��
            % ������ǰ��ʱ�ģ������豸��϶����
            if k_mac(m_var)>1  % ��Ҫ��ʹ�õĻ���֮ǰ�Ƿ��в���ӹ�
                % t_span{m_var}(k_mac(m_var),:)=[mac_t{m_var}(k_mac(m_var)-1,2),start_t];  % [����k��һ�μӹ�����ʱ��,���μӹ���ʼʱ��]
                % [����k��һ�μӹ�����ʱ��,���μӹ���ʼʱ��]
                t_span{m_var}(k_mac(m_var),:)=[start_t_m, start_t];
            else
                t_span{m_var}(k_mac(m_var),:)=[0,start_t];  % m_var�����ĵ�k_mac(m_var)�μӹ���¼��0->start_tΪ����ʱ��
            end
        else
            % ����m_var��ÿ�δ���ʱ��
            span=t_span{m_var}(:,2)-t_span{m_var}(:,1);  % ���� t_span{m_var}(:,1) ��һ��Ԫ��
            %{
            �ҳ���������ͬʱ���������λ�ã����μӹ����ڻ���m_var��ĳ�δ���/�ӹ���϶�����
            1�����ڴ���/�ӹ���϶��ɼӹ� span>=pro_time��2����ʼ���μӹ�ʱ��+��ʱ<=��һ�������ļӹ���ʼʱ��
            ����ֵΪ����m_var�ĵ�req_span�δ���/�ӹ���϶
            %} 
            % req_span=intersect(find(span>=pro_time), find(t_span{m_var}(:,2)>=t_span{m_var}(:,1)+pro_time));
            req_span=intersect(find(span>=pro_time), find(t_span{m_var}(:,2)>=start_t_p+pro_time));
            % req_span=find(span>=pro_time);
            if size(req_span,1)>=1 && size(req_span,2)  % ���Բ���ӹ�
                var=req_span(1);  % ѡ���һ����϶�ӹ�
                start_t=max(start_t_p, t_span{m_var}(var,1));  % �Ƚ���һ����ļӹ�����ʱ�䡢����m_var�ĵ�var�δ�����ʼʱ��
                % ���²���������¼�϶�����빤��ļӹ���ʼ+����ʱ�䡢����m_var�ĵ�req_span�δ�������ʱ��
                t_span{m_var}(k_mac(m_var),:)=[start_t+pro_time, t_span{m_var}(var,2)]; 
                t_span{m_var}(var,2)=start_t;  % ���²��������м�϶��Ӱ�죺����m_var�ĵ�req_span�δ�������ʱ��=���빤��Ŀ�ʼ�ӹ�ʱ��start_t
                % t_span{m_var}=sortrows(t_span{m_var}, 1);  % ����t_span��һ���е�Ԫ�ذ�������������
            else  % �޷�����ӹ����Ȼ������к��ٿ�ʼ�ӹ�
                start_t=start_t_m;  % �޸��ˣ�
                t_span{m_var}(k_mac(m_var),:)=[mac_t{m_var}(k_mac(m_var)-1,2),start_t];
            end
        end
        % -----------------------------------------------


        stop_t=start_t+pro_time;
        part_t{p_var}(k_part(p_var),:)=[start_t,stop_t];
        mac_t{m_var}(k_mac(m_var),:)=[start_t,stop_t];
    end
end

