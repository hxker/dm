json.array!(@scores) do |score|
  json.extract! score, :competition_id, :comp_name, :kind, :th, :team1_id, :team2_id, :score1, :score2, :referee_id, :operator
  json.url score_url(score, format: :json)
end