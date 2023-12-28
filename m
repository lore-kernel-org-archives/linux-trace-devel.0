Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D4010780
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BECC433C7;
	Thu, 28 Dec 2023 20:36:25 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx7z-00000000Dsg-2WyL;
	Thu, 28 Dec 2023 15:37:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 03/23] libtracefs: Free "missed_followers" of instance
Date: Thu, 28 Dec 2023 15:35:25 -0500
Message-ID: <20231228203714.53294-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The missed_followers array was allocated but not freed in the clean up of
the instance.

Fixes: 44501430 ("libtracefs: Add tracefs_follow_missed_events() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index be1478ee7a92..c385a078ecec 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -124,6 +124,7 @@ __hidden void trace_put_instance(struct tracefs_instance *instance)
 
 	free(instance->trace_dir);
 	free(instance->followers);
+	free(instance->missed_followers);
 	free(instance->name);
 	pthread_mutex_destroy(&instance->lock);
 	free(instance);
-- 
2.42.0

