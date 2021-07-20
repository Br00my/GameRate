document.addEventListener('turbolinks:load', function(){
  var createBtns = document.querySelectorAll('.comment_create_btn');
  
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

  var editBtns = document.querySelectorAll('.comment_edit_btn');

  editBtns.forEach(editBtn => {
    editBtn.addEventListener('click', function(e){
      e.target.style.display = 'none';

      var commentId = e.target.dataset.comment_id;
      document.querySelector('#comment_edit_form_' + commentId).style.display = 'block';
    })
  })

  var editCancelBtns = document.querySelectorAll('.comment_edit_cancel_btn');

  editCancelBtns.forEach(editCancelBtn => {
    editCancelBtn.addEventListener('click', function(e){
      var commentId = editCancelBtn.dataset.comment_id;
      document.querySelector('#comment_edit_form_' + commentId).style.display = 'none';

      document.querySelector('#comment_edit_btn_' + commentId).style.display = 'block';
    })
  })
})