Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB5038DF9
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Oct 2024 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671264; cv=none; b=LKfZHh7w+vRIqIpm9oMS2Z2mYsU5/x0eNtoBkv2qWRae34lYwhLQCw8pSmnwDbz9vsDXbn0RxRd6S7cODNe6MFUI2FjVuXLTs+25HmhCZRXwB3VFw8CTXqfDbXJRyz0osaZuVlGtw/jYGY+c8dA8WW7j05qgyQRjbcN4B0emdic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671264; c=relaxed/simple;
	bh=PBVuWp2josTlAriSnjIzdw4bSD/9qVgzDDV6iDPnfnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtD7P1zYbLLqLChS+iyLW/XqC3d6f4DfPI2cf8e0339l4jIFAZyJ2TxA5icIbHu/m7/Qr3nlf0Czze6mmdC4FvDjmxqp9pG9bzL3WRc7goHasNC8yMnSVwGkJZd7eLS9vMf4yoJl/GKiH2OPJ0GtqX/mgs5HNwpkX5mdtraj4qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ACFC4CEC3;
	Fri, 11 Oct 2024 18:27:43 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1szKMk-00000001V1C-2EQX;
	Fri, 11 Oct 2024 14:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] trace-cmd list: Use tracefs_filter_functions()
Date: Fri, 11 Oct 2024 14:26:51 -0400
Message-ID: <20241011182752.357499-2-rostedt@goodmis.org>
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

Instead of reading the available_filter_functions file and parsing it
manually, simply call tarcefs_filter_functions() and report what it wrote
as it does the work for us.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index fbf2882e1a83..0fbb8eabd44b 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -236,16 +236,6 @@ static void process_events(process_file_func func, const char *re, int flags)
 		regfree(&event_reg);
 }
 
-static int show_file_write(char *buf, int len, int flags)
-{
-	return fwrite(buf, 1, len, stdout);
-}
-
-static void show_file_re(const char *name, const char *re)
-{
-	process_file_re(show_file_write, name, re, 0);
-}
-
 static char *get_event_file(const char *type, char *buf, int len)
 {
 	char *system;
@@ -476,10 +466,19 @@ static void show_clocks(void)
 
 static void show_functions(const char *funcre)
 {
-	if (funcre)
-		show_file_re("available_filter_functions", funcre);
-	else
+	char **list;
+	int i;
+
+	if (!funcre) {
 		show_file("available_filter_functions");
+		return;
+	}
+
+	if (tracefs_filter_functions(funcre, NULL, &list) < 0)
+		die("Failed to read filte functions");
+	for (i = 0; list[i]; i++)
+		printf("%s\n", list[i]);
+	tracefs_list_free(list);
 }
 
 
-- 
2.45.2

