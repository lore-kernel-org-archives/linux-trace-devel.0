Received: from 2.mo548.mail-out.ovh.net (2.mo548.mail-out.ovh.net [178.33.255.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65132E401
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 19:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.33.255.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706469955; cv=none; b=ginB+m0+d4KWC6bc3P3A4xkeyZw1A/VX1Y2jkFdWerVwsh1MQo2V8N61Y6yUP+87z4UCopxQ+Le2dodsRQsmsrEP2bMl70n29cEWsgPBT5/YI0l/by37UM7naeiLG8xAIZmECMS+ixpIbjcaoTPZGB8HpM556MNP/Fs9yT9COlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706469955; c=relaxed/simple;
	bh=+sTxfy8pSylwvtWNBeJPiw3AfQcwIVJ5cvPWCRqdqy0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtIj3114olIDgda5GnMTJbVBPKbiHpqt9jPMBkftGbTT2ctFNqbtIb6VOlL2HT2IXl4bek8C3heEDKLOAR6RKSEnuIZnRRlrox5VB9mPCEmHRHUEHK8lKyu/GcolNvh6uiSkZDZUaNsRhR9fVaJyfhn7jd25MShGC0GXIdXSnXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=178.33.255.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.22])
	by mo548.mail-out.ovh.net (Postfix) with ESMTPS id BA1FB21476;
	Sun, 28 Jan 2024 19:25:50 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.107) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 28 Jan
 2024 20:25:50 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-107S001e2502754-dc9d-49bf-a1be-6e198acd4542,
                    F6BBF12166BF17D31185B0BF3C367C102A143481) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH v2 20/34] kernelshark: Fix potential memory leaks in libkshark-configio
Date: Sun, 28 Jan 2024 20:25:39 +0100
Message-ID: <20240128192539.56331-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <d1529d10-861c-6fe9-c27b-722405895ae0@gmail.com>
References: <d1529d10-861c-6fe9-c27b-722405895ae0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG8EX2.mxp5.local (172.16.2.72) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 50924710-8f80-401f-ad0c-cd819b7c81ce
X-Ovh-Tracer-Id: 12267242436884258714
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddguddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnheptdehteffieekvdejgeduleehleekheehkefggfehhedtveejffejvdegtdevhfejnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdejpdelvddrudeiuddruddviedrgeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegkedpmhhouggvpehsmhhtphhouhht

Free previously allocated kshark_config_doc if format is not supported.

Also allow to call kshark_export_*() functions that allocate a new
kshark_config_doc with format equal to KS_CONFIG_AUTO.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/libkshark-configio.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index 9a1ba60..3a0e979 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -515,7 +515,7 @@ kshark_export_trace_file(const char *file, const char *name,
 	if (!conf)
 		return NULL;
 
-	switch (format) {
+	switch (conf->format) {
 	case KS_CONFIG_JSON:
 		kshark_trace_file_to_json(file, name, conf->conf_doc);
 		return conf;
@@ -523,6 +523,7 @@ kshark_export_trace_file(const char *file, const char *name,
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			conf->format);
+		kshark_free_config_doc(conf);
 		return NULL;
 	}
 }
@@ -682,7 +683,7 @@ kshark_export_plugin_file(struct kshark_plugin_list *plugin,
 	if (!conf)
 		return NULL;
 
-	switch (format) {
+	switch (conf->format) {
 	case KS_CONFIG_JSON:
 		kshark_plugin_to_json(plugin, conf->conf_doc);
 		return conf;
@@ -690,6 +691,7 @@ kshark_export_plugin_file(struct kshark_plugin_list *plugin,
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			conf->format);
+		kshark_free_config_doc(conf);
 		return NULL;
 	}
 }
@@ -740,12 +742,12 @@ kshark_export_all_plugins(struct kshark_context *kshark_ctx,
 			  enum kshark_config_formats format)
 {
 	struct kshark_config_doc *conf =
-		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+		kshark_config_new("kshark.config.plugins", format);
 
 	if (!conf)
 		return NULL;
 
-	switch (format) {
+	switch (conf->format) {
 	case KS_CONFIG_JSON:
 		kshark_all_plugins_to_json(kshark_ctx, conf->conf_doc);
 		return conf;
@@ -753,6 +755,7 @@ kshark_export_all_plugins(struct kshark_context *kshark_ctx,
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			conf->format);
+		kshark_free_config_doc(conf);
 		return NULL;
 	}
 }
@@ -868,12 +871,12 @@ kshark_export_stream_plugins(struct kshark_data_stream *stream,
 			     enum kshark_config_formats format)
 {
 	struct kshark_config_doc *conf =
-		kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+		kshark_config_new("kshark.config.plugins", format);
 
 	if (!conf)
 		return NULL;
 
-	switch (format) {
+	switch (conf->format) {
 	case KS_CONFIG_JSON:
 		kshark_stream_plugins_to_json(stream, conf->conf_doc);
 		return conf;
@@ -881,6 +884,7 @@ kshark_export_stream_plugins(struct kshark_data_stream *stream,
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
 			conf->format);
+		kshark_free_config_doc(conf);
 		return NULL;
 	}
 }
@@ -1026,14 +1030,15 @@ kshark_export_model(struct kshark_trace_histo *histo,
 	if (!conf)
 		return NULL;
 
-	switch (format) {
+	switch (conf->format) {
 	case KS_CONFIG_JSON:
 		kshark_model_to_json(histo, conf->conf_doc);
 		return conf;
 
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
-			format);
+			conf->format);
+		kshark_free_config_doc(conf);
 		return NULL;
 	}
 }
-- 
2.43.0

