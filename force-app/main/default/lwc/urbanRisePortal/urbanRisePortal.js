import { LightningElement } from 'lwc';
import HomeBanner from '@salesforce/resourceUrl/HomeBanner';

export default class UrbanRiseHome extends LightningElement {

    HomeBanner = HomeBanner;

    scrollToProperties() {

        const section =
            this.template.querySelector(
                '.properties-section'
            );

        if (section) {

            section.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }
    
    scrollToContact() {

        const section =
            this.template.querySelector(
                '.contact-section'
            );

        if (section) {

            section.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }
}