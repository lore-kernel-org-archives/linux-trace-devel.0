Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD892F528
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0938AC433C8;
	Tue, 17 Oct 2023 23:33:27 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qstaa-009G0R-39;
	Tue, 17 Oct 2023 19:35:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Avidan Borisov <avidanborisov@gmail.com>,
	Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd record: Cleanup - be consistent with return status variable
Date: Tue, 17 Oct 2023 19:20:29 -0400
Message-ID: <20231017233503.2205514-3-rostedt@goodmis.org>
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

The variable that checks return status in daemonize_start() is "rc". To be
consistent with the rest of the code, change it to "ret".

Also check for less than zero instead of -1.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c943f486291e..022c27ffc294 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1655,7 +1655,7 @@ static void daemonize_start(void)
 	int devnull;
 	int status;
 	int pid;
-	int rc;
+	int ret;
 
 	pid = fork();
 	if (pid == -1)
@@ -1719,12 +1719,12 @@ static void daemonize_start(void)
 			die("daemonize: sigaction failed");
 
 		do {
-			rc = waitpid(pid, &status, 0);
-		} while (!child_detached && ((rc == -1) && (errno == EINTR)));
+			ret = waitpid(pid, &status, 0);
+		} while (!child_detached && ((ret < 0) && (errno == EINTR)));
 
 		if (child_detached)
 			exit(0);
-		else if (rc == pid)
+		else if (ret == pid)
 			exit(WIFEXITED(status));
 		else
 			die("daemonize: waitpid failed");
-- 
2.42.0

