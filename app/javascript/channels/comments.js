import consumer from "./consumer"

document.addEventListener('turbolinks:load', function(){
  if (document.querySelector('.reviews') == null) { return; }

  consumer.subscriptions.create('CommentsChannel', {
    connected(){
      this.perform('follow');
    },

    received(data){
      if (gon.user_id == data.user_id) { return; }

      switch (data.action) {
        case 'create':
          var comment = document.createElement('div');
          comment.classList.add('comment');
          comment.id = 'comment_' + data.comment_id;
          var commentText = document.createElement('div');
          commentText.classList.add('comment_text');
          commentText.id = 'comment_text_' + data.comment_id;
          commentText.innerHTML = data.comment_text;
          comment.appendChild(commentText);
          var comments = document.querySelector('#review_' + data.review_id + ' .comments');
          comments.appendChild(comment);
          break;
        case 'update':
          document.querySelector('#comment_text_' + data.comment_id).textContent = data.comment_text;
          break;
        case 'destroy':
          var comment = document.querySelector('#comment_' + data.comment_id);
          comment.parentNode.removeChild(comment);
          break;
      }
    }
  })

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
      document.querySelector('#comment_text_' + commentId).style.display = 'none';
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