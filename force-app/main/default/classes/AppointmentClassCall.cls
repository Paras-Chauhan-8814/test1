public class AppointmentClassCall {
    
    public static void appointmentConditions(List<Appointment__c> appointmentData, String action){

        Map<ID , Map<String, Integer>> doctorVSTotalAppointments = new Map<ID, Map<String, Integer>>();
        Map<ID , Map<ID, Map<String, Integer>>> patientVSTotalAppointments = new  Map<ID, Map<ID, Map<String, Integer>>>();
        Map<ID , String> doctorVSName = new Map<ID, String>();
        Map<ID , String> patientVSName = new Map<ID, String>();
        Set<ID> patientID = new Set<ID>();
        Set<ID> doctorID = new Set<ID>();
       
       // List<Appointment__c> newData = new List<Appointment__c>();
        List<Appointment__c> oldNewData = new List<Appointment__c>();
        Set<ID> updatedAppointmentIds = new Set<ID>();

        try{
            for(Appointment__c a : appointmentData) {
                //newData.add(a);
                patientID.add(a.Patient__c);
                doctorID.add(a.Doctor__c);
                if(action == 'Update') {
                    updatedAppointmentIds.add(a.ID);
                }
            }
    
            List<Appointment__c> oldAppointmemtData = new List<Appointment__c>();
            if(action == 'Update') {

                oldAppointmemtData = [SELECT ID, Date__c, Doctor__r.Name, Patient__r.Name FROM Appointment__c WHERE (Patient__c IN : patientID OR Doctor__c IN : doctorID) AND ID NOT IN : updatedAppointmentIds];
            }
            else {

                oldAppointmemtData = [SELECT ID, Date__c, Doctor__r.Name, Patient__r.Name FROM Appointment__c WHERE Patient__c IN : patientID OR Doctor__c IN : doctorID];
            }

                oldNewData.addAll(appointmentData);
                oldNewData.addAll(oldAppointmemtData);
                
                for(Appointment__c a : oldNewData) {
    
                    DateTime appointmentDateTime = a.Date__c;
                    Date appointmentDate = date.newinstance(appointmentDateTime.year(), appointmentDateTime.month(), appointmentDateTime.day());
                    String dateKey = String.valueOF(appointmentDate);
    
                    //Set doctor vs date vs Totel Appointment
                    if(!doctorVSTotalAppointments.containsKey(a.Doctor__c)) {
    
                        doctorVSTotalAppointments.put(a.Doctor__c, new Map<String, Integer>());
                        doctorVSTotalAppointments.get(a.Doctor__c).put(dateKey, 1);
                    }
                    else if(!doctorVSTotalAppointments.get(a.Doctor__c).containsKey(dateKey)) {
    
                            doctorVSTotalAppointments.get(a.Doctor__c).put(dateKey, 1);
                    }else {

                        doctorVSTotalAppointments.get(a.Doctor__c).put(dateKey, doctorVSTotalAppointments.get(a.Doctor__c).get(dateKey) + 1);
                    }
    
                    //set patient vs Doctor VS date vs totel appointments
                    if(!patientVSTotalAppointments.containsKey(a.Patient__c)) {
    
                        patientVSTotalAppointments.put(a.Patient__c, new Map<ID, Map<String, Integer>>());
                        patientVSTotalAppointments.get(a.Patient__c).put(a.Doctor__c, new Map<String, Integer>());
                        patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).put(dateKey, 1);
                    } 
                    else if(!patientVSTotalAppointments.get(a.Patient__c).containsKey(a.Doctor__c)) {
    
                        patientVSTotalAppointments.get(a.Patient__c).put(a.Doctor__c, new Map<String, Integer>());
                        patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).put(dateKey, 1);
                    } 
                    else if(!patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).containsKey(dateKey)) {
    
                        patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).put(dateKey, 1);
                    }
                    else{
                        patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).put(dateKey, patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).get(dateKey) + 1 );
                    }
    
                    //set doctor id vs name
                        doctorVSName.put(a.Doctor__c , a.Doctor__r.Name);
                    //set patient vs name
                        patientVSName.put(a.Patient__c , a.Patient__r.Name);
                }
        

        for(Appointment__c a : appointmentData) {

                DateTime appointmentDateCurrent = a.Date__c;
                Date appointmentCurrentDate = date.newinstance(appointmentDateCurrent.year(), appointmentDateCurrent.month(), appointmentDateCurrent.day());
                String keyDate = String.valueOF(appointmentCurrentDate);

                  
                    if(doctorVSTotalAppointments.get(a.Doctor__c).get(keyDate) > 2) {

                        a.addError('Appointment can not be registered because Dr.'+ doctorVSName.get(a.Doctor__c)+' has been booked for the day.');
                    }
                    if(patientVSTotalAppointments.get(a.Patient__c).get(a.Doctor__c).get(keyDate) > 1) {

                        a.addError('This appointment cannot be registered because Mr/Mrs '+patientVSName.get(a.Patient__c)+' had already registered an appointment with Dr. '+doctorVSName.get(a.Doctor__c)+' for '+keyDate);
                    } 
        }
    }
    Catch(Exception exp) {

        system.debug('The following exception has occurred in method "appointmentConditions" : ' + exp.getMessage() +
                     ' at Line no: ' + exp.getLineNumber());
    }
    }
}