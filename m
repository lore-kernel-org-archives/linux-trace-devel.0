Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D51E20ADC9
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743796124; cv=none; b=KwQJJrF0GMf6CbnWGk0LTWAxQn46YqsJGEgXsOqiJttEibAgdR30cHHp/i7k1YRd4FWl5uwshbNzYFebM5ZKVA+oIUTsVkj80gkzE0jNvJGvHeL5jyMx97Jv5eWhbnetaLnTNV/xsXRKptZDHyPLaHGgKJYBZ+d2BZzchF+fots=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743796124; c=relaxed/simple;
	bh=P8P4dT0ALHmT3b8bIQCNY/92qpN315DyP4yT3tnJXIc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=lQyVA0OUZxG9qdNLi7MA/f0/UfcWB4cQ2z5RWDW0AYSmcnLg6TEqye2t9WLYD1kFt1r2U5GUufXHLU3UNNB5bdWFWq32GC0h0EdI/Y4zcebZgpTD87OsH7kPOPpbBkgUE6IANnRkNJnUx5DgCXgiqh+J1xa4CmxLrTpfxAupUDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F87C4CEDD
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 19:48:43 +0000 (UTC)
Date: Fri, 4 Apr 2025 15:49:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Check if any functions were found
Message-ID: <20250404154949.6422bc8a@gandalf.local.home>
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

The trace-cmd list operation on functions will crash if no functions were
found:

  $ trace-cmd list -f aueaeu
  Segmentation fault

The list returned is NULL but the code still loops over the list of found
functions. Do not loop if no function is found.

Fixes: 39acb4cc1 ("trace-cmd list: Use tracefs_filter_functions()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 8badd1f2..a441d136 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -476,7 +476,7 @@ static void show_functions(const char *funcre)
 
 	if (tracefs_filter_functions(funcre, NULL, &list) < 0)
 		die("Failed to read filte functions");
-	for (i = 0; list[i]; i++)
+	for (i = 0; list && list[i]; i++)
 		printf("%s\n", list[i]);
 	tracefs_list_free(list);
 }
-- 
2.47.2

