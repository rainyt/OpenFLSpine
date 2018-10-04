/******************************************************************************
 * Spine Runtimes Software License v2.5
 *
 * Copyright (c) 2013-2016, Esoteric Software
 * All rights reserved.
 *
 * You are granted a perpetual, non-exclusive, non-sublicensable, and
 * non-transferable license to use, install, execute, and perform the Spine
 * Runtimes software and derivative works solely for personal or internal
 * use. Without the written permission of Esoteric Software (see Section 2 of
 * the Spine Software License Agreement), you may not (a) modify, translate,
 * adapt, or develop new applications using the Spine Runtimes or otherwise
 * create derivative works or improvements of the Spine Runtimes or (b) remove,
 * delete, alter, or obscure any trademarks or any copyright, trademark, patent,
 * or other intellectual property or proprietary rights notices on or in the
 * Software, including any copy thereof. Redistributions in binary or source
 * form must include this license and terms.
 *
 * THIS SOFTWARE IS PROVIDED BY ESOTERIC SOFTWARE "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL ESOTERIC SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, BUSINESS INTERRUPTION, OR LOSS OF
 * USE, DATA, OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

package spine;

import spine.support.utils.Array;

/** Stores the setup pose for an {@link IkConstraint}.
 * <p>
 * See <a href="http://esotericsoftware.com/spine-ik-constraints">IK constraints</a> in the Spine User Guide. */
class IkConstraintData {
    public var name:String;
    public var order:Int = 0;
    public var bones:Array<BoneData> = new Array();
    public var target:BoneData;
    public var bendDirection:Int = 1;
    public var mix:Float = 1;

    public function new(name:String) {
        if (name == null) throw new IllegalArgumentException("name cannot be null.");
        this.name = name;
    }

    /** The IK constraint's name, which is unique within the skeleton. */
    #if !spine_no_inline inline #end public function getName():String {
        return name;
    }

    /** See {@link Constraint#getOrder()}. */
    #if !spine_no_inline inline #end public function getOrder():Int {
        return order;
    }

    #if !spine_no_inline inline #end public function setOrder(order:Int):Void {
        this.order = order;
    }

    /** The bones that are constrained by this IK constraint. */
    #if !spine_no_inline inline #end public function getBones():Array<BoneData> {
        return bones;
    }

    /** The bone that is the IK target. */
    #if !spine_no_inline inline #end public function getTarget():BoneData {
        return target;
    }

    #if !spine_no_inline inline #end public function setTarget(target:BoneData):Void {
        if (target == null) throw new IllegalArgumentException("target cannot be null.");
        this.target = target;
    }

    /** Controls the bend direction of the IK bones, either 1 or -1. */
    #if !spine_no_inline inline #end public function getBendDirection():Int {
        return bendDirection;
    }

    #if !spine_no_inline inline #end public function setBendDirection(bendDirection:Int):Void {
        this.bendDirection = bendDirection;
    }

    /** A percentage (0-1) that controls the mix between the constrained and unconstrained rotations. */
    #if !spine_no_inline inline #end public function getMix():Float {
        return mix;
    }

    #if !spine_no_inline inline #end public function setMix(mix:Float):Void {
        this.mix = mix;
    }

    #if !spine_no_inline inline #end public function toString():String {
        return name;
    }
}
