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

import java.util.Random

import com.typesafe.config.ConfigFactory
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.io.Source


class UsersSimulation extends Simulation {


  private val url = ConfigFactory.load().getString("core.host")
  private val port = ConfigFactory.load().getInt("core.port")
  private val login = ConfigFactory.load().getString("core.login")
  private val pass = ConfigFactory.load().getString("core.password")
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
        .formParam("username", login)
        .formParam("password", pass)
        .formParam("grant_type", "password")
        .check(status.is(200))
        .check(jsonPath("$.access_token").exists)
        .check(jsonPath("$.access_token").ofType[String].saveAs("authToken"))
    )


  var createUser: ScenarioBuilder = scenario("Create user")
    .exec(session => {
      session.setAll(
        ("randomFirstName", firstNameList(new Random().nextInt(firstNameList.length))),
        ("randomLastName", lastNameList(new Random().nextInt(lastNameList.length)))
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


  var createDesk: ScenarioBuilder = scenario("Create")
    .exec(session => {
      session.setAll(
        ("randomFirstName", firstNameList(new Random().nextInt(firstNameList.length))),
        ("randomLastName", lastNameList(new Random().nextInt(lastNameList.length)))
      )
    })
    .exec(
      http("Create user")
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

    checkUp
      .repeat(repeatCount) {
        exec(createUser)
      }

      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
