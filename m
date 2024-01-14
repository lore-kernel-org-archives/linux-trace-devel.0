Received: from 3.mo552.mail-out.ovh.net (3.mo552.mail-out.ovh.net [178.33.254.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159E5CB5
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.140.245])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 829AB29D99;
	Sun, 14 Jan 2024 17:17:42 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:41 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0028acce6ab-4b34-4ade-b892-476d5ae529bd,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 23/34] kernelshark: Fix 'const' type qualifier on return type has no effect
Date: Sun, 14 Jan 2024 18:17:12 +0100
Message-ID: <20240114171723.14092-24-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240114171723.14092-1-dev@benjarobin.fr>
References: <20240114171723.14092-1-dev@benjarobin.fr>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: be436c96-3e5f-4a39-850b-cfd545df8e1a
X-Ovh-Tracer-Id: 1672524314129293210
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth

Also fix clang build, which allow to execute Clang-Tidy and Clazy

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/libkshark-tepdata.c | 12 ++++++------
 src/libkshark.h         | 20 ++++++++++----------
 tests/test-input.c      |  4 ++--
 tests/test-input_ctrl.c |  4 ++--
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index b780957..2d0fcb0 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -634,8 +634,8 @@ ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
 	return -ENOMEM;
 }
 
-static const int tepdata_get_event_id(struct kshark_data_stream *stream,
-				      const struct kshark_entry *entry)
+static int tepdata_get_event_id(struct kshark_data_stream *stream,
+				const struct kshark_entry *entry)
 {
 	int event_id = KS_EMPTY_BIN;
 	struct tep_record *record;
@@ -727,8 +727,8 @@ static char *tepdata_get_event_name(struct kshark_data_stream *stream,
 	return buffer;
 }
 
-static const int tepdata_get_pid(struct kshark_data_stream *stream,
-				 const struct kshark_entry *entry)
+static int tepdata_get_pid(struct kshark_data_stream *stream,
+			   const struct kshark_entry *entry)
 {
 	struct tep_record *record;
 	int pid = KS_EMPTY_BIN;
@@ -1054,8 +1054,8 @@ static char *tepdata_dump_entry(struct kshark_data_stream *stream,
 	return entry_str;
 }
 
-static const int tepdata_find_event_id(struct kshark_data_stream *stream,
-				       const char *event_name)
+static int tepdata_find_event_id(struct kshark_data_stream *stream,
+				 const char *event_name)
 {
 	struct tep_event *event;
 	char *buffer, *system, *name;
diff --git a/src/libkshark.h b/src/libkshark.h
index 1514f33..97d3227 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -142,8 +142,8 @@ typedef char *(*stream_get_str_func) (struct kshark_data_stream *,
 				      const struct kshark_entry *);
 
 /** A function type to be used by the method interface of the data stream. */
-typedef const int (*stream_get_int_func) (struct kshark_data_stream *,
-					  const struct kshark_entry *);
+typedef int (*stream_get_int_func) (struct kshark_data_stream *,
+				    const struct kshark_entry *);
 
 /** A function type to be used by the method interface of the data stream. */
 typedef int (*stream_find_id_func) (struct kshark_data_stream *,
@@ -176,16 +176,16 @@ typedef kshark_event_field_format
 			    const char *);
 
 /** A function type to be used by the method interface of the data stream. */
-typedef const int (*stream_read_event_field) (struct kshark_data_stream *,
-					      const struct kshark_entry *,
-					      const char *,
-					      int64_t *);
+typedef int (*stream_read_event_field) (struct kshark_data_stream *,
+					const struct kshark_entry *,
+					const char *,
+					int64_t *);
 
 /** A function type to be used by the method interface of the data stream. */
-typedef const int (*stream_read_record_field) (struct kshark_data_stream *,
-					       void *,
-					       const char *,
-					       int64_t *);
+typedef int (*stream_read_record_field) (struct kshark_data_stream *,
+					 void *,
+					 const char *,
+					 int64_t *);
 
 struct kshark_context;
 
diff --git a/tests/test-input.c b/tests/test-input.c
index 31620b9..c6a5fa2 100644
--- a/tests/test-input.c
+++ b/tests/test-input.c
@@ -69,8 +69,8 @@ bool KSHARK_INPUT_CHECK(const char *file, char **format)
 	return false;
 }
 
-static const int get_pid(struct kshark_data_stream *stream,
-			 const struct kshark_entry *entry)
+static int get_pid(struct kshark_data_stream *stream,
+		   const struct kshark_entry *entry)
 {
 	return entry->pid;
 }
diff --git a/tests/test-input_ctrl.c b/tests/test-input_ctrl.c
index 3dcc92e..77abab1 100644
--- a/tests/test-input_ctrl.c
+++ b/tests/test-input_ctrl.c
@@ -71,8 +71,8 @@ bool KSHARK_INPUT_CHECK(const char *file, char **format)
 	return false;
 }
 
-static const int get_pid(struct kshark_data_stream *stream,
-			 const struct kshark_entry *entry)
+static int get_pid(struct kshark_data_stream *stream,
+		   const struct kshark_entry *entry)
 {
 	return entry->pid;
 }
-- 
2.43.0

