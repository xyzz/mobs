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

on_step_proxy = (func) ->
    return (self_, dtime) ->
        -- call step() every `interval`
        every = self_.ms_object.__class.interval
        if not self_.interval
            -- we want a nice distribution to make sure that a lot of step()s aren't called at the same time
            self_.interval = math.random! * every
        self_.interval += dtime
        if self_.interval >= every
            self_.interval -= every
            self_.ms_object\step!

registered_classes = {}
max_id = 0

class Mob
    new: (pos) =>
        if not pos
            -- used to load entity in on_activate
            return
        @object = minetest.add_entity(pos, @name)
        entity = @object\get_luaentity!
        entity.ms_object = @
        entity.id = max_id
        max_id += 1

        @init!
    register: =>
        registered_classes[@name] = @@
        minetest.register_entity(@name, {
            visual: "sprite",
            textures: {@texture}
            physical: true,
            on_step: on_step_proxy @step,
            get_staticdata: (self_) ->
                -- we want to serialize all values except object because it's userdata provided by minetest
                object_tmp = nil
                if self_.ms_object
                    object_tmp = self_.ms_object.object
                    self_.ms_object.object = nil
                data = minetest.serialize self_.ms_object
                if self_.ms_object
                    self_.ms_object.object = object_tmp
                return data
            on_activate: (self_, staticdata) ->
                data = minetest.deserialize staticdata
                if not data
                    -- only happens when on_activate is called right after add_entity
                    return
                self_.ms_object = registered_classes[@name]!
                self_.ms_object.object = self_.object
                for key, value in pairs data
                    self_.ms_object[key] = value
                self_.id = max_id
                max_id += 1

                self_.ms_object\init!
        })
    -- called every time entity is added/activated
    init: =>
        @acceleration {x: 0, y: -9.81, z: 0}
    velocity: (value) =>
        if not value
            return @object\getvelocity!
        @object\setvelocity value
    acceleration: (value) =>
        if not value
            return @object\getacceleration!
        @object\setacceleration value
