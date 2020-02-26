Return-Path: <SRS0=1BtL=4O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D26EC4BA19
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52B7C206E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AeIz+1yB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBZQcI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:32:08 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42173 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbgBZQcH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 11:32:07 -0500
Received: by mail-lj1-f194.google.com with SMTP id d10so3802525ljl.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Feb 2020 08:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ytAs4N8eHHrCE5vlEUflW+GDRTfBuxWUc/so7AGAKZ0=;
        b=AeIz+1yB8F4MI/hr6SmTV7dcLgtKqj8QA/+ZmmrTJtgwqnBjIA88WyQvJhkA5i/Qjj
         P94gpc+OxxU+l6mAm3lZZoVApJqtMg0hsMiBtzjJxGi3x3IJ0tzL0X93GEGSDF2xRbUA
         eS/IKdXpwvXcDAsigvkMd1SmODkusn/3tlCkKqw27qVoJVehrf2LoYLnWhZ+DIMYA7PR
         SiU5lf5QjaZHA/4HUTkjeBphFbY1vaGtFp0QO4KfaN6tmKyfYJ7aGMc8NPwxbr87t8Nk
         FerIqItw3kS5ohQ+FWeCUUZ2eYzrbMgPaMt9KP6ECgZX8WK2GeX4Y6DSLZ/F5vPmiI8n
         yVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ytAs4N8eHHrCE5vlEUflW+GDRTfBuxWUc/so7AGAKZ0=;
        b=XEuXLDNFaYiNTt+hKgOUXhUp1+aQwslhKQYEIvzP8TcpvGtQI9LIfkBlM9sTYbfvZX
         JSa84KXv5AVhS9em9uSxrTowMJd+kNObkIF0AVV8+RcoWLk51zXlYKHBsYDqvKX+B9fc
         yAB8+qlUrmiC6+flae8slFvjCqvaJJqClBcpyu3GdV+IK/Doj/HAI0yHUN1n3YDLNRIf
         4dfLDKpwwozVuub9GC2aEGJ6W+3wArpGZsAzjg9rDpnQzgMFF5JrDPt8gnBWrYYGW5/Y
         WOVs8cluMAVhS1HEHX9/rQFRY3eQk70+Vn99KV8nmcjvDuhjHyh/prQDf4Wxa5sbvqeE
         nvYw==
X-Gm-Message-State: APjAAAXx2vocNniKTkhmLigy+WYBXBsK81nns+2+JajrmO2Ly3M0tRRT
        42W+MsMlwMR6b3sXE76aJWCND3XLkgM=
X-Google-Smtp-Source: APXvYqy2myAgGbE66fycqoKrjoXOIROQqZ5SIrtdyd4MzfJEvjNGrlirGLdc3+YrwMHQjmPMQP24rQ==
X-Received: by 2002:a05:651c:204f:: with SMTP id t15mr3357761ljo.240.1582734725884;
        Wed, 26 Feb 2020 08:32:05 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s2sm1264133lfd.67.2020.02.26.08.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:32:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/5] trace-cmd: Add new libtraceevent flag to suppress parsing warnings
Date:   Wed, 26 Feb 2020 18:31:57 +0200
Message-Id: <20200226163159.20232-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226163159.20232-1-tz.stoyanov@gmail.com>
References: <20200226163159.20232-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the event's format strings are parsed by tep_parse_format()
API and there is a parsing error, a warning is printed. There are
use cases when these errors are not important and should be suppressed.
A new flag is added to
 enum tep_flag {
   ...
   TEP_NO_PARSING_WARNINGS
   ...
 }
for such use cases. It can be set / cleared / checked using
the existing libtraceevent APIs:
 void tep_set_flag(struct tep_handle *tep, int flag);
 void tep_clear_flag(struct tep_handle *tep, enum tep_flag flag);
 bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 2 ++
 lib/traceevent/event-parse.c     | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 52bafa54..49e3d287 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -321,6 +321,8 @@ enum tep_flag {
 	TEP_NSEC_OUTPUT		= 1,	/* output in NSECS */
 	TEP_DISABLE_SYS_PLUGINS	= 1 << 1,
 	TEP_DISABLE_PLUGINS	= 1 << 2,
+	TEP_NO_PARSING_WARNINGS	= 1 << 3, /* Disable warnings while parsing
+					     event's format strings */
 };
 
 #define TEP_ERRORS 							      \
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 064c100d..61cd7ea1 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6222,6 +6222,7 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 				  struct tep_handle *tep, const char *buf,
 				  unsigned long size, const char *sys)
 {
+	int show_warning_state = show_warning;
 	struct tep_event *event;
 	int ret;
 
@@ -6274,11 +6275,12 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 	 * If the event has an override, don't print warnings if the event
 	 * print format fails to parse.
 	 */
-	if (tep && find_event_handle(tep, event))
+	if (tep && (tep_test_flag(tep, TEP_NO_PARSING_WARNINGS) ||
+		    find_event_handle(tep, event)))
 		show_warning = 0;
 
 	ret = event_read_print(event);
-	show_warning = 1;
+	show_warning = show_warning_state;
 
 	if (ret < 0) {
 		ret = TEP_ERRNO__READ_PRINT_FAILED;
-- 
2.24.1

