Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D1D136E09
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jun 2024 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718394898; cv=none; b=s7cX6ultcXl4TaDoX3upi+9TuUcC6X+6qxGNOmJ7o99w/IXf6I3YpVhwLi84eBdItUyu7IL7Km23h9/26+dbcJrvyXNmePQDuZKg9/tJYnUqStWcBAjaDlIBtZBSfnzzmrl1blN4xAUqutUZNmfuJGYytaUhntxQBueWG6IH8zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718394898; c=relaxed/simple;
	bh=y3mAPoa8MYZjzTZUuZYp8ViW+eP7ddB+NqkO6lpxynY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Sq/uX51+kDmQpSkhDn/EciO8JiO2cbcOjT564awfqnKaD/W815/UBiUbv9tGkdbDO0RuBYT8lcSr2H0JxtlWOXFXUgtRR4h0xDyMIge4bZYu2P3jGP/BXrh5oFkMTsUwoCcHXXJcd18f5+PMk15H+OmctxCry9L5lUC6O5JPkTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231D2C2BD10;
	Fri, 14 Jun 2024 19:54:58 +0000 (UTC)
Date: Fri, 14 Jun 2024 15:54:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: "Jerome Marchand" <jmarchan@redhat.com>
Subject: [PATCH] libtraceevent: Do not return a local stack pointer in
 get_field_str()
Message-ID: <20240614155456.092944eb@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Jerome Marchand sent a patch with the description of:

    The function get_field_str() can return a pointer to string on the
    stack. Replace it by a global variable.

    Fixes a RETURN_LOCAL error (CWE-562)

But made hex a global variable. Having a generic name "hex" as a global
variable in a library will cause a lot of issues. Just make it a static
variable, and then it can be used outside the function.

Link: https://lore.kernel.org/linux-trace-devel/20240607160542.46152-5-jmarchan@redhat.com/

Fixes: dee43d8067350 ("tools lib traceevent: Let filtering numbers by string use function names")
Reported-by: "Jerome Marchand" <jmarchan@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/parse-filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parse-filter.c b/src/parse-filter.c
index e448ee2b6799..75b84a0cc4ae 100644
--- a/src/parse-filter.c
+++ b/src/parse-filter.c
@@ -1704,8 +1704,8 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
 	struct tep_handle *tep;
 	unsigned long long addr;
 	const char *val = NULL;
+	static char hex[64];
 	unsigned int size;
-	char hex[64];
 
 	/* If the field is not a string convert it */
 	if (arg->str.field->flags & TEP_FIELD_IS_STRING) {
-- 
2.43.0

