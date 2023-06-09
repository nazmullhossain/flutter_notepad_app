const express=require("express");
const mongoose=require("mongoose");
const cors=require("cors");
const authRouter = require("./routes/auth_router");
const PORT= process.env.PORT | 3001;

const app=express();
const DB="mongodb+srv://nazmulldata:165257As$@cluster0.9rjgl0a.mongodb.net/?retryWrites=true&w=majority"
app.use(express.json());
app.use(authRouter);
app.use(cors());

mongoose.connect(DB).then(()=>{
    console.log("connection is suctessfully")
}).catch((err)=>{
    console.log(err)
})

app.listen(PORT, '0.0.0.0', ()=>{
    console.log(`Connected at port ${PORT}`); 
})