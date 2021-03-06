function newObj = copy(obj)
    try
        % R2010b or newer - directly in memory (faster)
        objByteArray = getByteStreamFromArray(obj);
        newObj = getArrayFromByteStream(objByteArray);
    catch
        % R2010a or earlier - serialize via temp file (slower)
        fname = [tempname '.mat'];
        save(fname, 'obj');
        newObj = load(fname);
        newObj = newObj.obj;
        delete(fname);
    end
end



% ==========================================================================
%
%    This file is part of SBDOT.
%
%    SBDOT is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SBDOT is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SBDOT.  If not, see <http://www.gnu.org/licenses/>.
%
%    Use of SBDOT is free for personal, non-profit, pure academic research
%    and educational purposes. Restrictions apply on commercial or funded
%    research use. Please read the IMPORTANT_LICENCE_NOTICE file.
%
% ==========================================================================


