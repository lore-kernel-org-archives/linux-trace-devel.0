Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2116BC19759
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E99492087E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rEZp0MFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfHAHuH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:50:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37901 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfHAHuH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 03:50:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so40872798wmj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Aug 2019 00:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IvFUHN7FpS94LvoV8i+aBboFYIHYlRWAxZBp7zLr2K4=;
        b=rEZp0MFa13ivYI19m0eJO2Y7/bJKE9OLKFCPqiGC2O/ONmlJnb6jIrv57UMFTbK6xy
         rfsn1QeawuxK1GyTtGlaNcNPyrWYv0RIkUUOFsYkfG5DI4spXht266vbpFUPMif2n4hw
         nwg1zTvgqki/EUbWc8quTWCFEZhXCXqQTJDr1Y2FA6QgSayVnc6MWdqoP/JhuFR+37gv
         QUhsXmFPmJOpLJviqb8vYus7PuVr5hC7nHALYw/cYP4RJOGRXyXcXEA/xFt0FcaXN+AC
         jzZSSB++GzrSXXdZjejHbLlvD127XDlJUJ323ndzqETDHWJMVMaTr96hVs+bd79LcG19
         q2iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IvFUHN7FpS94LvoV8i+aBboFYIHYlRWAxZBp7zLr2K4=;
        b=kpqiOdHzzAWZWQpmKBv+Fcem/NVL1pmHq7KxY8AiuxfqpQb+ER5tbzpNDFVnkB+FF3
         6e2qtItlsuOwPEnGzrd9k94PUsQ8bFBuzd/xjn0SuJP6MpycAFw3HCjnZ5W7JCWOnZM6
         bzQxZ1yx9RfWlEr7mB2qR5Gm6B3KMEDhtCRlKyj9pHkS+aIDNBMQnQShc5joOQZHQeyA
         C2V8kKVBZ9DT3OfvHuD6zh63yzZYmrLvmG8qf6WmrwfGi0pZ8x7qSwDr7lWjDhEhkPl4
         rXHMHzC9DbCGzPGLbKfuZu/AEKQzb+4RqiQ948DTR238+HXV3TsTo9WW07akyisCF6IC
         Vy6w==
X-Gm-Message-State: APjAAAVsfORkTan/HRJCkF5Yn7/mvl2d7wFhDxqnOvWCwT4q3VD601fp
        kGMey6jDh4Iyq6EfoXij298/f67rKfk=
X-Google-Smtp-Source: APXvYqyLjwUgLVvYS/a8dJy4cLpi1PzFTA6eVIp900AmgXpJx2W5q9oJjF8wy9zS0DrYLV2gIQOrBg==
X-Received: by 2002:a05:600c:490:: with SMTP id d16mr11848295wme.104.1564645805262;
        Thu, 01 Aug 2019 00:50:05 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u2sm4033483wmc.3.2019.08.01.00.50.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 00:50:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/3] tools/lib/traceevent: Remove tep_register_trace_clock()
Date:   Thu,  1 Aug 2019 10:49:58 +0300
Message-Id: <20190801074959.22023-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801074959.22023-1-tz.stoyanov@gmail.com>
References: <20190801074959.22023-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

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
index 0f2bc23efdca..93a21bdd0eaf 100644
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
@@ -7015,7 +7005,6 @@ void tep_free(struct tep_handle *tep)
 		free_handler(handle);
 	}
 
-	free(tep->trace_clock);
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index cf7f302eb44a..d438ee44289f 100644
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

