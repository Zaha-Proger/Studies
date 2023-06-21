USE KutinRPL;
SELECT TOP(1) * FROM(
  SELECT *, (_count1 + _count2 + _count3 + _count4) AS _count
  FROM (SELECT *,(SELECT win_score_if_1_is_first FROM(SELECT team_id_1, COUNT(*) * 3 AS win_score_if_1_is_first
    FROM game AS g WHERE ((SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.team_id = g.team_id_1) -
      (SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.team_id = g.team_id_2)) > 0
    GROUP BY team_id_1) AS q1 WHERE (team_id_1 = team_id)) AS _count1,
  (SELECT win_score_if_2_is_first FROM (SELECT team_id_2, COUNT(*) * 3 AS win_score_if_2_is_first
    FROM game AS g WHERE ((SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.team_id = g.team_id_1) -
      (SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.team_id = g.team_id_2)) < 0
    GROUP BY team_id_2) AS q2 WHERE (team_id_2 = team_id)) AS _count2,
  (SELECT draw_1_if_1_is_first FROM (SELECT team_id_2, COUNT(*) AS draw_1_if_1_is_first
    FROM game AS g WHERE ((SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.game_id = g.team_id_1) - 
      (SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.game_id = g.team_id_2)) = 0
    GROUP BY team_id_2) AS q01 WHERE (team_id_2 = team_id)) AS _count3, 
  (SELECT draw_2_if_1_is_first FROM (SELECT team_id_1, COUNT(*) AS draw_2_if_1_is_first
    FROM game AS g WHERE ((SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.game_id = g.team_id_1) - 
      (SELECT COUNT(*) AS goals_count FROM game_event AS ge
      WHERE ge.game_id = g.game_id and ge.game_id = g.team_id_2)) = 0
    GROUP BY team_id_1) AS q02 WHERE (team_id_1 = team_id)) AS _count4
  FROM team) AS qq
) AS qqq
ORDER BY _count DESC