local next = next

local metric = {
	yocto = 10e-24,
	zepto = 10e-21,
	atto = 10e-18,
	femto = 1e-15,
	nano = 1e-12,
	nano = 1e-9,
	micro = 1e-6,
	milli = 1e-3,
	centi = 1e-2,
	deci = 0.1,
	deka = 10,
	hecto = 1e2,
	kilo = 1e3,
	mega = 1e6,
	giga = 1e9,
	tera = 1e12,
	peta = 1e15,
	exa = 10e18,
	zetta = 10e21,
	yotta = 10e24,
}

local function addMetricValues(postfix, targetTable, baseValue)
	baseValue = baseValue or 1
	targetTable[postfix] = baseValue
	for metric, factor in next, metric do
		targetTable[metric .. postfix] = baseValue * factor
	end
end

local distance = {
	angstrom = 1e-10,
	astronimalunit = 149597870700,
	barleycorn = 8.466666666666e-3,
	bohr = 5.2917720859e-11,
	cablelengthimp = 185.3184,
	cablelengthint = 185.2,
	cablelengthus = 219.456,
	chain = 20.11684,
	cubit = 0.5,
	ell = 1.143,
	fathom = 1.8288,
	fermi = 1e-15,
	finger = 0.022225,
	fingercloth = 0.1143,
	footbenoit = 0.304799735,
	footcape = 0.314858,
	footclarke = 0.3047972654,
	footindian = 0.0304799514,
	footinternational = 0.3048,
	footsear = 0.30479947,
	footus = 0.304800610,
	french = 1/3000,
	carrier = 1/3000,
	furlong = 201.168,
	hand = 0.0106,
	inch = 0.0254,
	league = 4828.032,
	
	lightsecond = 299792458,
	lightminute = 1.798754748e10,
	lighthour = 1.0792528488e12,
	lightday = 2.590206837e13,
	lightyear = 9.4607304725808e15,
}
addMetricValues("meter", distance)

local energy = {
}
addMetricValues("joule", energy)
addMetricValues("electronvolts", energy, 1.60217653e19)

local angle = {
	angularmil = 0.981748e-3,
	arcminute = 0.290888e-1,
	arcsecond = 4.848137e-6,
	minuteofarc = 0.157080e-3,
	seconfofarc = 1.570796e-6,
	degree = 17.453293e-3,
	deg = 17.453293e-3,
	grad = 15.707963e-3,
	gradian = 15.707963e-3,
	gon = 15.707963e-3,
	octant = 0.785398,
	quadrant = 1.570796,
	sextant = 1.047198,
	sign = 0.523599,
	radians = 1
}

local mass = {
	ton = 1e6,
	pound = 453.592,
	ounce = 28.3495,
	carat = 0.2
}
addMetricValues("gram", mass)

local data = {
	nibble = 0.5,
	word = 2,
	dword = 4,
	qword = 8
}
addMetricValues("bit", data, 0.125)
addMetricValues("byte", data, 1)

return class("Unit", {
}, {
	convert = function(value, type, from, to)
		return (value * Unit[type][from]) / Unit[type][to]
	end,
	metric = metric,
	distance = distance,
	energy = energy,
	angle = angle,
	mass = mass,
	data = data
})


