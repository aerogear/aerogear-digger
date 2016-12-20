import hudson.security.*
// Create API user with limited permissions to manage jobs only.
// Created user would not be able to list jobs and perform any administrative operations.

// Steps
// 1. Provide username and password here
def userName = "";
def password = "";

// Execute script
// Do not edit script after this line
def instance = Jenkins.getInstance();
def strategy = instance.getAuthorizationStrategy();

jenkins.model.Jenkins.instance.securityRealm.createAccount(userName, password);
strategy.add(hudson.model.Item.BUILD, 	   userName);
strategy.add(Item.CANCEL,  	   userName);
strategy.add(Item.CONFIGURE ,  userName);
strategy.add(Item.CREATE    ,  userName);
strategy.add(Item.DELETE    ,  userName);
strategy.add(Item.DISCOVER  ,  userName);
strategy.add(Item.READ      ,  userName);
strategy.add(Item.WORKSPACE ,  userName);

instance.save();