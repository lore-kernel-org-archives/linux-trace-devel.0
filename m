Received: from 7.mo552.mail-out.ovh.net (7.mo552.mail-out.ovh.net [188.165.59.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92FA5251
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.140.245])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id D7D0B29EAE;
	Sun, 14 Jan 2024 17:17:42 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:42 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002269d7859-3cad-4d88-8f90-67f7b8c7acdd,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 24/34] kernelshark: Fix potential memory leaks in libkshark-tepdata
Date: Sun, 14 Jan 2024 18:17:13 +0100
Message-ID: <20240114171723.14092-25-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 04f7ab3d-a3cf-48d4-b239-23f1f1ccd309
X-Ovh-Tracer-Id: 1672524314568384410
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth

- In tepdata_get_field_names(), buffer was never free on error
- In kshark_tep_open_buffer(), names were never free if
  kshark_get_data_stream() failed
- In kshark_tep_open_buffer(), prevent any double free error with
  "name" and "file" fields of buffer_stream
- In kshark_tep_init_all_buffers(), return failure code if failed to
  copy "name" and "file" fields of buffer_stream

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/libkshark-tepdata.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 2d0fcb0..d15c155 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -949,6 +949,7 @@ static int tepdata_get_field_names(struct kshark_data_stream *stream,
 	for (i = 0; i < nr_fields; ++i)
 		free(buffer[i]);
 
+	free(buffer);
 	return -EFAULT;
 }
 
@@ -1424,8 +1425,10 @@ int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
 
 	sd_buffer = kshark_add_stream(kshark_ctx);
 	buffer_stream = kshark_get_data_stream(kshark_ctx, sd_buffer);
-	if (!buffer_stream)
-		return -EFAULT;
+	if (!buffer_stream) {
+		ret = -EFAULT;
+		goto fail;
+	}
 
 	for (i = 0; i < n_buffers; ++i) {
 		if (strcmp(buffer_name, names[i]) == 0) {
@@ -1438,7 +1441,8 @@ int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
 			if (!buffer_stream->name || !buffer_stream->file) {
 				free(buffer_stream->name);
 				free(buffer_stream->file);
-
+				buffer_stream->name = NULL;
+				buffer_stream->file = NULL;
 				ret = -ENOMEM;
 				break;
 			}
@@ -1449,6 +1453,7 @@ int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
 		}
 	}
 
+fail:
 	for (i = 0; i < n_buffers; ++i)
 		free(names[i]);
 	free(names);
@@ -1500,8 +1505,9 @@ int kshark_tep_init_all_buffers(struct kshark_context *kshark_ctx,
 		if (!buffer_stream->name || !buffer_stream->file) {
 			free(buffer_stream->name);
 			free(buffer_stream->file);
-			ret = -ENOMEM;
-			break;
+			buffer_stream->name = NULL;
+			buffer_stream->file = NULL;
+			return -ENOMEM;
 		}
 
 		ret = kshark_tep_stream_init(buffer_stream, buffer_input);
-- 
2.43.0

