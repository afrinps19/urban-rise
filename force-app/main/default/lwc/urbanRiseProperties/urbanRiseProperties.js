import { LightningElement, wire } from 'lwc';
import getProperties from '@salesforce/apex/PropertyController.getProperties';

export default class urbanRiseProperties extends LightningElement {

    properties = [];

    @wire(getProperties)
    wiredProperties({ data, error }) {

        if (data) {

            this.properties = data.map(item => {
                return {
                    ...item,
                    formattedPrice:
                        item.Price_Per_Unit__c
                        ? new Intl.NumberFormat('en-IN').format(item.Price_Per_Unit__c)
                        : '0'
                };
            });

        } else if (error) {
            console.error(error);
        }
    }
}