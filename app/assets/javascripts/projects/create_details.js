var project_id

$(function () {

	/*
		Design
	*/

		initOpenButton();
		initPaint();

		/*
			Focus buttons
		*/

			function initOpenButton() {
				$('#a').on('click', function () {
					$('.create-details-container').addClass('open');
				});
			}

		/*
			/ Focus buttons
		*/

		/*
			Paint
		*/

			function initPaint() {

				/*
					View, tool
				*/

					var img = new Image();

					img.onload = function() {

						var 
							$svg = $('#svg'),
							$g = $('#g'),
							tranX = 0,
							tranY = 0,
							scale = 1;

						// Move
						var isMoving = false, isDoing = false;

						// Polyline
						var
							polyline = null,
							points = '',
							circle;

						$('#image').attr({
							'width': this.width,
							'height': this.height,
							'x': $svg.width() / 2 - this.width / 2,
							'y': $svg.height() / 2 - this.height / 2,
							'xlink:href': this.src
						});

						function canDo() {
							return !isDoing && !isMoving;
						}

						/*
							Move, zoom
						*/

							// Mouse wheel always zoom
							// Hold spacebar to move
							$svg.on({
								mousewheel: function (e) {
									isUp = e.originalEvent.wheelDelta < 0;

									if (isUp) {
										if (scale < 0.5) {
											return;
										}
										scale -= 0.1;
									}
									else {
										if (scale > 2) {
											return;
										}
										scale += 0.1;
									}

									tranX = -(e.clientX - $svg.offset().left) * (scale - 1);
									tranY = -(e.clientY - $svg.offset().top) * (scale - 1);

									updateViewBox();
								},
								focus: function () {
									$document.on('keypress.move', function (e) {
										if (!isMoving && e.keyCode == 32) {
											e.preventDefault();
											isMoving = true;

											var
												isFirst = true,
												x, y,
												movedX = 0,
												movedY = 0;

											$svg.on({
												'mousemove.move': function (e) {
													if (isFirst) {
														x = e.offsetX;
														y = e.offsetY;
														isFirst = false;
													}

													movedX = e.offsetX - x;
													movedY = e.offsetY - y;

													updateViewBoxWithValue(
														tranX + movedX, 
														tranY + movedY, 
														scale);
												}
											}).css('cursor', 'move');

											$document.on('keyup.move', function () {
												tranX += movedX;
												tranY += movedY;

												isMoving = false;
												$svg.off('.move').css('cursor', 'default');
												$document.off('keyup.move');
											});
										}
									});
								},
								focusout: function () {
									$document.off('.move');
									$svg.off('.move');
								}
							}).attr('tabindex', '0').css('outline', '0');

							function updateViewBox() {
								$g.css('transform', 'translate(' + tranX + 'px,' + tranY + 'px) scale(' + scale +')');
							}

							function updateViewBoxWithValue(tranX, tranY, scale) {
								$g.css('transform', 'translate(' + tranX + 'px,' + tranY + 'px) scale(' + scale +')');
							}

						/*
							/ Move, zoom
						*/

						/*
							Paint
						*/

						$('.toolbox-container').find('[aria-type="tool"]').on('click', function () {
							if ($(this).hasClass('active')) {
								return;
							}
							$(this).addClass('active').siblings('[aria-type="tool"].active').removeClass('active').trigger('end');
						});

						function getPosition(e) {
							return {
								x: (e.clientX - $svg.offset().left - tranX) / scale,
								y: (e.clientY - $svg.offset().top - tranY) / scale
							}
						}

						function removeEditPoints() {
							$g.find('[aria-object="edit_point"]').remove();
						}

						function startPolyline() {
							polyline = null;
							points = '';

							$g.on({
								'click.polyline': function (e) {
									if (!canDo()) {
										return;
									}
									pos = getPosition(e);

									if (polyline == null) {
										// Begin
										points = pos.x + ',' + pos.y;

										// Start point
										polyline = document.createElementNS("http://www.w3.org/2000/svg", "polyline");
										polyline.setAttribute('points', points);
										polyline.style.stroke = '#000';
										polyline.style.fill = 'rgba(245,245,245,.3)';
										$g.append(polyline);

										// End point
										circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
										circle.setAttribute('cx', pos.x);
										circle.setAttribute('cy', pos.y);
										circle.setAttribute('r', 5);
										circle.style.cursor = 'pointer';
										$g.append(circle);

										// Display line on move
										$g.on('mousemove.polyline', function (e) {
											pos = getPosition(e);
											polyline.setAttribute("points", points + ' ' + pos.x + ',' + pos.y);
										});

										// Click to end point => finish
										$(circle).on('click', function (e) {
											if (!canDo()) {
												return;
											}

											// For stop create next point
											e.stopPropagation();

											// Stop envent
											$g.off('mousemove.polyline');

											// Create end point
											points += ' ' + circle.getAttribute('cx') + ',' + circle.getAttribute('cy');
											polyline.setAttribute("points", points);

											// Display polyline
											polyline.style.fill = 'rgba(245,245,245,.2)';

											// Set event
											var $polyline = $(polyline);
											$polyline.on({
												'mousedown.move_polyline': function(e) {
													isDoing = true;

													// Edit points
													removeEditPoints();
													movedX = 0;
													movedY = 0;
													start = getPosition(e);

													$document.on('keydown.key_polyline', function (e) {
														if (e.keyCode == 46) {
															removeEditPoints();
															$polyline.remove();
														}
													});

													$svg.on({
														'mousemove.move_polyline': function (e) {
															current = getPosition(e);
															$polyline.css('transform', 'translate(' + (movedX = current.x - start.x) + 'px, ' + (movedY = current.y - start.y) + 'px)');
														},
														'mouseup.move_polyline': function(e) {
															// Change all points
															$polyline.attr('points', $polyline.attr('points').split(' ').map(function (value) {
																value = value.split(',');
																return (parseInt(value[0]) + movedX) + ',' + (parseInt(value[1]) + movedY);
															}).join(' '));

															$polyline.css('transform', 'translate(0px, 0px)');
															$svg.off('.move_polyline');
															if ($(e.target).is($polyline) || $(e.target).is('[aria-object="edit_point"]')) {
																createEditPoints($polyline);
															}
														}
													}).off('mouseup.end_edit_polyline').on('mouseup.end_edit_polyline', function (e) {
														if (!($(e.target).is($polyline) || $(e.target).is('[aria-object="edit_point"]'))) {
															isDoing = false;
															removeEditPoints();
															$svg.off('mouseup.end_edit_polyline .move_polyline');
															$document.off('.key_polyline');
														}
													});
												}
											});

											// Remove element
											circle.remove();
											points = '';
											circle = null;
											polyline = null;
										});
									}
									else {
										// New point
										points += ' ' + pos.x + ',' + pos.y;
										polyline.setAttribute("points", points);
									}
								}
							});

							function createEditPoints($polyline) {
								// Edit point
								var points = $polyline.attr('points').split(' ').map(function (value) {
									value = value.split(',');
									return { x: value[0], y: value[1] }
								});
								$(points).each(function (index) {
									// Skip last
									if (index == points.length - 1) {
										return;
									}

									var circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
									circle.setAttribute('cx', this.x);
									circle.setAttribute('cy', this.y);
									circle.setAttribute('r', 3);
									circle.setAttribute('aria-object', 'edit_point');
									circle.style.cursor = 'pointer';
									$(circle).data('index', index).on({
										mousedown: function (e) {
											isMoving = true;

											init = { x: parseInt(circle.getAttribute('cx')), y: parseInt(circle.getAttribute('cy')) };
											start = getPosition(e);
											pointIndex = $(this).data('index');

											$svg.on({
												'mousemove.move_point': function (e) {
													current = getPosition(e);

													points[pointIndex].x = init.x + current.x - start.x;
													points[pointIndex].y = init.y + current.y - start.y;

													if (pointIndex == 0) {
														points[points.length - 1] = points[pointIndex];
													}

													circle.setAttribute('cx', points[pointIndex].x);
													circle.setAttribute('cy', points[pointIndex].y);

													$polyline.attr('points', points.map(function (value) {
														return value.x + ',' + value.y;
													}).join(' '))
												},
												'mouseup.move_point': function (e) {
													isMoving = false;
													$svg.off('.move_point');
												}
											})
										}
									});
									$g.append(circle);
								});
							}
						}

						function endPolyline() {
							$g.off('.polyline');
							if (polyline != null) {
								points = '';
								polyline.remove();
								circle.remove();
								polyline = null;
								circle = null;
							}
						}

						$('[aria-click="polyline"]').on({
							click: function () {
								startPolyline();
							},
							end: function () {
								endPolyline();
							}
						});

						/*
							/ Paint
						*/
						
					}

					img.src = '/assets/a.jpg';

				/*
					/ View, tool
				*/

				/*
					Item
				*/

					$('.items-container .item-container').each(function () {
						var 
							$itemListPanel = $(this),
							$itemList = $itemListPanel.children();

						$itemListPanel.on({
							mouseenter: function () {
								$(this).addClass('show').siblings('.show').removeClass('show').scrollLeft(0);
							},
							mouseover: function (e) {
								var 
									scrollableWidth = $itemList[0].getBoundingClientRect().width - $itemListPanel[0].getBoundingClientRect().width,
									offsetLeft = $itemListPanel.offset().left
									panelWidth = $itemListPanel.width() - 100;

								if (scrollableWidth > 0) {
									$itemListPanel.on({
										mousemove: function (e) {
											var position = e.clientX - offsetLeft - 50;
											$itemListPanel.scrollLeft(scrollableWidth * (position / panelWidth));
										}
									})
								}
							},
							mouseout: function () {
								$itemListPanel.off('mousemove');
							}
						});
					});

				/*
					/ Item
				*/
			}

		/*
			/ Paint
		*/

	/*
		/ Design
	*/

	/*
		View
	*/

		var $viewPart = $('#view_part');

		view_initBlockButtons();

		/*
			Block
		*/

			function view_initBlockButtons() {

				/*
					Create block
				*/

				$viewPart.find('[aria-click="create_block"]').on('click', function () {
					createBlock();
				});

				/*
					/ Create block
				*/
			}

		/*
			/ Block
		*/



	/*
		/ View
	*/

	/*
		Function
	*/

		function createBlock() {
			$.ajax({
				url: '/blocks/_create',
				data: 'JSON'
			}).done(function (data) {
				if (data.status == 0) {
					var 
						$html = $(data.result),
						$form = $html.find('form');

					var $popup = popupFull({
						html: $html,
						width: 'medium'
					});

					initForm($form, {
						submit: function () {
							console.log($form.serialize());
							return;
							$.ajax({
								url: '/blocks/create',
								method: 'POST',
								data: $form.serialize() + 'block%5Bproject_id%5D=' + project_id,
								dataType: 'JSON'
							}).done(function (data) {
								if (data.status == 0) {
									alert('OK');
								}
								else {
				          popupPrompt({
				            title: _t.form.error_title,
				            type: 'danger',
				            content: _t.form.error_content
				          })
								}
							}).fail(function () {
			          popupPrompt({
			            title: _t.form.error_title,
			            type: 'danger',
			            content: _t.form.error_content
			          })
							});
						}
					});
				}
				else {
          popupPrompt({
            title: _t.form.error_title,
            type: 'danger',
            content: _t.form.error_content
          })
				}
			}).fail(function () {
        popupPrompt({
          title: _t.form.error_title,
          type: 'danger',
          content: _t.form.error_content
        })
			})
		}

	/*
		/ Function
	*/

})