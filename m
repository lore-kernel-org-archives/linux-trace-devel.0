Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A147A14ABC
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 08:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A39AC433C8;
	Wed, 27 Sep 2023 08:19:04 +0000 (UTC)
Date: Wed, 27 Sep 2023 04:19:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@chromium.org>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Fix allocation of val_stats
Message-ID: <20230927041901.07b756e9@rorschach.local.home>
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

The val_stats is to be the same size as the number of val types. But the
number of key times was used to create the size.

Fixes: 8df588c6bc128 ("libtraceeval histogram: Add updating of stats")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/histograms.c b/src/histograms.c
index 42959c154a11..fdc9f0c2fbce 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -740,7 +740,7 @@ static int create_entry(struct traceeval *teval,
 	if (!entry)
 		return -1;
 
-	entry->val_stats = calloc(teval->nr_key_types, sizeof(*entry->val_stats));
+	entry->val_stats = calloc(teval->nr_val_types, sizeof(*entry->val_stats));
 	if (!entry->val_stats)
 		goto fail_entry;
 
-- 
2.40.1

