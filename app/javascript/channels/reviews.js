import consumer from "./consumer"

document.addEventListener('turbolinks:load', function(){
  consumer.subscriptions.create('ReviewsChannel', {
    connected(){
      this.perform('follow');
    },

    received(data){
      if (gon.user_id == data.user_id) { return; }

      if (document.querySelector('.reviews') != null) {
        switch (data.action) {
          case 'create':
            var review = document.createElement('div');
            review.id = 'review_' + data.review_id;
            review.classList.add('review');
            review.innerHTML = data.review_partial;
            if (gon.owns_game == true) {
              review.innerHTML += data.comment_create_window_partial;
              var createBtn = review.querySelector('.comment_create_btn');

              createBtn.addEventListener('click', function(e){
                e.target.style.display = 'none';

                review.querySelector('.comment_create_form').style.display = 'block';
              })

              review.querySelector('.comment_create_cancel_btn').addEventListener('click', function(e){
                review.querySelector('.comment_create_form').style.display = 'none';

                createBtn.style.display = 'block';
              })
            }
            document.querySelector('.reviews').appendChild(review);
            document.querySelector('.game_rate').innerHTML = data.game_stars_partial;
            break;
          case 'update':
            var review = document.querySelector('#review_data_' + data.review_id);
            review.innerHTML = data.review_partial;
            document.querySelector('.game_rate').innerHTML = data.game_stars_partial;
            break;
          case 'destroy':
            var review = document.querySelector('#review_' + data.review_id);
            review.parentNode.removeChild(review);
            document.querySelector('.game_rate').innerHTML = data.game_stars_partial;
            break;
        }
      }
      else {
        document.querySelector('#game_' + data.game_id + ' .game_rate').innerHTML = data.game_stars_partial;
      }
    }
  })

  var reviewCreateForm = document.querySelector('.review_create_form');

  if (reviewCreateForm != null) {
    if (reviewCreateForm.dataset.reviewed == 'true') {
      reviewCreateForm.style.display = 'none';
    }
  }

  var editBtn = document.querySelector('.review_edit_btn');

  if (editBtn == null) { return; }
  
  editBtn.addEventListener('click', function(e){
    e.target.style.display = 'none';

    document.querySelector('.review_edit_form').style.display = 'block';

    var reviewId = e.target.dataset.review_id;      
    document.querySelector('#review_data_' + reviewId).style.display = 'none';
  })

  document.querySelector('.review_edit_cancel_btn').addEventListener('click', function(e){
    document.querySelector('.review_edit_form').style.display = 'none';

    editBtn.style.display = 'block';
    var reviewId = e.target.dataset.review_id;
    console.log(reviewId);
    document.querySelector('#review_data_' + reviewId).style.display = 'block';
  })
})