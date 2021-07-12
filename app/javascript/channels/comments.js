document.addEventListener('turbolinks:load', function(){
  var createBtn = document.querySelector('.comment_create_btn');

  if (createBtn == null) { return; }

  var reviewId = createBtn.dataset.review_id;
  
  createBtn.addEventListener('click', function(e){
    e.target.style.display = 'none';

    document.querySelector('#comment_create_form_' + reviewId).style.display = 'block';
  })

  document.querySelector('.comment_create_cancel_btn').addEventListener('click', function(){
    document.querySelector('#comment_create_form_' + reviewId).style.display = 'none';

    createBtn.style.display = 'block';
  })
})