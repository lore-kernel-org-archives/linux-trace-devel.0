Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD8858AD1
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 Nov 2023 20:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6454C433C8;
	Tue, 28 Nov 2023 20:30:03 +0000 (UTC)
Date: Tue, 28 Nov 2023 15:30:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: David Vernet <void@manifault.com>, kernel-team@meta.com,
 julia.lawall@inria.fr, himadrispandya@gmail.com, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: [PATCH] trace-cmd record: Use copy of PATH for strtok_r()
 operations
Message-ID: <20231128153024.6e0d40e1@gandalf.local.home>
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

As strtok_r() modifies the string it is parsing, using the environment variable
PATH to find the paths for execution causes it to be truncated when reused by
exec. Instead, make a copy of the PATH environment variable to use to parse the
paths.

I had this fixed in my repo for some time and never pushed it out, but it was
eventually reported by others.

Link: https://lore.kernel.org/all/20231128192435.36507-1-void@manifault.com/

Reported-by: David Vernet <void@manifault.com>
Fixes: edf9424029cc ("trace-cmd: Open code execvp routine to avoid multiple execve syscalls")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bced8040..c424a874 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1698,6 +1698,11 @@ static void execute_program(int argc, char **argv)
 		if (!path)
 			die("can't search for '%s' if $PATH is NULL", argv[0]);
 
+		/* Do not modify the actual environment variable */
+		path = strdup(path);
+		if (!path)
+			die("Failed to allocate PATH");
+
 		for (entry = strtok_r(path, ":", &saveptr);
 		     entry; entry = strtok_r(NULL, ":", &saveptr)) {
 
@@ -1708,6 +1713,7 @@ static void execute_program(int argc, char **argv)
 				break;
 
 		}
+		free(path);
 	} else {
 		strncpy(buf, argv[0], sizeof(buf));
 	}
-- 
2.42.0

