Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D49C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 13:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F1761155
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Aug 2021 13:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbhHENeu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Aug 2021 09:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbhHENet (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Aug 2021 09:34:49 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E11EC061765
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Aug 2021 06:34:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l18so6594304wrv.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Aug 2021 06:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i2H4wpRx0wJUzv3eEjGTSHgcJ1CIjxFeb0CK+qzl27A=;
        b=BthodyvAmP5sk3RCb9UOcFTepZRO0JrKMJDXWpDvK47h2ohuLrIldj6YUPIzwoas+1
         Erh3KNssfC6DMaeu0/sMUk9spdqT2t9lDu1IbN4KtJ+SCMnpwWKtWKDY2L3M207zMms+
         cOMN0qQRuxRyJjHN8DBuZJ/XRf6he2AbenhnYRM7IIi+dTsDC2YXvkPwwvH0k/wnGX5G
         Hr2Upjymf5rFKXWdCKqd41h7INjyiWQpsR3elUy+lmeTL9R54R0+Yc6Fr2c9OATIMQum
         UDCdUSl3E5yIMdQT+iFNWpffAZCfS/vd8OM7gXk2SGp3tpujXe69Z/QlvaRZL0Pb6cZx
         JI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i2H4wpRx0wJUzv3eEjGTSHgcJ1CIjxFeb0CK+qzl27A=;
        b=T3apLehxDh0F202fi5lD7Oft2E/q4HUHbY1cDg1muJDMSghwSK8/ZxX/E4zRBPF0Dx
         f7lHRACIGKPDpbUGRneBAD8htHw62cIXCgFByS1UHow0e2fqiHw8smQ7aHm0qFFTCLyT
         WoaCp1h7BDKQ5UnBpErKF5NW0ij1ruH1I6FLh83fsEYnfw37CifvT8nhat5fw+8a5hh7
         T5R1y0HUnlVsIaBzXMlPykTTLd9dTqeyFilceSPncTgZiSp2MPh6t02uC/kVnpZIW/Wu
         bJ8dHTkHde2A5S2vW2LrQvq97Dj3kacZ2M0zhh4pbe0/rwIJa721P1b2Xzv12tY1alNM
         7Ieg==
X-Gm-Message-State: AOAM531rlh9I5JMzI23iQymhJfnfecI9QX7WnQt0ZN9JHa8WUb3anSG3
        GJsVdI9IcBSGEf5KqAukMR8=
X-Google-Smtp-Source: ABdhPJzJFlzO3RWQOx604ysdwL7kMOpTyPR0NG69543yAtbLWR83q71SplSX9AqbHU3U18/TNkjAZQ==
X-Received: by 2002:a05:6000:1106:: with SMTP id z6mr5438269wrw.296.1628170474062;
        Thu, 05 Aug 2021 06:34:34 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id x12sm6397950wrt.35.2021.08.05.06.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 06:34:33 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 1/2] libtraceevent: Add dynamic_offset()
Date:   Thu,  5 Aug 2021 16:34:18 +0300
Message-Id: <20210805133419.50802-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
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

