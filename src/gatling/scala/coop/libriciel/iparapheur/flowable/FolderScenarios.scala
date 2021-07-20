/*
 * i-Parapheur
 * Copyright (C) 2019-2020 Libriciel-SCOP
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
package coop.libriciel.iparapheur.flowable

import coop.libriciel.iparapheur.CoreApi._
import io.gatling.core.Predef._
import io.gatling.core.structure.ChainBuilder
import io.gatling.http.Predef._

import java.util.Random


object FolderScenarios {

  var createFolder: ChainBuilder =
    exec(getRandomDeskIdAsAdmin)
      .exec(getRandomTypeId)
      .exec(getRandomSubtypeId)
      .exec(session => {
        session.setAll(
          ("randomNameValue", new Random().nextInt(250000))
        )
      })
      .exec(
        http("Create Folder")
          .post("api/v1/tenant/${tenantId}/desk/${deskId}/draft")
          .queryParam("typeId", "${typeId}")
          .queryParam("subtypeId", "${subtypeId}")
          .queryParam("name", "Folder ${randomNameValue}")
          .formUpload("mainFiles", "dummy.pdf")
          .check(status.is(201))
      )

}
