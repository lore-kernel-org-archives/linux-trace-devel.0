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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBDCC4BA13
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50AD2206E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pHmokIL8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgBZQcL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:32:11 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33433 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbgBZQcK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 11:32:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so3854967lji.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Feb 2020 08:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bAPoEhczHGp2R5b1dAXEMIuuV6OQAATrpRCgG0atUHY=;
        b=pHmokIL8VzhTWCm8o59/0ivtXBZwNy72T+rLNp/TIKOf7DOOTu2fH18Z5L73QQxO19
         LIIos9YGKiDYB+IJUxPdPhQvvkBK9/xwuWOQOfAjp9gsiaa56s37NuE3tmacp+Rk2b22
         RUCXDZNULvoW4xXJw1EARqMhtrrXw8lNH498yYewR1lqoHTPtQrVApcgc2wtf99o/Ysy
         NvDCADKi+ucLo3aWrI8dJTtTs5qrVNP4M72XMX7HLBBGvaX73sKfGMh++3I6QC/VLumf
         HRDhlRrH3bm1zbagWJRhJtC4z4ooL44uaOCQB5TN1cyuh6tyacyQlaXkJ7hdllcH7Gte
         ARYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bAPoEhczHGp2R5b1dAXEMIuuV6OQAATrpRCgG0atUHY=;
        b=sBB6Fs2NMKNCXROn3EOBTiWrk4xjWoFGB2E0MH+I0A0N4Hu2VfGwFHaY9H7Z57b8A3
         KoormfaqjM6qPG+78M4wMLtlJgBq5ysjLZLBBvctcaHH+SX6us86JpCvXOzASqLvU7O1
         SvFBILgzccKWtZnqX/monnSwoiZVVZQQettamBtebXfjHgv+/YE8k8s1RS94qkJhDxrD
         Tl9VI8kgGxcsbIp+MnaoVLM5EPkL2NC91WvG3CTpPKlUz7XbRpFx6dm/XEhsszLIscae
         ztyEMrIEpn7uQZfQr/3pmp1IpSsZEfB61bBz+JYt98TF56fa/HRK8RFrXd8Tep0kEv7d
         hXOA==
X-Gm-Message-State: APjAAAXLW9n4d+QTi365g4RwmBLqHWqiktCv02bsyfMeb+BAOBC2c4oT
        I+WrNTnjbjx1opw7ht1H+u8=
X-Google-Smtp-Source: ADFU+vtryBq6y1RUpdAdpkcE9k4zKklMJPMxp/BdvIoHpijj2iwcf9jO/R+i6w80g5FtTuZtfFAyow==
X-Received: by 2002:a05:651c:1a2:: with SMTP id c2mr3670608ljn.79.1582734727435;
        Wed, 26 Feb 2020 08:32:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s2sm1264133lfd.67.2020.02.26.08.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:32:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/5] trace-cmd: Suppress parsing warnings in tracefs_local_events() API
Date:   Wed, 26 Feb 2020 18:31:58 +0200
Message-Id: <20200226163159.20232-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226163159.20232-1-tz.stoyanov@gmail.com>
References: <20200226163159.20232-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs_local_events() API allocates new tep handler and initializes it
with the events from the local system. However, at that moment no traceevent plugins
are loaded. Part of events loading is parsing the event's format file, but
successful parsing of print format string from this file depends of traceevent
plugins. That's why a lot of parsing could be printed.
To suppress the warnings, the TEP_NO_PARSING_WARNINGS flag is set on the newly
allocated tep handler.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/tracefs/tracefs-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 8e825f50..0875e665 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -590,7 +590,7 @@ struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
 	tep = tep_alloc();
 	if (!tep)
 		return NULL;
-
+	tep_set_flag(tep, TEP_NO_PARSING_WARNINGS);
 	if (fill_local_events_system(tracing_dir, tep, sys_names, NULL)) {
 		tep_free(tep);
 		tep = NULL;
-- 
2.24.1

