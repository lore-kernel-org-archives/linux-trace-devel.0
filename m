Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5A9249ED
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00422C433C8;
	Wed, 11 Oct 2023 22:22:27 +0000 (UTC)
Date: Wed, 11 Oct 2023 18:23:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Fix timestamp when vals is NULL
Message-ID: <20231011182351.098416bb@gandalf.local.home>
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

If traceeval_init() is passed NULL for vals, it can crash because he
teval->timestamp_idx is not updated and stays at zero. Then the check for
timestamp will iterate the NULL array of vals and crash.

Move the initialization of teval->timestamp_idx right after the teval is
allocated and do not depend on the val check to update it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index 572f33eb3ac6..f77afc3a86a1 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -338,8 +338,6 @@ static int check_vals(struct traceeval *teval, struct traceeval_type *vals, int
 			vals[i].flags |= TRACEEVAL_FL_STAT;
 		vals[i].index = i;
 	}
-	if (!ts_found)
-		teval->timestamp_idx = -1;
 	return 0;
 }
 
@@ -402,6 +400,8 @@ struct traceeval *traceeval_init_data_size(struct traceeval_type *keys,
 		goto fail;
 	}
 
+	teval->timestamp_idx = -1;
+
 	ret = check_keys(keys, nr_keys);
 	if (ret < 0)
 		goto fail_release;
-- 
2.42.0

