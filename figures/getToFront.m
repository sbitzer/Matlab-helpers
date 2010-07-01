function getToFront(ax, handles)

axchilds = get(ax,'Children');

ind = ismember(axchilds,handles);

set(ax,'Children',[axchilds(ind);axchilds(~ind)])