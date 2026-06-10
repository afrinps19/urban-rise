import { LightningElement, wire } from 'lwc';

import getInvoice
from '@salesforce/apex/UrbanRiseInvoiceController.getInvoice';

export default class UrbanRiseInvoice extends LightningElement {

    invoice;

    today =
        new Date().toLocaleDateString();

    @wire(getInvoice)
    wiredInvoice({ data, error }) {

        console.log('DATA => ', data);
        console.log('ERROR => ', error);

        if (data) {

            this.invoice = data;

        }

        if (error) {

            console.error(
                'WIRE ERROR => ',
                JSON.stringify(error)
            );
        }
    }
}