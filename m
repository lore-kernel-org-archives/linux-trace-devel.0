Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A82A2AE7F
	for <linux-trace-devel@vger.kernel.org>; Tue, 26 Aug 2025 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219933; cv=none; b=BVa5DCec0WM2VQFPY2QD7a4O24Sjch+oOEKx7XtacE62BjO90+mcRb+ehDLnskPl3zeZNXWuBAoyIkQUeFLElcMl/79z0DGX/7SBk384aDrp3rf/DAbU1C8aEypb/rt1GCP0Yq/XovhgArkEjL93MF81OSa+gZ5TqEHOLwCxCNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219933; c=relaxed/simple;
	bh=G7WK+k376F0HyA7oxjyj7u63cOZe5Zpc0fTPRlsKeZg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=jdQF7MD8le/8vOBRxvyOzZgPBFDdbQo9VF42ttAiJJVt98A9wML0lCLLAcKuxErJCq2flr1ZtIND5qTncFoov9UnjRBtgRwo90OOz0vt1sT73j3nTvmzc8+2vzD9Z5ax76G1K+8c2N/eHoT5RpwAgTGYpqMKcbgwnlz+2DxcTj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2987C16017D
	for <linux-trace-devel@vger.kernel.org>; Tue, 26 Aug 2025 14:52:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id D931E20026
	for <linux-trace-devel@vger.kernel.org>; Tue, 26 Aug 2025 14:52:07 +0000 (UTC)
Date: Tue, 26 Aug 2025 10:52:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record/set: Use write() instead of fwrite() for
 options
Message-ID: <20250826105223.4b857921@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pqo1z8rnaj335ctipkup1dqarwrap1pc
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: D931E20026
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+oj0gmSVn6h9oV+e+q8AY3A5fOLOPt8V0=
X-HE-Tag: 1756219927-560938
X-HE-Meta: U2FsdGVkX19dHsYgN5opZInJamawGv2Zgfi0TWOX6j3h+BqsLqDO5F7EXN0A1lwuKHWe+TUpT4AghdVhsh6CAHUWY5BGThM7TdyyWeeJ5hsld8v9hv0pGoFcveLJluxrtZAIbhiJBs0XtDge3XZ8J5qVpwO2gbvwtSYrHZqPyNWl3B3HoSkyvCAfBXFextOutObKbVCRRev6Qbfdjm9VQKO3ztFBBmftdmgTjQ4X2yMrISoeA7yxdzTya2ApNvT2/tNe0HRAFaQOProvP/vevls9ZOjPCrSnb4tiBVGIK1Lne0Wrn0T8y2L8oPTKCUDh2j/mj6xwtk5HcWCn7eZXU3tRZ1R0TRwkCYjWa+9OA/xdm3VYty5Bsjryf6yQrsav

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

For some reason, using fwrite() to write to trace_options does not return
the error messages. When using -O userstacktrace_delay on a system that did
not have it supported, the  fwrite() succeeds and the user of trace-cmd
things the option is set. This is confusing when looking at the output and
not seeing the delayed stack traces.

Switch fopen()/fwrite() over to open()/write() where there's no dependency
on glibc getting it correct.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f36ee6cd..4872d0d7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1964,22 +1964,23 @@ static void save_option(struct buffer_instance *instance, const char *option)
 
 static int set_option(struct buffer_instance *instance, const char *option)
 {
-	FILE *fp;
 	char *path;
+	int ret;
+	int fd;
 
 	path = tracefs_instance_get_file(instance->tracefs, "trace_options");
-	fp = fopen(path, "w");
-	if (!fp)
+	fd = open(path, O_WRONLY | O_TRUNC);
+	if (fd < 0)
 		warning("writing to '%s'", path);
 	tracefs_put_tracing_file(path);
 
-	if (!fp)
+	if (fd < 0)
 		return -1;
 
-	fwrite(option, 1, strlen(option), fp);
-	fclose(fp);
+	ret = write(fd, option, strlen(option));
+	close(fd);
 
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static void disable_func_stack_trace_instance(struct buffer_instance *instance)
-- 
2.47.2

