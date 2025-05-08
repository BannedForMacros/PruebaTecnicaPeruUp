import { LightningElement, api, wire } from 'lwc';
import getTotales from '@salesforce/apex/TaskStats.totales';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { refreshApex } from '@salesforce/apex';

export default class TareaProgress extends LightningElement {

    @api recordId;         
    total = 0;
    done  = 0;

    wiredData;             
    channel     = '/data/TaskChangeEvent';
    subscription;

    @wire(getTotales, { contactId: '$recordId' })
    wiredTotales(value) {
        this.wiredData = value;
        const { data, error } = value;
        if (data) {
            this.total = data.total;
            this.done  = data.done;
        } else if (error) {
            console.error(JSON.stringify(error));
        }
    }

    connectedCallback() {
        this.subscribeCdc();
        onError(err => console.error('EMP API', err));
    }
    disconnectedCallback() {
        if (this.subscription) unsubscribe(this.subscription, () => {});
    }

    subscribeCdc() {
        if (this.subscription) return;
        subscribe(this.channel, -1, msg => {
            if (msg?.data?.payload?.WhoId__c === this.recordId) {
                refreshApex(this.wiredData);
            }
        }).then(resp => { this.subscription = resp; });
    }

    get percent()     { return this.total ? Math.round(100 * this.done / this.total) : 0; }
    get widthStyle()  { return `width:${this.percent}%;`; }
}
