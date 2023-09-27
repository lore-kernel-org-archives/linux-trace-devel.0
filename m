Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C134E273E2
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D4C433C9;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049U0-11;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 10/11] libtraceeval: Make traceeval_stat() check size of keys array
Date: Wed, 27 Sep 2023 08:33:13 -0400
Message-Id: <20230927123314.989589-11-rostedt@goodmis.org>
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

Make traceeval_stat() into a macro to pass in the size of the keys
array, and rename the function to traceeval_stat_size() that now takes
the size of the keys array.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 10 +++++++---
 src/histograms.c         | 10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 804a0aaa631d..a1b498108fb4 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -211,9 +211,13 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 void traceeval_results_release(struct traceeval *teval,
 			       const struct traceeval_data *results);
 
-struct traceeval_stat *traceeval_stat(struct traceeval *teval,
-				      const struct traceeval_data *keys,
-				      struct traceeval_type *type);
+#define traceeval_stat(teval, keys, type)				\
+	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), type)
+
+struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
+					   const struct traceeval_data *keys,
+					   size_t nr_keys,
+					   struct traceeval_type *type);
 
 unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
 unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
diff --git a/src/histograms.c b/src/histograms.c
index 28cf0d4ed225..4d534d127cff 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -844,13 +844,17 @@ static bool is_stat_type(struct traceeval_type *type)
 	}
 }
 
-struct traceeval_stat *traceeval_stat(struct traceeval *teval,
-				      const struct traceeval_data *keys,
-				      struct traceeval_type *type)
+struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
+					   const struct traceeval_data *keys,
+					   size_t nr_keys,
+					   struct traceeval_type *type)
 {
 	struct entry *entry;
 	int ret;
 
+	if (teval->nr_key_types != nr_keys)
+		return NULL;
+
 	if (!is_stat_type(type))
 		return NULL;
 
-- 
2.40.1

