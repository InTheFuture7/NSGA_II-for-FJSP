%{ 
    ���Ƹ���ͼ
%}
function f = ganttChart1(J, P_chromosome, M, mac_t)
    P=P_chromosome(1, 1:(size(P_chromosome,2)-4));  % ������޸�Ŀ�꺯����������ô��Ҫ�޸�4��
    % P=P_chromosome(1:28);  % ������޸�Ŀ�꺯����������ô��Ҫ�޸�4����ù�������(1,28)
    % P=P_chromosome(1:50);  % ������޸�Ŀ�꺯����������ô��Ҫ�޸�4����ù�������(1,28)

    p_text=[];  % ��¼�������Ĺ�������Ϣ�����磺����i�ĵ�1�������¼Ϊ1����2�������¼Ϊ2����
    m_info=[];  % ��¼�豸�ļӹ���Ϣ�����磺����i�ĵ�1�β���ӹ���¼Ϊ1����2�μӹ���¼Ϊ2����
    p_color=[];  % ��������ɫ��Ӧ�������ֱ�ʾ��������ɫ
    % color=['#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30', '#A2142F','#4DBEEE','#FFFF00','#F0FFF0','##D3D3D3','#F5DEB3'];
    color=['r','g','b','c','m','y'];
    for i=1:size(J,2)  % ���ε������й���
        p_index=find(P==i);  % ���ҹ��� i �ڹ�������е�λ��
        % ��������ɫ��Ӧ��1-2��2-3��3-4��4-5��5-6��6-1��7-2��8-3
        color_i=mod(i,6)+1;  % i ���� 6 ������� +1
        % color_i=i;  % ��Ӧline9
        for j=1:size(p_index,2)  % ���α�������i�����й��򣬴ӵ�j������ʼ
            p_var=p_index(j);  % �鿴����i�ĵ�j�������ڹ������P�е�λ�� p_var
            p_text(p_var)=j;
            p_color(p_var)=color_i;
        end
    end

    for i=1:J(1).num_mac  % �������л���
        m_index = find(M==i);  % ���һ��� i �ڻ�������M�е�λ��
        if size(m_index,1)>=1 && size(m_index,2)>=1  % �ӹ��У���ʹ�õ���į����
            for j=1:size(m_index,2)
                m_var=m_index(j);
                m_info(m_var)=j;
            end
        end
    end

    n_bay_nb=J(1).num_mac;  % ��������Ŀ
    n_task_nb=length(P);  % ��������

    c_time=P_chromosome(size(P,2)+1);  %���������ʱ��
    % disp(c_time)
    % d_time=P_chromosome(size(P,2)+2);  % ����ʱ��
    e_load=P_chromosome(size(P,2)+2);  % �豸����
    % disp(e_load)
    % e_cons=P_chromosome(size(P,2)+4);  % ��������

    axis([0, P_chromosome(size(P,2)+1)+2, 0, n_bay_nb+0.5]);  % x�ᣨ���������ʱ��+2�� y��ķ�Χ��������+2��
    set(gca, 'xtick', 0:2:c_time);  % x�����������
    set(gca, 'ytick', 0:1:n_bay_nb+0.5);  % y�����������
    xlabel('�ӹ�ʱ��'), ylabel('������');  % x�� y�������
    % sche_info=sprintf('����깤ʱ��:%d  ������:%d �豸�ܸ���:%d �ܺ�����:%.2fKw/h',c_time,d_time,e_load,e_cons)
    sche_info=sprintf('����깤ʱ��:%d �豸�ܸ���:%d', c_time, e_load)
    title(sche_info);  % ͼ�εı���
    rec=[0,0,0,0];

    for i=1:n_task_nb  % ���α������й���
        % �� (rec(1), rec(2)) Ϊ�������½ǣ�ˮƽ���һ���rec(3)��λ�����ϻ���rec(4)��λ
        rec(1) = mac_t{M(i)}(m_info(i),1);  % ��M(i)�Ż����ĵ�m_info(i)�μӹ��Ŀ�ʼ�ӹ�ʱ��
        rec(2) = M(i)-0.3;
        rec(3) = mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);  % ���ε�x�᷽��ĳ���
        rec(4) = 0.6;  % ����y�᷽�򳤶�
        % �������ţ�����ţ��ӹ�ʱ�������ַ���
        % ����P(i)�ĵ�p_text(i)�������豸�ӹ���ʱmac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1)
        %{
            todo:�������д������޸ġ�����P(i),����i�Ĺ�����p_text(i),�ӹ�������M(i),�ӹ�ʱ��mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1))
            �ñ����洢��Ȼ���ʽ��Ϊ����
            ��ʽΪ��һ�������ʾһ�������������е�һ�б�ʾһ��������Ϊ���������н���Ϊ����k�ӹ��������ʱ
        %}

        txt=sprintf('%d p(%d,%d)=%d', i, P(i), p_text(i), mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1));  
        % ��(mac_t{M(i)}(m_info(i),1)+0.2, M(i))λ�ã�����txt����˵��
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

    for i =1:n_task_nb  % ���α������й���
        proce_time{P(i)}(p_text(i), M(i)) = mac_t{M(i)}(m_info(i),2)-mac_t{M(i)}(m_info(i),1);        
    end
    save proce_time proce_time;
end

