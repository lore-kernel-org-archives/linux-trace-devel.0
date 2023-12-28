Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B2310948
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B02C433CA;
	Thu, 28 Dec 2023 21:53:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKo-00000000EIo-3WGG;
	Thu, 28 Dec 2023 16:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 04/22] libtracefs: Free buf in clear_func_filter()
Date: Thu, 28 Dec 2023 16:51:59 -0500
Message-ID: <20231228215433.54854-5-rostedt@goodmis.org>
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

The buf variable was allocated via tracefs_instance_file_read() but must be
freed with free().

Fixes: 789e82d7 ("libtracefs: New API to reset ftrace instance")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index c385a078ecec..2efcc75dfd98 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -1371,6 +1371,7 @@ static void clear_func_filter(struct tracefs_instance *instance, const char *fil
 		filter[len+1] = '\0';
 		tracefs_instance_file_append(instance, file, filter);
 	}
+	free(buf);
 }
 
 static void clear_func_filters(struct tracefs_instance *instance)
-- 
2.42.0

