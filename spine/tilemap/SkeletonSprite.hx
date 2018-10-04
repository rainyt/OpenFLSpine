/******************************************************************************
 * Spine Runtimes Software License
 * Version 2.1
 *
 * Copyright (c) 2013, Esoteric Software
 * All rights reserved.
 *
 * You are granted a perpetual, non-exclusive, non-sublicensable and
 * non-transferable license to install, execute and perform the Spine Runtimes
 * Software (the "Software") solely for internal use. Without the written
 * permission of Esoteric Software (typically granted by licensing Spine), you
 * may not (a) modify, translate, adapt or otherwise create derivative works,
 * improvements of the Software or develop new applications using the Software
 * or (b) remove, delete, alter or obscure any trademarks or any copyright,
 * trademark, patent or other intellectual property or proprietary rights
 * notices on or in the Software, including any copy thereof. Redistributions
 * in binary or source form must include this license and terms.
 *
 * THIS SOFTWARE IS PROVIDED BY ESOTERIC SOFTWARE "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL ESOTERIC SOFTARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

package spine.tilemap;

import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.Vector;
import spine.attachments.MeshAttachment;
import spine.Bone;
import spine.Skeleton;
import spine.SkeletonData;
import spine.Slot;
import spine.support.graphics.TextureAtlas;
import spine.attachments.RegionAttachment;
import spine.support.graphics.Color;
import openfl.display.TileContainer;
import openfl.display.Tile;
import openfl.events.Event;

/**
 * Tilemap渲染器
 */
class SkeletonSprite extends TileContainer {

	public var skeleton:Skeleton;
	public var timeScale:Float = 1;
	//坐标数组
	private var _tempVerticesArray:Array<Float>;

	private var _isPlay:Bool = true;

	/**
	 * 渲染骨骼对应关系
	 */
	private var _map:Map<AtlasRegion,TileContainer>;

	public function new(skeletonData:SkeletonData) {
		super();

		skeleton = new Skeleton(skeletonData);
		skeleton.updateWorldTransform();

		_map = new Map<AtlasRegion,TileContainer>();

		#if zygame
		openfl.Lib.current.addEventListener(Event.ENTER_FRAME, enterFrame);
		#else
		openfl.Lib.current.addEventListener(Event.ENTER_FRAME, enterFrame);
		#end
	}

	/**
	 * 渲染事件
	 * @param e 
	 */
	private function enterFrame(e:Event):Void
	{
		advanceTime(1/60);
	}
	
	public function destroy():Void {
		#if zygame
		openfl.Lib.current.removeEventListener(Event.ENTER_FRAME, enterFrame);
		#else
		openfl.Lib.current.removeEventListener(Event.ENTER_FRAME, enterFrame);
		#end
		this.removeTiles();
	}
	
	public function play():Void {
		_isPlay = true;
	}

	public function stop():Void {
		_isPlay = false;
	}

	public function advanceTime (delta:Float):Void {
		if(!_isPlay)
			return;
		skeleton.update(delta * timeScale);
		renderTriangles();
	}

	function renderTriangles():Void
	{
		var drawOrder:Array<Slot> = skeleton.drawOrder;
		var n:Int = drawOrder.length;
		var triangles:Array<Int> = null;
		var uvs:Array<Float> = null;
		var atlasRegion:AtlasRegion;
		var bitmapData:BitmapData = null;
		var slot:Slot;
		var r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 0;
		var color:Int;
		var blend:Int;

		this.removeTiles();

		for (i in 0 ... n)
		{
			//获取骨骼
			slot = drawOrder[i];
			//初始化参数
			triangles = null;
			uvs = null;
			atlasRegion = null;
			bitmapData = null;
			//如果骨骼的渲染物件存在
			if(slot.attachment != null)
			{
				if (Std.is(slot.attachment, RegionAttachment))
				{
					//如果是矩形
					var region:RegionAttachment = cast slot.attachment;
					atlasRegion = cast region.getRegion();
					r = region.getColor().r;
					g = region.getColor().g;
					b = region.getColor().b;
					a = region.getColor().a;

					//矩形绘制
					if(atlasRegion != null)
					{

						var wrapper:TileContainer = _map.get(atlasRegion);
						var tile:Tile = null;
						if(wrapper == null){
							wrapper = new TileContainer();
							tile = new Tile(atlasRegion.page.rendererObject.getID(atlasRegion));
							wrapper.addTile(tile);
							_map.set(atlasRegion,wrapper);
						}
						else{
							tile = wrapper.getTileAt(0);
							tile.id = atlasRegion.page.rendererObject.getID(atlasRegion);
						}

						var regionWidth:Float = atlasRegion.rotate ? atlasRegion.height : atlasRegion.width;
						var regionHeight:Float = atlasRegion.rotate ? atlasRegion.width : atlasRegion.height;

						tile.rotation = -region.getRotation();
						tile.scaleX = region.getScaleX() * (region.getWidth() / atlasRegion.width);
						tile.scaleY = region.getScaleY() * (region.getHeight() / atlasRegion.height);

						
						var radians:Float = -region.getRotation() * Math.PI / 180;
						var cos:Float = Math.cos(radians);
						var sin:Float = Math.sin(radians);
						var shiftX:Float = -region.getWidth() / 2 * region.getScaleX();
						var shiftY:Float = -region.getHeight() / 2 * region.getScaleY();
						if (atlasRegion.rotate) {
							tile.rotation += 90;
							shiftX += regionHeight * (region.getWidth() / atlasRegion.width);
						}

						tile.x = region.getX() + shiftX * cos - shiftY * sin;
						tile.y = -region.getY() + shiftX * sin + shiftY * cos;

						var bone:Bone = slot.bone;
						var flipX:Int = skeleton.flipX ? -1 : 1;
						var flipY:Int = skeleton.flipY ? -1 : 1;

						wrapper.x = bone.getWorldX();
						wrapper.y = bone.getWorldY();
						wrapper.rotation = bone.getWorldRotationX() * flipX * flipY;
						wrapper.scaleX = bone.getWorldScaleX() * flipX;
						wrapper.scaleY = bone.getWorldScaleY() * flipY;
						this.addTile(wrapper);
					}

				}
				else if(Std.is(slot.attachment, MeshAttachment)){
					//如果是网格
					// var region:MeshAttachment = cast slot.attachment;
					// region.computeWorldVertices(slot,0,region.getWorldVerticesLength(), _tempVerticesArray,0,2);
					// uvs = region.getUVs();
					// triangles = region.getTriangles();
					// atlasRegion = cast region.getRegion();
					// r = region.getColor().r;
					// g = region.getColor().g;
					// b = region.getColor().b;
					// a = region.getColor().a;

					// var tile:Tile = new Tile();
				}
				
			}
		}
	}


}
