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
import workflow.utils.Requests._


object Scenarios {

  val repeatCount: Int = ConfigFactory.load().getInt("tests.repeat_count")


  val undoForAll: ScenarioBuilder = scenario("Undo")
    .foreach("${tasks}", "task") {
      exec(undoTask)
    }


  val visaForAll: ScenarioBuilder = scenario("Visa")
    .foreach("${tasks}", "task") {
      exec(visaTask)
    }


  val signatureForAll: ScenarioBuilder = scenario("Signature")
    .foreach("${tasks}", "task") {
      exec(signatureTask)
    }


  val rejectForAll: ScenarioBuilder = scenario("Reject")
    .foreach("${tasks}", "task") {
      exec(rejectTask)
    }


  def transfertForAll(targetGroup: String): ScenarioBuilder = scenario("Transfert")
    .foreach("${tasks}", "task") {
      exec(transfertTask(targetGroup))
    }


  def secondOpinionForAll(targetGroup: String): ScenarioBuilder = scenario("Second")
    .foreach("${tasks}", "task") {
      exec(secondOpinionTask(targetGroup))
    }

}
