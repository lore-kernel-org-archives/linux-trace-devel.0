Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82236290B
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 08:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22769C433C7;
	Wed, 27 Sep 2023 08:16:32 +0000 (UTC)
Date: Wed, 27 Sep 2023 04:16:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Fix comparing unsigned against zero
Message-ID: <20230927041629.43ffbfd9@rorschach.local.home>
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

nr_key_types and nr_val_types are both size_t which is an unsized number.
A compare against zero is always false:

	if (teval->nr_key_types < 0)

Typecast it to signed for these comparisons.

Also change the few places the "size_t i" is used where it does:

	for (; i >= 0; i--)

as that too needs to be signed to work.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index 96f0926f062c..42959c154a11 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -159,7 +159,7 @@ static size_t type_alloc(const struct traceeval_type *defs,
 {
 	struct traceeval_type *new_defs = NULL;
 	size_t size;
-	size_t i;
+	ssize_t i;
 
 	*copy = NULL;
 
@@ -196,7 +196,7 @@ fail:
 	else
 		print_err("traceeval_type list missing a name");
 
-	for (; i >=0; i--)
+	for (; i >= 0; i--)
 		free(new_defs[i].name);
 	free(new_defs);
 	return -1;
@@ -303,14 +303,14 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
 
 	/* alloc key types */
 	teval->nr_key_types = type_alloc(keys, &teval->key_types);
-	if (teval->nr_key_types <= 0) {
+	if ((ssize_t)teval->nr_key_types <= 0) {
 		err_msg = "Failed to allocate user defined keys";
 		goto fail_release;
 	}
 
 	/* alloc val types */
 	teval->nr_val_types = type_alloc(vals, &teval->val_types);
-	if (teval->nr_val_types < 0) {
+	if ((ssize_t)teval->nr_val_types < 0) {
 		err_msg = "Failed to allocate user defined values";
 		goto fail_release;
 	}
@@ -785,7 +785,7 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	union traceeval_data *copy = entry->vals;
 	union traceeval_data old[teval->nr_val_types];
 	size_t size = teval->nr_val_types;
-	size_t i;
+	ssize_t i;
 
 	if (!size)
 		return 0;
-- 
2.40.1

