import { LightningElement, wire } from 'lwc';
import createLead from '@salesforce/apex/urbanenquiry.createLead';
import getProperties from '@salesforce/apex/urbanenquiry.getProperties';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UrbanRiseContact extends LightningElement {

    fullName = '';
    phone = '';
    email = '';
    propertyId = '';

    propertyOptions = [];

    @wire(getProperties)
    wiredProperties({ error, data }) {

        if (data) {

            this.propertyOptions = data.map(property => {
                return {
                    label: property.Name,
                    value: property.Id
                };
            });

        } else if (error) {

            console.error('Property Error:', error);
        }
    }

    handleName(event) {
        this.fullName = event.target.value;
    }

    handlePhone(event) {
        this.phone = event.target.value;
    }

    handleEmail(event) {
        this.email = event.target.value;
    }

    handleProperty(event) {
        this.propertyId = event.detail.value;
    }

    async handleSubmit() {

        try {

            if (
                !this.fullName ||
                !this.phone ||
                !this.email ||
                !this.propertyId
            ) {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Required',
                        message: 'Please fill all fields',
                        variant: 'warning'
                    })
                );

                return;
            }

            const leadId = await createLead({
                fullName: this.fullName,
                phone: this.phone,
                email: this.email,
                propertyId: this.propertyId
            });

            console.log('Lead Created:', leadId);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Lead submitted successfully',
                    variant: 'success'
                })
            );

            this.fullName = '';
            this.phone = '';
            this.email = '';
            this.propertyId = '';

        } catch (error) {

            console.error(
                'ERROR:',
                JSON.stringify(error, null, 2)
            );

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message:
                        error?.body?.message ||
                        'Unable to create Lead',
                    variant: 'error'
                })
            );
        }
    }
}