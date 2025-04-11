Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D331DB346
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 13:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744378505; cv=none; b=dY1WGAeIeeOdM4Pya2JCnQqmEl43PgVodPzFL7afldGp+dCLGoky7TJdYUFlJ8kMgoJWc5VaySjcVMrHsi166OyA0fyKnzoq//U8vzUZYnOjP8mzGO+tKXVVTop96QYr32aUeIrLwKvAVsD3kPEhzthE+D44XmMR0+DAq9+ZDLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744378505; c=relaxed/simple;
	bh=eIkJnVr+2aFtTVVK0ndkmwOgh9JeQOhpOSJ/qrNszCQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=TAXrkJT0DtU9eCJQCO4eSN6XIrJefwGU9i4FduynUXdLtquZOC3guAFITP3pbCnrV/fIzTnQUev4n75QTuoGtetVAdbG9IjZckwDmfVPia4Xm6OlK69cLnQ7Wajp4/sQFVwZMuajoat75AyPR06q+aA/4BnhgmBvyj49+1f2Xy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C0DC4CEE5
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 13:35:04 +0000 (UTC)
Date: Fri, 11 Apr 2025 09:36:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Show all functions that match string by
 default
Message-ID: <20250411093628.3f68fb02@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Before tracefs_filter_functions() was used to find the list of functions,
the trace-cmd list -f would list all functions that match the given string
by default. After the switching over to tracefs_filter_functions(), by
default it does a exact match.

This is quite annoying, as in most cases the user wants to see what
available functions have the given string. If the user knows the function
they are looking for, they do not need to use trace-cmd list -f !

Fixes: 39acb4cc1 ("trace-cmd list: Use tracefs_filter_functions()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 4e2cf041..073b37fb 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -466,6 +466,8 @@ static void show_clocks(void)
 
 static void show_functions(const char *funcre)
 {
+	bool found = false;
+	char *new_re = NULL;
 	char **list;
 	int i;
 
@@ -474,11 +476,33 @@ static void show_functions(const char *funcre)
 		return;
 	}
 
+	/* if the re doesn't have any regular expressions, then add them */
+	for (i = 0; !found && funcre[i]; i++) {
+		if (funcre[i] == '\\')
+			continue;
+		switch (funcre[i]) {
+		case '*':
+		case '[':
+		case '(':
+		case '.':
+		case '?':
+			found = true;
+		}
+	}
+
+	if (!found) {
+		/* Add glob around expression */
+		if (asprintf(&new_re, "*%s*", funcre) < 0)
+			die("Failed to allocate memory");
+		funcre = new_re;
+	}
+
 	if (tracefs_filter_functions(funcre, NULL, &list) < 0)
 		die("Failed to read filte functions");
 	for (i = 0; list && list[i]; i++)
 		printf("%s\n", list[i]);
 	tracefs_list_free(list);
+	free(new_re);
 }
 
 
-- 
2.47.2

