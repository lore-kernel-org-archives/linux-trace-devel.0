Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E2BC00528
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 19:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjG1TFq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjG1TFo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 15:05:44 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3AF3AB9
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:05:42 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-348fac49ef1so6803545ab.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690571142; x=1691175942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LdH3/AbrasPZEt7KrIB8Ff8OpN57OVIxmlHAZKL3EfU=;
        b=NLTfTjOOodC9edY/h2aNA512Dt5/ncs4IIMAJHopiAX7QnWqYVAn9lp6Vq7GUOi2zf
         Qfyat3J1+CpsnbKoFvhVK/7bGh5KgLHLrkoL3OEGOmUYRLJX5GDbSYSyW1jn261/NeDL
         hFtwQnD/jViuyb7twBZrrHAqJ+QcvZ31MswB0L9ZxxBEQJ3AhHcbbXYlOvahe/kagmnl
         gRUaEd2K+oOTizRFLOV5acsI80tKUhUmBj9a5ISGI4P3JPKxP4+YGbrnQ1g4mf27Q2l8
         hNt5pUceiq/UILPFFD/bgsnxlBF4gzScL6iE626yyH4BpuVdcqXYhFKizDLRLKPputS+
         OJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690571142; x=1691175942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LdH3/AbrasPZEt7KrIB8Ff8OpN57OVIxmlHAZKL3EfU=;
        b=fLJc3agiJUNd0+JKFWTcF+paTLlNoIV0l7Dzlp7NRX91s614DGTApOzGEnGfId5kDz
         yCJEng8XyB2ISKjITXT+PNN0OCRidAdVg9PGqbLsQGI9QC6wB4GSMfZE8K6uaTltZOBK
         q0mM//ruu/B9dODN9Ev3TbvaOgeciraaVXBJ96BfXIa2A5cd4a2AmQXiV7/eNFaaqMK1
         7M1azyXX2qCv6VmsgFf5XR/TaKwsSN7cOjrEJ7Ed1IYi0saJSr7Q3wR0xhnUa7EvQfIz
         ov1GUymGsvZgPFC3TYQTx/TkBLPFIhwdCm3HJA7btYKaANZ6Tdn9NXHxG4VBqDW22Mq2
         A99A==
X-Gm-Message-State: ABy/qLa7e9MSKq4NQ9aF0KDfswDmtiL1eddCj3jBD++LM+EM4hgTeOF4
        ocKj6ylVQ6WdoXvBqc5AtKO4IAQdicJE7A==
X-Google-Smtp-Source: APBJJlG9iFqxrH9dY3ri1pQcNdiBsWX8QnZAQDPKndS8MP44P7/IabGI21hlWIaa6Jmq5ZWuqMMuBg==
X-Received: by 2002:a05:6e02:2142:b0:348:987a:fd8c with SMTP id d2-20020a056e02214200b00348987afd8cmr391169ilv.31.1690571141879;
        Fri, 28 Jul 2023 12:05:41 -0700 (PDT)
Received: from localhost.localdomain ([2a00:79e1:abc:1705:d317:f8ec:adf0:bb06])
        by smtp.gmail.com with ESMTPSA id u22-20020a02aa96000000b0042b3a328ee0sm1268452jai.166.2023.07.28.12.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 12:05:41 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH 4/5] histograms: traceeval compare
Date:   Fri, 28 Jul 2023 15:04:39 -0400
Message-ID: <20230728190515.23088-4-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728190515.23088-1-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

traceeval_compare() compares two struct traceeval instances for
equality. This suite of comparitors was made for testing purposes.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 src/histograms.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 176 insertions(+), 2 deletions(-)

diff --git a/src/histograms.c b/src/histograms.c
index f46a0e0..5f1c7ef 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -20,6 +20,19 @@
 #define for_each_key(i, keys)	\
 	for (i = 0; (keys)[(i)].type != TRACEEVAL_TYPE_NONE; (i)++)
 
+/**
+ * Compare two integers of variable length.
+ *
+ * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
+ * if @b is greater than @a.
+ */
+#define compare_numbers_return(a, b)	\
+do {					\
+	if ((a) < (b))			\
+		return -1;		\
+	return (a) != (b);		\
+} while (0)				\
+
 /** A key-value pair */
 struct entry {
 	union traceeval_data	*keys;
@@ -56,10 +69,171 @@ static void print_err(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
-// TODO
+/**
+ * Return 0 if @orig and @copy are the same, 1 otherwise.
+ */
+static int compare_traceeval_type(struct traceeval_type *orig,
+		struct traceeval_type *copy)
+{
+	int o_name_null;
+	int c_name_null;
+
+	// same memory/null
+	if (orig == copy)
+		return 0;
+
+	size_t i = 0;
+	do {
+		if (orig[i].type != copy[i].type)
+			return 1;
+		if (orig[i].type == TRACEEVAL_TYPE_NONE)
+			return 0;
+		if (orig[i].flags != copy[i].flags)
+			return 1;
+		if (orig[i].id != copy[i].id)
+			return 1;
+		if (orig[i].dyn_release != copy[i].dyn_release)
+			return 1;
+		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
+			return 1;
+
+		// make sure both names are same type
+		o_name_null = !orig[i].name;
+		c_name_null = !copy[i].name;
+		if (o_name_null != c_name_null)
+			return 1;
+		if (o_name_null)
+			continue;
+		if (strcmp(orig[i].name, copy[i].name) != 0)
+			return 1;
+	} while (orig[i++].type != TRACEEVAL_TYPE_NONE);
+
+	return 0;
+}
+
+/**
+ * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
+ * -1 for the other way around, and -2 on error.
+ */
+static int compare_traceeval_data(union traceeval_data *orig,
+		const union traceeval_data *copy, struct traceeval_type *type)
+{
+	if (!orig || !copy)
+		return 1;
+
+	switch (type->type) {
+	case TRACEEVAL_TYPE_NONE:
+		/* There is no corresponding traceeval_data for TRACEEVAL_TYPE_NONE */
+		return -2;
+
+	case TRACEEVAL_TYPE_STRING:
+		int i = strcmp(orig->string, copy->string);
+		if (!i)
+			return 0;
+		if (i > 0)
+			return 1;
+		return -1;
+
+	case TRACEEVAL_TYPE_NUMBER:
+		compare_numbers_return(orig->number, copy->number);
+
+	case TRACEEVAL_TYPE_NUMBER_64:
+		compare_numbers_return(orig->number_64, copy->number_64);
+
+	case TRACEEVAL_TYPE_NUMBER_32:
+		compare_numbers_return(orig->number_32, copy->number_32);
+
+	case TRACEEVAL_TYPE_NUMBER_16:
+		compare_numbers_return(orig->number_16, copy->number_16);
+
+	case TRACEEVAL_TYPE_NUMBER_8:
+		compare_numbers_return(orig->number_8, copy->number_8);
+
+	case TRACEEVAL_TYPE_DYNAMIC:
+		return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
+
+	default:
+		print_err("%d is out of range of enum traceeval_data_type", type->type);
+		return -2;
+	}
+}
+
+/**
+ * Compare arrays fo union traceeval_data's with respect to @def.
+ *
+ * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
+ */
+static int compare_traceeval_data_set(union traceeval_data *orig,
+		const union traceeval_data *copy, struct traceeval_type *def)
+{
+	int i = 0;
+	int check;
+
+	// compare data arrays
+	for_each_key(i, def) {
+		if ((check = compare_traceeval_data(&orig[i], &copy[i], &def[i])))
+			goto fail_compare_data_set;
+	}
+
+	return 0;
+fail_compare_data_set:
+	if (check == -2)
+		return -1;
+	return 1;
+}
+
+/**
+ * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
+ */
+static int compare_entries(struct entry *orig, struct entry *copy,
+		struct traceeval *teval)
+{
+	int check;
+
+	// compare keys
+	check = compare_traceeval_data_set(orig->keys, copy->keys,
+			teval->def_keys);
+	if (check)
+		return check;
+
+	// compare values
+	check = compare_traceeval_data_set(orig->vals, copy->vals,
+			teval->def_vals);
+	return check;
+}
+
+/**
+ * Return 0 if struct hist_table of @orig and @copy are the same, 1 if not,
+ * and -1 on error.
+ */
+static int compare_hist(struct traceeval *orig, struct traceeval *copy)
+{
+	struct hist_table *o_hist = orig->hist;
+	struct hist_table *c_hist = copy->hist;
+	int cnt = !(o_hist->nr_entries == c_hist->nr_entries);
+	if (cnt)
+		return 1;
+
+	for (size_t i = 0; i < o_hist->nr_entries; i++) {
+		// cmp each entry
+		compare_entries(&o_hist->map[i], &c_hist->map[i], orig);
+	}
+	return 0;	
+}
+
+/**
+ * Return 0 if @orig and @copy are the same, 1 if not, -1 if error.
+ */
 int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
 {
-	return -1;
+	if ((!orig) || (!copy))
+		return -1;
+
+	int keys = compare_traceeval_type(orig->def_keys, copy->def_keys);
+	int vals = compare_traceeval_type(orig->def_vals, copy->def_vals);
+	int hists = compare_hist(orig, copy);
+
+	return (keys || vals || hists);
 }
 
 /**
-- 
2.41.0

