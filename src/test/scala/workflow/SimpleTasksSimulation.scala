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
package workflow

import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder
import workflow.tasks.{SecondOpinionTests, SetupTests, SignatureTests, VisaTests}
import workflow.utils.Requests._


class SimpleTasksSimulation extends Simulation {

  /**
   * The simulations need to be in a file named *Simulation, and execute this.
   * Every tests (Visa, Signature...) could be executed in a separate *Simulation file,
   * but Gatling it would create a separate log and report for each.
   *
   * For such simple tests cases, everything is called from here, merging everything in one report/log.
   */
  setUp(

    checkUp

      .exec(SetupTests.uploadVisaScenario)
      .exec(SetupTests.uploadSignatureScenario)
      .exec(SetupTests.uploadSecondOpinionScenario)

      .exec(VisaTests.simple)
      .exec(VisaTests.reject)
      .exec(VisaTests.secondOpinion)
      .exec(VisaTests.secondOpinionUndo)
      .exec(VisaTests.transfert)
      .exec(VisaTests.transfertUndo)
      .exec(VisaTests.doubleTransfert)
      .exec(VisaTests.doubleTransfertUndo)

      .exec(SignatureTests.simple)
      .exec(SignatureTests.reject)
      .exec(SignatureTests.secondOpinion)
      .exec(SignatureTests.secondOpinionUndo)
      .exec(SignatureTests.transfert)
      .exec(SignatureTests.transfertUndo)
      .exec(SignatureTests.doubleTransfert)
      .exec(SignatureTests.doubleTransfertUndo)

      .exec(SecondOpinionTests.simple)
      .exec(SecondOpinionTests.secondOpinion)
      .exec(SecondOpinionTests.secondOpinionTransfert)
      .exec(SecondOpinionTests.secondOpinionUndo)

      .inject(atOnceUsers(1))

  ).protocols(httpConf)

}
