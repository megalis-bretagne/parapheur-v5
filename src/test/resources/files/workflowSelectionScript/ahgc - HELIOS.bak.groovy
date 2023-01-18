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

// org.postgresql.util.PSQLException: ERROR: value too long for type character varying(255)
// je pourrais juste sélectionner le circuit, s'il n'a pas de bureau variable
// si je sélectionne le circuit, je lui passe un tableau indexé avec les différents bureaux variables
selectionCircuit {
    circuit "signature", ["Bleu"];
    //if (GdaBjType % 3 == 0) {
    //    circuit "signature", ["Bleu"];
    //}
    //else if(GdaBjType % 3 == 1) {
    //    circuit "signature", ["Rouge"];
    //}
    //else {
    //    circuit "signature", ["Vert"];
    //}
}
