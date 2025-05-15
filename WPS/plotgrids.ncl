
;   Script display location of model domains
;   Only works for ARW domains
;   Only works for NCL versions 6.2 or later
;   Reads namelist file directly

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;

; Check the version of NCL
  version = systemfunc("ncl -V")
  if(version.lt.6.2) then
    print("You need NCL V6.2 or later to run this script. Try running plotgrids.ncl. Stopping now...")
    return
  end if

; We generate plots, but what kind do we prefer?
;  type = "x11"
; type  = "pdf"
; type  = "ps"
; type  = "ncgm"
  type  = "png"
  wks   = gsn_open_wks(type,"wps_show_dom")

; read the following namelist file
  filename = "namelist.wps"

; Set the colors to be used
  colors = (/"white","black","White","ForestGreen","DeepSkyBlue","Red","Blue"/)
  gsn_define_colormap(wks, colors)  


; Set some map information ; line and text information
  mpres = True
  mpres@mpFillOn = True
  mpres@mpFillColors  = (/"background","DeepSkyBlue","ForestGreen","DeepSkyBlue", "transparent"/)
  mpres@mpDataBaseVersion           = "Ncarg4_1"
  mpres@mpGeophysicalLineColor      = "Black"
  mpres@mpGridLineColor             = "Black"
  mpres@mpLimbLineColor             = "Black"
  mpres@mpNationalLineColor         = "Black"
  mpres@mpPerimLineColor            = "Black"
  mpres@mpUSStateLineColor          = "Black"
  mpres@mpOutlineBoundarySets       = "AllBoundaries"
  mpres@mpDataBaseVersion           = "MediumRes"
  ;mpres@mpGridSpacingF             = 45
  ;mpres@mpGridLatSpacingF          = 2
  ;mpres@mpGridLonSpacingF          = 2
  ;mpres@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
  ;mpres@mpGeophysicalLineColor     = "Black"      ; color of cont. outlines
  mpres@mpGeophysicalLineThicknessF = 2.0          ; thickness of outlines
  mpres@mpDataSetName               = "Earth..4"   ; choose most recent boundaries
  mpres@tiMainString                = " WPS Domain Configuration  "

;;;;;;;;;;;;;;;;;;;; TOPO ;;;;;;;;;;;;;;;;;;;;;;
;    minlat = -80
;    maxlat = 80
;    minlon = -170
;    maxlon = 170

;topo_file = "/nobackupp11/isingh2/EXTERNAL_DATA/ETOPO_2022_v1_60s_N90W180_bed.nc"
;  a         = addfile(topo_file,"r")
;  elev      = a->z({minlat:maxlat},{minlon:maxlon})
;
; Set all values below -100 to missing, hence removing all
; the ocean elevation values. The ocean will be filled in
; a light blue (see mpOceanFillColor below).
;
;  elev = where(elev.lt.-100.,elev@_FillValue,elev)
;  cmap = read_colormap_file("OceanLakeLandSnow")  ; read color data

;  mpres@cnFillOn           = True     ; turn on contour fill
;  mpres@cnFillPalette      = cmap(2:,:)  ; set color map
;  mpres@cnLinesOn          = False    ; turn off contour lines
;  mpres@cnLineLabelsOn     = False    ; turn off line labels
;  mpres@cnInfoLabelOn      = False    ; turn off info label
;  mpres@lbBoxLinesOn       = False    ; turn off labelbar box lines
;  mpres@cnFillMode         = "RasterFill"   ; for faster draw
;---Pick "nice" contour levels (-100 to 8500 in steps of 62.5)
;  mnmxint = nice_mnmxintvl( min(elev), max(elev), 18, False)
;  mpres@cnLevelSelectionMode = "ManualLevels"
;  mpres@cnMinLevelValF       = 0.              ; put it slightly above 0.0 so we get the blue color
;  mpres@cnMaxLevelValF       = mnmxint(1)
;  mpres@cnLevelSpacingF      = mnmxint(2)/8.   ; Increase the number of levels 
                                             ; by choosing a smaller spacing.
;  mpres@gsnAddCyclic         = False           ; don't add longitude cyclic point
;  mpres@mpFillOn             = True
;  mpres@mpOceanFillColor     = "LightBlue"
;  mpres@mpLandFillColor      = "transparent"
;  mpres@mpFillDrawOrder      = "PostDraw"
;  mpres@pmTickMarkDisplayMode       = "Always"   ; Better ticmkark labels
;  mpres@mpGeophysicalLineThicknessF = 2
  ;plot = gsn_csm_contour_map(wks,elev,mpres)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  lnres = True 
  lnres@gsLineThicknessF = 2.5
  lnres@domLineColors    = (/ "white", "Red" , "Red" , "Blue" /)

  txres = True
  txres@txFont = "helvetica-bold"
  ;txres@txJust = "BottomLeft"
  txres@txJust = "TopLeft"
  txres@txPerimOn = False
  txres@txFontHeightF = 0.015

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Do not change anything between the ";;;;;" lines

  maxdom = 21
  nvar = 19
  parent_idn = new (maxdom,integer)
  parent_grid_ration = new (maxdom,integer)
  i_parent_startn = new (maxdom,integer)
  j_parent_startn = new (maxdom,integer)
  e_wen = new (maxdom,integer)
  e_snn = new (maxdom,integer)
  plotvar = new((/maxdom,nvar/),float)
  plotvar@_FillValue = -999.0

  plotvar = wrf_wps_read_nml(filename)

  mpres@max_dom = floattointeger(plotvar(0,0))
  mpres@dx = plotvar(0,1)
  mpres@dy = plotvar(0,2)
  if (.not.ismissing(plotvar(0,3))) then
    mpres@ref_lat = plotvar(0,3)
  else
    mpres@ref_lat = 0.0
  end if
  if (.not.ismissing(plotvar(0,4))) then
    mpres@ref_lon = plotvar(0,4)
  else
    mpres@ref_lon = 0.0
  end if
  if (.not.ismissing(plotvar(0,5))) then
    mpres@ref_x = plotvar(0,5)
  end if
  if (.not.ismissing(plotvar(0,6))) then
    mpres@ref_y = plotvar(0,6)
  end if
  mpres@truelat1 = plotvar(0,7)
  mpres@truelat2 = plotvar(0,8)
  mpres@stand_lon = plotvar(0,9)
  mproj_int = plotvar(0,10)
  mpres@pole_lat = plotvar(0,11)
  mpres@pole_lon = plotvar(0,12)

  do i = 0,maxdom-1
    parent_idn(i) = floattointeger(plotvar(i,13))
    parent_grid_ration(i) = floattointeger(plotvar(i,14))
    i_parent_startn(i) = floattointeger(plotvar(i,15))
    j_parent_startn(i) = floattointeger(plotvar(i,16))
    e_wen(i) = floattointeger(plotvar(i,17))
    e_snn(i) = floattointeger(plotvar(i,18))
  end do


  if(mpres@max_dom .gt. 1) then
    do i = 1,mpres@max_dom-1

      ;Making sure edge is nested grid is at least 5 grid points from mother domain.
      if(i_parent_startn(i) .lt. 5) then
        print("Warning: Western edge of grid must be at least 5 grid points from mother domain!")
      end if
      if(j_parent_startn(i) .lt. 5) then
        print("Warning: Southern edge of grid must be at least 5 grid points from mother domain!")
      end if
      pointwe = (e_wen(i)-1.)/parent_grid_ration(i)
      pointsn = (e_snn(i)-1.)/parent_grid_ration(i)
      gridwe = e_wen(parent_idn(i)-1)-(pointwe+i_parent_startn(i))
      gridsn = e_snn(parent_idn(i)-1)-(pointsn+j_parent_startn(i))
      if(gridwe .lt. 5) then
        print("Warning: Eastern edge of grid must be at least 5 grid points from mother domain!")
      end if
      if(gridsn .lt. 5) then
        print("Warning: Northern edge of grid must be at least 5 grid points from mother domain!")
      end if

      ;Making sure nested grid is fully contained in mother domain.
      gridsizewe = (((e_wen(parent_idn(i)-1)-4)-i_parent_startn(i))*parent_grid_ration(i))-(parent_grid_ration(i)-1)
      gridsizesn = (((e_snn(parent_idn(i)-1)-4)-j_parent_startn(i))*parent_grid_ration(i))-(parent_grid_ration(i)-1)
      if(gridwe .lt. 5) then
        print("Warning: Inner nest (domain = " + (i+1) + ") is not fully contained in mother nest (domain = " + parent_idn(i) + ")!")
        print("For the current setup of mother domain = " + parent_idn(i) + ", you can only have a nest of size " + gridsizewe + "X" + gridsizesn + ". Stopping Program!")
        exit
      end if
      if(gridsn .lt. 5) then
        print("Warning: Inner nest (domain = " + (i+1) + ") is not fully contained in mother nest (domain = " + parent_idn(i) + ")!")
        print("For the current setup of mother domain = " + parent_idn(i) + ", you can only have a nest of size " + gridsizewe + "X" + gridsizesn + ". Stopping Program!")
        exit
      end if

      ;Making sure the nest ends at a mother grid domain point.
      pointwetrunc = decimalPlaces(pointwe,0,False)
      pointsntrunc = decimalPlaces(pointsn,0,False)
      if((pointwe-pointwetrunc) .ne. 0.) then
        nest_we_up = (ceil(pointwe)*parent_grid_ration(i))+1
        nest_we_dn = (floor(pointwe)*parent_grid_ration(i))+1
        print("Nest does not end on mother grid domain point. Try " + nest_we_dn + " or " + nest_we_up + ".")
      end if
      if((pointsn-pointsntrunc) .ne. 0.) then
        nest_sn_up = (ceil(pointsn)*parent_grid_ration(i))+1
        nest_sn_dn = (floor(pointsn)*parent_grid_ration(i))+1
        print("Nest does not end on mother grid domain point. Try " + nest_sn_dn + " or " + nest_sn_up + ".")
      end if

    end do
  end if

  mpres@parent_id = parent_idn(0:mpres@max_dom-1)
  mpres@parent_grid_ratio = parent_grid_ration(0:mpres@max_dom-1)
  mpres@i_parent_start = i_parent_startn(0:mpres@max_dom-1)
  mpres@j_parent_start = j_parent_startn(0:mpres@max_dom-1)
  mpres@e_we = e_wen(0:mpres@max_dom-1)
  mpres@e_sn = e_snn(0:mpres@max_dom-1)

  if(mproj_int .eq. 1) then
    mpres@map_proj = "lambert"
    mpres@pole_lat = 0.0
    mpres@pole_lon = 0.0
  else if(mproj_int .eq. 2) then
    mpres@map_proj = "mercator"
    mpres@pole_lat = 0.0
    mpres@pole_lon = 0.0
  else if(mproj_int .eq. 3) then
    mpres@map_proj = "polar"
    mpres@pole_lat = 0.0
    mpres@pole_lon = 0.0
  else if(mproj_int .eq. 4) then
    mpres@map_proj = "lat-lon"
  end if
  end if
  end if
  end if

; Deal with global wrf domains that don't have dx or dy

  if (mpres@dx.lt.1e-10 .and. mpres@dx.lt.1e-10) then
    mpres@dx = 360./(mpres@e_we(0) - 1)
    mpres@dy = 180./(mpres@e_sn(0) - 1)
    mpres@ref_lat = 0.0
    mpres@ref_lon = 180.0
  end if

  mp = wrf_wps_dom (wks,mpres,lnres,txres)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Now you can add some information to the plot. 
; Below is an example of adding a white dot over the DC location.
  pmres = True
  ;pmres@gsMarkerColor = "White"
  ;pmres@gsMarkerIndex = 16
  ;pmres@gsMarkerSizeF = 0.01
  ;gsn_polymarker(wks,mp,28.6,-26.5,pmres)

; Define the latitudes and longitudes of the markers
;lat_markers = (/-11.5,-12,-12.20/) ; lon_markers = (/130.2,130.8,130.7/)    ;AUS1.1
;lat_markers = (/16.7,16.7,16.7/)     lon_markers = (/118.8,118.65,119.0/)   ;PHI1.1 
;lat_markers = (/-2.5,-3.0,-3.0/)     lon_markers = (/-58.0,-60.0,-60.10/) 
;lat_markers = (/13.5,13.7,13.3/)     
;lon_markers = (/138.5,137.1,137.0/)    ;WPO1.1
;lat_markers = (/29.0,29.0,29.15/)    lon_markers = (/-94.5,-94.5,-94.70/)   ;USA1.1 FIRST_RUN
;lat_markers = (/29.0,29.0,29.15/)    lon_markers = (/-94.0,-94.0,-94.20/)   ;USA1.1 DOMAIN SHIFTED TO EAST
;lat_markers = (/16.5,15.75,15.75/)   lon_markers = (/129.6,129.25,129.6/)   ;PHI2.1
;lat_markers = (/-3.5,-3,-3/) lon_markers = (/-58,-60,-60.10/)       ;BRA1.1
;lat_markers = (/-31.8,-33.1,-33.2/) lon_markers = (/-63.6,-62.5,-62.4/)            ;ARG1.1
lat_markers = (/0.3,1.12,1.19/) 
lon_markers = (/80.33,78.9,79.09/)            ;SIO1.1 

 ; Define the marker symbols and sizes
  marker_symbols = (/1, 1, 1/)  ; 1: circle, 2: diamond, 3: square
  marker_sizes = (/0.03, 0.03, 0.03/)

  ; Define the colors of the markers
  marker_colors = (/ "black", "white", "red" /)

  ; Add polymarkers to the map with different colors
  do i = 0, dimsizes(lat_markers) - 1
    pmres@gsMarkerColor = marker_colors(i)
    pmres@gsMarkerIndex = marker_symbols(i)
    pmres@gsMarkerSizeF = marker_sizes(i)
    gsn_polymarker(wks, mp, lon_markers(i), lat_markers(i),pmres)
  end do

  frame(wks)           ; lets frame the plot - do not delete

end
