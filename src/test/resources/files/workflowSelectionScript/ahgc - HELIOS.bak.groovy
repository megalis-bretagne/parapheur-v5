// org.postgresql.util.PSQLException: ERROR: value too long for type character varying(255)
// je pourrais juste sélectionner le circuit, s'il n'a pas de bureau variable
// si je sélectionne le circuit, je lui passe un tableau indexé avec les différents bureaux variables
selectionCircuit {
    circuit "signature", ["Bleu"];
    //if (GdaBjType % 3 == 0) {
    //    circuit "signature", ["Bleu"];
    //}
    //else if(GdaBjType % 3 == 1) {
    //    circuit "signature", ["Rouge"];
    //}
    //else {
    //    circuit "signature", ["Vert"];
    //}
}
