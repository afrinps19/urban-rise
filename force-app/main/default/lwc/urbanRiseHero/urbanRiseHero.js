import { LightningElement } from 'lwc';

export default class urbanRiseHero extends LightningElement {

    handleHome() {
        console.log('Home Clicked');
    }

    handleProperties() {
        console.log('Properties Clicked');
    }

    handleContact() {
        console.log('Contact Clicked');
    }

    handleBookTour() {

        this.dispatchEvent(
            new CustomEvent(
                'booktour'
            )
        );
    }

    handleExplore() {

        this.dispatchEvent(
            new CustomEvent(
                'exploreproperties'
            )
        );
    }
}
