Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A8C45008
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Aug 2024 21:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189738; cv=none; b=KN3p6NZH0GXQHCtdPJZ3CtEgNoFiGmBR75w99U9HAw7cKrHSZSxv5zvAg1OJBGjZy0wLh2SWEwwwsCY1gP8EEYHEWzeuT653eqwM7Ck4IaaPOTVUvAniKFNLmVjv95HnMjkDqRFEc0ENYh1YeWdWX0deXXmm1fieXkGM5iloAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189738; c=relaxed/simple;
	bh=bEU7M/9dTZFq4k4pcF1azK2X5IjEkQzoJVy/9fa6Udk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=QSlgh7RLxEjB3GV6zgdKULuNbv//mlGs1z2f34kaBMWIJQ0gif3Knp/hOO4w1FK1YwB5dCrk6vGt+GmXy+PmsqncjQ4gjgyeKkKRZ5JfwI72tZsuhrp3fIGnF54uB1wFBp4Zf4grSlGhmsJb/jdQREuNP2y6PidsMoIB17Vcbd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CCFC4AF0F
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Aug 2024 21:35:37 +0000 (UTC)
Date: Tue, 20 Aug 2024 17:36:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Have tracefs_instance_tracers() return instance
 tracers
Message-ID: <20240820173604.29693def@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_instance_tracers() was always returning the top level tracers
and not the tracers that were available for the given instance.

Fixes: 185019c0 ("libtracefs: Add tracefs_instance_tracers() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 83069aa..77d1ba8 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -1012,12 +1012,20 @@ char **tracefs_tracers(const char *tracing_dir)
  */
 char **tracefs_instance_tracers(struct tracefs_instance *instance)
 {
-	const char *tracing_dir = NULL;
+	char *tracing_dir = NULL;
+	char **list;
+	int ret;
 
-	if (instance)
-		tracing_dir = instance->trace_dir;
+	if (instance) {
+		ret = asprintf(&tracing_dir, "%s/instances/%s", instance->trace_dir,
+			       instance->name);
+		if (ret < 0)
+			return NULL;
+	}
 
-	return list_tracers(tracing_dir);
+	list = list_tracers(tracing_dir);
+	free(tracing_dir);
+	return list;
 }
 
 static int load_events(struct tep_handle *tep,
-- 
2.43.0

