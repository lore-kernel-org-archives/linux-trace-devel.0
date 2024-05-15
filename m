Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE233BBDC;
	Wed, 15 May 2024 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715797846; cv=none; b=Df+2Xu1oZ4rYeabJoUMSNv5VmIrueA0LAMashbcmlVxzKZycBRWodsZMI7z0aN8HvWhxHgMsVLU8hY1nebJNoLPIzh2SeUch6MWZku4CZaGt6bBq1Ac2IOSbN22PfEYRGVmWO3tpdFgT8lRhNZ8ZgIJo5TmMKYp2AXgvwY2bh9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715797846; c=relaxed/simple;
	bh=sRbiVevVShvt/y0kurmh1ipVGnlfCNmkXm05Pe7vTTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZyzCfrROtn+QeC7G7L3fjSI0gleNtdeD19n9zg/Ay6u1RSaK2UhmEdT2cJIs4v5uTs2CX7vU+OgDz5RjRYy5VSwE+e7WbKUOD//GoEIHggR3fSvn+RjUDiqbebUnjjrcIt5hUXIijHH2qDT+RniKzLa3hD1jK0xHByRVeqhYBaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZW3Ej/ps; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZW3Ej/ps"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-244bdd730dcso2179886fac.0;
        Wed, 15 May 2024 11:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715797843; x=1716402643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=jO43CSWoDxG3vPjwZ3gBpfgGuOMGKSLPDRektMpEJPw=;
        b=ZW3Ej/pspR6Z1Ak+LGXuJ5Tcx2aAoFJnjZ2mFk58WKqrBXI+RdNwDNiO3YnCKAdgHP
         CyOw9UdB1doxmImTtpAo1EAKwcj1JYj6JZ+JNR57rvWEUGwpX6KWOXtyp+Xqalp0+1u0
         kFVXvUQYIq8arYyyp2tm/ux9kJfREvTC/DKKQY/lLKiTdxhKw4jbd2U5EXvmwihxoWiD
         VEDf4jBnc2GZIt06pUhedffFNjGNSWE2Eg3YbYjUSYsB0iQlzYNrcZ21LnDFTOno7+Jz
         5Ps+DLjj9KWueUdJEmNSec/49/LTg4QQFaBtskhFIcKBVh2OyzD4Oe5jZRAkxbVHPKdq
         y7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715797843; x=1716402643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jO43CSWoDxG3vPjwZ3gBpfgGuOMGKSLPDRektMpEJPw=;
        b=R4tiqil+y9N+gZkYU/l04K4vMCYvtP0Qwi88jbxsGZJ+zZk8xzQBdy5SFBN+tYy6zp
         KqI0FUkkaxgrcE9o+H1NMhnUnUjHVtd5tqogQwIfI1tQnuI9DNjPDNZDcKz/8HCVzKCm
         xStStaC2255+YDG9msHZZXk6RRSMQlve+ZCeFVvqldsPqfbsL8D7a43QLprl77iwJeIx
         eLdyetxgyhfjestmx0AM6GTKaMYLBHXfmEPF5hrGqfnSl7dO+8n+DWtBdxVq3/zFDnAF
         yAHN+D72JwUTbI2eqrfkSN5RcjnAlS+JcgjGSVw3c90cCGkITERhcT6plvQSKG4pcQg3
         15AQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxkOWzk/StP9PMKClnVuyzOJk/wzGoNWBRA9d6GQK2wMrDkMFkGuLISeyBgjBuvGBzNHIkbE14YAi4SLTIzH7m48R3ZbPZ1Ww0f/38Ycd7ANoabQ8sxNWYg/mK/tv7mRuYXnOjW2IA6W9TPnW07Qk=
X-Gm-Message-State: AOJu0YxHAXv2CwsaFjvpWC6XjQHcSGVjksm3a5uzxQXyruXwc42bFvPv
	ZqU6vufxc5xLBEv/sKk9N21+5ikTCMLOHxDYWQ9mCNHpHhAiCUOg
X-Google-Smtp-Source: AGHT+IFMNnMDfeeGX1CoVuitjtHF0fgecLxMVBNAyO/T1jc0fFdu/8Gk7hj4RrPw0OBp6Eoom7NgBQ==
X-Received: by 2002:a05:6870:d203:b0:23a:5273:bf9 with SMTP id 586e51a60fabf-24172a779a7mr19240252fac.21.1715797843068;
        Wed, 15 May 2024 11:30:43 -0700 (PDT)
Received: from fionn.redhat.com ([74.12.5.183])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e25f3ec65sm28965351cf.81.2024.05.15.11.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 11:30:42 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From: John Kacur <jkacur@redhat.com>
To: Daniel Bristot de Oliveria <bristot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-trace-devel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH v3 1/2] rtla: Fix -t\--trace[=file]
Date: Wed, 15 May 2024 14:30:23 -0400
Message-ID: <20240515183024.59985-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The -t option has an optional argument.
The usual case is for a short option to be specified without an '='
and for the long version to be specified with an '='

Various forms of this do not work as expected.
For example:
rtla timerlat hist -T50 -tfile.txt
will result in a truncated file name of "ile.txt"

Another example is that the long form without the '=' will result in the
default file name instead of the requested file name.

This patch properly parses the optional argument with and without '='
and with and without spaces for the short form.

This patch was also tested using -t and --trace without providing a file
name both as the last requested option and with a following long and
short option.

For example:

rtla timerlat hist -T50 -t -u
rtla timerlat hist -T50 --trace -u

This fix is applied to both timerlat top and hist
and to osnoise top and hist

Here is the full testing for rtla timerlat hist

Before applying the patch

rtla timerlat hist -T50 -t=file.txt
Works as expected, "file.txt"

rtla timerlat hist -T50 -tfile.txt
Truncated file name "ile.txt"

rtla timerlat hist -T50 -t file.txt
Default file name instead of file.txt

rtla timerlat hist -T50 --trace=file.txt
Truncated file name "ile.txt"

rtla timerlat hist -T50 --trace file.txt
Default file name "timerlat_trace.txt" instead of "file.txt"

After applying the patch

rtla timerlat hist -T50 -t=file.txt
Works as expected, "file.txt"

rtla timerlat hist -T50 -tfile.txt
Works as expected, "file.txt"

rtla timerlat hist -T50 -t file.txt
Works as expected, "file.txt"

rtla timerlat hist -T50 --trace=file.txt
Works as expected, "file.txt"

rtla timerlat hist -T50 --trace file.txt
Works as expected, "file.txt"

In addition the following tests were performed to make sure that
the default file name worked as expected including with trailing options

rtla timerlat hist -T50 -t
Works as expected "timerlat_trace.txt"

rtla timerlat hist -T50 --trace
Works as expected "timerlat_trace.txt"

rtla timerlat hist -T50 -t -u
Works as expected "timerlat_trace.txt"

rtla timerlat hist -T50 --trace -u
Works as expected "timerlat_trace.txt"

Version 3
- Fix checkpatch problems
- Fix language in the commit message to be more neutral
- Separate the documentation changes out into a second patch

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/tracing/rtla/src/osnoise_hist.c  | 14 +++++++++-----
 tools/tracing/rtla/src/osnoise_top.c   | 14 +++++++++-----
 tools/tracing/rtla/src/timerlat_hist.c | 14 +++++++++-----
 tools/tracing/rtla/src/timerlat_top.c  | 14 +++++++++-----
 4 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 198a17a3ea2e..7be17d09f7e8 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -437,7 +437,7 @@ static void osnoise_hist_usage(char *usage)
 	static const char * const msg[] = {
 		"",
 		"  usage: rtla osnoise hist [-h] [-D] [-d s] [-a us] [-p us] [-r us] [-s us] [-S us] \\",
-		"	  [-T us] [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
+		"	  [-T us] [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
 		"	  [-c cpu-list] [-H cpu-list] [-P priority] [-b N] [-E N] [--no-header] [--no-summary] \\",
 		"	  [--no-index] [--with-zeros] [-C[=cgroup_name]] [--warm-up]",
 		"",
@@ -453,7 +453,7 @@ static void osnoise_hist_usage(char *usage)
 		"	  -C/--cgroup[=cgroup_name]: set cgroup, if no cgroup_name is passed, the rtla's cgroup will be inherited",
 		"	  -d/--duration time[s|m|h|d]: duration of the session",
 		"	  -D/--debug: print debug info",
-		"	  -t/--trace[=file]: save the stopped trace to [file|osnoise_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|osnoise_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <filter>: enable a trace event filter to the previous -e event",
 		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
@@ -645,9 +645,13 @@ static struct osnoise_hist_params
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
+			} else if (optind < argc && argv[optind][0] != '0')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "osnoise_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/osnoise_top.c b/tools/tracing/rtla/src/osnoise_top.c
index 7e5aab22727d..07ba55d4ec06 100644
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -283,7 +283,7 @@ static void osnoise_top_usage(struct osnoise_top_params *params, char *usage)
 
 	static const char * const msg[] = {
 		" [-h] [-q] [-D] [-d s] [-a us] [-p us] [-r us] [-s us] [-S us] \\",
-		"	  [-T us] [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
+		"	  [-T us] [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] \\",
 		"	  [-c cpu-list] [-H cpu-list] [-P priority] [-C[=cgroup_name]] [--warm-up s]",
 		"",
 		"	  -h/--help: print this menu",
@@ -298,7 +298,7 @@ static void osnoise_top_usage(struct osnoise_top_params *params, char *usage)
 		"	  -C/--cgroup[=cgroup_name]: set cgroup, if no cgroup_name is passed, the rtla's cgroup will be inherited",
 		"	  -d/--duration time[s|m|h|d]: duration of the session",
 		"	  -D/--debug: print debug info",
-		"	  -t/--trace[=file]: save the stopped trace to [file|osnoise_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|osnoise_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <filter>: enable a trace event filter to the previous -e event",
 		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
@@ -486,9 +486,13 @@ struct osnoise_top_params *osnoise_top_parse_args(int argc, char **argv)
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
+			} else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "osnoise_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index fbe2c6549bf9..a3907c390d67 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -652,7 +652,7 @@ static void timerlat_hist_usage(char *usage)
 	char *msg[] = {
 		"",
 		"  usage: [rtla] timerlat hist [-h] [-q] [-d s] [-D] [-n] [-a us] [-p us] [-i us] [-T us] [-s us] \\",
-		"         [-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
+		"         [-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
 		"	  [-P priority] [-E N] [-b N] [--no-irq] [--no-thread] [--no-header] [--no-summary] \\",
 		"	  [--no-index] [--with-zeros] [--dma-latency us] [-C[=cgroup_name]] [--no-aa] [--dump-task] [-u|-k]",
 		"	  [--warm-up s]",
@@ -669,7 +669,7 @@ static void timerlat_hist_usage(char *usage)
 		"	  -d/--duration time[m|h|d]: duration of the session in seconds",
 		"	     --dump-tasks: prints the task running on all CPUs if stop conditions are met (depends on !--no-aa)",
 		"	  -D/--debug: print debug info",
-		"	  -t/--trace[=file]: save the stopped trace to [file|timerlat_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|timerlat_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <filter>: enable a trace event filter to the previous -e event",
 		"	     --trigger <trigger>: enable a trace event trigger to the previous -e event",
@@ -885,9 +885,13 @@ static struct timerlat_hist_params
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
+			} else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "timerlat_trace.txt";
 			break;
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 3a23e8d481c6..8c16419fe22a 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -446,7 +446,7 @@ static void timerlat_top_usage(char *usage)
 	static const char *const msg[] = {
 		"",
 		"  usage: rtla timerlat [top] [-h] [-q] [-a us] [-d s] [-D] [-n] [-p us] [-i us] [-T us] [-s us] \\",
-		"	  [[-t[=file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
+		"	  [[-t[file]] [-e sys[:event]] [--filter <filter>] [--trigger <trigger>] [-c cpu-list] [-H cpu-list]\\",
 		"	  [-P priority] [--dma-latency us] [--aa-only us] [-C[=cgroup_name]] [-u|-k] [--warm-up s]",
 		"",
 		"	  -h/--help: print this menu",
@@ -462,7 +462,7 @@ static void timerlat_top_usage(char *usage)
 		"	  -d/--duration time[m|h|d]: duration of the session in seconds",
 		"	  -D/--debug: print debug info",
 		"	     --dump-tasks: prints the task running on all CPUs if stop conditions are met (depends on !--no-aa)",
-		"	  -t/--trace[=file]: save the stopped trace to [file|timerlat_trace.txt]",
+		"	  -t/--trace[file]: save the stopped trace to [file|timerlat_trace.txt]",
 		"	  -e/--event <sys:event>: enable the <sys:event> in the trace instance, multiple -e are allowed",
 		"	     --filter <command>: enable a trace event filter to the previous -e event",
 		"	     --trigger <command>: enable a trace event trigger to the previous -e event",
@@ -668,9 +668,13 @@ static struct timerlat_top_params
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
+			} else if (optind < argc && argv[optind][0] != '-')
+				params->trace_output = argv[optind];
 			else
 				params->trace_output = "timerlat_trace.txt";
 
-- 
2.44.0

