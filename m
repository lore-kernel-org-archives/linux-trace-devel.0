Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83871F5858
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Feb 2026 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770325929; cv=none; b=tnHHUG8+QFkfRRaK5ODWHSGO/LWYb78EAhrtFkQFRqTsclDJ9Vo46Ogd0o1GwpvLiMpW/37omyYDQy2H/ZBV49cz1m5MuFXYPbZRP4kqXppn5ay10iR6sRO9zc9QuuCH59HQ6/imIE20EepzV7+ZWAnqlimZ0rHfcJxmVpsLZcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770325929; c=relaxed/simple;
	bh=+5LA4UTMNQ4ELPM1krALDNXdnBzhEcuW0LeD8Z3FomU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=iT8+iQdO0e4GeEbOCRmMgKh7lLe5qTKWRWvlQ0rMZgph+kAqnMCmwJ2DN7eUQ+9HO0gmwOlsrStc6t888c5PP64HV4vIZRsEf6IYAcz17OSBBoOzbWLuJKcWRFEzo21jMQe9HQsIYQC2RQKz2HRGhj0gTwX+TZD3/kvpcvLBLBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE0375A12F
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Feb 2026 21:12:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 9784418
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Feb 2026 21:12:06 +0000 (UTC)
Date: Thu, 5 Feb 2026 16:12:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Mention '-l' if '-f' is used with
 function tracer and without events
Message-ID: <20260205161242.73ac1e0e@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3mcdacc58xc5g63zryaab9rqnbg5mqws
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 9784418
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+GmLfclu5xq2fp6sgVQexbo6OEh8RAwuQ=
X-HE-Tag: 1770325926-298373
X-HE-Meta: U2FsdGVkX1/eACOkq4gxXXR/SEXCDdtQoRXMd4yx3brUVcKkI56Iaq+dQUpLWUz66+RBMw/tDYmrmjYLyGlivR1Zea8sYl92605YkEwyPvWhbu3rqszZDAPBKtzLKoxsmdhYfg+KAksAvx7I0/ZkTJI/ckTBjU51cXuC8hc4EX57Xzg6Njl8bD6hBlIHXcqZnWTFNS0MZsC8MnDVoRe1kn+5Ylp5LtzgFmwoqHZFwJwcaSTjYAI6I+o17F3aOOf/9WZSistU2ttQDD2Gbxnosj34xVzcCuzHuLuaUIKkHvPNFiLA2CTkW/m1/XvpXs0EQM6S+CRZon/JAUZhvIZtjCTQNmEX/BAicfjJMKN0XeM+BQDk2FN9/5EiAI+1Sn0TRmIgJp3t6ZKDxWIkPAgsTg==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

A question was asked on stackoverflow on how to use filtering with function
tracer. The user was using '-f' instead of '-l'. This could be a common
mistake. Print a message referencing the '-l' command if '-f' is used
without an event but with function or function graph tracing.

Link: https://stackoverflow.com/questions/79862514/how-to-function-trace-a-custom-linux-kernel-module-with-trace-cmd

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9fbd60a9..1966ec14 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6439,6 +6439,15 @@ bool trace_tsc2nsec_is_supported(void)
 	return get_tsc_nsec(NULL, NULL) == 0;
 }
 
+static bool is_function(const char *tracer)
+{
+	if (!tracer)
+		return false;
+
+	return strcmp(tracer, "function") == 0 ||
+		strcmp(tracer, "function_graph");
+}
+
 static void parse_record_options(int argc,
 				 char **argv,
 				 enum trace_cmd curr_cmd,
@@ -6550,8 +6559,14 @@ static void parse_record_options(int argc,
 				list_event(optarg);
 			break;
 		case 'f':
-			if (!last_event)
-				die("filter must come after event");
+			if (!last_event) {
+				const char *s = "";
+
+				if (is_function(ctx->instance->plugin))
+					s = "\n  Did you mean to filter functions? Then use: -l <filter>";
+				die("filter must come after event%s", s);
+			}
+
 			if (last_event->filter) {
 				last_event->filter =
 					realloc(last_event->filter,
-- 
2.50.1

