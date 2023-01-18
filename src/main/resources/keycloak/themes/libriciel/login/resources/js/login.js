/*
 * iparapheur
 * Copyright (C) 2019-2023 Libriciel SCOP
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

function switchInputType(id, el) {
    var x = document.getElementById(id);
    // switch type
    x.type = x.type === "password" ? "text" : "password";
    // switch classes
    el.classList.toggle("fa-eye");
    el.classList.toggle("fa-eye-slash");
    // set focus
    x.focus();
}