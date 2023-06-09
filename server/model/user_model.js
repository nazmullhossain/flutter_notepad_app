const mongoose=require('mongoose');

const userSchema= mongoose.Schema({

name:{
    type: String,
    required: true,

},
email:{
    type: String,
    required: true,

},

profilePic:{
    type: String,
    required: true,
    
}


});

const UserModel=mongoose.model("UserModel",userSchema);

module.exports=UserModel;
