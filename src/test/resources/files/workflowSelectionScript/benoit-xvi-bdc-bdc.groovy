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

selectionCircuit{
	//Test des métadonnées optionnelles
	try{
		if(service_gestionnaire){}
	}
	catch (Exception ex){
		service_gestionnaire="";
	}

	//Tableau de correspondance valeur métadonnées->noms courts de bureau
	correspondance=[
		"informatique":"Directeur Informatique",
		"ressources humaines":"Directrice RH",
		"marchés publics":"Directeur MP",
		"finances":"Directeur Finances",
		"":"DGS"
	];

	//Conditions d'aiguillage
	if(montant<5000){
		if(correspondance[service_gestionnaire]){
			circuit "s_burvar_script",[correspondance[service_gestionnaire]];
		}
	}else if(montant<10000){
		circuit "s_burvar_script",["DGS"];
	}else{
		circuit "s_burvar_script",["President Departement"];
	}
}
