trigger SeguimientoLimit on Seguimiento__c (before insert, before update) {

    Set<Id> contactIds = new Set<Id>();
    for (Seguimiento__c seg : Trigger.new) {
        if (seg.Contacto__c != null &&
            seg.Etapa__c == 'Pendiente') {
            contactIds.add(seg.Contacto__c);
        }
    }
    if (contactIds.isEmpty()) return;

    Map<Id,Integer> pendientesPorContacto = new Map<Id,Integer>();
    for (AggregateResult ar :
        [SELECT   Contacto__c   contactId,
                  COUNT(Id)     numPendientes
           FROM   Seguimiento__c
           WHERE  Contacto__c   IN :contactIds
           AND    Etapa__c      = 'Pendiente'
           GROUP  BY Contacto__c]) {

        pendientesPorContacto.put(
            (Id)      ar.get('contactId'),
            (Integer) ar.get('numPendientes')
        );
    }

    for (Seguimiento__c seg : Trigger.new) {

        if (seg.Contacto__c == null ||
            seg.Etapa__c   != 'Pendiente')
            continue;

        Integer actuales = pendientesPorContacto.get(seg.Contacto__c);
        if (actuales == null) actuales = 0;

        if (actuales + 1 > 5) {
            seg.addError(
                'Este contacto ya tiene 5 tareas en "Pendiente". ' +
                'Completa o cambia la etapa de alguna antes de crear otra.'
            );
        }
    }
}
