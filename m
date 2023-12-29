Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28C17D1
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A120C433C8
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:20:10 +0000 (UTC)
Date: Thu, 28 Dec 2023 22:20:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd stat: Add sub-buffer size
Message-ID: <20231228222008.2742615a@rorschach.local.home>
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

[
  Note, this depends on libtracefs 1.8 and can not be added until
  that's released.
]

Show the sub-buffer size if the file system supports it and it is different
than the architecture page size.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 9a6e22254b48..1d95d9934b47 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -633,6 +633,8 @@ static void report_buffers(struct buffer_instance *instance)
 	char *str;
 	char *cont;
 	char file[FILE_SIZE];
+	int pagesize;
+	int bufsize;
 	int cpu;
 
 	str = tracefs_instance_file_read(instance->tracefs, "buffer_size_kb", NULL);
@@ -678,6 +680,11 @@ static void report_buffers(struct buffer_instance *instance)
 	printf("\nBuffer total size in kilobytes:\n");
 	printf("   %s\n", str);
 
+	pagesize = getpagesize();
+	bufsize = tracefs_instance_get_subbuf_size(instance->tracefs);
+	if (bufsize > 0 && bufsize * 1024 != pagesize)
+		printf("\nSub-buffer size in kilobytes:\n   %d\n", bufsize);
+
  out:
 	free(str);
 }
-- 
2.42.0

