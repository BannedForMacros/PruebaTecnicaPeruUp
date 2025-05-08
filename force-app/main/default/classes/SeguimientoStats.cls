public with sharing class SeguimientoStats {

    @AuraEnabled(cacheable=true)
    public static Integer totalTareas(Id contactId) {
        return [
            SELECT COUNT()
            FROM  Seguimiento__c         //  ← 2 guiones bajos
            WHERE Contacto__c = :contactId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer tareasCompletadas(Id contactId) {
        return [
            SELECT COUNT()
            FROM  Seguimiento__c
            WHERE Contacto__c = :contactId
              AND Etapa__c    = 'Completado'
        ];
    }
}
