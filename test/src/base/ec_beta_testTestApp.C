//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "ec_beta_testTestApp.h"
#include "ec_beta_testApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
ec_beta_testTestApp::validParams()
{
  InputParameters params = ec_beta_testApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

ec_beta_testTestApp::ec_beta_testTestApp(InputParameters parameters) : MooseApp(parameters)
{
  ec_beta_testTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

ec_beta_testTestApp::~ec_beta_testTestApp() {}

void
ec_beta_testTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  ec_beta_testApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"ec_beta_testTestApp"});
    Registry::registerActionsTo(af, {"ec_beta_testTestApp"});
  }
}

void
ec_beta_testTestApp::registerApps()
{
  registerApp(ec_beta_testApp);
  registerApp(ec_beta_testTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
ec_beta_testTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ec_beta_testTestApp::registerAll(f, af, s);
}
extern "C" void
ec_beta_testTestApp__registerApps()
{
  ec_beta_testTestApp::registerApps();
}
