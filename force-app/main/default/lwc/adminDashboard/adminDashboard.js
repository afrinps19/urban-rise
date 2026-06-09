import { LightningElement, wire } from 'lwc';
import getDashboardData from '@salesforce/apex/AdminDashboardController.getDashboardData';

export default class AdminDashboard extends LightningElement {

    dashboard = {
        totalProperties: 0,
        totalEnquiries: 0,
        totalUnits: 0,
        availableUnits: 0,
        totalRevenue: 0,
        pendingInvoices: 0,
        totalSiteVisits: 0,
        openLeads: 0,
        leads: [],
        siteVisits: [],
        properties: []
    };

    currentDate = new Date().toDateString();

    @wire(getDashboardData)
    wiredDashboard({ data, error }) {

        if (data) {
            this.dashboard = data;
            console.log('Dashboard loaded', data);
        }

        if (error) {
            console.error('Dashboard error', error);
        }
    }
}