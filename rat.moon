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

export ^

class Rat extends Mob
    name: "mobs:rat"
    texture: "mobs_rat.png"
    interval: 5
    step: =>
        x = math.random! - 0.5
        z = math.random! - 0.5
        y = 0
        if math.random! > 0.8
            -- jump
            y = 5
        @velocity {x: x, y: y, z: z}

Rat\register!


-- ported from 0.3
minetest.register_abm {
    nodenames: {"default:tree", "default:jungletree", "group:tree"},
    interval: 10,
    chance: 200,
    action: (pos, node, active_object_count, active_object_count_wider) ->
        if active_object_count_wider != 0
            return
        p1 = vector.add(pos, {
            x: math.random(-2, 2),
            y: 0,
            z: math.random(-2, 2)
        })
        n1 = minetest.get_node p1
        n1b = minetest.get_node vector.add(p1, {x: 0, y: -1, z: 0})
        if n1.name == "air" and do
                (n1b.name == "default:dirt_with_grass" or minetest.get_item_group(n1b.name, "grass"))
            Rat(p1)
}
