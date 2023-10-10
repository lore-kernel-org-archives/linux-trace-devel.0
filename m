Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFA732192
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C62C433CA;
	Tue, 10 Oct 2023 19:53:06 +0000 (UTC)
Date: Tue, 10 Oct 2023 15:54:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Do not update stats if both the timestamp and
 value are zero
Message-ID: <20231010155427.4822d4d7@gandalf.local.home>
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

If the timestamp and the value are both zero, the stats will not be
updated. We may in the future add a way to allow it to add zero of both,
but in most case, a delta of zero is pretty meaningless.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/histograms.c b/src/histograms.c
index 480b78da606b..4e03c967dca3 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -538,6 +538,10 @@ __hidden void _teval_update_stat(struct traceeval_type *type,
 				 unsigned long long val,
 				 unsigned long long ts)
 {
+	/* If both the delta and the timestamp are zero, ignore this */
+	if (!val && !ts)
+		return;
+
 	if (!stat->count++) {
 		stat->max = val;
 		stat->min = val;
-- 
2.42.0

