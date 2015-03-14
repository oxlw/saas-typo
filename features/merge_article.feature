Feature: Merge Articles
    As an admin
    So that I can merge articles
    I want to see a merge form on the edit article page

    Background: there are articles and users in the database

        Given the blog is set up

        And the following users exist:
            | profile_id | login  | name   | password     | email           | state  |
            | 2       | ShaunD | ShaunD | coolcool     | sd@berkeley.edu | active |
            | 3       | TomY   | TomY   | coolcool     | ty@berkeley.edu | active |

        And the following articles exist:
            | id | title    | author | user_id | body     | allow_comments | published | published_at        | state     | type    |
            | 3  | SArticle | ShaunD | 2       | SStuff | true           | true      | 2015-14-03 14:30:00 | published | Article |
            | 4  | TArticle | TomY | 3       | TStuff | true           | true      | 2015-14-03 15:00:00 | published | Article |

        And the following comments exist:
            | id | type    | author | body       | article_id | user_id | created_at          |
            | 1  | Comment | ShaunD | MyComment  | 3          | 2       | 2015-14-03 16:11:00 |
            | 2 | Comment | ShaunD | HisComment | 4          | 2       | 2015-14-03 15:07:00 |

    Scenario: A non-admin cannot merge articles
        Given I am logged in as "ShaunD" with password "coolcool"
        And I am on the Edit Page of Article with id 3
        Then I should not see "Merge Articles"

    Scenario: An admin can merge articles
        Given I am logged in as "admin" with password "aaaaaaaa"
        And I am on the Edit Page of Article with id 3
        Then I should see "Merge Articles"
        When I fill in "merge_with" with "4"
        And I press "Merge"
        Then I should be on the admin content page
        And I should see "Articles successfully merged!"

    Scenario: The merged articles' content should be from both articles
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "SArticle"
        When I follow "SArticle"
        Then I should see "SStuff"
        And I should see "TStuff"

    Scenario: The merged article should have one author (either one of the both)
        Given the articles with ids "3" and "4" were merged
        Then author should be "TomY" or "ShaunD"
 

    Scenario: Comments on each of the two articles need to all be carried over
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "SArticle"
        When I follow "SArticle"
        Then I should see "MyComment"
        And I should see "HisComment"

    Scenario: The title should be either one of the merged articles
        Given the articles with ids "3" and "4" were merged
        And I am on the home page
        Then I should see "SArticle" or "TArticle"
