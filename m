Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DE3129A83
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706120459; cv=none; b=OlIT2OjNSeAX4IiQMS5i+ZJETaiB6lxaj6R3ob4rCVg890quXKgjuaugAsrkT8mgDnaozd7J+OXSli72XSJw/qeGEFvHySradaMwNf+Be0CaA7X6fx2lfdXaaFiSCFS8sYvvlPIqTApTgxAmr2xit4ChmXFzXRPKl0GT015mg2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706120459; c=relaxed/simple;
	bh=/acKWj4QQAQX+tQ595iXwOAvEfN5y88zRApSSetWcFY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=eiTfo7h1jKHemcX4+2raMUcpvuGxu/cQ30iwaPLd47aHHrxAGqDv6Ym89NRYEqvStBtmKb1S2ujuOL9IJoacexO5nHj9wDzOqYom0XxGYUDddCsxsNba3qVwKXcP4/J45we1fffpjQdO+8+uE9psOVRhQorlRXZMyywDF+wUFQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA98C433C7
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 18:20:58 +0000 (UTC)
Date: Wed, 24 Jan 2024 13:22:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd report: Allow for multiple files without having
 -i
Message-ID: <20240124132231.638e148a@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If trace-cmd report is called with a single file that is not specified by
the -i option, it will report it. But if it is called with multiple files,
it will only report the first one. Allow all the trace.dat files at the
end of options to be considered files to read.

That is, currently if you have:

  trace-cmd record -e sched sleep 100
  trace-cmd split -r -m 100 -o trace-split.dat
  trace-cmd report trace-split.dat.*

It will only show the report of trace-split.dat.0001 and not the rest. To
get the rest, each one would need to be included with -i. Instead, allow
them all to be reported with the above command.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt | 2 +-
 tracecmd/trace-read.c                          | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index ddbde811427e..62fba1e5b381 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -7,7 +7,7 @@ trace-cmd-report - show in ASCII a trace created by trace-cmd record
 
 SYNOPSIS
 --------
-*trace-cmd report* ['OPTIONS'] ['input-file']
+*trace-cmd report* ['OPTIONS'] ['input-file' ['input-file' ...]]
 
 DESCRIPTION
 -----------
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 1dea54c44b38..beaf97a8c570 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1806,6 +1806,10 @@ void trace_report (int argc, char **argv)
 			usage(argv);
 		input_file = argv[optind + 1];
 		add_first_input(input_file, tsoffset);
+		for (int i = optind + 2; i < argc; i++) {
+			multi_inputs++;
+			add_input(argv[i]);
+		}
 	}
 
 	if (!multi_inputs) {
-- 
2.43.0

