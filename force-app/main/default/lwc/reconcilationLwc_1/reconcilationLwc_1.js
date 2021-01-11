import { LightningElement , wire, track} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Source_INFO from '@salesforce/schema/Reconciliation__c.Source_p__c';
import RECONCILIATION_OBJECT from '@salesforce/schema/Reconciliation__c';
import reconciliationCreateMethod from '@salesforce/apex/ReconcilationLwc_1_Class1.reconciliationCreateMethod';

export default class ReconcilationLwc_1 extends LightningElement {

    @track reconciliationName;
    @track firstName;
    @track lastName;
    @track email;
    @track phone;
    @track selectedOptionStatus;
    @track selectedOptionSource;
    reconciliationObject = RECONCILIATION_OBJECT;
    

    get eventOptionsStatus() {
        return [
            { label: 'None', value: '' },
            { label: 'New', value: 'New' },
            { label: 'New Pending', value: 'New Pending' },
            { label: 'New Submitted', value: 'New Submitted' },
            { label: 'Cancelled', value: 'Cancelled' },
            { label: 'Blocked', value: 'Blocked' },
        ];
    }

    get eventOptionsSource() {
        return [
            { label: 'None', value: '' },
            { label: 'Online', value: 'Online' },
            { label: 'Email', value: 'Email' },
            { label: 'Phone', value: 'Phone' }
        ];
    }

    handleSave(event) {
        var inp = this.template.querySelectorAll(".inp");
        console.log('inp  >>'+inp);
        inp.forEach(function (element) {
          console.log(element.name);
          console.log(element.value);
          if (element.name == "firstName") {
            this.reconciliationObject.first_Name__c = element.value;
          } else if (element.name == "lastName") {
            this.reconciliationObject.last_Name__c = element.value;
          } else if (element.name == "email") {
            this.reconciliationObject.email__c = element.value;
          } else if (element.name == "phone") {
            this.reconciliationObject.phone__c = element.value;
          }
        }, this);
        this.reconciliationObject.Name = this.reconciliationObject.first_Name__c + this.reconciliationObject.last_Name__c;
        this.callother();
      }

      handleChangeStatus(event) {

        this.reconciliationObject.Status_p__c = event.detail.value;
      }

      handleChangeSource(event) {

        this.reconciliationObject.Source_p__c = event.detail.value;
      }

      callother(){
        this.template.querySelector("Form").reset();
        console.log('reconciliationObject >>'+this.reconciliationObject.first_Name__c);

        reconciliationCreateMethod({  firstName : this.reconciliationObject.first_Name__c ,
                                      lastName : this.reconciliationObject.last_Name__c ,
                                      phone : this.reconciliationObject.phone__c ,
                                      email : this.reconciliationObject.email__c ,
                                      status : this.reconciliationObject.Status_p__c ,
                                      source : this.reconciliationObject.Source_p__c 
                                        }) //change:'change', 
          .then(result => {
              console.log('Succesfully updated');
              console.log(result);
          });
      }
}