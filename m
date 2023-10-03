Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BD22915
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 13:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2BAC433C8;
	Tue,  3 Oct 2023 13:09:28 +0000 (UTC)
Date: Tue, 3 Oct 2023 09:10:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: [PATCH v2] libtraceeval: Fix comparing unsigned against zero
Message-ID: <20231003091032.06e697a3@gandalf.local.home>
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

nr_key_types and nr_val_types are both size_t which is an unsized number.
A compare against zero is always false:

	if (teval->nr_key_types < 0)

Change them to ssize_t (signed type).

Also change the few places the "size_t i" is used where it does:

	for (; i >= 0; i--)

as that too needs to be signed to work.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230927041629.43ffbfd9@rorschach.local.home

  - Use ssize_t type instead of typecasting (Ross Zwisler)

 src/eval-local.h | 4 ++--
 src/histograms.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/eval-local.h b/src/eval-local.h
index 5c3918f17cc1..f7a9de4628ba 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -66,8 +66,8 @@ struct traceeval {
 	struct traceeval_type		*key_types;
 	struct traceeval_type		*val_types;
 	struct hash_table		*hist;
-	size_t				nr_key_types;
-	size_t				nr_val_types;
+	ssize_t				nr_key_types;
+	ssize_t				nr_val_types;
 };
 
 struct traceeval_iterator {
diff --git a/src/histograms.c b/src/histograms.c
index 96f0926f062c..9f9594aa9546 100644
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

