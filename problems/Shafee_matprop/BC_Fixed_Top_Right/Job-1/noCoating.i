[Mesh] 
	[./fmg] 
		type = FileMeshGenerator 
		file = data/noCoating.msh 
	[] 
[] 

[GlobalParams] 
	displacements = 'disp_x disp_y' 
[] 

[AuxVariables] 
	[./temp] 
		initial_condition = 0 
	[../] 
	[./eigenstrain_xx] 
		order = FIRST 
		family = MONOMIAL 
		block = 'block_NMC ' 
	[../] 
	[./eigenstrain_yy] 
		order = FIRST 
		family = MONOMIAL 
		block = 'block_NMC ' 
	[../] 
	[./total_strain_xx] 
		order = FIRST 
		family = MONOMIAL 
		block = 'block_NMC ' 
	[../] 
	[./total_strain_yy] 
		order = FIRST 
		family = MONOMIAL 
		block = 'block_NMC ' 
	[../] 
[] 

[Functions] 
	[./temperature_load] 
		type = ParsedFunction 
		expression = 'if(t<=0.5, 180*t, (-1)*(t-0.5)*180 + 90.0)' 
	[../] 
	[./hf_NMC] 
		type = PiecewiseLinear 
		x = '0' 
		y = '12600' 
	[../] 

	[./hf_LPS] 
		type = PiecewiseLinear 
		x = '0' 
		y = '500.0' 
	[../] 
[] 

[Modules] 
	[./TensorMechanics] 
	 [./Master] 
	   [./NMC] 
	     strain = FINITE 
		 add_variables = true 
		 eigenstrain_names = eigenstrain 
		 generate_output = 'stress_xx stress_yy vonmises_stress strain_xx strain_yy' 
		 block = 'block_NMC' 
	   [../] 

	   [./LPS] 
		 strain = FINITE 
		 add_variables = true 
		 generate_output = 'stress_yy stress_xx vonmises_stress plastic_strain_xx plastic_strain_yy' 
		 block = ' block_LPS' 
	   [../] 
	 [../] 
	[../] 
[] 

[AuxKernels] 
	[./tempfuncaux] 
		type = FunctionAux 
		variable = temp 
		function = temperature_load 
	[../] 

	[./eigenstrain_yy] 
		type = RankTwoAux 
		block = 'block_NMC' 
		rank_two_tensor = eigenstrain 
		variable = eigenstrain_yy 
		index_i = 1 
		index_j = 1 
		execute_on = 'initial timestep_end' 
	[../] 
	[./eigenstrain_xx] 
		type = RankTwoAux 
		block = 'block_NMC' 
		rank_two_tensor = eigenstrain 
		variable = eigenstrain_xx 
		index_i = 0 
		index_j = 0 
		execute_on = 'initial timestep_end' 
	[../] 

	[./total_strain_yy] 
		type = RankTwoAux 
		block = 'block_NMC' 
		rank_two_tensor = total_strain 
		variable = total_strain_yy 
		index_i = 1 
		index_j = 1 
		execute_on = 'initial timestep_end' 
	[../] 
	[./total_strain_xx] 
		type = RankTwoAux 
		block = 'block_NMC' 
		rank_two_tensor = total_strain 
		variable = total_strain_xx 
		index_i = 0 
		index_j = 0 
		execute_on = 'initial timestep_end' 
	[../] 
[] 

[Contact] 
	[nmc_lps] 
		primary = 'block_NMC_right' 
		secondary = 'block_LPS_left' 
		penalty = 1e5 
	    formulation = penalty 
		tangential_tolerance = 0.0001 
	[] 
[] 

[BCs] 
	[./x_disp] 
		type = DirichletBC 
		variable = disp_x 
		boundary = 'block_right block_top block_left' 
		value = 0.0 
	[../] 
	[./y_disp] 
		type = DirichletBC 
		variable = disp_y 
		boundary = 'block_right block_top block_bottom' 
		value = 0.0 
	[../] 
[] 

[Materials] 
	[./elasticity_tensor_NMC] 
		type = ComputeIsotropicElasticityTensor 
		block = 'block_NMC' 
		youngs_modulus = 177500 
		poissons_ratio = 0.33 
	[../] 

	[./isotropic_plasticity_NMC] 
		type = IsotropicPlasticityStressUpdate 
		block = 'block_NMC' 
		yield_stress = 12600.0 
		hardening_function = hf_NMC 
	[../] 

	[./radial_return_stress_NMC] 
		type = ComputeMultipleInelasticStress 
		tangent_operator = elastic 
		inelastic_models = 'isotropic_plasticity_NMC' 
		block = 'block_NMC' 
	[../] 

	[./thermal_expansion_strain_NMC] 
		type = ComputeThermalExpansionEigenstrain 
		block = 'block_NMC' 
		stress_free_temperature = 0 
		thermal_expansion_coeff = 0.00075 
		temperature = temp 
		eigenstrain_name = eigenstrain 
	[../] 

	[./elasticity_tensor_LPS] 
		type = ComputeIsotropicElasticityTensor 
		block = 'block_LPS' 
		youngs_modulus = 2000.0 
		poissons_ratio = 0.33 
	[../] 

  	[./isotropic_plasticity_LPS] 
		type = IsotropicPlasticityStressUpdate 
		block = 'block_LPS' 
		yield_stress = 500.0 
		hardening_function = hf_LPS 
	[../] 

	[./radial_return_stress_LPS] 
		type = ComputeMultipleInelasticStress 
		tangent_operator = elastic 
		inelastic_models = 'isotropic_plasticity_LPS' 
		block = 'block_LPS' 
	[../] 
[] 

[Executioner] 
	type = Transient 
	automatic_scaling = true 
	solve_type = NEWTON 
	petsc_options_iname = -pc_type 
	petsc_options_value = lu 

	nl_max_its = 99 
	nl_rel_tol = 1e-7 
	nl_abs_tol = 1e-9 
	l_tol = 1e-8 

	start_time = 0.0 
	n_startup_steps = 1 
	end_time = 1 
	dt = 0.025 
	dtmin = 0.001 
[] 

[Outputs] 
	exodus = true 
	csv = true 
	file_base = rst1/rst 
[] 

[Postprocessors] 
	[./Gap] 
		type = PointValue 
		point = '0.0 0.00250001 0.0' 
		variable = disp_y 
	[../] 
[]
