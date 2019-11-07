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
package auth

import java.util.UUID

import com.typesafe.config.ConfigFactory
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.util.Random


class UsersSimulation extends Simulation {


  private val url = ConfigFactory.load().getString("keycloak.host")
  private val port = ConfigFactory.load().getInt("keycloak.port")
  private val repeatCount = ConfigFactory.load().getInt("tests.repeat_count")


  val httpConf: HttpProtocolBuilder = http.baseUrl("http://" + url + ":" + port + "/")
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")


  val checkUp: ScenarioBuilder = scenario("Check up")
    .exec(
      http("Check up")
        .post("auth/realms/api/protocol/openid-connect/token")
        .formParam("client_id", "admin-cli")
        .formParam("username", "rest-admin")
        .formParam("password", "admin")
        .formParam("grant_type", "password")
        .check(status.is(200))
        .check(jsonPath("$.access_token").exists)
        .check(jsonPath("$.access_token").ofType[String].saveAs("authToken"))
    )


  var createDesk: ScenarioBuilder = scenario("Create")
    .exec(
      http("Create")
        .post("auth/admin/realms/api/groups")
        .header("Authorization", "bearer ${authToken}")
        .body(StringBody(_ =>
          s"""
              {
                  "name" : "name_${UUID.randomUUID.toString}"
              }
           """)).asJson
        .check(status.is(201))
    )


  var listDesk: ScenarioBuilder = scenario("List")
    .exec(
      http("Create")
        .get("auth/admin/realms/api/groups")
        .header("Authorization", "bearer ${authToken}")
        .queryParam("first", Random.nextInt(repeatCount))
        .queryParam("max", 100)
        .check(status.is(200))
    )


  /**
   * The simulations need to be in a file named *Simulation, and execute this.
   * Every tests (Visa, Signature...) could be executed in a separate *Simulation file,
   * but Gatling it would create a separate log and report for each.
   *
   * For such simple tests cases, everything is called from here, merging everything in one report/log.
   */
  setUp(

    checkUp
      .repeat(repeatCount) {
        exec(createDesk)
          .exec(listDesk)
      }

      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
