Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FD41F602
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D47CC43395;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049To-0k;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 07/11] libtraceveal: Add type checks to traceeval_data vals and keys
Date: Wed, 27 Sep 2023 08:33:10 -0400
Message-Id: <20230927123314.989589-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230927123314.989589-1-rostedt@goodmis.org>
References: <20230927123314.989589-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the traceeval_data has a type, add checks to traceeval_insert()
and traceveal_query() as well as traceeval_stat() to make sure the keys
and vals match the types that were for the traceeval.

Which also caught a bug in task_eval.c display_process_stats().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c |  2 +-
 src/histograms.c    | 17 +++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index e62bfddafdd3..475df190acd2 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -785,7 +785,7 @@ static void display_process_stats(struct traceeval *teval,
 	};
 
 	for (int i = 0; i < OTHER; i++) {
-		TRACEEVAL_SET_NUMBER_64(keys[1], i);
+		TRACEEVAL_SET_NUMBER(keys[1], i);
 
 		delta = 0;
 		stat = traceeval_stat(teval, keys, &delta_vals[0]);
diff --git a/src/histograms.c b/src/histograms.c
index fc29558d75fe..954042da28e4 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -479,10 +479,16 @@ static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 	struct hash_item *item;
 	unsigned key;
 	int check = 0;
+	int i;
 
 	if (!teval || !keys)
 		return -1;
 
+	for (i = 0; i < teval->nr_key_types; i++) {
+		if (keys[i].type != teval->key_types[i].type)
+			return -1;
+	}
+
 	key = make_hash(teval, keys, hist->bits);
 
 	for (iter = hash_iter_bucket(hist, key); (item = hash_iter_bucket_next(iter)); ) {
@@ -792,6 +798,11 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	if (!size)
 		return 0;
 
+	for (i = 0; i < teval->nr_val_types; i++) {
+		if (vals[i].type != teval->val_types[i].type)
+			return -1;
+	}
+
 	for (i = 0; i < size; i++) {
 		old[i] = copy[i];
 
@@ -928,10 +939,16 @@ int traceeval_insert(struct traceeval *teval,
 {
 	struct entry *entry;
 	int check;
+	int i;
 
 	entry = NULL;
 	check = get_entry(teval, keys, &entry);
 
+	for (i = 0; i < teval->nr_val_types; i++) {
+		if (vals[i].type != teval->val_types[i].type)
+			return -1;
+	}
+
 	if (check == -1)
 		return check;
 
-- 
2.40.1

