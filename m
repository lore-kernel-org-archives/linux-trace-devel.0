Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7C323778
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7917AC433AB;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049U4-16;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 11/11] libtraceeval: Only do stats on values marked with the STAT flag
Date: Wed, 27 Sep 2023 08:33:14 -0400
Message-Id: <20230927123314.989589-12-rostedt@goodmis.org>
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

Add TRACEEVAL_FL_STAT to perform stats on the value, otherwise ignore it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  1 +
 samples/task-eval.c      |  1 +
 src/histograms.c         | 39 ++++++++++++++++++++-------------------
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index a1b498108fb4..618e67593dc0 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -38,6 +38,7 @@ enum traceeval_flags {
 	TRACEEVAL_FL_VALUE		= (1 << 1),
 	TRACEEVAL_FL_SIGNED		= (1 << 2),
 	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
+	TRACEEVAL_FL_STAT		= (1 << 4),
 };
 
 /*
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 475df190acd2..6b01b8d076f2 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -147,6 +147,7 @@ static struct traceeval_type delta_vals[] = {
 	{
 		.type	= TRACEEVAL_TYPE_NUMBER_64,
 		.name	= "delta",
+		.flags = TRACEEVAL_FL_STAT,
 	},
 	{
 		.type	= TRACEEVAL_TYPE_NONE,
diff --git a/src/histograms.c b/src/histograms.c
index 4d534d127cff..0a3ab84d288e 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -505,6 +505,25 @@ static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 	return check;
 }
 
+static bool is_stat_type(struct traceeval_type *type)
+{
+	/* Only value numbers have stats */
+	if (!(type->flags & TRACEEVAL_FL_VALUE) ||
+	    !(type->flags & TRACEEVAL_FL_STAT))
+		return false;
+
+	switch (type->type) {
+	case TRACEEVAL_TYPE_NUMBER:
+	case TRACEEVAL_TYPE_NUMBER_64:
+	case TRACEEVAL_TYPE_NUMBER_32:
+	case TRACEEVAL_TYPE_NUMBER_16:
+	case TRACEEVAL_TYPE_NUMBER_8:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * Copy @src to @dst with respect to @type.
  *
@@ -571,7 +590,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
 		return 0;
 	}
 
-	if (!stat)
+	if (!stat || !is_stat_type(type))
 		return 0;
 
 	if (!stat->count++) {
@@ -826,24 +845,6 @@ static int update_entry(struct traceeval *teval, struct entry *entry,
 	return -1;
 }
 
-static bool is_stat_type(struct traceeval_type *type)
-{
-	/* Only value numbers have stats */
-	if (!(type->flags & TRACEEVAL_FL_VALUE))
-		return false;
-
-	switch (type->type) {
-	case TRACEEVAL_TYPE_NUMBER:
-	case TRACEEVAL_TYPE_NUMBER_64:
-	case TRACEEVAL_TYPE_NUMBER_32:
-	case TRACEEVAL_TYPE_NUMBER_16:
-	case TRACEEVAL_TYPE_NUMBER_8:
-		return true;
-	default:
-		return false;
-	}
-}
-
 struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 					   const struct traceeval_data *keys,
 					   size_t nr_keys,
-- 
2.40.1

