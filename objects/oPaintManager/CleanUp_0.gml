pubsub_unsubscribe("PaintSurfaceReset");
pubsub_unsubscribe("DebugPaintEnable");
pubsub_unsubscribe("DebugPaintTeam");
pubsub_unsubscribe("PaintSurfaceApply");

paint_surface_destroy();
paint_queue_destroy();
alarm[0] = -1;