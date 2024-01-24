import { LightningElement,track,wire, api } from 'lwc';

import doLogin from '@salesforce/apex/CommunityAuthController.doLogin'
// import doLogin from '@salesforce/apex/CommunityAuthController.doLogin';


export default class LoginComponent extends LightningElement {
    @track username = null;
    @track password = null;
    @track errorCheck;
    @track errorMessage;

    handleUserNameChange(event){

        this.username = event.target.value;
    }

    handlePasswordChange(event){
        
        this.password = event.target.value;
    }

    handleLogin(event){
        console.log('Handlelogin is called');

        if(this.username && this.password){

            doLogin({ username: this.username, password: this.password })
            .then((result) => {
                
                window.location.href = result;
            })
            .catch((error) => {
                this.error = error;      
                this.errorCheck = true;
                this.errorMessage = error.body.message;
            });

        }

    }
}