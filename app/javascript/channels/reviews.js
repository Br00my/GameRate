document.addEventListener('turbolinks:load', function(){
  var editLink = document.querySelector('.review_edit_btn');

  if (editLink != null) {
    editLink.addEventListener('click', function(e){
      e.target.style.display = 'none';
      document.querySelector('.review_edit_form').style.display = 'block';
      reviewId = e.target.dataset.review_id;
      document.querySelector('#review_data_' + reviewId).style.display = 'none';
    })
  }
})