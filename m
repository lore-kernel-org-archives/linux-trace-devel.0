Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E8126E0D
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2D0C433CC;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049Tw-0v;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 09/11] libtraceeval: Make traceeval_remove() check size of keys array
Date: Wed, 27 Sep 2023 08:33:12 -0400
Message-Id: <20230927123314.989589-10-rostedt@goodmis.org>
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

Make traceeval_remove() into a macro to pass in the size of the keys
array, and rename the function to traceeval_remove_size() that now takes
the size of the keys array.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 7 +++++--
 src/histograms.c         | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 7f48bb92cc96..804a0aaa631d 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -196,8 +196,11 @@ int traceeval_insert_size(struct traceeval *teval,
 	traceeval_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
 			      vals, TRACEEVAL_ARRAY_SIZE(vals))
 
-int traceeval_remove(struct traceeval *teval,
-		     const struct traceeval_data *keys);
+int traceeval_remove_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys);
+
+#define traceeval_remove(teval, keys)					\
+	traceeval_remove_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
 
 int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *keys,
 			 size_t nr_keys, const struct traceeval_data **results);
diff --git a/src/histograms.c b/src/histograms.c
index ab8a560fe14d..28cf0d4ed225 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -977,13 +977,16 @@ int traceeval_insert_size(struct traceeval *teval,
  *         0 if it did not find an time matching @keys
  *        -1 if there was an error.
  */
-int traceeval_remove(struct traceeval *teval,
-		     const struct traceeval_data *keys)
+int traceeval_remove_size(struct traceeval *teval,
+			  const struct traceeval_data *keys, size_t nr_keys)
 {
 	struct hash_table *hist = teval->hist;
 	struct entry *entry;
 	int check;
 
+	if (teval->nr_key_types != nr_keys)
+		return -1;
+
 	entry = NULL;
 	check = get_entry(teval, keys, &entry);
 
-- 
2.40.1

