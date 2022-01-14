Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152AFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 10:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiANK5w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 05:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiANK5v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 05:57:51 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842FAC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 02:57:51 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 15so322879edx.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 02:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rdQFMFrBJwvb3I1nsJD/uD42M8OI24825Pzfk9uRT10=;
        b=iov2vVGaLC+TFFY5lnDDbszBHl0ovxhtdwbvh3beTXZ7ylhocSRYbY7tuU6nchVlCU
         CaJXosGGV6HhO3NSjDY6KMF4u5J07avVajX1gMo1QGeDoMbUl2phXozowDxKdULB3Sn0
         yPPfGWY9iHZ4ZSiru5UQ+ZvpKWo5s1sDDdT8N6AI+qYSwmqMHBMI078htchxf7zVMuWx
         rYXP/PJfNHkyiCX1gaI7Rac/QXaAA/01ei4M6xIQRKYjvjcXoY/+o4NrVAALEAxTRYsC
         ec5x6Ry1hdQGiDoUBp3srk3J+OXEjmA9IEIfz/RXw6sVh1kjp9t68Z5ACjrMJMx6LfXx
         0qlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rdQFMFrBJwvb3I1nsJD/uD42M8OI24825Pzfk9uRT10=;
        b=YMOwcv4DKMyB6boiFILRvTOLb8axd5t982tvVPjRHNBhHbSlVVYMi987URT/VTZK4P
         EtkBBBJp3g8dtFJWDzBvlay3f0R2mCfPOzX0PpHzo2nbqDA1E+cr8LueZNXylKjkiHN2
         QkOBcLFGE21oUOPpYRq+Hd4+FdQUvunQ3hAmHQg9EBAOhFcwjxKDPdqSlVUKxdy+nOfq
         MHIwBlJ5zOJ1AaOdgdoAiIVeeb9zoHaJeVKJkUIiziTQNisw/wkSjX9XrTaH3JAjCdhb
         fLSfG6gX7n1eYI9f3GycIvjzFCozzOs1Z/OqD6vGats6WcMoVus8ROpw3vuo8NWgM7Ou
         vrQg==
X-Gm-Message-State: AOAM533fag2/p/vp6wrpen3Z9l3BYlmgtka/x7kUNlJ5cMCnK4ZU56Xw
        bMt+GXZeshQxJ/dSiSh7ZIefy4RaWx0=
X-Google-Smtp-Source: ABdhPJzFsQzkvcMCoFwMNxj9ndIqr9nHR9V0lAf04S5HKyOHRq3dcj7WCM0rv5O54ba1tFlFx3Xd5A==
X-Received: by 2002:a17:907:7212:: with SMTP id dr18mr7048687ejc.646.1642157870102;
        Fri, 14 Jan 2022 02:57:50 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l2sm1242646ejk.187.2022.01.14.02.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 02:57:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd reset: Clear all dynamic events
Date:   Fri, 14 Jan 2022 12:57:48 +0200
Message-Id: <20220114105748.46761-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should set ftrace state to default,
including all dynamically created events. Currently only synthetic events
are deleted. The command is enhanced to delete all dynamic events, using
the new tracefs library API for dynamic events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 43 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b4200db1..aee3b01a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5221,41 +5221,18 @@ static void clear_error_log(void)
 		clear_instance_error_log(instance);
 }
 
-static void clear_all_synth_events(void)
+static void clear_all_dynamic_events(void)
 {
-	char sevent[BUFSIZ];
-	char *save = NULL;
-	char *line;
-	char *file;
-	char *buf;
-	int len;
-
-	file = tracefs_instance_get_file(NULL, "synthetic_events");
-	if (!file)
-		return;
-
-	buf = read_file(file);
-	if (!buf)
-		goto out;
-
-	sevent[0] = '!';
-
-	for (line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
-		len = strlen(line);
-		if (len > BUFSIZ - 2)
-			len = BUFSIZ - 2;
-		strncpy(sevent + 1, line, len);
-		sevent[len + 1] = '\0';
-		write_file(file, sevent);
-	}
-out:
-	free(buf);
-	tracefs_put_tracing_file(file);
-
+	/* Clear event probes first, as they may be attached to other dynamic event */
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE |
+				     TRACEFS_DYNEVENT_KRETPROBE |
+				     TRACEFS_DYNEVENT_UPROBE |
+				     TRACEFS_DYNEVENT_URETPROBE |
+				     TRACEFS_DYNEVENT_SYNTH,
+				     true);
 }
 
-
-
 static void clear_func_filters(void)
 {
 	struct buffer_instance *instance;
@@ -5951,7 +5928,7 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
-	clear_all_synth_events();
+	clear_all_dynamic_events();
 	clear_error_log();
 	/* set clock to "local" */
 	reset_clock();
-- 
2.34.1

