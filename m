Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC5F1C68BF
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 18:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671264; cv=none; b=DnecfIBxA1Z0ngb62Qs6y8rwzGORLJ0C1WC5N87PjNA42cE5SklwvyflpJNJND85FvhkgnWNPvna9kizw2r10HkbOdhnvGuWCv2Flw8yoNNNEEIlzsq6x3wlf9451vni2zp5Lr799FyH/YeJ4NnfWjLn8KkStzD6+jj7JPTrYj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671264; c=relaxed/simple;
	bh=9fGvKar5twjECkK+6RsSjh+1jfdjInvrNC8nZJern+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCMXh589vIja5j53ioR2Cg9VBgxGSlxsqap5SmYlIihYEs0w/DEH7ervLR5+RWaiYVU680gITNGDcPMmM5cSkr1MLOpLgw9d9VJ6k1TJkczmzOHJJ1yylpmXKS+icQavATn06QZ1u/8/B5NYNw7w06PiaUauyMMR4P2BNNkKCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E466C4CED2;
	Fri, 11 Oct 2024 18:27:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1szKMk-00000001V1N-2a6N;
	Fri, 11 Oct 2024 14:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] trace-cmd stat: Use tracefs_instances() instead of walking them
Date: Fri, 11 Oct 2024 14:26:54 -0400
Message-ID: <20241011182752.357499-5-rostedt@goodmis.org>
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

Use the new tracefs_instances() function to retrieve a list of instances
on the system instead of calling tracefs_instance_walk() and having a
helper function do the printing. This simplifies the code a bit.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 1d95d9934b47..7ac62f2a3076 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -113,23 +113,23 @@ static void report_file(struct buffer_instance *instance,
 	free(str);
 }
 
-static int report_instance(const char *name, void *data)
+static void report_instances(void)
 {
-	bool *first = (bool *)data;
+	char **list;
+	int i;
 
-	if (*first) {
-		*first = false;
-		printf("\nInstances:\n");
-	}
-	printf(" %s\n", name);
-	return 0;
-}
+	list = tracefs_instances(NULL);
 
-static void report_instances(void)
-{
-	bool first = true;
+	if (!list || !list[0])
+		goto out;
+
+	printf("\nInstances:\n");
 
-	tracefs_instances_walk(report_instance, &first);
+	for (i = 0; list[i]; i++)
+		printf(" %s\n", list[i]);
+
+ out:
+	tracefs_list_free(list);
 }
 
 struct event_iter *trace_event_iter_alloc(const char *path)
-- 
2.45.2

