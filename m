Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F45218A6D8
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729019459; cv=none; b=TxP8OI8vqS8mKI1IlaEPEK4n9syUBrHs+aJmpdPASb+vlIyU7KyuAbSToLaQjwqTiJxM5dTSEl+8X0o5i/WsdhxvImJQ/jDdEzdXKB616M3wfQsufUP2sCrM4qwOc9GXV7leO8aY3PSeEHaEfeKAr2AYMDDU30+MeQQPcFQFbdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729019459; c=relaxed/simple;
	bh=e/feUKiP0IKEvwFeMVpvg4BOOMU7xVAut4uJXGol9tw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=r28PwpUENloQ92r2owlp40TioX8gsFaO0rTouwgkpJStvYg4Dsrwjlov/ICYE7WqBefoZqHfa/1fpdPltZ0la4emHjKfKkpDb+UgFXNc7lcdDQFmVhTwBStjtXmmZGDc6D/YXOZf2qW8iVZH//QNIFKreIOw4SlMvmn2vHQNzK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61364C4CEC6;
	Tue, 15 Oct 2024 19:10:58 +0000 (UTC)
Date: Tue, 15 Oct 2024 15:11:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Metin Kaya <metin.kaya@arm.com>
Subject: [PATCH] libtracefs: Have tracefs_dynevent_get_all() find kprobes
 and uprobes properly
Message-ID: <20241015151117.5562bd41@gandalf.local.home>
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

The function tracefs_dynevent_get_all() will only look at the
dynamic_events file if it exists to find matching probes. But because
uprobes and kprobes both use the same prefix "p" as well as uretprobes and
kretprobes (with prefix "r"), it cannot use the dynamic_events file to
differentiate between the two.

Have kprobes and uprobes always use their own files (kprobe_events and
uprobe_events) even if dynamic_events file exists.

Also cleaned up the code to be a bit more efficient.

Link: https://lore.kernel.org/all/20241015123831.347ff0f4@gandalf.local.home/

Fixes: b04f18b005c6b ("libtracefs: New APIs for dynamic events")
Reported-by: Metin Kaya <metin.kaya@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-dynevents.c | 113 +++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 53 deletions(-)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 85c1fcd9d5d5..6b9ba539fde3 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -34,23 +34,21 @@ static int dyn_generic_del(struct dyn_events_desc *, struct tracefs_dynevent *);
 static int dyn_synth_del(struct dyn_events_desc *, struct tracefs_dynevent *);
 
 struct dyn_events_desc {
-	enum tracefs_dynevent_type type;
-	const char *file;
-	const char *prefix;
+	enum tracefs_dynevent_type	type;
+	const char			*file;
+	const char			*prefix;
 	int (*del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
 	int (*parse)(struct dyn_events_desc *desc, const char *group,
 				char *line, struct tracefs_dynevent **ret_dyn);
 } dynevents[] = {
-	{TRACEFS_DYNEVENT_KPROBE, KPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_KPROBE,    KPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
 	{TRACEFS_DYNEVENT_KRETPROBE, KPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_UPROBE, UPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_UPROBE,    UPROBE_EVENTS, "p", dyn_generic_del, dyn_generic_parse},
 	{TRACEFS_DYNEVENT_URETPROBE, UPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_EPROBE, "", "e", dyn_generic_del, dyn_generic_parse},
-	{TRACEFS_DYNEVENT_SYNTH, SYNTH_EVENTS, "", dyn_synth_del, dyn_synth_parse},
+	{TRACEFS_DYNEVENT_EPROBE,    "",            "e", dyn_generic_del, dyn_generic_parse},
+	{TRACEFS_DYNEVENT_SYNTH,     SYNTH_EVENTS, "", dyn_synth_del, dyn_synth_parse},
 };
 
-
-
 static int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
 {
 	char *str;
@@ -280,8 +278,13 @@ static void init_devent_desc(void)
 		return;
 
 	/* Use  ftrace dynamic_events, if available */
-	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++)
+	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++) {
+		/* kprobes and uprobes do not use default file */
+		if (dynevents[i].prefix[0] == 'p' ||
+		    dynevents[i].prefix[0] == 'r')
+			continue;
 		dynevents[i].file = DYNEVENTS_EVENTS;
+	}
 
 	dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].prefix = "s";
 }
@@ -480,16 +483,15 @@ int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force)
 	return desc->del(desc, devent);
 }
 
-static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system,
-			     struct tracefs_dynevent ***ret_all)
+static int get_dynevent(enum tracefs_dynevent_type type, const char *system,
+			struct tracefs_dynevent ***ret_all, int count)
 {
 	struct dyn_events_desc *desc;
-	struct tracefs_dynevent *devent, **tmp, **all = NULL;
+	struct tracefs_dynevent *devent, **tmp, **all;
 	char *content;
-	int count = 0;
 	char *line;
 	char *next;
-	int ret;
+	int ret = -1;
 
 	desc = get_devent_desc(type);
 	if (!desc)
@@ -499,6 +501,9 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
 	if (!content)
 		return -1;
 
+	if (ret_all)
+		all = *ret_all;
+
 	line = content;
 	do {
 		next = strchr(line, '\n');
@@ -507,11 +512,12 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
 		ret = desc->parse(desc, system, line, ret_all ? &devent : NULL);
 		if (!ret) {
 			if (ret_all) {
-				tmp = realloc(all, (count + 1) * sizeof(*tmp));
+				tmp = realloc(all, (count + 2) * sizeof(*tmp));
 				if (!tmp)
-					goto error;
+					break;
 				all = tmp;
 				all[count] = devent;
+				all[count + 1] = NULL;
 			}
 			count++;
 		}
@@ -521,12 +527,38 @@ static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system
 	free(content);
 	if (ret_all)
 		*ret_all = all;
+
 	return count;
+}
 
-error:
-	free(content);
-	free(all);
-	return -1;
+static int get_all_dynevents(enum tracefs_dynevent_type type, const char *system,
+			     struct tracefs_dynevent ***ret_all)
+{
+	int count = 0;
+	int i;
+
+	if (ret_all)
+		*ret_all = NULL;
+
+	for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++) {
+		if (!((1 << i) & type))
+			continue;
+
+		count = get_dynevent((1 << i), system, ret_all, count);
+		if (count < 0) {
+			count = 0;
+			break;
+		}
+	}
+
+	if (!count) {
+		if (ret_all) {
+			free(*ret_all);
+			*ret_all = NULL;
+		}
+		count = -1;
+	}
+	return count;
 }
 
 /**
@@ -561,41 +593,16 @@ void tracefs_dynevent_list_free(struct tracefs_dynevent **events)
 struct tracefs_dynevent **
 tracefs_dynevent_get_all(unsigned int types, const char *system)
 {
-	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
-	int count, all = 0;
-	int i;
+	struct tracefs_dynevent **events;
+	int count;
 
-	for (i = 1; i < TRACEFS_DYNEVENT_MAX; i <<= 1) {
-		if (types) {
-			if (i > types)
-				break;
-			if (!(types & i))
-				continue;
-		}
-		count = get_all_dynevents(i, system, &events);
-		if (count > 0) {
-			tmp = realloc(all_events, (all + count + 1) * sizeof(*tmp));
-			if (!tmp)
-				goto error;
-			all_events = tmp;
-			memcpy(all_events + all, events, count * sizeof(*events));
-			all += count;
-			/* Add a NULL pointer at the end */
-			all_events[all] = NULL;
-			free(events);
-		}
+	count = get_all_dynevents(types, system, &events);
+	if (count <= 0) {
+		free(events);
+		return NULL;
 	}
 
-	return all_events;
-
-error:
-	free(events);
-	if (all_events) {
-		for (i = 0; i < all; i++)
-			free(all_events[i]);
-		free(all_events);
-	}
-	return NULL;
+	return events;
 }
 
 /**
-- 
2.45.2

