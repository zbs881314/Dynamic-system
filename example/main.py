# Import
from apm import *
	
# Select server
server = 'http://xps.apmonitor.com'
app = 'reactor'

# Clear previous application
apm(server,app,'clear all')

# Load model file
apm_load(server,app,'reactor.apm')

# Load time points for future predictions
csv_load(server,app,'horizon.csv')

# APM Variable Classification
# class = FV, MV, SV, CV
#   F or FV = Fixed value - parameter may change to a new value every cycle
#   M or MV = Manipulated variable - independent variable over time horizon
#   S or SV = State variable - model variable for viewing
#   C or CV = Controlled variable - model variable for control

#Parameters
FVs = 'Fa','Caf','Cbf','V'
MVs = 'T','Fb'

#Variables
SVs = 'Ca','Cb','F','Inlet_B','Outlet_B','Production_B1','Production_B2'
CVs = ''

# Set up variable classifications for data flow
for x in FVs: apm_info(server,app,'FV',x)
for x in MVs: apm_info(server,app,'MV',x)
for x in SVs: apm_info(server,app,'SV',x)
for x in CVs: apm_info(server,app,'CV',x)

# Options

# time units (1=sec,2=min,3=hrs,etc)
apm_option(server,app,'nlc.ctrl_units',3)
apm_option(server,app,'nlc.hist_units',3)

# set controlled variable error model type
apm_option(server,app,'nlc.cv_type',2)
apm_option(server,app,'nlc.ev_type',2)
apm_option(server,app,'nlc.reqctrlmode',3)

# read data from CSV file
apm_option(server,app,'nlc.csv_read',1)

# set number of nodes
apm_option(server,app,'nlc.nodes',3)

# Manipulated variables (u)
apm_option(server,app,'fb.upper',200)
apm_option(server,app,'fb.dmax',20)
apm_option(server,app,'fb.lower',0)
apm_option(server,app,'fb.status',1)
apm_option(server,app,'fb.fstatus',0)

apm_option(server,app,'t.upper',500)
apm_option(server,app,'t.dmax',20)
apm_option(server,app,'t.lower',300)
apm_option(server,app,'t.status',1)
apm_option(server,app,'t.fstatus',0)

# imode (1=ss, 2=mpu, 3=rto, 4=sim, 5=mhe, 6=nlc)
apm_option(server,app,'nlc.imode',6)

# Run on APM server
solver_output = apm(server,app,'solve')
print solver_output

# Open Web Viewer and Display Link
print "Opening web viewer"
url = apm_web(server,app)
