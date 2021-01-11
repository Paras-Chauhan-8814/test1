import { LightningElement } from 'lwc';
import getContactDetails from '@salesforce/apex/ContactController.getContactDetails';
import getTextMethod1 from '@salesforce/apex/ContactController.getTextMethod1';
import getTextMethod2 from '@salesforce/apex/ContactController.getTextMethod2';
import getTextMethod3 from '@salesforce/apex/ContactController.getTextMethod3';

const CONTACTS_IDS = [
    '0032w00000LSBx7AAH',
    '0032w00000LSBx3AAH',
    '0032w00000LSBxFAAX'
 ];
  
export default class Promise_Asyn_Await_LWC extends LightningElement {

    connectedCallback() {
        // this.invokeApexMethods(); //Dependend Promise


        // Aggregate Promises in LWC
        // const apexPromises = CONTACTS_IDS.map(contactId => getContactDetails({
        //     recordId: contactId
        // }));
        // console.log('apexPromises >> '+apexPromises);
        // this.resolveApexPromises(apexPromises);

        this.invokeApexMethods();
    }

    async invokeApexMethods() {
        try {
            const result1 = await getTextMethod1();
            console.log('Method1 result: ' + result1);
            const result2 = await getTextMethod2({
                message1: result1
            });
            console.log('Method2 result: ' + result2);
            const result3 = await getTextMethod3({
                message2: result2
            });
            console.log('Method3 result: ' + result3);
        } catch(error) {
            console.log(error);
        } finally {
            console.log('Finally Block');
        }
    }

    /*
    // Aggregate Promises in LWC
    resolveApexPromises(apexPromises) {
        Promise.all(apexPromises)
        .then((result) => {
            console.log(result);
        })
        .catch((error) => {
            console.log(error);
        })
        .finally(() => {
            console.log('Finally');
        })
    }
 */
    //Dependend Promise
   /* invokeApexMethods() {
        getTextMethod1()
        .then((result1) => {
            console.log('Method1 result: ' + result1);
 
            getTextMethod2({
                message1: result1
            })
            .then((result2) => {
                console.log('Method2 result: ' + result2);
 
                getTextMethod3({
                    message2: result2
                })
                .then((result3) => {
                    console.log('Method3 result: ' + result3);
                })
                .catch((error => {
                    console.log(error);
                }));
            })
            .catch((error => {
                console.log(error);
            }));
        })
        .catch((error) => {
            console.log(error);
        })
        .finally(() => {
            console.log('Finally Block');
        })
    }
    */
}