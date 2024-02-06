#include "ec_beta_testApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
ec_beta_testApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

ec_beta_testApp::ec_beta_testApp(InputParameters parameters) : MooseApp(parameters)
{
  ec_beta_testApp::registerAll(_factory, _action_factory, _syntax);
}

ec_beta_testApp::~ec_beta_testApp() {}

void 
ec_beta_testApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<ec_beta_testApp>(f, af, s);
  Registry::registerObjectsTo(f, {"ec_beta_testApp"});
  Registry::registerActionsTo(af, {"ec_beta_testApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
ec_beta_testApp::registerApps()
{
  registerApp(ec_beta_testApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
ec_beta_testApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ec_beta_testApp::registerAll(f, af, s);
}
extern "C" void
ec_beta_testApp__registerApps()
{
  ec_beta_testApp::registerApps();
}
