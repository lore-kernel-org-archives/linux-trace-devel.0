Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790941096A
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E59C433C7;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJt-15Pu;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 20/22] libtracefs: Also clear max_graph_depth on reset
Date: Thu, 28 Dec 2023 16:52:15 -0500
Message-ID: <20231228215433.54854-21-rostedt@goodmis.org>
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

Clear the "max_graph_depth" file on tracefs_instance_reset()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 8d9dd0e21498..b94630a324a1 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1490,6 +1490,7 @@ void tracefs_instance_reset(struct tracefs_instance *instance)
 	tracefs_tracer_clear(instance);
 	tracefs_instance_file_write(instance, "events/enable", "0");
 	tracefs_instance_file_write(instance, "set_ftrace_pid", "");
+	tracefs_instance_file_write(instance, "max_graph_depth", "0");
 	tracefs_instance_file_clear(instance, "trace");
 
 	systems = tracefs_event_systems(NULL);
-- 
2.42.0

