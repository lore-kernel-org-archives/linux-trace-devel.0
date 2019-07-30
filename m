Return-Path: <SRS0=vd9q=V3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2A7C0650F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 529C920693
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mggJjftR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfG3Mug (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:50:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35043 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729949AbfG3Mug (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:50:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so65660047wrm.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2019 05:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JnzCczmuM/i7m6CDCUq81+uQq9wjEFzkS3eglTsuwgE=;
        b=mggJjftRRlljnoRwLLCYziq4/dIgoP5VqWJQZpoSoNozA+soPFpeaHeiFq3VPfTZ1r
         QzbszT6TvyFKFy57jqyyq5RfFoVU9t99re0sezm0g8E6UqZwvgUyOWhRxvX+siwXss4z
         rUy/5ej+EN+By+5XUMttQfG9GJ6w/uhkLUrUrHsJLagpPE5WAKpzNz9zrwBmKxpJCgcx
         4RkJweTg7kEStoDzO9Z+v56FbDMBHy4PK/NjBByKiBjuDMoryIGWPZLXyB4CgwSANSBF
         htaXwYuojs0qXU7CZ0GJy8A9NPMpLd12uE9CJz02aDhzpAwa+wY2ETRBY6u/oDJU48h0
         VrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnzCczmuM/i7m6CDCUq81+uQq9wjEFzkS3eglTsuwgE=;
        b=MZSwDZU/ibfIYIwcIwPr8STlRxBO50kBGMC/48oGm2oPRK1SahTTf390erSaTRDYWO
         fYz9E+/IOcDq8H16kGbE77tw+q60G6ALjdh+ehEtBnkgztqAHo7m0KVs94i0Ajit41QC
         gE/topfsmpFsj0lWdVYT5hym541E25gj3wp7o5IrykLnZA5KG0z1CIUny/Xg9r/xoFUw
         sYQWIaDsTvxd9VN7A4sZYV8CDY5U7EdDPdM2I+PIZpFILZPuJFIOhi1M3IJl+pIfyjjx
         0xmp0dHqzAvzYrdQhQxP5mRNpDeLzi8T/H+G+8CKF9n9kqrHstV3gdPlaCZ+RnFw/kAH
         qUuA==
X-Gm-Message-State: APjAAAXRYf7fP3thgYl1IyqPw6gZ40jr5HTm2EyxoYGekkl7tEBIGLe4
        FwBFn+lJ5xBW36/1u34PhUU=
X-Google-Smtp-Source: APXvYqynyBYSiCPS+lNZtiqmM984Th94X84WzH0bBOcJ3bIZxmRT3pk9e/6ZMxWiF2jfqPZSSSWRAw==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr11105475wrl.134.1564491033779;
        Tue, 30 Jul 2019 05:50:33 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n12sm67577012wmc.24.2019.07.30.05.50.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:50:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/3] tools/lib/traceevent: Remove tep_register_trace_clock()
Date:   Tue, 30 Jul 2019 15:50:27 +0300
Message-Id: <20190730125028.24789-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730125028.24789-1-tz.stoyanov@gmail.com>
References: <20190730125028.24789-1-tz.stoyanov@gmail.com>
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

