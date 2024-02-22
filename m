Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870B214E2C9
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708617854; cv=none; b=khwBITha7gFjqQguViDUHzWWw7bRarPLE/zz1uCVeQ72MCiA5B47LrsPWe9KPtQQQJPdmlCwvbUhSxzTFvPU0RtOLX4JM/iS7iLsy9ELnNJ1yb2IwvYUHEwQn+ayfkg3G36gSCNh1N3DEFb/2Gwqj7w7ZtzVynUkqcOBdfhatf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708617854; c=relaxed/simple;
	bh=SUPFOczILXAuLmC4rmsQlF7UslQnRLRhyyAVWIi20Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=HaA+U+jd0yh+eJsma4NcFjPXeKzFZSDuqrlMEUDQ8Gx82smSXUb+rExO8gG/WhxvoGcVPszIrJpH38lFwxpZbQ44dVaID8VYkaPovTAAcKG3Paud2JMD2NaETukSUxnNYa3KvoZRbBzHX2iooWyj4/yQmLzb82CMI7sWhWUb5qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1118C433F1;
	Thu, 22 Feb 2024 16:04:13 +0000 (UTC)
Date: Thu, 22 Feb 2024 11:06:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Miko Larsson <mikoxyzzz@gmail.com>
Subject: [PATCH] trace-cmd utest: Add PATH_MAX if it is not already defined
Message-ID: <20240222110604.156aa6bb@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In some setups PATH_MAX may not be defined (it is usually defined in
linux/limits.h), but we just use PATH_MAX as something to hold the paths
to the tracing files. In that case, just define it to 1024 if it's not
already defined.

Link: https://lore.kernel.org/linux-trace-devel/20240222-utest-fixes-v2-1-7b8ee8dca0b7@gmail.com/

Reported-by: Miko Larsson <mikoxyzzz@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 5dce3e94df6a..164f5da1f06a 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -22,6 +22,10 @@
 
 #include "trace-utest.h"
 
+#ifndef PATH_MAX
+#define PATH_MAX 1024
+#endif
+
 static char tracecmd_exec[PATH_MAX];
 
 #define TRACECMD_SUITE		"trace-cmd"
-- 
2.43.0

