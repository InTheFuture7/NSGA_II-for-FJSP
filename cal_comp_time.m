% ��������깤ʱ�� part_t Ϊ���ȷ�������Ӧ�ļӹ�ʱ����Ϣ
function max_comp_time = cal_comp_time(part_t)
    max_time=[];  % ��¼������������깤ʱ��
    for i=1:size(part_t,2)
        m=size(part_t{i},1);
        max_time=[max_time, part_t{i}(m,2)];  % ����i������깤ʱ�䣬����ӵ�����max_time��
    end
    max_comp_time=max(max_time);
end

