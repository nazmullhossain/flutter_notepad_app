const express=require('express');
const UserModel = require('../model/user_model');
const { model } = require('mongoose');
const auth = require('../middleware/auth_middleware');
const jwt=require("jsonwebtoken");
const authRouter=express.Router();


authRouter.post("/api/signup", async(req,res)=>{
try{

    const {name,email,profilePic}=req.body;

  let user=await  UserModel.findOne({email});

if(!user){
    user=new UserModel({
        email,
        profilePic,
        name,

    });
    user=await user.save();
}

const token = jwt.sign({ id: user._id }, "passwordKey");

res.json({ user, token });


}catch(e){
res.status(500).json({error:e.message})
}
});


authRouter.get("/", auth, async (req, res) => {
    const user = await UserModel.findById(req.user);
    res.json({ user, token: req.token });
  });


module.exports=authRouter;
