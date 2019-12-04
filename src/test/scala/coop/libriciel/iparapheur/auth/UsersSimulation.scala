/*
 * i-Parapheur
 * Copyright (C) 2018-2019 Libriciel-SCOP
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
package coop.libriciel.iparapheur.auth

import java.util.Random

import coop.libriciel.iparapheur.CoreApi
import coop.libriciel.iparapheur.CoreApi.{FIRST_NAMES_LIST, LAST_NAMES_LIST}
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder


class UsersSimulation extends Simulation {


  var createUser: ScenarioBuilder = scenario(getClass.getName)
    .exec(session => {
      session.setAll(
        ("randomFirstName", FIRST_NAMES_LIST(new Random().nextInt(FIRST_NAMES_LIST.length))),
        ("randomLastName", LAST_NAMES_LIST(new Random().nextInt(LAST_NAMES_LIST.length)))
      )
    })
    .exec(
      http("Create")
        .post("api/admin/user")
        .header("Authorization", "bearer ${authToken}")
        .body(StringBody(
          """
            {
              "userName" : "${randomFirstName}_${randomLastName}",
              "email": "${randomFirstName}.${randomLastName}@dom.local",
              "firstName": "${randomFirstName}",
              "lastName": "${randomLastName}",
              "password": "password"
            }
          """)).asJson
        .check(status.is(201))
    )


  /**
   * The simulations need to be in a file named *Simulation, and execute this.
   * Every tests (Visa, Signature...) could be executed in a separate *Simulation file,
   * but Gatling it would create a separate log and report for each.
   *
   * For such simple tests cases, everything is called from here, merging everything in one report/log.
   */
  setUp(
    CoreApi.checkUp
      .repeat(CoreApi.repeatCount) {
        exec(createUser)
      }
      .inject(atOnceUsers(1))
  ).protocols(CoreApi.httpConf)

}
