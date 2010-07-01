% applyFormat2Fig(vis,format)
%
% applies arbitrary formatting instructions to graphic objects in a figure 
% this is useful if you want to compare different formatting on the same
% figure and want to switch between formats easily
%
% in:
%       vis       -   structure with handles to the figure content, each
%                     field in vis corresponds to a graphics object, but
%                     the fields may also contain collections of the same
%                     type of graphics object in an array (vector of
%                     handles), e.g. vis.points1 may be a vector containing
%                     the handles to several lineseries objects each of
%                     which corresponding to one point in the figure
%       format    -   structure with formatting instructions for the
%                     different graphics objects, all of the fields
%                     contain another structure which holds property-value
%                     pairs for the graphics objects of Matlab, the
%                     property names are encoded as field names of the
%                     structure and the values are the contents of the
%                     fields, only formatting instructions for those
%                     objects are applied which are defined both in vis
%                     and format, e.g. format.points1.Color = 'r' sets the
%                     colour of all points of vis.points1 to red, if,
%                     however, format.points1 also is an array of structures
%                     the same length as vis.points1, then each point is
%                     coloured according to its own instructions
function applyFormat2Fig(vis,format)

gobjects = fieldnames(format);

for n = 1:length(gobjects)
    if isfield(vis,gobjects{n}) && ~isempty(vis.(gobjects{n}))
        names = fieldnames(format.(gobjects{n}));
        for i = 1:length(names)
            if length(format.(gobjects{n}))>1 && length(format.(gobjects{n}))==length(vis.(gobjects{n}))
                for j = 1:length(format.(gobjects{n}))
                    if ~isempty(format.(gobjects{n})(j).(names{i}))
                        set(vis.(gobjects{n})(j),names{i},format.(gobjects{n})(j).(names{i}))
                    end
                end
            else
                set(vis.(gobjects{n}),names{i},format.(gobjects{n}).(names{i}))
            end
        end
    end
end

figure(vis.fig)