Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD411D363D
	for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2024 10:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729850736; cv=none; b=eqNQEA7tk1w7OBgfVrH0ryfunvVV+agaqCsNpneTPZZWj44ZgMX75v6/ENON0D7G0BipO994fJkj/lcj5dKwn1LxX3LXo8LFr4Tk0DdsytpIPmztpAheuHpnxJhRLzA90/a5cRnub1OuY4SMjJjS0235FJH/CBF0j3SOcs/RDd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729850736; c=relaxed/simple;
	bh=X3i1l40jTI2DdXP5kKJTRaJ+N3wHx2JYOMauxnKLaOE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=sfgamBHJwVoHBjHFvnJnMh++zEca97uAbS2nXGL+uxuxzvYhnY6HHbd+XHhhBpXaB/KzHpC68h8zbudnOay+gDeJJfmTaexA1l+YihWWi7mOYQqorwmjB368wT90JDJcXzPwoaNWwcWOcwT2TgWaMIAa0o6/4XzrBy/Bj1zb4L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181ECC4CEC3
	for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2024 10:05:35 +0000 (UTC)
Date: Fri, 25 Oct 2024 06:05:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceeval task-eval: Fix passing wrong teval to helper
 function
Message-ID: <20241025060532.4f2d6418@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The addition of helper functions was supposed to make the code simpler,
but instead it ended up passing the wrong teval into one of the helper
functions due to a cut-and-paste error.

Pass the teval_cpus descriptor to the cpu helper function and not the
teval_threads descriptor.

Fixes: f38b05e1 ("libtraceeval task-eval: Simplify logic by adding more helper functions")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 178936d..5b6da1a 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -677,7 +677,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	/* Update the individual thread as well */
 
 	insert_thread_data(pdata->teval_threads, pid, RUNNING, prio, delta, record->ts);
-	insert_cpu_data(pdata->teval_threads, record->cpu, RUNNING, delta, record->ts);
+	insert_cpu_data(pdata->teval_cpus, record->cpu, RUNNING, delta, record->ts);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
-- 
2.45.2

