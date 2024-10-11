Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC121C68AC
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671264; cv=none; b=HtX+jxHq8Pjp4dEkPFCizhWYtbF/ndu89PPCwPkW+sA0DNVu2HTYLC49I1UbWMIbkKAdaDJuWo8wmEh4hXKj9NL5a+1fEZwu6HDp6wIF2QlZoGLTaGiBLj0V+p1WHYmhifC2eFFnGrarmX3k0WJsupCKUiFekVLQNh9EybLnWvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671264; c=relaxed/simple;
	bh=AmA4nJjKpsd7bjZPoe5wu4DjQwibukGbL+POWmAwT38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpOMTB34LF0a76sfBPcGMuaMkJK1/RMl5rgA0iTdyqMuWTd5IOoFxbvBTA3kSzeWWD/8vsb/kBOmJybwnNXjOVPwOn6Cdj4TT/fh4yodDzBIDjT9QGjEQ3yDtwPwH8Jm3/qz04c/T7cHGwJwSKTVkDtTIAjb40aHSXGH6d8Epm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED24BC4CEC7;
	Fri, 11 Oct 2024 18:27:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1szKMk-00000001V1J-2T4M;
	Fri, 11 Oct 2024 14:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] trace-cmd list: Use tracefs_instances() to list instances
Date: Fri, 11 Oct 2024 14:26:53 -0400
Message-ID: <20241011182752.357499-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241011182752.357499-1-rostedt@goodmis.org>
References: <20241011182752.357499-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of walking the instances directory, use the tracefs_instances()
function to find all the instances.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 0fbb8eabd44b..8badd1f2e3e3 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -484,31 +484,20 @@ static void show_functions(const char *funcre)
 
 static void show_buffers(void)
 {
-	struct dirent *dent;
-	DIR *dir;
-	char *path;
-	int printed = 0;
+	char **list;
+	int i;
 
-	path = tracefs_get_tracing_file("instances");
-	dir = opendir(path);
-	tracefs_put_tracing_file(path);
-	if (!dir)
+	list = tracefs_instances(NULL);
+	if (!list)
 		die("Can not read instance directory");
 
-	while ((dent = readdir(dir))) {
-		const char *name = dent->d_name;
-
-		if (strcmp(name, ".") == 0 ||
-		    strcmp(name, "..") == 0)
-			continue;
-
-		printf("%s\n", name);
-		printed = 1;
-	}
-	closedir(dir);
+	for (i = 0; list[i]; i++)
+		printf("%s\n", list[i]);
 
-	if (!printed)
+	if (!i)
 		printf("No buffer instances defined\n");
+
+	tracefs_list_free(list);
 }
 
 
-- 
2.45.2

