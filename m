Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C491154BE2
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744292210; cv=none; b=Wx6Sza0nPejj7qNjgpJOFNI9GnP8f4lFkrRe9T5s7zkuGsb67+ZbOx6pkahtuPnlntAEc+8vnVIuEwBI4vQ3GO7v9Aykx42sq/a1tewGh4y9BuI6r1BEgnfSvMBHn37+Ab00OIIJefYjJUvBEuFrbivzuc3+t23tgCtRteZ1AhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744292210; c=relaxed/simple;
	bh=SC2HUnm26zksRHmBn0b4ISR/+iqjobZ9pBlLXD3FB1Q=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=dpIHK9iwLS3SfwSfTg10vj8ZjWNRxGyfa3OP2gwQPZV6j1fAcGT3gOPJgGv5q0gF3egL7UA5hpczdQ9F3XVzAHwi44ws1Z9mrIoscrh6hFEAYW1agw3XM2e9biGWMfijDaishsii1916fIb4z3AW+63m1ppQQVhv1y2AguAPbJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6A2C4CEE8
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 13:36:49 +0000 (UTC)
Date: Thu, 10 Apr 2025 09:38:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd sqlhist: Initialize err value to tracefs_sql()
Message-ID: <20250410093810.14642ddc@gandalf.local.home>
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

If tracefs_sql() fails, it doesn't always initialize the passed in "err"
pointer. That should be set to NULL before passing it in otherwise it can't
be known if the function set it on error.

Fixes: 1d5ac88ee ("trace-cmd sqlhist: Add 'sqlhist' command")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-sqlhist.c b/tracecmd/trace-sqlhist.c
index 9f2b94e6..ee7eed82 100644
--- a/tracecmd/trace-sqlhist.c
+++ b/tracecmd/trace-sqlhist.c
@@ -28,7 +28,7 @@ static int do_sql(const char *instance_name,
 	struct tep_handle *tep;
 	struct trace_seq seq;
 	enum tracefs_synth_handler handler;
-	char *err;
+	char *err = NULL;
 	int ret;
 
 	if ((action & ACTIONS) && !var)
-- 
2.47.2

