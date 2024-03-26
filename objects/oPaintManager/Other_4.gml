paint_queue_create();
paint_team_color_refresh();
paint_queue_insert(new PaintItemStructure(
	100,100,1,1,sSplat01,make_color_rgb(0,0,0)),0);
	paint_queue_insert(new PaintItemStructure(
	150,100,1,1,sSplat01,make_color_rgb(0,0,0)),0);
paint_queue_insert(new PaintItemStructure(
	250,100,1,1,sSplat01,make_color_rgb(20,0,0)),1);
paint_queue_insert(new PaintItemStructure(
	280,100,1,1,sSplat01,make_color_rgb(20,0,0)),1);

pubsub_subscribe("PaintSurfaceReset",paint_surface_destroy);