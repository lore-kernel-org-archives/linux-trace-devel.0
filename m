Received: from 7.mo548.mail-out.ovh.net (7.mo548.mail-out.ovh.net [46.105.33.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212C431A66
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.105.33.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706469925; cv=none; b=mD1C1wLlqNBLitcogQMOzdIPDrvn28Vs2MMErxRiF8b06ZVG47WRFqnjDZzSmA9wEvjn9/HjbNNPv0HJKQNTQmx2/5Ob3MfcOlJJeK9cc39j9eayZ3I5OWbzpD43kzL2cvIgvHZWFkyW3vLMfAf4cWAvv66OMEMYPutiW5+ZGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706469925; c=relaxed/simple;
	bh=yGwtjRQqpxrE0whNNQG7J08GSxIkD078+tGMYA9uKmg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cPBQjSZtGLVjZ9KGRQuSO6gTLzBly3nfJGwnFgLhumuzho7OgF2YSp6ppqTg+QM7TyvXOJKra8XVIu3k9aRrfk+IA+Mg4f7j2eP6d1c96DkejojCGiLIqgU0gOtJTCqm6BUUScPKM/669L4YNnB79DerxFcQ4+h6mhjU4EPH8vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=46.105.33.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.17.171])
	by mo548.mail-out.ovh.net (Postfix) with ESMTPS id 6B7DA20F31;
	Sun, 28 Jan 2024 19:25:13 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.97) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 28 Jan
 2024 20:25:12 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-97G002aba63841-86cf-4a2a-bd4f-cfa9e7db7622,
                    F6BBF12166BF17D31185B0BF3C367C102A143481) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH v2 24/34] kernelshark: Fix potential memory leaks in libkshark-tepdata
Date: Sun, 28 Jan 2024 20:24:59 +0100
Message-ID: <20240128192459.56260-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <a6f9937c-7f4a-558b-4f73-993ded8efe4e@gmail.com>
References: <a6f9937c-7f4a-558b-4f73-993ded8efe4e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG4EX2.mxp5.local (172.16.2.32) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: f149111e-baa7-4243-b590-c3726da01ea1
X-Ovh-Tracer-Id: 12256827863587119002
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddguddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnheptdehteffieekvdejgeduleehleekheehkefggfehhedtveejffejvdegtdevhfejnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdeljedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehgeekpdhmohguvgepshhmthhpohhuth

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
index 2d0fcb0..ea647f9 100644
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
+		goto end;
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
 
+end:
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

