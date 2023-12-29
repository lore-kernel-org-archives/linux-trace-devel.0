Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129258BE3
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD8FC433C8;
	Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Hf-00000000HmF-0JbD;
	Thu, 28 Dec 2023 22:11:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd library: Add back setting errno to zero in tracecmd_stack_tracer_status()
Date: Thu, 28 Dec 2023 22:10:14 -0500
Message-ID: <20231229031138.68313-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231229031138.68313-1-rostedt@goodmis.org>
References: <20231229031138.68313-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

A clean up was made to remove all the settings of errno to zero in the
library, but it was a bit too aggressive in doing so. It removed the errno
setting to zero in tracecmd_stack_tracer_status() just before it called
strtol() which it uses to test for the success of that function. By not
clearing errno, it was causing trace-cmd stat to report:

 "Error reading stack tracer status"

Fixes: dcd5ee3142 ("libtracecmd: Do not set errno to zero")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index fc61f9d1111b..b5002f1daa07 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -557,6 +557,7 @@ int tracecmd_stack_tracer_status(int *status)
 
 	buf[n] = 0;
 
+	errno = 0;
 	num = strtol(buf, NULL, 10);
 
 	/* Check for various possible errors */
-- 
2.42.0

