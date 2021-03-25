Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49962C433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E2F61A25
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCYGld (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhCYGlB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:01 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF152C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:00 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p19so528161wmq.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U+Rurdt3TLvNbFd+pb3BnO5RroijQkjhTL6sPJpY6XE=;
        b=uGPKYN30B6hOJNEIB5o2CJEq7Gb45vq66numMHs11jvHt8d+zOv2ru2Pi4dBk9kQiY
         oTjp3FH0ZeCjqtgVTspeOQHDI8cP2a2C2+/mTkIXueSWwcEEjsjj7Ci2AeKyPFhaow5Z
         Zrq9tnS7QTEN/ct5mGHPVv/VfJK4NZpororytW/V6xeAeQh164ho9GDJRdGTt00iu+SX
         WkLDr8WmEgO0nZl2Yj7H7J62oiCSUVZuaBjIothtRXmCT/lN4grUPJ0rU3rlRH7gps/M
         CviogicIuuAkFc8ZDK6tK/y7jDx5SI3B9v7va3+fkJkA8uaGpGQiFH/d8hbCcJpj2i/M
         6YCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+Rurdt3TLvNbFd+pb3BnO5RroijQkjhTL6sPJpY6XE=;
        b=QUtPd1VPze/lt8k5xROqzkr3QBArWrdW7GUdTG5LxAefmR4lnLe6CBNxF14XdHnp/g
         16iFRl3z1m2lJkI4nFucbhq1kbD9NuZs06yGYd/0Y4hnmea97Pjw1PI3/Lp9nR9kQjRN
         9/XM4JGjvo5bqRHvzON+gz+My07ioxbza8gdUoQeVXRYljcP0X1+kDFSUSSPhRVHQxj0
         nCl3fiJZ1xjgd0+KDyda+Fsn46X3pwbdYBMyrVq8KVC682ns8EEqazdziwt1NYVUIavW
         93SY7KYPukEcf4T9L/1qFlGxQbxHjTsz+pheFZaEWFWa3hXffi1ITcBTkUrHQF82m1XL
         rpyg==
X-Gm-Message-State: AOAM533lcP4iizzp2r+WvUiwLjZ57uozBx/T0LY8VT1c8zMzKZkB4IZo
        Z0YAqVfwiRUSL+1+mohQTMos1fJfneg+UA==
X-Google-Smtp-Source: ABdhPJz1SU2BWM9atDOzDr4cO6MxmeNWl0JON+DVORW3YB+f/rdk7SKsunI+n1uEHq4I/HuKF3atwQ==
X-Received: by 2002:a05:600c:4292:: with SMTP id v18mr6147206wmc.23.1616654459606;
        Wed, 24 Mar 2021 23:40:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:40:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 02/23] trace-cmd: Extend trace-cmd dump subcommand to display the clock
Date:   Thu, 25 Mar 2021 08:40:34 +0200
Message-Id: <20210325064055.539554-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace clock, used to record the tracing data is saved in the trace.dat
file. As "trace-cmd dump" command shows the metadata content of the
file, it should display the trace clock also.
Added a new parameter
  "trace-cmd dump --clock"
which shows the clock saved in the file. The clock can be displayed
also with
 "trace-cmd dump --all"

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-dump.1.txt |  2 ++
 tracecmd/trace-dump.c                        | 34 +++++++++++++++++++-
 tracecmd/trace-usage.c                       |  1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-dump.1.txt b/Documentation/trace-cmd/trace-cmd-dump.1.txt
index 71b8e655..0f8626fa 100644
--- a/Documentation/trace-cmd/trace-cmd-dump.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-dump.1.txt
@@ -46,6 +46,8 @@ OPTIONS
     Print all options, stored in the file.
 *--flyrecord*::
     Print the offset and the size of tracing data per each CPU.
+*--clock*::
+    Print the trace clock, used for timestamp of the tracing events, stored in the file.
 *--all*::
     Print all meta data from the file.
 *--help*::
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 6172231e..5db1ecfa 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -24,6 +24,7 @@
 
 static struct tep_handle *tep;
 static unsigned int trace_cpus;
+static int has_clock;
 
 enum dump_items {
 	SUMMARY		= (1 << 0),
@@ -37,6 +38,7 @@ enum dump_items {
 	CMDLINES	= (1 << 8),
 	OPTIONS		= (1 << 9),
 	FLYRECORD	= (1 << 10),
+	CLOCK		= (1 << 11),
 };
 
 enum dump_items verbosity;
@@ -496,7 +498,7 @@ static void dump_options(int fd)
 			die("cannot read the option size");
 
 		count++;
-		if (!DUMP_CHECK(OPTIONS)) {
+		if (!DUMP_CHECK(OPTIONS) && !DUMP_CHECK(CLOCK) && !DUMP_CHECK(SUMMARY)) {
 			lseek64(fd, size, SEEK_CUR);
 			continue;
 		}
@@ -512,6 +514,7 @@ static void dump_options(int fd)
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			dump_option_string(fd, size, "TRACECLOCK");
+			has_clock = 1;
 			break;
 		case TRACECMD_OPTION_UNAME:
 			dump_option_string(fd, size, "UNAME");
@@ -556,6 +559,29 @@ static void dump_latency(int fd)
 	do_print(SUMMARY, "\t[Latency tracing data]\n");
 }
 
+static void dump_clock(int fd)
+{
+	long long size;
+	char *clock;
+
+	do_print((SUMMARY | CLOCK), "\t[Tracing clock]\n");
+	if (!has_clock) {
+		do_print((SUMMARY | CLOCK), "\t\t No tracing clock saved in the file\n");
+		return;
+	}
+	if (read_file_number(fd, &size, 8))
+		die("cannot read clock size");
+	clock = calloc(1, size);
+	if (!clock)
+		die("cannot allocate clock %d bytes", size);
+
+	if (read_file_bytes(fd, clock, size))
+		die("cannot read clock %d bytes", size);
+	clock[size] = 0;
+	do_print((SUMMARY | CLOCK), "\t\t%s\n", clock);
+	free(clock);
+}
+
 static void dump_flyrecord(int fd)
 {
 	long long cpu_offset;
@@ -572,6 +598,7 @@ static void dump_flyrecord(int fd)
 		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
+	dump_clock(fd);
 }
 
 static void dump_therest(int fd)
@@ -626,6 +653,7 @@ static void dump_file(const char *file)
 }
 
 enum {
+	OPT_clock	= 243,
 	OPT_all		= 244,
 	OPT_summary	= 245,
 	OPT_flyrecord	= 246,
@@ -666,6 +694,7 @@ void trace_dump(int argc, char **argv)
 			{"cmd-lines", no_argument, NULL, OPT_cmd_lines},
 			{"options", no_argument, NULL, OPT_options},
 			{"flyrecord", no_argument, NULL, OPT_flyrecord},
+			{"clock", no_argument, NULL, OPT_clock},
 			{"validate", no_argument, NULL, 'v'},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
@@ -721,6 +750,9 @@ void trace_dump(int argc, char **argv)
 		case OPT_head_page:
 			verbosity |= HEAD_PAGE;
 			break;
+		case OPT_clock:
+			verbosity |= CLOCK;
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 1a7abd58..22537d20 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -377,6 +377,7 @@ static struct usage_help usage_help[] = {
 		"          --cmd-lines print information mapping a PID to a process name\n"
 		"          --options print options\n"
 		"          --flyrecord information of offset and count of recorded events per CPU\n"
+		"          --clock trace clock, saved in the file\n"
 		"          -h, --help show usage information\n"
 	},
 	{
-- 
2.30.2

