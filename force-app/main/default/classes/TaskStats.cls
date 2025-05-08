public with sharing class TaskStats {

    /**
     * Devuelve:  { total: Integer, done: Integer }
     * @param contactId  Id del Contacto
     */
    @AuraEnabled(cacheable=true)
    public static Map<String,Integer> totales(Id contactId) {

        // --- Total de tareas (Task.WhoId = Contact) ---
        Integer total = [
            SELECT COUNT()
              FROM Task
             WHERE WhoId = :contactId
               AND IsDeleted = FALSE
        ];

        // --- Tareas completadas (Status = 'Completed') ---
        Integer done  = [
            SELECT COUNT()
              FROM Task
             WHERE WhoId  = :contactId
               AND Status = 'Completed'
               AND IsDeleted = FALSE
        ];

        return new Map<String,Integer>{
            'total' => total,
            'done'  => done
        };
    }
}
