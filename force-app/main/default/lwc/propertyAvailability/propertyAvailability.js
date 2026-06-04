import { LightningElement, wire } from 'lwc';

import getPropertyAvailability
from '@salesforce/apex/PropertyAvailabilityController.getPropertyAvailability';

export default class PropertyAvailability extends LightningElement {

    properties = [];
    error;

    @wire(getPropertyAvailability)
    wiredProperties({ data, error }) {

        if(data){
            this.properties = data;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.properties = [];
            console.error(error);
        }
    }
}