Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73451E4BE
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jan 2024 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705699582; cv=none; b=YoklCXR+sr1fIvvB/JDLcvxBq2ddOPsgyvJYjKZ5xoJh6YeduWOVFYqPZXv/HEoqlM15SjyWNlC5kK2zyvv200x93BFWQeadn8pPjdLDqzJ66yhquaX5gE3ZtMvb5KrXgoBWxo4AJcgZ5DdSs7UadHHycxuelaZ/FnJ/5VmrHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705699582; c=relaxed/simple;
	bh=RlfqGx7CFaC8qyt5O7i3kp5LFG6X8PvpM2tR9NGWDaY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=p/0tSh1rIU9Ueecq/Btu571Exw7XPsGlXRvZzyGK1/rVTpkep/uJNNb3BybxQGAFdWmtJJnQ4zcR9k+fT74rrrlY6VDn1/jZuaTuIyfwbOcmSPaJC+XO2kKATpsoyOKu1WEXMigpCJwN08HKZcfU665XPVkJYihsUdFp81KdFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17592C433F1
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jan 2024 21:26:21 +0000 (UTC)
Date: Fri, 19 Jan 2024 16:27:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Fix top_instance.output_file being NULL
Message-ID: <20240119162743.1a107fa9@gandalf.local.home>
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

If the -o comes after a -B, the output_file name will be associated to the
trace instance of that -B, and the top_instance.output_file will be NULL.
If recording is started in a location that is read-only, the temp file
created for the top instance is going to try to be created in that read-only
file system.

 /sys/kernel/tracing# trace-cmd record -o /tmp/test.dat -B test -e sched
 Hit Ctrl^C to stop recording
 ^Ctrace-cmd: Permission denied
   could not create file (null).cpu0

Make sure all instances, including the top_instance has their output_file
correct.

Also, because the output file could have been created under another
instance, check if that instance already has the output file before
assigning over it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 762afba4..91cc90d4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7122,6 +7122,10 @@ static void record_trace(int argc, char **argv,
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
 
+	/* Make sure top_instance.output_file exists */
+	if (!top_instance.output_file)
+		top_instance.output_file = strdup(ctx->output);
+
 	if (ctx->data_flags & (DATA_FL_GUEST | DATA_FL_PROXY))
 		set_tsync_params(ctx);
 
@@ -7131,7 +7135,9 @@ static void record_trace(int argc, char **argv,
 	for_all_instances(instance) {
 		if (ctx->temp)
 			instance->temp_dir = ctx->temp;
-		instance->output_file = strdup(ctx->output);
+		/* The -o could have been done after -B */
+		if (!instance->output_file)
+			instance->output_file = strdup(ctx->output);
 		if (!instance->output_file)
 			die("Failed to allocate output file name for instance");
 		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
-- 
2.43.0

