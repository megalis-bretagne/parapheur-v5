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
package workflow.utils

import com.typesafe.config.ConfigFactory
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder


object Requests {

  private val url = ConfigFactory.load().getString("flowable.host")
  private val port = ConfigFactory.load().getInt("flowable.port")

  val httpConf: HttpProtocolBuilder = http.baseUrl("http://" + url + ":" + port + "/")
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .acceptEncodingHeader("gzip, deflate")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")
    .basicAuth("kermit", "kermit")


  // <editor-fold desc="Checks">


  def listTasks(groupName: String): ScenarioBuilder = scenario("List")
    .exec(http("Check")
      .post("flowable-rest/service/query/tasks")
      .body(StringBody(
        s"""
          {
            "candidateGroup" : "$groupName",
            "size" : 100
          }
        """)).asJson
      .check(status.is(200))
      .check(jsonPath("$.total").exists)
      .check(jsonPath("$.data").exists)
      .check(jsonPath("$.total").ofType[Int].gte(1))
      .check(jsonPath("$.data[*].id").ofType[String].findAll.saveAs("tasks"))
      .check(jsonPath("$.data[*].category").ofType[String].is("dossier_id_123456"))
    )


  def checkNothingToDo(groupName: String): ScenarioBuilder = scenario("List")
    .exec(http("Check")
      .post("flowable-rest/service/query/tasks")
      .body(StringBody(
        s"""
          {
            "candidateGroup" : "$groupName",
            "size" : 100
          }
        """)).asJson
      .check(status.is(200))
      .check(jsonPath("$.total").exists)
      .check(jsonPath("$.data").exists)
      .check(jsonPath("$.total").ofType[Int].is(0))
    )


  val checkUp: ScenarioBuilder = scenario("Check up")
    .exec(
      http("Check up")
        .get("flowable-rest/service/management/engine")
        .check(status.is(200))
        .check(jsonPath("$.version").exists)
    )


  val checkEmptiness: ScenarioBuilder = scenario("Check emptiness")
    .exec(http("Check")
      .get("flowable-rest/service/runtime/tasks")
      .check(status.is(200))
      .check(jsonPath("$.total").exists)
      .check(jsonPath("$.total").ofType[Int].is(0))
    )

  // </editor-fold desc="Checks">


  val visaTask: ScenarioBuilder = scenario("Visa")
    .exec(http("Visa")
      .post("flowable-rest/service/runtime/tasks/${task}")
      .body(StringBody(
        """
          {
            "action" : "complete",
            "variables" : [
              { "name" : "approved", "value" : true },
              { "name" : "action", "value" : "visa" }
            ]
          }
        """)).asJson
      .check(status.is(200)))


  val signatureTask: ScenarioBuilder = scenario("Signature")
    .exec(http("Signature")
      .post("flowable-rest/service/runtime/tasks/${task}")
      .body(StringBody(
        """
          {
            "action" : "complete",
            "variables" : [
              { "name" : "approved", "value" : true },
              { "name" : "action", "value" : "signature" }
            ]
          }
        """)).asJson
      .check(status.is(200)))


  val rejectTask: ScenarioBuilder = scenario("Reject")
    .exec(http("Reject")
      .post("flowable-rest/service/runtime/tasks/${task}")
      .body(StringBody(
        """
          {
            "action" : "complete",
            "variables" : [
              { "name" : "approved", "value" : true },
              { "name" : "action", "value" : "reject" }
            ]
          }
        """)).asJson
      .check(status.is(200)))


  def transfertTask(targetGroup: String): ScenarioBuilder = scenario("Transfert")
    .exec(http("Transfert")
      .post("flowable-rest/service/runtime/tasks/${task}")
      .body(StringBody(
        s"""
          {
            "action" : "complete",
            "variables" : [
              { "name" : "approved", "value" : true },
              { "name" : "action", "value" : "transfert" },
              { "name" : "delegate_candidate_groups", "value" : "$targetGroup" }
            ]
          }
        """)).asJson
      .check(status.is(200)))


  def secondOpinionTask(targetGroup: String): ScenarioBuilder = scenario("Second")
    .exec(http("Second opinion")
      .post("flowable-rest/service/runtime/tasks/${task}")
      .body(StringBody(
        s"""
          {
            "action" : "complete",
            "variables" : [
              { "name" : "approved", "value" : true },
              { "name" : "action", "value" : "second" },
              { "name" : "delegate_candidate_groups", "value" : "$targetGroup" }
            ]
          }
        """)).asJson
      .check(status.is(200)))


  val undoTask: ScenarioBuilder = scenario("Undo")
    .exec(http("Undo")
      .post("flowable-rest/service/runtime/tasks/${task}")
      .body(StringBody(
        """
          {
            "action" : "complete",
            "variables" : [
              { "name" : "approved", "value" : true },
              { "name" : "action", "value" : "undo" }
            ]
          }
        """)).asJson
      .check(status.is(200)))

}
