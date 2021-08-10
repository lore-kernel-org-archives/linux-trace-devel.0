Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44278C432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D9460F56
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 12:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhHJM1f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbhHJM1f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 08:27:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B07CC0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u3so35150705ejz.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Aug 2021 05:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2H4wpRx0wJUzv3eEjGTSHgcJ1CIjxFeb0CK+qzl27A=;
        b=lZel7iOhiETUwMBaYNiTP7jO5tqq0KkdPSWNQjPo6UcJGC1CGe6XULDCNWgbseAZCJ
         mXi313164o6PsrpGjDkeOV7NNdWsRlOTY7suyZqm1jL5QItToCNLJbxQUXoy/Lu6PsE5
         SBpqwHBAJNTrHvBRn1RvMqLxZfhMTxd3WM+bASIQVKZ5dyamDISND6kAznayRaGgll38
         cPm4LiCyRbjSf1Hf9QNh06ZlS2IdzVBtIQC3S0DJvL3QdiG/6bMYzxxNeB86mreYWvJl
         HrXAwsKPqY0xKT0a7EYo7Jb02eH3L3/bulZ0Wn5MmP73V+QSfp04LDjJVmTHaM4Xwm/b
         eYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2H4wpRx0wJUzv3eEjGTSHgcJ1CIjxFeb0CK+qzl27A=;
        b=LHfoALQZZcaJNoPQgJOYXEepBcFsAMEacTo7URyLLh1xjGljHvc6CD/+KRC9/2kX8V
         G2r5g2HXe8RjV1RpWqroIcMcv242vRK2BxObWLTwEeQwZB0mF+WO+Zl1cI3UABB05cRC
         NwvlZKibZw3ZZzP33A4b6IpfyqnCtugaFxVoAmSCgqOeekhsDuYmO9ipqm4Opt7AWJRa
         tGrwJ0tCUy/zDltvKvcrlSBW9DOA0Z2mGTJbv3ZvTUQ+bOvsxR0ivItALg046ErQkiaw
         H/M68ruufBcgomUwU35n3dsGdgpqVS05I7FLU3f5Va4vE5DHYPnfa3sNE+BOg6RjLPF+
         N+zg==
X-Gm-Message-State: AOAM530PN+tLCeWBnnYo9Ms6xA/4idqPjPqse9NkXE3ko6fptQNTu7mN
        W620Gcwh8lBHPZNFM/IwsPU=
X-Google-Smtp-Source: ABdhPJzokxbZhKOVOGv3nRzBuPo7Q8fVwLEYqgDC1BxzhlxVU6pGHudjarqCsISrS7kMunR3+Qw3jw==
X-Received: by 2002:a17:906:2809:: with SMTP id r9mr27239456ejc.463.1628598431566;
        Tue, 10 Aug 2021 05:27:11 -0700 (PDT)
Received: from crow.. ([95.87.199.76])
        by smtp.gmail.com with ESMTPSA id ks20sm1074501ejb.101.2021.08.10.05.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:27:11 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 1/5] libtraceevent: Add dynamic_offset()
Date:   Tue, 10 Aug 2021 15:26:55 +0300
Message-Id: <20210810122659.145759-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810122659.145759-1-y.karadz@gmail.com>
References: <20210810122659.145759-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The total allocated length of the dynamic array is stored in the top half
of the corresponding 32 bit field and the offset is in the bottom half of
the same field. Since the decoding of the length and offset is performed
in multiple locations is the code, we define a static helper function to
replace/cleanup the existing open coded conversions.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/event-parse.c | 134 ++++++++++++++++++++++------------------------
 1 file changed, 63 insertions(+), 71 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index f42ae38..fd6d916 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3858,6 +3858,36 @@ static unsigned long long test_for_symbol(struct tep_handle *tep,
 	return val;
 }
 
+#define TEP_OFFSET_LEN_MASK		0xffff
+#define TEP_LEN_SHIFT			16
+
+static void dynamic_offset(struct tep_handle *tep, int size, void *data,
+			   unsigned int *offset, unsigned int *len)
+{
+	unsigned long long val;
+
+	/*
+	 * The total allocated length of the dynamic array is
+	 * stored in the top half of the field and the offset
+	 * is in the bottom half of the 32 bit field.
+	 */
+	val = tep_read_number(tep, data, size);
+
+	if (offset)
+		*offset = (unsigned int)(val & TEP_OFFSET_LEN_MASK);
+	if (len)
+		*len = (unsigned int)((val >> TEP_LEN_SHIFT) & TEP_OFFSET_LEN_MASK);
+}
+
+static inline void dynamic_offset_field(struct tep_handle *tep,
+					struct tep_format_field *field,
+					void *data,
+					unsigned int *offset,
+					unsigned int *len)
+{
+	dynamic_offset(tep, field->size, data + field->offset, offset, len);
+}
+
 static unsigned long long
 eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg *arg)
 {
@@ -3866,7 +3896,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 	unsigned long long left, right;
 	struct tep_print_arg *typearg = NULL;
 	struct tep_print_arg *larg;
-	unsigned long offset;
+	unsigned int offset;
 	unsigned int field_size;
 
 	switch (arg->type) {
@@ -3930,18 +3960,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 
 			switch (larg->type) {
 			case TEP_PRINT_DYNAMIC_ARRAY:
-				offset = tep_read_number(tep,
-						   data + larg->dynarray.field->offset,
-						   larg->dynarray.field->size);
+				dynamic_offset_field(tep, larg->dynarray.field, data,
+						     &offset, NULL);
+				offset += right;
 				if (larg->dynarray.field->elementsize)
 					field_size = larg->dynarray.field->elementsize;
-				/*
-				 * The actual length of the dynamic array is stored
-				 * in the top half of the field, and the offset
-				 * is in the bottom half of the 32 bit field.
-				 */
-				offset &= 0xffff;
-				offset += right;
 				break;
 			case TEP_PRINT_FIELD:
 				if (!larg->field.field) {
@@ -4060,27 +4083,14 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		}
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
-		offset = tep_read_number(tep,
-					 data + arg->dynarray.field->offset,
-					 arg->dynarray.field->size);
-		/*
-		 * The total allocated length of the dynamic array is
-		 * stored in the top half of the field, and the offset
-		 * is in the bottom half of the 32 bit field.
-		 */
-		val = (unsigned long long)(offset >> 16);
+		dynamic_offset_field(tep, arg->dynarray.field, data,
+				     NULL, &field_size);
+		val = (unsigned long long) field_size;
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
-		offset = tep_read_number(tep,
-					 data + arg->dynarray.field->offset,
-					 arg->dynarray.field->size);
-		/*
-		 * The total allocated length of the dynamic array is
-		 * stored in the top half of the field, and the offset
-		 * is in the bottom half of the 32 bit field.
-		 */
-		offset &= 0xffff;
+		dynamic_offset_field(tep, arg->dynarray.field, data,
+				     &offset, NULL);
 		val = (unsigned long long)((unsigned long)data + offset);
 		break;
 	default: /* not sure what to do there */
@@ -4209,12 +4219,13 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	struct tep_print_flag_sym *flag;
 	struct tep_format_field *field;
 	struct printk_map *printk;
+	unsigned int offset, len;
 	long long val, fval;
 	unsigned long long addr;
 	char *str;
 	unsigned char *hex;
 	int print;
-	int i, len;
+	int i;
 
 	switch (arg->type) {
 	case TEP_PRINT_NULL:
@@ -4318,11 +4329,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_HEX:
 	case TEP_PRINT_HEX_STR:
 		if (arg->hex.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
-			unsigned long offset;
-			offset = tep_read_number(tep,
-				data + arg->hex.field->dynarray.field->offset,
-				arg->hex.field->dynarray.field->size);
-			hex = data + (offset & 0xffff);
+			dynamic_offset_field(tep, arg->hex.field->dynarray.field, data,
+				             &offset, NULL);
+			hex = data + offset;
 		} else {
 			field = arg->hex.field->field.field;
 			if (!field) {
@@ -4347,13 +4356,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		int el_size;
 
 		if (arg->int_array.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
-			unsigned long offset;
-			struct tep_format_field *field =
-				arg->int_array.field->dynarray.field;
-			offset = tep_read_number(tep,
-						 data + field->offset,
-						 field->size);
-			num = data + (offset & 0xffff);
+			dynamic_offset_field(tep, arg->int_array.field->dynarray.field, data,
+					     &offset, NULL);
+			num = data + offset;
 		} else {
 			field = arg->int_array.field->field.field;
 			if (!field) {
@@ -4393,42 +4398,33 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_TYPE:
 		break;
 	case TEP_PRINT_STRING: {
-		int str_offset;
-		int len;
-
 		if (arg->string.offset == -1) {
 			struct tep_format_field *f;
 
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
-		str_offset = data2host4(tep, *(unsigned int *)(data + arg->string.offset));
-		len = (str_offset >> 16) & 0xffff;
+		dynamic_offset(tep, 4, data + arg->string.offset, &offset, &len);
 		/* Do not attempt to save zero length dynamic strings */
 		if (!len)
 			break;
-		str_offset &= 0xffff;
-		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
+		offset &= TEP_OFFSET_LEN_MASK;
+		print_str_to_seq(s, format, len_arg, ((char *)data) + offset);
 		break;
 	}
 	case TEP_PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
 	case TEP_PRINT_BITMASK: {
-		int bitmask_offset;
-		int bitmask_size;
-
 		if (arg->bitmask.offset == -1) {
 			struct tep_format_field *f;
 
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
-		bitmask_size = bitmask_offset >> 16;
-		bitmask_offset &= 0xffff;
+		dynamic_offset(tep, 4, data + arg->bitmask.offset, &offset, &len);
 		print_bitmask_to_seq(tep, s, format, len_arg,
-				     data + bitmask_offset, bitmask_size);
+				     data + offset, len);
 		break;
 	}
 	case TEP_PRINT_OP:
@@ -5271,13 +5267,12 @@ static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
 			      void *data, int size, struct tep_event *event,
 			      struct tep_print_arg *arg, int print_len)
 {
+	unsigned int offset, arr_len;
 	int plen = print_len;
 	char *delim = " ";
 	int ret = 0;
 	char *buf;
 	int i;
-	unsigned long offset;
-	int arr_len;
 
 	switch (*(ptr + 1)) {
 	case 'C':
@@ -5304,11 +5299,9 @@ static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
 		return ret;
 	}
 
-	offset = tep_read_number(event->tep,
-				 data + arg->dynarray.field->offset,
-				 arg->dynarray.field->size);
-	arr_len = (unsigned long long)(offset >> 16);
-	buf = data + (offset & 0xffff);
+	dynamic_offset_field(event->tep, arg->dynarray.field, data,
+			     &offset, &arr_len);
+	buf = data + offset;
 
 	if (arr_len < plen)
 		plen = arr_len;
@@ -5336,19 +5329,18 @@ static int is_printable_array(char *p, unsigned int len)
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field)
 {
-	unsigned long long val;
-	unsigned int offset, len, i;
 	struct tep_handle *tep = field->event->tep;
+	unsigned int offset, len, i;
+	unsigned long long val;
 
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
-		offset = field->offset;
-		len = field->size;
 		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-			val = tep_read_number(tep, data + offset, len);
-			offset = val;
-			len = offset >> 16;
-			offset &= 0xffff;
+			dynamic_offset_field(tep, field, data, &offset, &len);
+		} else {
+			offset = field->offset;
+			len = field->size;
 		}
+
 		if (field->flags & TEP_FIELD_IS_STRING &&
 		    is_printable_array(data + offset, len)) {
 			trace_seq_printf(s, "%s", (char *)data + offset);
-- 
2.30.2

