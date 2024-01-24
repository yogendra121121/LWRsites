import { LightningElement,track,wire } from 'lwc';

// import isEmailExist from '@salesforce/apex/CommunityAuthController.isEmailExist';
import cerateContact from '@salesforce/apex/CommunityAuthController.cerateContact';

export default class RegisterComponent extends LightningElement {
    @track firstName = null;
    @track lastName = null;
    @track email = null;
    @track username = null;
    @track CommunityNickname = null;
    @track alias = null;
    // @track userName = null;
    // @track password = null;
    // @track confirmPassword = null;
    // @track errorCheck;
    // @track errorMessage;
    // showUserName;
    // @track showTermsAndConditions;
    // @track showTermsAndConditionsLoading = false;
    // @track infoTooltipDisplayData = {};
    // @track requiredTooltipDisplayData = {};
    // @track errorTooltipDisplayData = {};
    // @track emailError;
    // @track passwordError;


    // connectedCallback(){

    //     this.showUserName = false;

    //     this.infoTooltipDisplayData.username = "tooltiptext usernameTooltiptext";
    //     this.infoTooltipDisplayData.password = "tooltiptext";

    //     this.requiredTooltipDisplayData.firstName = 'tooltiptext tooltipHide';
    //     this.requiredTooltipDisplayData.lastName = 'tooltiptext tooltipHide';
    //     this.requiredTooltipDisplayData.email = 'tooltiptext tooltipHide';
    //     this.requiredTooltipDisplayData.username = 'tooltiptext tooltipHide';        
    //     this.requiredTooltipDisplayData.hearAboutUs = 'tooltiptext tooltipHide';
    //     this.requiredTooltipDisplayData.password = 'tooltiptext tooltipHide';
    //     this.requiredTooltipDisplayData.confirmPassword = 'tooltiptext tooltipHide';

    //     this.errorTooltipDisplayData.email = 'tooltiptext tooltipHide';
    //     this.errorTooltipDisplayData.password = 'tooltiptext tooltipHide';
    // }
    firstNamevalue(event){
        this.firstName = event.target.value;
    }
    lastNamevalue(event){
        this.lastName = event.target.value
    }
    emailvalue(event){
        this.email = event.target.value
    }
    userNamevalue(event){
        this.username = event.target.value
    }

    CommunityNicknamevalue(event){
        this.CommunityNickname = event.target.value
    }

    Aliasvalue(event){
        this.alias = event.target.value
    }

    

    handleRegister(){
        console.log('handle register called');
        console.log(this.firstName, this.lastName, this.email, this.username, this.CommunityNickname, this.alias)

        //apex Controller method call
        cerateContact({
            firstName:this.firstName,
            lastName:this.lastName,
            email:this.email,
            username:this.username,
            CommunityNickname:this.CommunityNickname,
            alias:this.alias

        })

        .then(result => { 
            console.log('Success ressult')
        })
        .catch(error => {
            console.log('Error: ', error)
        })


    }
}