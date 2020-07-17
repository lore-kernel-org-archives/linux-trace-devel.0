Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7CAC433EA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 07:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5C220704
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 07:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxqKEd0G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgGQH5r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgGQH5r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 03:57:47 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C35C061755
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 00:57:47 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so9760577ejd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 00:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WHOC6iB9lbTsvTrZXunRhVTgmvEOCKM8OrSAmTfYcW4=;
        b=fxqKEd0GQEk2VJXo3P0Kwq019LOiAuF0d7YBKNpOYcnAi5MBy+DY4GbeTOBQOzvD46
         7NWmDUS6pcM4INDFYlKwvfHvb5jbPcLT8pmTDYngnIfgPQ5feAKRaCJuY9t2Ymb0n19r
         KdJzHI3jcwxc5w/pB3BAltVPM72rHz67m3MTWYJY9ka6Nl8ZgQOaY5G0SZVOAL1BUErq
         jsIkSRzZmBroRPFDXZUVeFoovTgl0OkV4WUvdSHGTWVKp4HVvJZQtSUI06U4b73nTkmP
         HLR8iuQS6XbXHb8uYOzSGZq6ARIyHYl0/MxVSCUgfH6u4UNF8qMCJBjtU0CwKhVuxEdl
         noNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WHOC6iB9lbTsvTrZXunRhVTgmvEOCKM8OrSAmTfYcW4=;
        b=D8tdObbCuaYUtEP8/JDDJww455IO7pkUZ+OjCu2BLQ0MI3SP6jcRt0N+sH1Nz6Dtzk
         8J3utby9wROZH+mRMwMqHunGnl79VtoEE3Gf8tCLl0EhUN7uuj/PPLIt0lxI3KQ+DJwe
         Zy/1jSJKeucRQUqhyrFAB/xd10UqIB/3DvTOQUkoJSwZ5mihDyd/X3F6VnP04NgcdgNK
         6C7sYiosYQSa97cJYush2K5BDpd5LqYWiwZeiM038GglpPTPMH/sY9JpoMlGC35ieV3P
         P/dgE4zzo9oiEFC/5fMRZeW6ygVeuYRtPmxf9Gf7uRQADuljqoaG1xpz616NmJ7ErxQq
         7fIw==
X-Gm-Message-State: AOAM530Lb/dhtFQjCw28PhIqxfgZvxYyGUCdPYRz/td4AKX6vgyAqL5S
        yrPCLQguv72LSlq6O5hCGvjmLrFjRJ4=
X-Google-Smtp-Source: ABdhPJyXZ4w4h5bc4WWk5HA3JClMUsYtyONCnRB/LdlcXlZAYobxrDVojO/mMEsewzl51FNNMiDBLg==
X-Received: by 2002:a17:907:20d1:: with SMTP id qq17mr7690720ejb.214.1594972665732;
        Fri, 17 Jul 2020 00:57:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c15sm7901997edm.47.2020.07.17.00.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 00:57:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Document "trace-cmd report --cpu ..." option
Date:   Fri, 17 Jul 2020 10:57:41 +0300
Message-Id: <20200717075741.74775-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717075741.74775-1-tz.stoyanov@gmail.com>
References: <20200717075741.74775-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added description of "trace-cmd report --cpu ..." option in
"trace-cmd report --help" output and in "trace-cmd report" man page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-report.1.txt | 9 +++++++++
 tracecmd/trace-usage.c               | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/trace-cmd-report.1.txt b/Documentation/trace-cmd-report.1.txt
index 66e96da7..864eb2d7 100644
--- a/Documentation/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd-report.1.txt
@@ -242,6 +242,15 @@ OPTIONS
 
      Example:  -O fgraph:tailprint
 
+*--cpu* <cpu list>::
+    List of CPUs, separated by "," or ":", used for filtering the events.
+    A range of CPUs can be specified using "cpuX-cpuY" notation, where all CPUs
+    in the range between cpuX and cpuY will be included in the list. The order
+    of CPUs in the list must be from lower to greater.
+
+    Example:  "--cpu 0,3" - show events from CPUs 0 and 3
+              "--cpu 2-4" - show events from CPUs 2, 3 and 4
+
 *--stat*::
     If the trace.dat file recorded the final stats (outputed at the end of record)
     the *--stat* option can be used to retrieve them.
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 85c63512..3f0b2d07 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -209,6 +209,8 @@ static struct usage_help usage_help[] = {
 		"          -w show wakeup latencies\n"
 		"          -l show latency format (default with latency tracers)\n"
 		"          -O plugin option -O [plugin:]var[=val]\n"
+		"          --cpu <cpu1,cpu2,...> - filter events according to the given cpu list.\n"
+		"                                  A range of CPUs can be specified using 'cpuX-cpuY' notation.\n"
 		"          --check-events return whether all event formats can be parsed\n"
 		"          --stat - show the buffer stats that were reported at the end of the record.\n"
 		"          --uname - show uname of the record, if it was saved\n"
-- 
2.26.2

