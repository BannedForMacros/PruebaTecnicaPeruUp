public with sharing class TaskStats {

    /**

     * @param contactId  Id del Contacto
     */
    @AuraEnabled(cacheable=true)
    public static Map<String,Integer> totales(Id contactId) {


        Integer total = [
            SELECT COUNT()
              FROM Task
             WHERE WhoId = :contactId
               AND IsDeleted = FALSE
        ];


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
