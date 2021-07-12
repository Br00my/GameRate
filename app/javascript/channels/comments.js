document.addEventListener('turbolinks:load', function(){
  var createBtns = document.querySelectorAll('.comment_create_btn');

  if (createBtns.length == 0) { return; }
  
  createBtns.forEach(createBtn => {
    createBtn.addEventListener('click', function(e){
      e.target.style.display = 'none';

      var reviewId = e.target.dataset.review_id;
      document.querySelector('#comment_create_form_' + reviewId).style.display = 'block';
    })
  })

  var createCancelBtns = document.querySelectorAll('.comment_create_cancel_btn');

  createCancelBtns.forEach(createCancelBtn => {
    createCancelBtn.addEventListener('click', function(){
      var reviewId = createCancelBtn.dataset.review_id;
      document.querySelector('#comment_create_form_' + reviewId).style.display = 'none';

      document.querySelector('#comment_create_btn_' + reviewId).style.display = 'block';
    })
  })
})