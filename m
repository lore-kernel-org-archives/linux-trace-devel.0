Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271675397
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.17.201])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 5FDDC20465;
	Sun, 14 Jan 2024 17:17:41 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:40 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002c619219f-2ce2-4631-9106-44e180301dd7,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 20/34] kernelshark: Fix potential memory leaks in libkshark-configio
Date: Sun, 14 Jan 2024 18:17:09 +0100
Message-ID: <20240114171723.14092-21-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: e1855602-598b-4a92-8427-dccade22d7ec
X-Ovh-Tracer-Id: 1672242839095566234
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeefnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht

Allocate a new kshark_config_doc only if the format is supported.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/libkshark-configio.c | 74 ++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index 9a1ba60..853e056 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -675,23 +675,25 @@ struct kshark_config_doc *
 kshark_export_plugin_file(struct kshark_plugin_list *plugin,
 			  enum kshark_config_formats format)
 {
-	/*  Create a new Configuration document. */
-	struct kshark_config_doc *conf =
-		kshark_config_new("kshark.config.library", format);
-
-	if (!conf)
-		return NULL;
+	struct kshark_config_doc *conf;
 
 	switch (format) {
 	case KS_CONFIG_JSON:
-		kshark_plugin_to_json(plugin, conf->conf_doc);
-		return conf;
+		break;
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
-			conf->format);
+			format);
 		return NULL;
 	}
+
+	/*  Create a new Configuration document. */
+	conf = kshark_config_new("kshark.config.library", format);
+	if (!conf)
+		return NULL;
+
+	kshark_plugin_to_json(plugin, conf->conf_doc);
+	return conf;
 }
 
 static bool kshark_all_plugins_to_json(struct kshark_context *kshark_ctx,
@@ -739,22 +741,24 @@ struct kshark_config_doc *
 kshark_export_all_plugins(struct kshark_context *kshark_ctx,
 			  enum kshark_config_formats format)
 {
-	struct kshark_config_doc *conf =
-		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
-
-	if (!conf)
-		return NULL;
+	struct kshark_config_doc *conf;
 
 	switch (format) {
 	case KS_CONFIG_JSON:
-		kshark_all_plugins_to_json(kshark_ctx, conf->conf_doc);
-		return conf;
+		break;
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
-			conf->format);
+			format);
 		return NULL;
 	}
+
+	conf = kshark_config_new("kshark.config.plugins", format);
+	if (!conf)
+		return NULL;
+
+	kshark_all_plugins_to_json(kshark_ctx, conf->conf_doc);
+	return conf;
 }
 
 static bool kshark_plugin_from_json(struct kshark_context *kshark_ctx,
@@ -867,22 +871,24 @@ struct kshark_config_doc *
 kshark_export_stream_plugins(struct kshark_data_stream *stream,
 			     enum kshark_config_formats format)
 {
-	struct kshark_config_doc *conf =
-		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
-
-	if (!conf)
-		return NULL;
+	struct kshark_config_doc *conf;
 
 	switch (format) {
 	case KS_CONFIG_JSON:
-		kshark_stream_plugins_to_json(stream, conf->conf_doc);
-		return conf;
+		break;
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
-			conf->format);
+			format);
 		return NULL;
 	}
+
+	conf = kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+	if (!conf)
+		return NULL;
+
+	kshark_stream_plugins_to_json(stream, conf->conf_doc);
+	return conf;
 }
 
 static bool kshark_stream_plugins_from_json(struct kshark_context *kshark_ctx,
@@ -1019,23 +1025,25 @@ struct kshark_config_doc *
 kshark_export_model(struct kshark_trace_histo *histo,
 		    enum kshark_config_formats format)
 {
-	/*  Create a new Configuration document. */
-	struct kshark_config_doc *conf =
-		kshark_config_new("kshark.config.model", format);
-
-	if (!conf)
-		return NULL;
+	struct kshark_config_doc *conf;
 
 	switch (format) {
 	case KS_CONFIG_JSON:
-		kshark_model_to_json(histo, conf->conf_doc);
-		return conf;
+		break;
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			format);
 		return NULL;
 	}
+
+	/*  Create a new Configuration document. */
+	conf = kshark_config_new("kshark.config.model", format);
+	if (!conf)
+		return NULL;
+
+	kshark_model_to_json(histo, conf->conf_doc);
+	return conf;
 }
 
 static bool kshark_model_from_json(struct kshark_trace_histo *histo,
-- 
2.43.0

