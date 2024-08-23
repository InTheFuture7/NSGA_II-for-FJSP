% %计算总延期时长
% function  total_def_time= cal_def_time(J,part_t)
%     total_def_time=0;
%     for i=1:size(J,2)
%         m=size(part_t{i},1);
%         comp_time=part_t{i}(m,2);
%         total_def_time=total_def_time+max(comp_time-J(i).a(3),0);
%     end
% end
% 
