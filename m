Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57F37E4
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 02:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E31EC433C8
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 02:29:07 +0000 (UTC)
Date: Wed, 11 Oct 2023 22:30:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Free "followers" when freeing instance
Message-ID: <20231011223031.0aa32a57@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

|From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

While running valgrind on an application that uses libtracefs, it revealed
that "followers" from tracefs_follow_event() is not freed if called for an
instance when the instance is freed.

Free it!

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index b3ed983db0e8..be1478ee7a92 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -123,6 +123,7 @@ __hidden void trace_put_instance(struct tracefs_instance *instance)
 		close(instance->ftrace_marker_raw_fd);
 
 	free(instance->trace_dir);
+	free(instance->followers);
 	free(instance->name);
 	pthread_mutex_destroy(&instance->lock);
 	free(instance);
-- 
2.42.0

