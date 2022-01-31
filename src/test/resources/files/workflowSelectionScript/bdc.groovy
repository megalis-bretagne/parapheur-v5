selectionCircuit {
    if (service in ['Indigo', 'Pourpre']) {
        circuit "signature", [service];
    }
    else {
        circuit "signature", ['Pêche'];
    }
}
