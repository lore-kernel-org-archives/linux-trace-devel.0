Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB86107
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 04:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5A7C433F1
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 04:16:52 +0000 (UTC)
Date: Tue, 9 Jan 2024 23:17:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd reset: Fix -d option
Message-ID: <20240109231751.1e49addd@gandalf.local.home>
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

There was a bug where a "trace-cmd record -B foo" would delete the foo
instance when the record was finished even if that instance previously
existed. But that fix was a bit too agreesive. It changed two places:

1) where the bug was, in remove_instance()

2) where the bug was not, in tracecmd_remove_instance() that uses the
instance->flags to know if it should be deleted or not.

The "trace-cmd reset" uses the latter function and if the "-d" option is
set, it is supposed to delete the instance. But because that function was
changed to only delete it if it created it (which reset does not do), it
broke it.

Fixes: 9d6f3baa3 ("trace-cmd record/extract: Do not destroy existing instances")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 16b73776..3114a664 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5419,8 +5419,7 @@ void tracecmd_remove_instances(void)
 			close(instance->tracing_on_fd);
 			instance->tracing_on_fd = 0;
 		}
-		if (tracefs_instance_is_new(instance->tracefs))
-			tracefs_instance_destroy(instance->tracefs);
+		tracefs_instance_destroy(instance->tracefs);
 	}
 }
 
-- 
2.42.0

