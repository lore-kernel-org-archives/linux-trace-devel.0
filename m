Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3FCC31E4A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF721206BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfFMPg5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40897 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfFMKPI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:15:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so20128737wre.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 03:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HL9TprUdYbAxqI3D6Y27Qnf+Ly8RmvPP6bh2C5LthIo=;
        b=Y/1upHHHe5UxRhby6aP2ayf6+9Qto2WluOiLxSBvj9OLZZebl15cB4hakcLln3/jQ7
         25v0HM8TEnfZZFKBXCpKNheBRwMzzAhzblIc0rjt+5SnBoQ66mBpDzmCaIbCe/oSX22m
         8sq2k7Pwni3F7iSVbLUDYw4H3hSxuxaKbJ3u5mCQq4fOxH3HWE1EJuukmMBm34Ic0C8l
         vInBiu5UvXnB13SvRIC/oOnmq+9Q3tttZYDU2mIzdoVNuZUpZtwIcJEjx0kqBoLBashE
         csC78xUHXyvCPqJF8ml9SZXe4z4e3JyW1HVv5Go5tZFCEgk4pgPa2lkESrjmUjIuCwAf
         6dlw==
X-Gm-Message-State: APjAAAVSLmzfLuIQP2nwySGnqX4yXJABknYjRc7LjAgY+I2zhA4PuYQb
        YGal+hwstLT23LY3hpAjQHo=
X-Google-Smtp-Source: APXvYqx91jhq+BQEI3w8qDhVX35MDQ69xa0CAnroU6S0T5ZYHMrcWKWdirh0CUxT9CytiE3/K7Vfbw==
X-Received: by 2002:a5d:4904:: with SMTP id x4mr32484079wrq.337.1560420906457;
        Thu, 13 Jun 2019 03:15:06 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t63sm3106418wmt.6.2019.06.13.03.15.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:15:05 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] tools/lib/traceevent: Remove tep_register_trace_clock()
Date:   Thu, 13 Jun 2019 13:15:02 +0300
Message-Id: <20190613101503.22105-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613101503.22105-1-tstoyanov@vmware.com>
References: <20190613101503.22105-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tep_register_trace_clock() API is used to instruct the
traceevent library how to print the event time stamps. As event
print interface if redesigned, this API is not needed any more.
The new event print API is flexible and the user can specify how
the time stamps are printed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-local.h |  2 --
 tools/lib/traceevent/event-parse.c       | 11 -----------
 tools/lib/traceevent/event-parse.h       |  1 -
 3 files changed, 14 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 6e58ee1fe7c8..cee469803a34 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -81,8 +81,6 @@ struct tep_handle {
 
 	/* cache */
 	struct tep_event *last_event;
-
-	char *trace_clock;
 };
 
 void tep_free_event(struct tep_event *event);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b3dfcc39f606..b97dbf1d63f7 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -351,16 +351,6 @@ int tep_override_comm(struct tep_handle *tep, const char *comm, int pid)
 	return _tep_register_comm(tep, comm, pid, true);
 }
 
-int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock)
-{
-	tep->trace_clock = strdup(trace_clock);
-	if (!tep->trace_clock) {
-		errno = ENOMEM;
-		return -1;
-	}
-	return 0;
-}
-
 struct func_map {
 	unsigned long long		addr;
 	char				*func;
@@ -7022,7 +7012,6 @@ void tep_free(struct tep_handle *tep)
 		free_handler(handle);
 	}
 
-	free(tep->trace_clock);
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5ed5107a4ec4..aef43f53560e 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -435,7 +435,6 @@ int tep_set_function_resolver(struct tep_handle *tep,
 void tep_reset_function_resolver(struct tep_handle *tep);
 int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
-int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *tep, const char *fmt,
-- 
2.21.0

