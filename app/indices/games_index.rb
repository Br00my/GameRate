ThinkingSphinx::Index.define :game, with: :active_record do
  indexes title
  indexes genres
end