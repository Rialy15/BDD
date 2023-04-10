SELECT pid_signalé, COUNT(*) as nombre_signalements
FROM signalement
GROUP BY pid_signalé
ORDER BY nombre_signalements DESC;
