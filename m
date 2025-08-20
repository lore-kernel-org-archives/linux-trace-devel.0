Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38BB271472
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Aug 2025 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755724816; cv=none; b=Qy9eSgJwHdR/tMbxGoi06cicfZCqGWBR0pAQfr8hQcBrotbyMLnKRC70XZCeiv59aE0EWAEth44o3LSaYKLdDrZFFWk+kweg36SK7XACQT7c+if53luzTTV88tgte4ysu/wmphVPQHOyFdZMw5Fi2gcoOHs7ULbBs6qHZU3Q/Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755724816; c=relaxed/simple;
	bh=wJ0QE5snbOY5HcyKwP5AghVb7bG8G+nNvlZHWlXsOCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pkVdmLxne58VT7eZZkrpHCMQttFquBVUeCHOU6nMGsXL7+4l7WBbWztKhKxuGUvil9O8GBI2Ed8K3Smc0GamCtY83hWwaAUuKk0bIY9e5jq3h3pmoSPu7/Dq/X/M7GwBZglyuaez/N6cIrEIsg0yOSsAvPje0p6ZbTlRyk0/sxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=GARb7BG/; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="GARb7BG/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1755724489;
	bh=wJ0QE5snbOY5HcyKwP5AghVb7bG8G+nNvlZHWlXsOCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=GARb7BG/+gA+1Ij9/PSEJ70H+8R6iL2EJD9GR19CkCVCc9WNlHfrz6sDI9Vwn46Xe
	 eiKfFTgmNiTvrQPMggp8FMNKT3BL3Q5AhqZ4pCPlJYwx3s0ZSs9AkE8F/VJLUZ7G97
	 JBm5HPKQBHAmc2GD8jYDNdApX0qFfytw8jmNN0HuWQ1NEZOo8aDyjGnaij2CK6+3qi
	 2ludkKqRr3M6h7FMpy44fWef2HfbxxqYMHE6oAGyvoiU2azjx3lkksnfR94GCBLO9e
	 DU5Sz9ba+D4mt75NCJIDglRq5SRJQoJVE1yVKcSu7X80GEVwaPzfQnZNA/yINhjIXA
	 sgvUs44iYmXYg==
Received: from integral2.. (unknown [103.216.223.55])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 29C0D3127F84;
	Wed, 20 Aug 2025 21:14:46 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH 2/2] ccli: commands: Fix optimized `strlen()` calls
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 21 Aug 2025 04:14:34 +0700
Message-Id: <20250820211434.1857859-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
References: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling with clang, the following warning appears:

  commands.c:291:6: warning: variable 'l' set but not used [-Wunused-but-set-variable]
    291 |         int l = 0;
        |             ^

Closer inspection shows that `l` is only used to accumulate the return
values of `strlen()` calls, but its value is never read. It turns out
that it indicates a deeper issue than a simple unused variable.

The purpose of the `strlen()` calls in this code is to ensure all
strings passed to `test_table()` are touched. However, `strlen()` is
declared with `__attribute_pure__`.

A pure function always produces the same result for the same input and
has no side effects.

If the result of `strlen()` is not used, the compiler is allowed to
remove the call entirely, which means the strings are never actually
touched.

For example, compiling with `-O3`:

        #include <string.h>
        void touch_string(char *s)
        {
                strlen(s);
        }

produces only:

        touch_string:
            retq

Even at `-O0`, gcc still omits the `strlen()` call:

        touch_string:
            pushq   %rbp
            movq    %rsp,%rbp
            movq    %rdi,-0x8(%rbp)
            nop
            popq    %rbp
            retq

Introduce a new macro, OPTIMIZER_HIDE_VAR(), to hide the variable from
the compiler's optimizer, keeping the strlen() calls intact. It also
cleans the clang warning.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Giving more context for src/commands.c hunk for easier review.

 src/ccli-local.h | 1 +
 src/commands.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/ccli-local.h b/src/ccli-local.h
index 31d16de73095..d7fd8e71e482 100644
--- a/src/ccli-local.h
+++ b/src/ccli-local.h
@@ -15,6 +15,7 @@
 #define __hidden __attribute__((visibility ("hidden")))
 
 #define ISSPACE(c) isspace((unsigned char)(c))
+#define OPTIMIZER_HIDE_VAR(X) __asm__ volatile ("": "+r" (X))
 
 struct line_buf {
 	char *line;
diff --git a/src/commands.c b/src/commands.c
--- a/src/commands.c
+++ b/src/commands.c
@@ -285,49 +285,50 @@ int ccli_execute(struct ccli *ccli, const char *line_str, bool hist)
 
 static void test_table(const void *data)
 {
 	const struct ccli_command_table *table = data;
 	const char *name = table->name;
 	int len = strlen(test_name);
 	int l = 0;
 	int i;
 
 	/* The root of the table does not need a name */
 	if (!name)
 		name = "root";
 
 	if (len)
 		strncat(test_name, "->", BUFSIZ - 1);
 	strncat(test_name, name, BUFSIZ - 1);
 
 	snprintf(test_message, BUFSIZ - 1,
 		 "Command table missing name or 'subcommands' NULL terminator");
 
 	/* Touch all the names first */
 	for (i = 0; table->subcommands[i]; i++)
 		l += strlen(table->subcommands[i]->name);
 
 	snprintf(test_message, BUFSIZ - 1,
 		 "Command table missing 'options' NULL terminator");
 
 	if (table->options) {
 		int clen;
 
 		/* Test the options too */
 
 		clen = strlen(test_name);
 		if (clen)
 			strncat(test_name, "->[options]", BUFSIZ - 1);
 
 		for (i = 0; table->options->options[i]; i++)
 			l += strlen(table->options->options[i]->name);
 
 		test_name[clen] = '\0';
 	}
 
 	/* Now recurse */
 	for (i = 0; table->subcommands[i]; i++)
 		test_table(table->subcommands[i]);
 
 	test_name[len] = '\0';
+	OPTIMIZER_HIDE_VAR(l);
 }
 

-- 
Ammar Faizi

