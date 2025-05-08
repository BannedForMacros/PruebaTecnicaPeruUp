import { LightningElement, api, wire, track } from 'lwc';
import TOTAL from '@salesforce/apex/SeguimientoStats.totalTareas';
import COMPLETADAS from '@salesforce/apex/SeguimientoStats.tareasCompletadas';

export default class SeguimientoProgress extends LightningElement {
    @api recordId;          
    @track total = 0;
    @track completadas = 0;

    @wire(TOTAL, { contactId: '$recordId' })
    wiredTotal({ data, error }) {
        if (data) {
            this.total = data;
        } else if (error) {
            
            console.error('Error al obtener el total de tareas:', error);
        }
    }

    @wire(COMPLETADAS, { contactId: '$recordId' })
    wiredComp({ data, error }) {
        if (data) {
            this.completadas = data;
        } else if (error) {
            
            console.error('Error al obtener las tareas completadas:', error);
        }
    }

    get percentage() {
        return this.total ? Math.round((this.completadas / this.total) * 100) : 0;
    }
}
