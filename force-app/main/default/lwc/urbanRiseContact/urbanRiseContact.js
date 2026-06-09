import { LightningElement } from 'lwc';
import createLead from '@salesforce/apex/urbanenquiry.createLead';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UrbanRiseContact extends LightningElement {

    fullName = '';
    phone = '';
    email = '';

    handleName(event) {
        this.fullName = event.target.value;
    }

    handlePhone(event) {
        this.phone = event.target.value;
    }

    handleEmail(event) {
        this.email = event.target.value;
    }

    async handleSubmit() {

        try {

            if (
                !this.fullName ||
                !this.phone ||
                !this.email    
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

            console.log('Submitting form...');
            console.log('Name:', this.fullName);
            console.log('Phone:', this.phone);
            console.log('Email:', this.email);

            const leadId = await createLead({
                fullName: this.fullName,
                phone: this.phone,
                email: this.email
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

            const inputs = this.template.querySelectorAll('input');

            inputs.forEach(input => {
                input.value = '';
            });

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