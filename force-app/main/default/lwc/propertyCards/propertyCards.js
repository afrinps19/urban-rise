import { LightningElement, wire } from 'lwc';
import getProperties from '@salesforce/apex/PropertyController.getProperties';

export default class PropertyCards extends LightningElement {

    properties = [];

    @wire(getProperties)
    wiredProperties({ data, error }) {

        if(data){
            this.properties = data;
        }

        if(error){
            console.error(error);
        }
    }
}