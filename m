Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D30CA46
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB5EC433CD;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZSr-1v;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 04/11] libtraceeval task-eval: Add way to read trace.dat buffer instances
Date: Tue, 10 Oct 2023 23:25:20 -0400
Message-ID: <20231011032640.1804571-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231011032640.1804571-1-rostedt@goodmis.org>
References: <20231011032640.1804571-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If a trace.dat file has data in a buffer instance, then task-eval should
be able to read that too. Add a "-B foo" option to task-eval that lets the
user specify a buffer instance that is within a trace.dat file.

This is used for when the trace.dat file is recorded as:

  trace-cmd record -B foo ...

The "foo" buffer is stored separately in the trace.dat file and requires
to be retrieved to be seen by libtracecmd.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index ad3e2424acc8..40e7345a27c4 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -41,6 +41,7 @@ static void usage(void)
 	       "  Run this on the resulting trace.dat file\n"
 	       "\n"
 	       "-c comm - to look at only a specific process called 'comm'\n"
+	       "-B instance - read a buffer instance in the trace.dat file\n"
 	       "\n",p);
 	exit(-1);
 }
@@ -975,17 +976,21 @@ int main (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
 	struct task_data data;
+	const char *buffer = NULL;
 	int c;
 
 	memset(&data, 0, sizeof(data));
 
 	argv0 = argv[0];
 
-	while ((c = getopt(argc, argv, "c:h")) >= 0) {
+	while ((c = getopt(argc, argv, "c:B:h")) >= 0) {
 		switch (c) {
 		case 'c':
 			data.comm = optarg;
 			break;
+		case 'B':
+			buffer = optarg;
+			break;
 		case 'h':
 		default:
 			usage();
@@ -1002,6 +1007,24 @@ int main (int argc, char **argv)
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
 
+	if (buffer) {
+		int bufs;
+		int i;
+
+		bufs = tracecmd_buffer_instances(handle);
+		for (i = 0; i < bufs; i++) {
+			const char *name;
+
+			name = tracecmd_buffer_instance_name(handle, i);
+			if (name && strcmp(name, buffer) == 0) {
+				handle = tracecmd_buffer_instance_handle(handle, i);
+				break;
+			}
+		}
+		if (i == bufs)
+			die("Can not find instance %s\n", buffer);
+	}
+
 	data.teval_tasks = traceeval_init(task_keys, task_vals);
 	if (!data.teval_tasks)
 		pdie("Creating trace eval processe data");
-- 
2.42.0

