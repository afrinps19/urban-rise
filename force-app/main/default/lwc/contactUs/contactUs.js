import { LightningElement, track } from 'lwc';
import createLead
from '@salesforce/apex/contactController.createLead';

import { ShowToastEvent }
from 'lightning/platformShowToastEvent';

export default class contactUs extends LightningElement {

    @track formData = {};

    handleChange(event) {

        const field = event.target.name;

        this.formData[field] =
            event.target.value;
    }

    async handleSubmit() {

        try {
            console.log('Submitting Lead...');
            console.log('Name:', this.formData.name);
            console.log('Email:', this.formData.email);
            console.log('Phone:', this.formData.phone);
            const leadId =
                await createLead({

                    fullName:
                        this.formData.name,

                    email:
                        this.formData.email,

                    phone:
                        this.formData.phone,

                    enquiryType:
                        this.formData.type,

                    location:
                        this.formData.location,

                    message:
                        this.formData.message
                });

            console.log(
                'Lead Created:',
                leadId
            );

            this.dispatchEvent(
                new ShowToastEvent({

                    title: 'Success',

                    message:
                        'Thank you. Our team will contact you shortly.',

                    variant: 'success'
                })
            );

            this.formData = {};

            this.clearForm();

        }
        catch(error){

            console.error(error);

            this.dispatchEvent(
                new ShowToastEvent({

                    title:'Error',

                    message:
                        error.body.message,

                    variant:'error'
                })
            );
        }
    }

    clearForm(){

        const fields =
            this.template.querySelectorAll(
                'input, textarea, select'
            );

        fields.forEach(field => {

            field.value = '';
        });
    }
}