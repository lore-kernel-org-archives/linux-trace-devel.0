Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D176F51A
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73CDC433C7;
	Thu, 28 Sep 2023 09:15:15 +0000 (UTC)
Date: Thu, 28 Sep 2023 05:15:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez 
 <stevie.6strings@gmail.com>
Subject: [PATCH] traceeval: Fix traceeval_insert() macro for NULL vals
Message-ID: <20230928051511.074ab689@rorschach.local.home>
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

If the vals is NULL (which is valid), the traceeval_insert() macro calls
traceeval_insert_size() with sizeof(vals)/sizeof(vals[0]) to get the
number of vals in the array. But this does not make sense with a NULL
value. Check for NULL and if vals is NULL then pass in zero.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index eefa48d5d772..f6caed6a2a98 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -187,7 +187,7 @@ int traceeval_insert_size(struct traceeval *teval,
 
 #define traceeval_insert(teval, keys, vals)				\
 	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
-			      vals, TRACEEVAL_ARRAY_SIZE(vals))
+			      vals, vals ? TRACEEVAL_ARRAY_SIZE(vals) : 0)
 
 int traceeval_remove_size(struct traceeval *teval,
 			  const struct traceeval_data *keys, size_t nr_keys);
-- 
2.40.1

