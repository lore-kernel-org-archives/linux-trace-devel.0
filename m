Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35500107BB
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD702C433C9;
	Thu, 28 Dec 2023 21:53:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKo-00000000EIv-3cjc;
	Thu, 28 Dec 2023 16:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 05/22] libtracefs: Free tracing_dir in case of remount
Date: Thu, 28 Dec 2023 16:52:00 -0500
Message-ID: <20231228215433.54854-6-rostedt@goodmis.org>
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

On remount, the tracing directory may move, and the tracing_dir needs to be
updated. If tracing_dir is the same it is simply returned, but if it is not,
it has to be calculated again. This was fixed but if it was changed, the old
tracing_dir was never freed.

Always free the tracing_dir before calculating a new one. This also requires
changing the type by removing the "const" attribute.

Fixes: 92c9292a ("libtracefs: Have tracefs_{tracing,debug}_dir() make sure it's still mounted")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-utils.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index ef90677cf617..e67b698f5b99 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -248,7 +248,7 @@ static int test_dir(const char *dir, const char *file)
  */
 const char *tracefs_tracing_dir(void)
 {
-	static const char *tracing_dir;
+	static char *tracing_dir;
 
 	/* Do not check custom_tracing_dir */
 	if (custom_tracing_dir)
@@ -257,6 +257,7 @@ const char *tracefs_tracing_dir(void)
 	if (tracing_dir && test_dir(tracing_dir, "trace"))
 		return tracing_dir;
 
+	free(tracing_dir);
 	tracing_dir = find_tracing_dir(false, true);
 	return tracing_dir;
 }
-- 
2.42.0

