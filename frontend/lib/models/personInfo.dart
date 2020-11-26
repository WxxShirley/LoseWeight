class PersonInfo
{
   String mobile;
   String nickname;
   String profile;
   String password;
   String cTime;
   String gender;

   PersonInfo({
     this.mobile,
     this.nickname,
     this.profile,
     this.password,
     this.cTime,
     this.gender
   });

   factory PersonInfo.fromJson(Map<String, dynamic> json){
     return PersonInfo(
       mobile: json["mobile"].toString(),
       nickname: json["nickname"],
       profile: json["profile"],
       password: json["password"],
       cTime: json["cTime"],
       gender: json["gender"]
     );
   }

}