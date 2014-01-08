[[
    Mobs for Minetest/Freeminer
    Copyright (C) 2014 Ilya Zhuravlev <whatever@xyz.is>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

package.path = minetest.get_modpath(minetest.get_current_modname!) .. '/?.lua;' .. package.path

require "mob"
require "rat"

minetest.register_chatcommand("spawn", {
    description: "Spawn something.",
    func: (name) ->
        pos = minetest.get_player_by_name(name)\getpos!
        thing = Rat(pos)
})
