@isTest
private class AppointmentClassCall_Test_Class {

    @testSetup static void testData() {
        List<Patient__c> patientList = new List<Patient__c>();

        for(Integer i=0;i<9;i++){

            Patient__c acc = new Patient__c();
            acc.Name = 'patient'+i;
            acc.Age__c  = i;
            patientList.add(acc);
        }
        insert patientList;

        List<Doctor__c> doctorList = new List<Doctor__c>();

        for(Integer i=0;i<3;i++){

            Doctor__c doc = new Doctor__c();
            doc.Name = 'doctor'+i;
            doctorList.add(doc);
        }
        insert doctorList;

    }

    @isTest static void appointmentNotMoreThenEight() {

        List<Patient__c> patientlist1 = [SELECT ID FROM Patient__c LIMIT 10];
        List<Appointment__c> appointmentList = new List<Appointment__c>();

        Doctor__c doc = [SELECt ID FROM Doctor__c WHERE Name ='doctor0'];

            for(Patient__c p : patientlist1) {
                Appointment__c ob = new Appointment__c();
                ob.Date__c = System.today().addDays(2);
                ob.Doctor__c = doc.ID;
                ob.Patient__c = p.ID;
                appointmentList.add(ob);
            }
            try{

                if(appointmentList.size()>0){
    
                    Test.startTest();
                    insert appointmentList;
                    Test.stopTest();
    
                }
            }
            catch(Exception e) {
                System.assert(e.getMessage().contains('has been booked for the day'));
            }
    }

    @isTest static void patientTwoAppointmentSameDoctor() {
        List<Appointment__c> appointmentList = new List<Appointment__c>();

        Patient__c patientlist1 = [SELECT ID FROM Patient__c LIMIT 1];

        Doctor__c doc = [SELECT ID FROM Doctor__c WHERE Name ='doctor0'];
          

            for(integer i=0;i<3;i++) {
                Appointment__c ob = new Appointment__c();
                ob.Date__c = System.today().addDays(2);
                ob.Doctor__c = doc.ID;
                ob.Patient__c = patientlist1.ID;
                appointmentList.add(ob);
            }
            try{

                if(appointmentList.size()>0){
    
                    insert appointmentList;
                }
            }
            catch(Exception e) {
                System.assert(e.getMessage().contains('already registered an appointment with Dr'));
            }
    }
    @isTest static void appointmentUpdate() {
        List<Appointment__c> appointmentList = new List<Appointment__c>();

        List<Patient__c> patientlist1 = [SELECT ID FROM Patient__c LIMIT 2];

        Doctor__c doc = [SELECT ID FROM Doctor__c WHERE Name ='doctor0'];
          

            
                Appointment__c ob = new Appointment__c();
                ob.Date__c = System.today().addDays(2);
                ob.Doctor__c = doc.ID;
                ob.Patient__c = patientlist1[0].ID;
                insert ob;

                Appointment__c app = [SELECT ID, Patient__c FROM Appointment__c WHERE ID =:ob.ID];
                app.Patient__c = patientlist1[1].ID;
                test.startTest();
                update app;
                test.stopTest();
           
    }
}