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

import coop.libriciel.iparapheur.auth._
import coop.libriciel.iparapheur.CoreApi._
import coop.libriciel.iparapheur.auth.DeskScenarios.createDesk
import coop.libriciel.iparapheur.auth.TenantScenarios.createTenant
import coop.libriciel.iparapheur.database.TypologyScenarios.{createSubtype, createType}
import coop.libriciel.iparapheur.flowable.WorkflowScenarios.createWorkflow
import coop.libriciel.iparapheur.flowable.FolderScenarios.createFolder
import io.gatling.core.Predef._
import io.gatling.core.structure.ChainBuilder


class FillApplicationSimulation extends Simulation {

  val createUsers: ChainBuilder = repeat(500) {
    exec(UserScenarios.createUser)
  }

  val createDesks: ChainBuilder = repeat(100) {
    exec(createDesk)
  }

  val createWorkflows: ChainBuilder = repeat(100) {
    exec(createWorkflow)
  }

  val createTypesAndSubtypes: ChainBuilder = repeat(100) {
    exec(createType)
      .exec(createSubtype)
  }

  val createFolders: ChainBuilder = repeat(500) {
    exec(createFolder)
  }

  val createTenants: ChainBuilder = exec(
    exec(CoreApi.authenticateRequest),
    createTenant
  )

  val fillTenant: ChainBuilder = exec(
    exec(CoreApi.authenticateRequest),
    createUsers.pause(5),
    createDesks.pause(5),
    createWorkflows.pause(5),
    createTypesAndSubtypes.pause(5),
    createFolders.pause(5),
  )

  /**
   * The simulations need to be in a file named *Simulation, and execute this.
   * Every tests (Visa, Signature...) could be executed in a separate *Simulation file,
   * but Gatling it would create a separate log and report for each.
   *
   * */
  setUp(
    scenario("Create and fill Tenants")
      .repeat(repeatCount) {
        exec(createTenants)
          .exec(fillTenant)
      }
      .inject(atOnceUsers(1))
  ).protocols(httpConf)

}
