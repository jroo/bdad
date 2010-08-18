class State < ActiveRecord::Base
  # name
  # state : two digit code
  def state_code_from_id(num)
    "%02i" % num
  end
end

# bdad_dev=> \d states
#                                    Table "public.states"
#    Column   |         Type          |                      Modifiers                       
# ------------+-----------------------+------------------------------------------------------
#  gid        | integer               | not null default nextval('states_gid_seq'::regclass)
#  area       | numeric               | 
#  perimeter  | numeric               | 
#  st99_d00_  | bigint                | 
#  st99_d00_i | bigint                | 
#  state      | character varying(2)  | 
#  name       | character varying(90) | 
#  lsad       | character varying(2)  | 
#  region     | character varying(1)  | 
#  division   | character varying(1)  | 
#  lsad_trans | character varying(50) | 
#  the_geom   | geometry              | 
# Indexes:
#     "states_pkey" PRIMARY KEY, btree (gid)
# Check constraints:
#     "enforce_dims_the_geom" CHECK (st_ndims(the_geom) = 2)
#     "enforce_geotype_the_geom" CHECK (geometrytype(the_geom) = 'MULTIPOLYGON'::text OR the_geom IS NULL)
#     "enforce_srid_the_geom" CHECK (st_srid(the_geom) = (-1))
