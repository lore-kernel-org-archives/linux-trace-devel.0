Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3622DAFA5
	for <linux-trace-devel@vger.kernel.org>; Mon, 11 Aug 2025 21:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754949364; cv=none; b=dok9fiw82YlkOT/ttSeeZs/G2U87IxMniufsQz+YINZyK9OfaQlRYU4D5dHuVBePnIyGxLJbepgccUpt6qzFVZPyjGwNW2R3bH+xI8IPynvArqBX9hz0HP24pjVbDi7BY4ahInsXLVIWLwPUpKy0IqxMqehVgmDe5z1hrnT3fOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754949364; c=relaxed/simple;
	bh=3KpBYjtcgCc1XsiLpNEI21MHvLLvyo1H+gR44XSFqzw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=XFdH+AsD0riIZpzQzJMpWW5GcU6vexktLxhosv5LAJcNlsRq308Y7qu5TmciRczOdTBsvxItetCdHqkPy3yl8JTjLHnffPTj9tONNhZGQv8/raAH8RCkwCxFlzl4UhI5p3fomlCARHPnC3dXu2yAyFv8ooSH8jR+gzWU5k1TDwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 462DBA5427
	for <linux-trace-devel@vger.kernel.org>; Mon, 11 Aug 2025 21:55:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 09B7D30
	for <linux-trace-devel@vger.kernel.org>; Mon, 11 Aug 2025 21:55:53 +0000 (UTC)
Date: Mon, 11 Aug 2025 17:55:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix tracefs_event_is_enabled() for all events
Message-ID: <20250811175552.662cda17@batman.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z815p14zj87xgd831b6ympamfx8wj91u
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 09B7D30
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Fkao5SbeN16C8EoSszLyS/WQ4sKQmaDg=
X-HE-Tag: 1754949353-443064
X-HE-Meta: U2FsdGVkX1+8ojHBGQ3phTsbKKUrBkZGUqPKhxntaG0fUNidT1Q4yP63MHioTSGBqSrYyqlhLrBMw+KXWE5OuexJzjRPFViQGhgSOibjYCh2fLes4tMwhYjyqhYPZt/SxXO6aZXPIZcgtpHzzWlnZpU1+AkI/wuXg/GEFfKEvzg2PJXBxGsZhn8wJcn7D4hEGaokMQPXaqpJGftpTeAJVY4xmuiWA6AWRvWK9hZGqfY9Jzc4vZOP5z90GRBs+351UKv10Pyyl4fZKN32TevI1aFtGnb3d6QAZIse+aWOJDDpatBX1Db6PU3d+0yMNRKT0sMJQKJQ2NzxSu+D/Pkz8fD0QVEUNjruTYkmDV6YS7qd3lD1tHuL+Kz6Cr2LmgHC

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When tracefs_event_is_ensabled() is called with both system and event
as NULL in order to get the state of all events, it tries to disable all
events. This is becaues the call to enable_disable_all() doesn't take
the state as a parameter and just looks at the "enable" flag.

Fixes: fc94d1a8 ("libtracefs: Add tracefs_event_enable/disable() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 1576153..aabec02 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -1511,12 +1511,23 @@ static int enable_disable_system(struct tracefs_instance *instance,
 }
 
 static int enable_disable_all(struct tracefs_instance *instance,
-			      bool enable)
+			      bool enable, enum event_state *state)
 {
 	const char *str = enable ? "1" : "0";
+	char *event_file;
 	int ret;
 
-	ret = tracefs_instance_file_write(instance, "events/enable", str);
+	ret = asprintf(&event_file, "events/enable");
+	if (ret < 0)
+		return ret;
+
+	if (state)
+		ret = read_event_state(instance, event_file, state);
+	else
+
+		ret = tracefs_instance_file_write(instance, event_file, str);
+	free(event_file);
+
 	return ret < 0 ? ret : 0;
 }
 
@@ -1552,7 +1563,7 @@ static int event_enable_disable(struct tracefs_instance *instance,
 
 	/* Handle all events first */
 	if (!system && !event)
-		return enable_disable_all(instance, enable);
+		return enable_disable_all(instance, enable, state);
 
 	systems = tracefs_event_systems(NULL);
 	if (!systems)
-- 
2.47.2

