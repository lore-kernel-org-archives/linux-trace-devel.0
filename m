Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7101C10967
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AB3C43395;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKo-00000000EJB-43Pa;
	Thu, 28 Dec 2023 16:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 09/22] libtracefs: Increase splice to use pipe max size
Date: Thu, 28 Dec 2023 16:52:04 -0500
Message-ID: <20231228215433.54854-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a pipe is created for splicing to read the tracing ring buffer, instead
of using the default size, which is usually around 65K, read
/proc/sys/fs/pipe_max_size and try to set the pipe to use that size instead.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-record.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index b078c8615194..8750fe7e0e29 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -319,6 +319,7 @@ int tracefs_cpu_read(struct tracefs_cpu *tcpu, void *buffer, bool nonblock)
 
 static int init_splice(struct tracefs_cpu *tcpu)
 {
+	char *buf;
 	int ret;
 
 	if (tcpu->splice_pipe[0] >= 0)
@@ -328,6 +329,12 @@ static int init_splice(struct tracefs_cpu *tcpu)
 	if (ret < 0)
 		return ret;
 
+	if (str_read_file("/proc/sys/fs/pipe-max-size", &buf, false)) {
+		int size = atoi(buf);
+		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
+		free(buf);
+	}
+
 	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ, &tcpu->pipe_size);
 	/*
 	 * F_GETPIPE_SZ was introduced in 2.6.35, ftrace was introduced
-- 
2.42.0

