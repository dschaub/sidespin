module ApplicationHelper
  def random_footer_tip
    [
        'Tip: Hit the ball harder.',
        'Tip: Face the black side of the paddle toward your opponent. The red side will make them angry and more likely to win.',
        'Tip: Lighter paddles are better. Drop your heavy STIGA for an oragami paddle to bring your game to the next level.',
        'Fun Fact: Lets were added to the game because King Henry VIII kept losing on double faults, which were made obsolete.',
        'Fun Fact: The game is called "table tennis" because players used to stand on a giant wooden table with full-sized rackets.'
    ].sample
  end
end
