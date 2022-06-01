# Test for Middle Ruby on Rails Developer position in Jetfin company
### Brief description

A site where users can leave reviews about the game and view their rating.

- The user logs in through the Steam game service
- Feedback can only be left about the acquired game
- The weight of the review depends on the time played

### Technologies used

- Fully developed according to the TDD/BDD methodology (RSpec/Capybara)
- ActionCable for working with WebSockets
- ActiveJob for background updates of games and played time
- Sphinx for searching games by name and genres
- Steam Api for obtaining information about: games acquired by the user (name, genre, etc.), time played, access to the user profile
- Devise to work with Steam OmniAuth
