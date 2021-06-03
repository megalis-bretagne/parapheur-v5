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

package coop.libriciel.iparapheur

import com.typesafe.config.ConfigFactory
import io.gatling.core.Predef.{jsonPath, scenario, _}
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef.{http, status, _}
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.io.Source


object CoreApi {

  private val bufferedFirstNameList = Source.fromResource("lorem_first_names.csv")
  private val bufferedLastNameList = Source.fromResource("lorem_last_names.csv")
  private val bufferedRolesList = Source.fromResource("lorem_roles.csv")
  private val bufferedCitiesList = Source.fromResource("lorem_cities.csv")

  val FIRST_NAMES_LIST: List[String] = bufferedFirstNameList.getLines().toList
  val LAST_NAMES_LIST: List[String] = bufferedLastNameList.getLines().toList
  val CITIES_LIST: List[String] = bufferedCitiesList.getLines().toList
  val ROLES_LIST: List[String] = bufferedRolesList.getLines().toList

  bufferedCitiesList.close()
  bufferedRolesList.close()
  bufferedFirstNameList.close()
  bufferedLastNameList.close()


  private val url = ConfigFactory.load().getString("core.host")
  private val port = ConfigFactory.load().getInt("core.port")
  private val login = ConfigFactory.load().getString("core.login")
  private val pass = ConfigFactory.load().getString("core.password")

  val repeatCount: Int = ConfigFactory.load().getInt("tests.repeat_count")


  val httpConf: HttpProtocolBuilder = http.baseUrl("http://" + url + ":" + port + "/")
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")


  val checkUp: ScenarioBuilder = scenario("Check up")
    .exec(
      http("Check up")
        .post("/auth/realms/api/protocol/openid-connect/token")
        .formParam("client_id", "admin-cli")
        .formParam("username", login)
        .formParam("password", pass)
        .formParam("grant_type", "password")
        .check(status.is(200))
        .check(jsonPath("$.access_token").exists)
        .check(jsonPath("$.access_token").ofType[String].saveAs("authToken"))
    )


  val getRandomTenantId: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/v1/tenant")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .queryParam("page", 0)
        .queryParam("pageSize", Integer.MAX_VALUE)
        .queryParam("withAdminRights", true)
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].id").ofType[String].findRandom.saveAs("tenantId"))
    )


  val getRandomDeskIdAsAdmin: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/v1/admin/tenant/${tenantId}/desk")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .queryParam("page", 0)
        .queryParam("pageSize", Integer.MAX_VALUE)
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].id").ofType[String].findRandom.saveAs("deskId"))
    )


  val getRandomDeskIdAsUser: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/v1/desk")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .queryParam("page", 0)
        .queryParam("pageSize", Integer.MAX_VALUE)
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].id").ofType[String].findRandom.saveAs("deskId"))
    )

  val getRandomTypeId: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/v1/tenant/${tenantId}/desk/${deskId}/types")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .queryParam("page", 0)
        .queryParam("pageSize", Integer.MAX_VALUE)
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].id").ofType[String].findRandom.saveAs("typeId"))
    )


  val getRandomSubtypeId: ScenarioBuilder = scenario(getClass.getName)
    .exec(
      http("Get")
        .get("api/v1/tenant/${tenantId}/desk/${deskId}/types/${typeId}/subtypes")
        .header("Authorization", "bearer ${authToken}")
        .header("Accept", "application/json")
        .queryParam("page", 0)
        .queryParam("pageSize", Integer.MAX_VALUE)
        .check(status.is(200))
        .check(jsonPath("$.total").exists)
        .check(jsonPath("$.data").exists)
        .check(jsonPath("$.total").ofType[Int].gte(1))
        .check(jsonPath("$.data[*].id").ofType[String].findRandom.saveAs("subtypeId"))
    )


}
