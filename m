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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C7EC43462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56DF606A5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbhD1HrZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbhD1HrY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:24 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292F1C06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:40 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u21so93208244ejo.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ON467nH9YaGyT/HCn3Gwt4mS83m2bbpS0e5BdPF5TME=;
        b=BR0T8HN0YHTmPDksve8tG0qOmWlBUWVxF52OeYTC/qOjdeHRzkgEExhFZtzt0n7ntk
         2f9DRdNmV5oiPFl2Rxb7RvXnJ0zpd6Juw76FP+7hj9OqLPHyjqQkIW0Ev/xzikkR0DGv
         ye/WSXZhteiHdL84a+OO3q4JcoG5ql1xAdoQ2TReVFSaFch+IPtG0tFdRDOG4/5VHt11
         bcB+MeHN7G6ozW7QJ5iWjdhyGnAHPvoNbMcb7VkD+q0G5SiLlQnHshkctDSy2ZHAieNG
         twCmKkHtnsPxDSnjWNyUfvmo6xp93abHfT+oPJ7E8zdLRNu0U4jSkCShsm8mvUVYfeXc
         BQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ON467nH9YaGyT/HCn3Gwt4mS83m2bbpS0e5BdPF5TME=;
        b=qSDOOOeFzWCj7vAOvuOu4xJNbnLJlMa8QoD6lvZUIlrfP3OfFS+5kIyTFpq6S1MU9z
         suSzwt2wNbJJFFQBzfXk619Jtfk02XSZGjC3LR/kMHrHeibKetM9WNWuglNaBhf50ZUa
         zBSlY1GX0FZA6eu028MMMv3CShuQYvJRPJ5FxvfTDxrYJRYAC7I+yT9FWYO+uvm0usgK
         duEYOvp3o1YUdcvNpksbxRR3GoMy9cSIHJPbNfoWbP8EAApzwu8rGJoeFyIbZOL946Nc
         x+J/HxwbHCbVvt7dF7FRjT2cm5xEuFQP6do3jcmh60Z7/+sNeAZn8uPNRA5+n+/wpTmy
         QULg==
X-Gm-Message-State: AOAM530HSkUQY79RRN/ztpukXHuIbnPkIoVLcvLr2eqGLUQy4KDRv6dS
        /lMCoOl17FxHUh+71rr4tIw=
X-Google-Smtp-Source: ABdhPJzEREJXnf1ZhbPkdvRlDWUSZlZSOEgOpXzOWJDGsxDmgXnY1l+TptOIpK+V+icCeug0LuiuLQ==
X-Received: by 2002:a17:907:33ce:: with SMTP id zk14mr14503997ejb.372.1619595998966;
        Wed, 28 Apr 2021 00:46:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/7] trace-cmd dump: Add --verbose
Date:   Wed, 28 Apr 2021 10:46:30 +0300
Message-Id: <20210428074630.757694-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "trace-cmd dump --verbose" argument for setting the desired
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-dump.1.txt | 8 ++++++++
 tracecmd/trace-dump.c                        | 6 ++++++
 tracecmd/trace-usage.c                       | 1 +
 3 files changed, 15 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
index 0f8626fa..b1a3f90d 100644
--- a/Documentation/trace-cmd/trace-cmd-dump.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-dump.1.txt
@@ -52,6 +52,14 @@ OPTIONS
     Print all meta data from the file.
 *--help*::
     Print usage information.
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd report --verbose warning
 
 EXAMPLES
 --------
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3f56f65a..5c5447bc 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -678,6 +678,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_verbose	= 242,
 	OPT_clock	= 243,
 	OPT_all		= 244,
 	OPT_summary	= 245,
@@ -722,6 +723,7 @@ void trace_dump(int argc, char **argv)
 			{"clock", no_argument, NULL, OPT_clock},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
+			{"verbose", required_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -778,6 +780,10 @@ void trace_dump(int argc, char **argv)
 		case OPT_clock:
 			verbosity |= CLOCK;
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 8a7e8c7b..1fc11ac3 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -393,6 +393,7 @@ static struct usage_help usage_help[] = {
 		"          --flyrecord information of offset and count of recorded events per CPU\n"
 		"          --clock trace clock, saved in the file\n"
 		"          -h, --help show usage information\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		NULL, NULL, NULL
-- 
2.30.2

