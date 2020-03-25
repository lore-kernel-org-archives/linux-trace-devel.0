Return-Path: <SRS0=JHVT=5K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835BEC54FD0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C8020722
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0rGR6DZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbgCYOIj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:08:39 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33753 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgCYOIi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 10:08:38 -0400
Received: by mail-lj1-f193.google.com with SMTP id f20so2631369ljm.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Mar 2020 07:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WvhwqahoZdltrwwlb5nBf/PbNg/5yRP/ddbkiNbh+P4=;
        b=T0rGR6DZnPrQ5AQtCg7iW9Ry7qeorJf7UPmD5+fHBSvMgzAbXRpYjBCN82sn21lxrF
         68G1N+qpVHl0+HoTPvPtyi+HS7L1o0peedaa3Hp7x5pff86R/JD2vV+VieXiuiUhEn7N
         g03cxPdyoOIz2SaYVNQRRDZDiezAmif00VNXVVaDNysdQiNivfCEVpoP4/NzMzbPxuvW
         ab1nBv1O+QnVK4pAvjbQ1yEih5YNoFt5RmgbKd12loB4EDg4zS7i9EwsL4MHCQFH+V1Y
         UUvQDZB48soEqljpGs5xfUloFOQMaNDympFBX95demvO3Yu9wg5TBvh7jEZH9I2UXMHW
         kzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WvhwqahoZdltrwwlb5nBf/PbNg/5yRP/ddbkiNbh+P4=;
        b=Hcb849x1vg7ihouHgqHi5MpZ1P2cmZl9SRAhigJW1qR27lPalm4beVczsKRTT+hNne
         mLrHRv8+KtpjC2EndaY5/mrP3Ch38YAY5hYhAkz9FLi74Q8h8+hrVET/Li52o4WrWAFd
         AZc16uqP4iM2Y9qQt0MmKGQlP2T5k9PB80/h/x2aXymFkLPgdcK7mxgCv81WRFmXyHqI
         tRu8cNJoIauY/dORjRk3h80J6tC45t2aWiMfPww4US68u7mUiGrHlgQ4U2CmzkGBtQ2l
         9UOWegyCA/Aen1kDeU71Y3UypGD55qb1P/5dQvAjNa5hoHUe8HJqGlaNyFFyvAKrFTki
         EQEg==
X-Gm-Message-State: AGi0Pua7lZq4FTedTsGsgz9URFc1nbhkVxvRQARUtdnYAXAvh11hw3CA
        ZdYqtWHVA9Ei9a/JksOGTJI=
X-Google-Smtp-Source: APiQypKQClQJhG06M4DZhSj798++O2zJfcT3igIuw9lQKb9Aqq3YPKS0NaW8L2E5OSJNzdsLe8pJNw==
X-Received: by 2002:a2e:94d5:: with SMTP id r21mr1996952ljh.81.1585145316206;
        Wed, 25 Mar 2020 07:08:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v9sm12017301ljv.82.2020.03.25.07.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:08:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Fix setting triggers to all events from given system
Date:   Wed, 25 Mar 2020 16:08:29 +0200
Message-Id: <20200325140829.184651-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325140829.184651-1-tz.stoyanov@gmail.com>
References: <20200325140829.184651-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When running the "trace-cmd record -e (system) -R (trigger)" command for an event system, it fails with
"no such file or directory error". This use case is supposed to apply the given trigger to all events
from the system.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206737
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 99 +++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 34 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7dbf599a..76305d1a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2658,6 +2658,21 @@ static void set_max_graph_depth(struct buffer_instance *instance, char *max_grap
 		die("could not write to max_graph_depth");
 }
 
+static bool check_file_in_dir(char *dir, char *file)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	ret = asprintf(&path, "%s/%s", dir, file);
+	if (ret < 0)
+		die("Failed to allocate id file path for %s/%s", dir, file);
+	ret = stat(path, &st);
+	free(path);
+	if (ret < 0 || S_ISDIR(st.st_mode))
+		return false;
+	return true;
+}
 
 /**
  * create_event - create and event descriptor
@@ -2703,14 +2718,19 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 		free(p);
 
 	if (old_event->trigger) {
-		event->trigger = strdup(old_event->trigger);
-		ret = asprintf(&p, "%s/trigger", path_dirname);
-		if (ret < 0)
-			die("Failed to allocate trigger path for %s", path);
-		ret = stat(p, &st);
-		if (ret < 0)
-			die("trigger specified but not supported by this kernel");
-		event->trigger_file = p;
+		if (check_file_in_dir(path_dirname, "trigger")) {
+			event->trigger = strdup(old_event->trigger);
+			ret = asprintf(&p, "%s/trigger", path_dirname);
+			if (ret < 0)
+				die("Failed to allocate trigger path for %s", path);
+			event->trigger_file = p;
+		} else {
+			/* Check if this is event or system.
+			 * Systems do not have trigger files by design
+			 */
+			if (check_file_in_dir(path_dirname, "id"))
+				die("trigger specified but not supported by this kernel");
+		}
 	}
 
 	return event;
@@ -2815,14 +2835,29 @@ static int expand_event_files(struct buffer_instance *instance,
 	return save_event_tail == instance->event_next;
 }
 
+static int expand_events_all(struct buffer_instance *instance,
+			     char *system_name, char *event_name,
+			     struct event_list *event)
+{
+	char *name;
+	int ret;
+
+	ret = asprintf(&name, "%s/%s", system_name, event_name);
+	if (ret < 0)
+		die("Failed to allocate system/event for %s/%s",
+		     system_name, event_name);
+	ret = expand_event_files(instance, name, event);
+	free(name);
+
+	return ret;
+}
+
 static void expand_event(struct buffer_instance *instance, struct event_list *event)
 {
 	const char *name = event->event;
 	char *str;
 	char *ptr;
-	int len;
 	int ret;
-	int ret2;
 
 	/*
 	 * We allow the user to use "all" to enable all events.
@@ -2833,41 +2868,37 @@ static void expand_event(struct buffer_instance *instance, struct event_list *ev
 		return;
 	}
 
-	ptr = strchr(name, ':');
+	str = strdup(name);
+	if (!str)
+		die("Failed to allocate %s string", name);
 
+	ptr = strchr(str, ':');
 	if (ptr) {
-		len = ptr - name;
-		str = malloc(strlen(name) + 1); /* may add '*' */
-		if (!str)
-			die("Failed to allocate event for %s", name);
-		strcpy(str, name);
-		str[len] = '/';
+		*ptr = '\0';
 		ptr++;
-		if (!strlen(ptr)) {
-			str[len + 1] = '*';
-			str[len + 2] = '\0';
-		}
 
-		ret = expand_event_files(instance, str, event);
+		if (strlen(ptr))
+			ret = expand_events_all(instance, str, ptr, event);
+		else
+			ret = expand_events_all(instance, str, "*", event);
+
 		if (!ignore_event_not_found && ret)
 			die("No events enabled with %s", name);
-		free(str);
-		return;
+
+		goto out;
 	}
 
 	/* No ':' so enable all matching systems and events */
-	ret = expand_event_files(instance, name, event);
-
-	len = strlen(name) + strlen("*/") + 1;
-	str = malloc(len);
-	if (!str)
-		die("Failed to allocate event for %s", name);
-	snprintf(str, len, "*/%s", name);
-	ret2 = expand_event_files(instance, str, event);
-	free(str);
+	ret = expand_event_files(instance, str, event);
+	ret &= expand_events_all(instance, "*", str, event);
+	if (event->trigger)
+		ret &= expand_events_all(instance, str, "*", event);
 
-	if (!ignore_event_not_found && ret && ret2)
+	if (!ignore_event_not_found && ret)
 		die("No events enabled with %s", name);
+
+out:
+	free(str);
 }
 
 static void expand_event_instance(struct buffer_instance *instance)
-- 
2.25.1

