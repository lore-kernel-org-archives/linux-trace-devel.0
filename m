Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1090FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D349A61158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhD1HrZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbhD1HrZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:25 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46AABC06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id t4so9892233ejo.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3CXbiQ9ZzrX8z8uXKHyQL3xa4g4CNdcsFHLX92cMwvw=;
        b=uxnkfSjeJNI84BXFyG3Rk66RPV0fYIMG9vQkPRtnTp3GgPJzhuFSeqXP7tqsPhuioX
         QDOJvOJ+EUGWyz5oq5SJnhNIYz2w2M00z0rO0f7+mWr58T43a9h6mFZf2JwiuTy90McC
         hRvP+pJuHUbJ+SFEpsJNcZz4z7a4SdV4n6rGf2wvD/NcA/xOqLWL56W1Ao/rmQKJy1u/
         b1Ssz5dl3xB4Us7pPk7jbeeeH7Fxy8gJPEmE9S/HKRK5T6BTiI8VZd6GebSkZ5BXbFq6
         kdgguXqTTih4m+O5Y7Uk2bx9O1Mb0eK3OyeUfu0/MZJXRhJ7oWIBzsJC8VRGIeNKuECz
         +muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CXbiQ9ZzrX8z8uXKHyQL3xa4g4CNdcsFHLX92cMwvw=;
        b=tq+rmISAivSARQpVFf8qkeBleS6TOlqpyeYzkrg3jgmTclleG1mruUadV6o4vS5/lt
         /HhYZp/qO43WFoDgY3+0tx4Eh49E2Kiw9wFa3XscnX8S2/dj3vqTMEeRGHJ0Oko7PvM/
         furjUOBvJnbZxFWKy3OEIKhc9gwatpR763ryrk4tR2wYUVSjY+R3tMJZSX3YsV1gYACt
         SUhs7042E9o1tfpQm/w4xvYHFoHyM5NUSNlgh8Fs5wuVlheUnPaxw4NDHDxV9E1ajB84
         S65Ql2E9uqU4jph8lD+FPIlbpwXg4NmEzKFOVqUaYBZFSDlPubSEmN1aJdRjYJIQaU25
         iKxA==
X-Gm-Message-State: AOAM531Nl8X+J3ZIQI8sBr1U9ZUHk4SZmyvbq9MFkTlJhZ/PHIZNawtG
        xXtpYqf8ipVWD5T4RMnA2z4=
X-Google-Smtp-Source: ABdhPJzXD79pDsrzebdjCUGwq2AA7hsO5D139TZLmDnzomSgsV/WKYM8U98/i22wz/sI3eQjOhta1w==
X-Received: by 2002:a17:907:9720:: with SMTP id jg32mr28226298ejc.10.1619595998095;
        Wed, 28 Apr 2021 00:46:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/7] trace-cmd stack: Add --verbose
Date:   Wed, 28 Apr 2021 10:46:29 +0300
Message-Id: <20210428074630.757694-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "trace-cmd stack --verbose" argument for setting the desired
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-stack.1.txt | 4 ++++
 tracecmd/trace-stack.c                        | 6 ++++++
 tracecmd/trace-usage.c                        | 1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-stack.1.txt b/Documentation/trace-cmd/trace-cmd-stack.1.txt
index a00c6900..75bd50ba 100644
--- a/Documentation/trace-cmd/trace-cmd-stack.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-stack.1.txt
@@ -24,6 +24,10 @@ stack found since the start was enabled.
 
 Use *--reset* to reset the stack counter to zero.
 
+User *--verbose* 'level' to set the log level. Supported log levels are "none", "critical", "error",
+"warning", "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting
+the log level to specific value enables all logs from that and all previous levels.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/trace-stack.c b/tracecmd/trace-stack.c
index 5e88b36c..6f57387a 100644
--- a/tracecmd/trace-stack.c
+++ b/tracecmd/trace-stack.c
@@ -140,6 +140,7 @@ static void read_trace(void)
 }
 
 enum {
+	OPT_verbose	= 252,
 	OPT_reset	= 253,
 	OPT_stop	= 254,
 	OPT_start	= 255,
@@ -163,6 +164,7 @@ void trace_stack (int argc, char **argv)
 			{"stop", no_argument, NULL, OPT_stop},
 			{"reset", no_argument, NULL, OPT_reset},
 			{"help", no_argument, NULL, '?'},
+			{"verbose", required_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -184,6 +186,10 @@ void trace_stack (int argc, char **argv)
 		case OPT_reset:
 			trace_type = STACK_RESET;
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 4c8b1300..8a7e8c7b 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -364,6 +364,7 @@ static struct usage_help usage_help[] = {
 		"          --start  enable the stack tracer\n"
 		"          --stop   disable the stack tracer\n"
 		"          --reset  reset the maximum stack found\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"check-events",
-- 
2.30.2

