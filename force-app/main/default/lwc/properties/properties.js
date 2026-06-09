import { LightningElement, wire, track } from 'lwc';

import getProperties
from '@salesforce/apex/propertiesController.getProperties';

import searchProperties
from '@salesforce/apex/propertiesController.searchProperties';

import createSiteVisit
from '@salesforce/apex/siteVisitController.createSiteVisit';

import { ShowToastEvent }
from 'lightning/platformShowToastEvent';

export default class Properties extends LightningElement {

    @track properties = [];
    @track filteredProperties = [];
    @track selectedProperty = {};

    showModal = false;
    showVisitModal = false;

    searchKey = '';
    visitDate = '';

    // LOAD PROPERTIES

    @wire(getProperties)
    wiredProperties({ error, data }) {

        if (data) {

            this.properties = data;
            this.filteredProperties = data;

            console.log(
                'Properties Loaded:',
                data
            );

        } else if (error) {

            console.error(
                'Property Load Error:',
                error
            );
        }
    }

    // SEARCH FIELD

    handleSearchKey(event) {

        this.searchKey =
            event.target.value;
    }

    // ENTER KEY SEARCH

    handleEnter(event) {

        if (event.key === 'Enter') {

            this.handleSearch();
        }
    }

    // SEARCH BUTTON

    async handleSearch() {

        try {

            console.log(
                'Searching:',
                this.searchKey
            );

            const result =
                await searchProperties({

                    searchText:
                        this.searchKey
                });

            this.filteredProperties =
                result;

            console.log(
                'Search Results:',
                result
            );

        }
        catch (error) {

            console.error(
                'Search Error:',
                error
            );
        }
    }

    // VIEW DETAILS BUTTON

    handleViewDetails(event) {

        const propertyId =
            event.currentTarget.dataset.id;

        this.selectedProperty =
            this.properties.find(
                property =>
                    property.Id === propertyId
            );

        console.log(
            'Selected Property:',
            this.selectedProperty
        );

        this.showModal = true;
    }

    // CLOSE PROPERTY MODAL

    closeModal() {

        this.showModal = false;
    }

    // BOOK A TOUR BUTTON

    handleBookTour() {

        this.showVisitModal = true;
    }

    // DATE PICKER

    handleVisitDate(event) {

        this.visitDate =
            event.target.value;

        console.log(
            'Visit Date:',
            this.visitDate
        );
    }

    // CLOSE VISIT MODAL

    closeVisitModal() {

        this.showVisitModal = false;
    }

    // SAVE SITE VISIT

    async saveSiteVisit() {

        try {

            if (!this.visitDate) {

                this.dispatchEvent(
                    new ShowToastEvent({

                        title: 'Required',

                        message:
                            'Please select a visit date',

                        variant: 'warning'
                    })
                );

                return;
            }

            console.log(
                'Creating Site Visit...'
            );

            console.log(
                'Property Id:',
                this.selectedProperty.Id
            );

            console.log(
                'Visit Date:',
                this.visitDate
            );

            const visitId =
                await createSiteVisit({

                    propertyId:
                        this.selectedProperty.Id,

                    visitDate:
                        this.visitDate
                });

            console.log(
                'Site Visit Created:',
                visitId
            );

            this.dispatchEvent(
                new ShowToastEvent({

                    title: 'Success',

                    message:
                        'Site Visit Scheduled Successfully',

                    variant: 'success'
                })
            );

            this.showVisitModal = false;
            this.showModal = false;

            this.visitDate = '';

        }
        catch (error) {

            console.error(
                'Site Visit Error:',
                JSON.stringify(error)
            );

            this.dispatchEvent(
                new ShowToastEvent({

                    title: 'Error',

                    message:
                        error?.body?.message ||
                        'Unable to schedule site visit',

                    variant: 'error'
                })
            );
        }
    }
}