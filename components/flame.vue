<template>
	<div v-show="showFlame" id="app" :style="dialog" style="position: absolute; top: 0; width:30px; height: 30px">
		<canvas id="canv" width="40" height="40"></canvas>
	</div>
</template>

<script>
  export default {
    data: () => ({
		showFlame: false,
		dialog: 'left: 20%',
    }),
    methods: {
      show() {
		this.showFlame = true
	  }
	},
	setup() {
		let canvas = ref()
		let context = ref()

		onMounted(() => {
			canvas = document.querySelector('#canv')
			context.value = canvas.getContext('2d')
			let $ = canvas.getContext( '2d' )
			// canvas.width  = window.innerWidth;
			// canvas.height = window.innerHeight;
			let msX = 20//window.innerWidth / 2
			let msY = 20//window.innerHeight / 2
			let arr = []
			let num = 25
			anim();
			var cnt = 0;
			function anim() {
			window.requestAnimationFrame(anim);
			if (cnt % 2 == 0) draw(1);		
			cnt++;
			$.fillStyle = 'hsla(21, 95%, 5%, 1)';
			$.fillRect(0,0, canvas.width, canvas.height);
			for (var i=0; i<arr.length; i++) {
				var a = arr[i]; 
				a.disp($); 
				a.upd();	
			}	
			while(arr.length>num)
				arr.shift(); 
			}
			function draw(_cnt) {
			for(var i=0; i<_cnt;i++) {
				var a = new _img(img, msX, msY); 
				a.vx = rnd(-0.1,0.1);
				a.vy = 0;
				a.sz = rnd(0.1,0.2);
				a.max = 0.011;
				a.alpha = 1;
				a.grav = -0.5; 
				a.drag = 0.96;
				a.min = 1.1; 
				a.fade = 0.04; 
				a.rot = rnd(0,360);
				a.spin = rnd(-1,2); 
				a.compositeOperation = 'lighter'; 
				arr.push(a); 				
			}
			}
			function _img(img, px, py) {
				this._px = px; 
				this._py = py; 
				this.vx = 0; 
				this.vy = 0; 
				this.min = 1; 
				this.sz = 1; 
				this.max = -1;
				this.shim = false;	
				this.drag = 1; 
				this.grav = 0; 
				this.alpha = 1; 
				this.fade = 0; 
				this.spin = 0; 
				this.rot = 0; 
				this.compositeOperation = 'source-over';
				this.img = img; 
				this.upd = function() {
					this.vx *= this.drag; 
					this.vy *= this.drag;
					this.vy += this.grav; 
					this._px += this.vx;
					this._py += this.vy; 
					this.sz *= this.min;
					if((this.max>0) && (this.sz>this.max))
						this.sz = this.max; 
					this.alpha -= this.fade; 	
					if(this.alpha<0) this.alpha = 0; 
					this.rot += this.spin; 
				};
				this.disp = function($$) {
					if(this.alpha ==0) return;
					$$.save(); 
					$$.translate(this._px, this._py);
					var s = this.shim ? this.sz * Math.random() : this.sz;
					$$.scale(s,s);
					$$.rotate(this.rot * (Math.PI / 90));
					$$.translate(img.width*-0.5, img.width*-0.5);
					$$.globalAlpha = this.alpha; 
					$$.globalCompositeOperation = this.compositeOperation;
					$$.drawImage(img,0,0);
					$$.restore();			
				};
			}
			let img = new Image();
			img.src= 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/131045/firestar.png';
			function rnd(min, max) {
				return ((Math.random()*(max-min)) + min); 
			}
			// window.addEventListener('mousemove', function(e) {
			// 				e.preventDefault();
			// 				msX = e.clientX;
			// 				msY = e.clientY;
			// }, false);
			// window.addEventListener('touchmove', function(e){
			// 		e.preventDefault();
			// 				msX = e.touches[0].clientX;
			// 				msY = e.touches[0].clientY;                  
			// }, false);

			// window.addEventListener('resize',function(){
			// 	canvas.width = window.innerWidth;
			// 	canvas.height = window.innerHeight;
			// },false);
		})
		return {
			canvas
		}
	},
}
	// created() {

// 	}
//   }

</script>