# frozen_string_literal: true

require_relative "test_helper"

class TestNbaStats < Minitest::Test
  include NbaStats

  DEFAULT_FILE_PATH = 'lib/data/data_2022_2023.csv'
  def test_that_it_has_a_version_number
    refute_nil ::NbaStats::VERSION
  end

  def test_it_can_extract_data
    le_bron = stats('LeBron James', DEFAULT_FILE_PATH, headers(DEFAULT_FILE_PATH))
    assert_equal 'PF', le_bron.position
  end

  def test_it_can_load_a_header
    headers = headers(DEFAULT_FILE_PATH)
    assert_equal 'Pos', headers[2]
  end

  def test_nil_is_returned_for_unknown_player
    fake_le_bron = stats('DeBron James',DEFAULT_FILE_PATH, headers(DEFAULT_FILE_PATH))
    assert_nil fake_le_bron
  end

  def test_it_can_handle_typos
    almost_le_bron = stats('DeBron James',
                           DEFAULT_FILE_PATH,
                           headers(DEFAULT_FILE_PATH),
                           autocorrect: true)

    assert_equal 'PF', almost_le_bron.position
  end

  def test_it_can_not_handle_too_much_typos
    assert_nil     stats('random string',
                         DEFAULT_FILE_PATH,
                         headers(DEFAULT_FILE_PATH),
                         autocorrect: true)
  end
end
