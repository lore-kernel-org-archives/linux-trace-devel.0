Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5914F13BAED;
	Fri, 10 May 2024 21:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376998; cv=none; b=eH+IvGz1m7QOMg/kfVkTCNDPufnuHEZuharV+dAj6++LEyz3+UsWI5STzPosDfCuM5Y+gjj7RREcaPwExOWYHOfBrcX5eAlK4IP1EesqFhUnuIxAJbkd0MZM84ATKs7ggAWHgM8cq2EcVJtL7PlvE091Db/MyFZXCNFnGnu4guA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376998; c=relaxed/simple;
	bh=bIDC620Rh4GiEuoBhdxXE1FuVdUikIyFnHOIwSkwkUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KTGPvz5dVFd/lHRyIrq40+Tu0DlzEaOvOfOQtp7PBypunbggcp5LlPzJ35WMKX3vNAFAcx0KitfWEi3V/h3e2rNH6/GQ3Vp3AVjkFDD4gj65/ekSXGK+tsNCSdaGQJcKMOu2x7uzKEwZ2c/0cTE5AJob+k//yCAI58Hom1exd+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzS3p0Ur; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzS3p0Ur"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7efcdc89872so690221241.3;
        Fri, 10 May 2024 14:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715376995; x=1715981795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=C6ELvJBwy1iNUX5Qa5LDru494IEkCMdLjBlX0MWn9l0=;
        b=NzS3p0UrYZAucAaJdIH6ZP0y+KDwwd3bvNVSAR12CxtDYSMON29spvh7oTshz50hjp
         Ze6qBFVUxwG/O78e8e1WxQ0YY+bRKTUFsB5wJMQzPLJ2GWcAW/YAzUUp2Da8rN/bsUfP
         VQMZetc5xPvZ/YpFn6oGs6BzLj1DCo/tYQTU2N2BeF9U7HrCXO57L0ggfiaL6xNWjzUY
         Q12YMTI6lgfsJizTmzOMAHqzNhwr6/JVqN8wOLBU1/82qooVXpEY+QmPmg7/oZChZyAk
         RioNKiCSx2pULAX/voECPvssDD1+TKow1ceEwA8+9H0P5rXH2rsHZ1mrvPmS/nxJ4/Ck
         xhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715376995; x=1715981795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6ELvJBwy1iNUX5Qa5LDru494IEkCMdLjBlX0MWn9l0=;
        b=BpGXEkJ5Lg1JG8DccIG/QJHiBlPjbO5X4soe8mXsSPfLDpNMMYWq4pTub/CBjgpfiY
         jFdrreoo9FoyQhSWmotI353k3xIAiQvonnEDgO3tdFA5Yonv9ioky5r6mOQsdUufpJId
         7vwHGYuJTMQQJbpsNc+X1GHI1ClNTKaWj42qeTDzPWs3MGjYqURycuuD6dI9AQPVR0zf
         LoxdLVKQDvX5nTCh+D+7bCm7GDMqS021uelN0ctrog2EWdN/VWzfNofIPFqKDhItyQdV
         I1ZtF5yVF2C1CA3+6/6FwcRrZ1L7ihEMmm/0752iZx8re0PLpt7d/nXesiqxNuasOzUH
         0FNw==
X-Forwarded-Encrypted: i=1; AJvYcCWGArnWHUNAEFLx2Rt7zon4igB4MoIAxg5ZUFwLNlc70NvI80KoaUIB9yrBFGtmSF2Gj+RnOiXCR+GmOvHPJXWXMBp6yakKEU5q6fuwSHE8mK4=
X-Gm-Message-State: AOJu0YzibEmeldDxpJZvBnLe/ZXgijKd0QfO9RWnaju2kkMzc2O3eQ13
	MmnBHa5jHLJnajS1kxrTIphwOYY1AYRDO0fIWK6yGy1rFGd7xrx5
X-Google-Smtp-Source: AGHT+IFuu1EqHb92fQZMRe54EZINu6tAMN6793Nm7CGqQj7u7L0DuFqGx2Q3+SR6jFKr9auSFTBRYQ==
X-Received: by 2002:a05:6102:d89:b0:47e:a214:8d02 with SMTP id ada2fe7eead31-48077cc45d3mr4217822137.0.1715376995127;
        Fri, 10 May 2024 14:36:35 -0700 (PDT)
Received: from localhost.localdomain (bras-base-rdwyon0600w-grc-16-74-12-5-183.dsl.bell.ca. [74.12.5.183])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43df5698e4fsm25308511cf.62.2024.05.10.14.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 14:36:34 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-devel@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>,
	John Kacur <jkacur@redhat.com>
Subject: [PATCH v2] rtla: Fix -t/--trace[=file]
Date: Fri, 10 May 2024 17:36:19 -0400
Message-ID: <20240510213619.53529-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally with a short option we don't provide an equals sign like this
-tfile.txt
-t file.txt

But we do provide an equals sign with the long option like this
--trace=file.txt

A good parser should also work with a space instead of an equals sign
--trace file.txt

Most of these are broken!

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
Saving trace to ile.txt
File name truncated

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
Saving trace to timerlat_trace.txt
Default file name used instead of the requested one.

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
Saving trace to file.txt
This works, but people normally don't use '=' with a short option

/rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
Saving trace to ile.txt
File name truncated

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
timerlat_trace.txt
Default file name used instead of the requested one.

After the fix

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -tfile.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t file.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t=file.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace=file.txt
Saving trace to file.txt

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace file.txt
Saving trace to file.txt

I also tested -t and --trace without providing a file name both as the
last requested option and with a following long and short option

For example

./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t -u
./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace -u
./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 -t
./rtla timerlat hist -P f:95 -u -c0-11 -E3500 -T50 --trace

And all correctly do Saving trace to timerlat_trace.txt as expected

This fix is applied to both timerlat top and hist
and to osnoise top and hist

Version 2

- Remove the '=' from [=file] in the on line help. Do the same thing
for the manpages.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Documentation/tools/rtla/common_options.rst       |  4 ----
 .../tools/rtla/common_osnoise_options.rst         |  5 +++++
 .../tools/rtla/common_timerlat_options.rst        |  4 ++++
 tools/tracing/rtla/src/osnoise_hist.c             | 15 ++++++++++-----
 tools/tracing/rtla/src/osnoise_top.c              | 15 ++++++++++-----
 tools/tracing/rtla/src/timerlat_hist.c            | 15 ++++++++++-----
 tools/tracing/rtla/src/timerlat_top.c             | 15 ++++++++++-----
 7 files changed, 49 insertions(+), 24 deletions(-)

diff --git a/Documentation/tools/rtla/common_options.rst b/Documentation/tools/rtla/common_options.rst
index aeb91ff3bd68..5d28ba61245c 100644
--- a/Documentation/tools/rtla/common_options.rst
+++ b/Documentation/tools/rtla/common_options.rst
@@ -14,10 +14,6 @@
 
         Print debug info.
 
-**-t**, **--trace**\[*=file*]
-
-        Save the stopped trace to [*file|osnoise_trace.txt*].
-
 **-e**, **--event** *sys:event*
 
         Enable an event in the trace (**-t**) session. The argument can be a specific event, e.g., **-e** *sched:sched_switch*, or all events of a system group, e.g., **-e** *sched*. Multiple **-e** are allowed. It is only active when **-t** or **-a** are set.
diff --git a/Documentation/tools/rtla/common_osnoise_options.rst b/Documentation/tools/rtla/common_osnoise_options.rst
index f792ca58c211..b05eee23b539 100644
--- a/Documentation/tools/rtla/common_osnoise_options.rst
+++ b/Documentation/tools/rtla/common_osnoise_options.rst
@@ -25,3 +25,8 @@
 
         Specify the minimum delta between two time reads to be considered noise.
         The default threshold is *5 us*.
+
+**-t**, **--trace**\[*file*]
+
+        Save the pretty stopped trace to [*file|osnoise_trace.txt*].
+
diff --git a/Documentation/tools/rtla/common_timerlat_options.rst b/Documentation/tools/rtla/common_timerlat_options.rst
index d3255ed70195..e4eca500b6a7 100644
--- a/Documentation/tools/rtla/common_timerlat_options.rst
+++ b/Documentation/tools/rtla/common_timerlat_options.rst
@@ -22,6 +22,10 @@
         Save the stack trace at the *IRQ* if a *Thread* latency is higher than the
         argument in us.
 
+**-t**, **--trace**\[*file*]
+
+        Save the pretty stopped trace to [*file|timerlat_trace.txt*].
+
 **--dma-latency** *us*
         Set the /dev/cpu_dma_latency to *us*, aiming to bound exit from idle latencies.
         *cyclictest* sets this value to *0* by default, use **--dma-latency** *0* to have
diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 01870d50942a..ede8bb44919c 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -436,7 +436,7 @@ static void osnoise_hist_usage(char *usage)
 	static const char * const msg[] = {
 		"",
 		"  usage: rtla osnoise hist [-h] [-D] [-d s] [-a us] [-p us] [-r us] [-s us] [-S us] \\",
-		"	  [-T us] [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
+		"	  [-T us] [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
 		"	  [-c cpu-list] [-H cpu-list] [-P priority] [-b N] [-E N] [--no-header] [--no-summary] \\",
 		"	  [--no-index] [--with-zeros] [-C[=cgroup_name]]",
 		"",
@@ -452,7 +452,7 @@ static void osnoise_hist_usage(char *usage)
 		"	  -C/--cgroup[=cgroup_name]: set cgroup, if no cgroup_name is passed, the rtla's cgroup will be inherited",
 		"	  -d/--duration time[s|m|h|d]: duration of the session",
 		"	  -D/--debug: print debug info",
-		"	  -t/--trace[=file]: save the stopped trace to [file|osnoise_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|osnoise_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <filter>: enable a trace event filter to the previous -e event",
 		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
@@ -640,9 +640,14 @@ static struct osnoise_hist_params
 			params->threshold = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg) {
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '0')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "osnoise_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 457360db0767..f7794f97aeaa 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -281,7 +281,7 @@ static void osnoise_top_usage(struct osnoise_top_params *params, char *usage)
 
 	static const char * const msg[] = {
 		" [-h] [-q] [-D] [-d s] [-a us] [-p us] [-r us] [-s us] [-S us] \\",
-		"	  [-T us] [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
+		"	  [-T us] [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
 		"	  [-c cpu-list] [-H cpu-list] [-P priority] [-C[=cgroup_name]]",
 		"",
 		"	  -h/--help: print this menu",
@@ -296,7 +296,7 @@ static void osnoise_top_usage(struct osnoise_top_params *params, char *usage)
 		"	  -C/--cgroup[=cgroup_name]: set cgroup, if no cgroup_name is passed, the rtla's cgroup will be inherited",
 		"	  -d/--duration time[s|m|h|d]: duration of the session",
 		"	  -D/--debug: print debug info",
-		"	  -t/--trace[=file]: save the stopped trace to [file|osnoise_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|osnoise_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <filter>: enable a trace event filter to the previous -e event",
 		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
@@ -480,9 +480,14 @@ struct osnoise_top_params *osnoise_top_parse_args(int argc, char **argv)
 			params->stop_total_us = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg){
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "osnoise_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index 5b869caed10d..f555d8603b42 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -521,7 +521,7 @@ static void timerlat_hist_usage(char *usage)
 	char *msg[] = {
 		"",
 		"  usage: [rtla] timerlat hist [-h] [-q] [-d s] [-D] [-n] [-a us] [-p us] [-i us] [-T us] [-s us] \\",
-		"         [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
+		"         [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
 		"	  [-P priority] [-E N] [-b N] [--no-irq] [--no-thread] [--no-header] [--no-summary] \\",
 		"	  [--no-index] [--with-zeros] [--dma-latency us] [-C[=cgroup_name]] [--no-aa] [--dump-task] [-u]",
 		"",
@@ -537,7 +537,7 @@ static void timerlat_hist_usage(char *usage)
 		"	  -d/--duration time[m|h|d]: duration of the session in seconds",
 		"	     --dump-tasks: prints the task running on all CPUs if stop conditions are met (depends on !--no-aa)",
 		"	  -D/--debug: print debug info",
-		"	  -t/--trace[=file]: save the stopped trace to [file|timerlat_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|timerlat_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <filter>: enable a trace event filter to the previous -e event",
 		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
@@ -744,9 +744,14 @@ static struct timerlat_hist_params
 			params->stop_total_us = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg) {
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "timerlat_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 8a3fa64319c6..5698dae30ec6 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -334,7 +334,7 @@ static void timerlat_top_usage(char *usage)
 	static const char *const msg[] = {
 		"",
 		"  usage: rtla timerlat [top] [-h] [-q] [-a us] [-d s] [-D] [-n] [-p us] [-i us] [-T us] [-s us] \\",
-		"	  [[-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
+		"	  [[-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
 		"	  [-P priority] [--dma-latency us] [--aa-only us] [-C[=cgroup_name]] [-u]",
 		"",
 		"	  -h/--help: print this menu",
@@ -350,7 +350,7 @@ static void timerlat_top_usage(char *usage)
 		"	  -d/--duration time[m|h|d]: duration of the session in seconds",
 		"	  -D/--debug: print debug info",
 		"	     --dump-tasks: prints the task running on all CPUs if stop conditions are met (depends on !--no-aa)",
-		"	  -t/--trace[=file]: save the stopped trace to [file|timerlat_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|timerlat_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <command>: enable a trace event filter to the previous -e event",
 		"	     --trigger <command>: enable a trace event trigger to the previous -e event",
@@ -547,9 +547,14 @@ static struct timerlat_top_params
 			params->stop_total_us = get_llong_from_str(optarg);
 			break;
 		case 't':
-			if (optarg)
-				/* skip = */
-				params->trace_output = &optarg[1];
+			if (optarg) {
+				if (optarg[0] == '=')
+					params->trace_output = &optarg[1];
+				else
+					params->trace_output = &optarg[0];
+			}
+			else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "timerlat_trace.txt";
 
-- 
2.44.0

