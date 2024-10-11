Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBBC1C689D
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671264; cv=none; b=d8YOBXYgbyf9Lb5N6RfjtYePzTHxaBRRYkKL8wRxQOr6GzbIRSIDaY4FMQ3O7r5rOUx5wX9VkGc941AMrvcFfQ85A2HUitJ21uxJm1h00jPlxITuiNPWeHONBp13O6TWWrZkIXS2aAFz2SOfRgK6zLUKg3nXNPiPXOqne4RvQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671264; c=relaxed/simple;
	bh=GinRNeJAB4dhB2YP61/7STN3CuM1gHgGnhlhc7klMCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2t5N6luKqGYHzezzKDy7i3GnIFFZN5sRDGlp/lVh+3TUJwf00ekzfJRLnZCxrBAopVWYJ9hXc7gf+5qO7AvbffaP0mgUogH+DSQlE/oAI25PmLKva7/Yfv7QVlGgxdSq4K8KS45D93vVXczsZ/D4nMboxPgTmEXKhgNOxNNHL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7CEC4CECE;
	Fri, 11 Oct 2024 18:27:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1szKMk-00000001V1F-2Mix;
	Fri, 11 Oct 2024 14:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] trace-cmd show: Add --max_latency
Date: Fri, 11 Oct 2024 14:26:52 -0400
Message-ID: <20241011182752.357499-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241011182752.357499-1-rostedt@goodmis.org>
References: <20241011182752.357499-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the --max_latency option to trace-cmd show to display the contents of
tracing_max_latency.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-show.c  | 6 ++++++
 tracecmd/trace-usage.c | 1 +
 2 files changed, 7 insertions(+)

diff --git a/tracecmd/trace-show.c b/tracecmd/trace-show.c
index cf70d86ca61c..c92c87990a23 100644
--- a/tracecmd/trace-show.c
+++ b/tracecmd/trace-show.c
@@ -25,6 +25,7 @@ enum {
 	OPT_tracing_on,
 	OPT_hist,
 	OPT_trigger,
+	OPT_max_latency,
 };
 
 void trace_show(int argc, char **argv)
@@ -58,6 +59,7 @@ void trace_show(int argc, char **argv)
 		{"graph_function", no_argument, NULL, OPT_graph_function},
 		{"graph_notrace", no_argument, NULL, OPT_graph_notrace},
 		{"cpumask", no_argument, NULL, OPT_cpumask},
+		{"max_latency", no_argument, NULL, OPT_max_latency},
 		{"help", no_argument, NULL, '?'},
 		{NULL, 0, NULL, 0}
 	};
@@ -151,6 +153,10 @@ void trace_show(int argc, char **argv)
 			show_instance_file(instance, "tracing_cpumask");
 			stop = 1;
 			break;
+		case OPT_max_latency:
+			show_instance_file(instance, "tracing_max_latency");
+			stop = 1;
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 8bbf2e3e79d6..7139016e5274 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -189,6 +189,7 @@ static struct usage_help usage_help[] = {
 		"          --graph_function (for set_graph_function)\n"
 		"          --graph_notrace (for set_graph_notrace)\n"
 		"          --cpumask (for tracing_cpumask)\n"
+		"          --max_latency (for tracing_max_latency)\n"
 	},
 	{
 		"reset",
-- 
2.45.2

