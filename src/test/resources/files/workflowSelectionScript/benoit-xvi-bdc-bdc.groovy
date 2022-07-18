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
