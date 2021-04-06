function (user, context, callback) {
  var namespace = 'https://argocd.rech.app/claims/';

  if (user.app_metadata && user.app_metadata.roles) {
        const groupRegEx = /^rech-app\/(.+)/;

  	    context.idToken[namespace + "groups"] = user.app_metadata.roles
            .filter(role => groupRegEx.test(role))
            .map(role => role.match(groupRegEx)[1]);
   }
  
  callback(null, user, context);
}