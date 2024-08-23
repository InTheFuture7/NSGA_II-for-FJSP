% %计算调度方案的总能耗 Time为最大完工时间
% function total_energy_cons= cal_ene_consu(Mac,mac_t,P,M,Time)
%     total_energy_cons=0;
%     i_cons=0;%空转能耗
%     m_cons=0;%加工能耗
%     t_cons=0;%转移能耗
%     j_cons=0;%车间固有能耗
%     j_cons=Time*Mac(1).a(1)/60;
%     for i=1:size(mac_t,2)          
%          for j=1:size(mac_t{i},1)
%              %计算空转能耗
%              if j>1
%                 i_cons=i_cons+Mac(i).e(2)*(mac_t{i}(j,1)-mac_t{i}(j-1,2))/60;
%              else
%                  i_cons=i_cons+Mac(i).e(2)*(mac_t{i}(j,1))/60;
%              end
%              %计算加工能耗
%              m_cons=m_cons+Mac(i).e(1)*(mac_t{i}(j,2)-mac_t{i}(j,1))/60;
%          end
%          %计算转移能耗
%          m_index=find(M==i);
%          if size(m_index,2)>0
%             if size(m_index,2)>1
%                 t_cons=t_cons+Mac(1).a(2);
%                for j=1:size(m_index,2)-1
%          %判断设备的相邻加工工序是否为该零件的相邻工序
%                     if P(m_index(j))~=P(m_index(j+1))
%                         t_cons=t_cons+Mac(1).a(2);
%                      else 
%                         p_var=P(m_index(j));%加工工件号
%                         p_index=find(P==p_var);
%                         k=find(p_index==m_index(j));
%                         if p_index(k+1)~=m_index(j+1)
%                             t_cons=t_cons+Mac(1).a(2);
%                         end
%                     end
%                end
%             else
%                 t_cons=t_cons+Mac(1).a(2);
%             end
%          end   
%     end
%     total_energy_cons=m_cons+i_cons+t_cons+j_cons;
% end
% 
