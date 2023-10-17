Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5706B43102
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0427EC433C7;
	Tue, 17 Oct 2023 23:33:27 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qstaa-009G0O-32;
	Tue, 17 Oct 2023 19:35:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Avidan Borisov <avidanborisov@gmail.com>,
	Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd record: Use SIGTERM as well for --daemonize
Date: Tue, 17 Oct 2023 19:20:28 -0400
Message-ID: <20231017233503.2205514-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231017233503.2205514-1-rostedt@goodmis.org>
References: <20231017233503.2205514-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently --daemonize expects a SIGINT to stop the daemon and build the
trace.dat file. But if the user just does a:

  kill <pid>

it will send a SIGTERM. This will actually kill the process and it will
not create the trace.dat file, leaving a bunch of trace.dat.cpuX files
just lying around.

Update it to also do the same with SIGTERM.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 69a10bf1f0bd..c943f486291e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3344,6 +3344,7 @@ static void do_sig(int sig)
 	case SIGALRM:
 	case SIGUSR1:
 	case SIGINT:
+	case SIGTERM:
 		return finish();
 	case SIGUSR2:
 		return flush();
@@ -3591,6 +3592,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 			return pid;
 
 		signal(SIGINT, SIG_IGN);
+		signal(SIGTERM, SIG_IGN);
 		signal(SIGUSR1, do_sig);
 		signal(SIGUSR2, do_sig);
 		signal(SIGALRM, do_sig);
@@ -7146,6 +7148,7 @@ static void record_trace(int argc, char **argv,
 
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
 		signal(SIGINT, do_sig);
+		signal(SIGTERM, do_sig);
 		if (!latency)
 			start_threads(type, ctx);
 	}
@@ -7182,7 +7185,7 @@ static void record_trace(int argc, char **argv,
 
 		if (do_daemonize) {
 			daemonize_finish();
-			printf("Send SIGINT to pid %d to stop recording\n", getpid());
+			printf("Send SIGINT/SIGTERM to pid %d to stop recording\n", getpid());
 		} else {
 			/* sleep till we are woken with Ctrl^C */
 			printf("Hit Ctrl^C to stop recording\n");
-- 
2.42.0

