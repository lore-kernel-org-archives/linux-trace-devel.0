Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC7562D
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 00:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA101C433C7
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 00:19:18 +0000 (UTC)
Date: Thu, 11 Jan 2024 19:20:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd meson: Add trace-sqlhist.c to meson.build
Message-ID: <20240111192022.37bd4602@gandalf.local.home>
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

The meson build was missing trace-sqlhist.c.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/meson.build b/tracecmd/meson.build
index be740117c820..a23376ba779d 100644
--- a/tracecmd/meson.build
+++ b/tracecmd/meson.build
@@ -28,6 +28,7 @@ sources = [
     'trace-tsync.c',
     'trace-usage.c',
     'trace-vm.c',
+    'trace-sqlhist.c',
 ]
 
 if vsock_defined
-- 
2.43.0

