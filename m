Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244E4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Nov 2022 14:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiKPOr4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 09:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiKPOrz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 09:47:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690383E0A0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 06:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668610022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tQJ3wH4H9PRF35Xm9OuZm6JIiOqk2qx2m80xxYq+r7Q=;
        b=KzoMXkwFlaJtT/KirObcVpw7chAZKkWE1Bp3GLYwU5y0aNHN+DYOrxVJ/1NgRMDPhS5mEE
        z+6OC28fyXobeN9pVvrM3L7o8R87a+E0GWCLUdJNH39Nkrk9CBIff6JCAl+w4JR9jr3dY2
        ZYLanDEQpwPcXvwkV/Jo7k58uUO4RDA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-RmXd3fmdMvCS9QN_Yp1VSQ-1; Wed, 16 Nov 2022 09:46:57 -0500
X-MC-Unique: RmXd3fmdMvCS9QN_Yp1VSQ-1
Received: by mail-qk1-f200.google.com with SMTP id bk30-20020a05620a1a1e00b006fb2378c857so16663820qkb.18
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Nov 2022 06:46:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQJ3wH4H9PRF35Xm9OuZm6JIiOqk2qx2m80xxYq+r7Q=;
        b=InOrdhVw9rQ8Ax49imyuvqHoW3wdyVHcYkBEfzeKhBR4gCwUwjQvxha/NgryArMFc6
         lnTzsXDv/srx0quoklX0AJkB17TEGdX6ErGUEY51Vs/eVUqcJ/JlkcpU78YhL5fCu3WJ
         3HbFvjdb9EBPRDN/OMItE22e0vNK5twKr+ua8Nt5YDQzA94ifM8zWOOwdIutLgz/R9P0
         9POqYAO800cZwLVGj0UB790eMbDNiYM5eQ7NTQrC7Tybj8m9aNzAT4AV3rz8RGkO5V8m
         51rZChq0pLPOcop0CM+5DKzp6srRN5JK1idweG12IrKIz/FzZzU9g/tVXJbfp8IzY2Wh
         WcXQ==
X-Gm-Message-State: ANoB5pm+tY/bOP6ytOTPpDV780KjgvwXJlgo5vknuxmOlH1QLSLy8YZK
        uIozQv/9gwdjUcu0RJbcBJAx7MJQRjqclF9Q8gFQsyqWQXZs0c1JbUMhU7R4PieQGPYixzPNWkP
        1txe7PrbkAQdKOlybHsIP5hD8DKk0cHSzrzicKunor095PngsoOPqV0F3coxh9noVuj8OoRl/9L
        HNY5gY8MU=
X-Received: by 2002:ac8:7dc1:0:b0:3a5:211f:1f2c with SMTP id c1-20020ac87dc1000000b003a5211f1f2cmr21709028qte.241.1668610016636;
        Wed, 16 Nov 2022 06:46:56 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6RNnVOxSGzAVBv1YWfwM9ukca55wtOp8xrtiCLwW+CPvkWHoD5qtlDqq1o3MCo/y07jz62Mg==
X-Received: by 2002:ac8:7dc1:0:b0:3a5:211f:1f2c with SMTP id c1-20020ac87dc1000000b003a5211f1f2cmr21708994qte.241.1668610016292;
        Wed, 16 Nov 2022 06:46:56 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id c22-20020ac87dd6000000b003a55fe9f352sm8916953qte.64.2022.11.16.06.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 06:46:55 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v2 2/2] libtraceevent: Pretty-print cpumask fields as a cpulist
Date:   Wed, 16 Nov 2022 14:46:46 +0000
Message-Id: <20221116144646.3664012-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221116144154.3662923-1-vschneid@redhat.com>
References: <20221116144154.3662923-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now that we can denote which bitmasks are cpumasks, it makes sense to
pretty-print them to a more user-friendly format: a cpulist.

There's two hurdles to that:
1) Estimating the required string buffer size.

   I've tried to condense it down to an estimator function that is
   computationally simple enough, though it overestimates by ~1/3.

   For reference, this estimates:
   180 bytes for NR_CPUS=64  (x86 defconfig)
   911 bytes for NR_CPUS=256 (arm64 defconfig)

2) Iterating through the bits and bytes.

   The kernel has a collection of carefully crafted bitmask iterators which
   make this relatively simple (cf. bitmap_list_string()), but I didn't
   feel justified in importing half a dozen helpers just for one function.
   I've implemented a "homegrown" byte-parsing logic which isn't the
   fastest, but is at least condensed to a single function.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 src/event-parse.c | 168 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 167 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index f447708..5e597f6 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4454,6 +4454,161 @@ static void print_bitmask_to_seq(struct tep_handle *tep,
 	free(str);
 }
 
+#define log10(n)               \
+(			       \
+	n < 10UL ? 0 :	       \
+	n < 100UL ? 1 :	       \
+	n < 1000UL ? 2 :       \
+	n < 10000UL ? 3 :      \
+	n < 100000UL ? 4 :     \
+	n < 1000000UL ? 5 :    \
+	n < 10000000UL ? 6 :   \
+	n < 100000000UL ? 7 :  \
+	n < 1000000000UL ? 8 : \
+	9		       \
+)
+
+/* ilog10(0) should be 1 but the 0 simplifies below math */
+#define ilog10(n)    \
+(                     \
+	n == 0 ? 0UL : \
+	n == 1 ? 10UL : \
+	n == 2 ? 100UL : \
+	n == 3 ? 1000UL : \
+	n == 4 ? 10000UL : \
+	n == 5 ? 100000UL : \
+	n == 6 ? 1000000UL : \
+	n == 7 ? 10000000UL : \
+	n == 8 ? 100000000UL : \
+		 1000000000UL   \
+)
+
+static unsigned int cpumask_worst_size(unsigned int nr_bits)
+{
+	/*
+	 * Printing all the CPUs separated by a comma is a decent bound for the
+	 * maximum memory required to print a cpumask (a slightly better bound
+	 * is chunks of 2 bits set, i.e. 0-1,3-4,6-7...).
+	 *
+	 * e.g. for nr_bits=132:
+	 * - 131 commas
+	 * - 10 * 1 chars for CPUS [0, 9]
+	 * - 90 * 2 chars for CPUS [10-99]
+	 * - 32 * 3 chars for CPUS [100-131]
+	 */
+	unsigned int last_cpu = nr_bits - 1;
+	unsigned int nr_chars = nr_bits - 1;
+	int last_lvl = log10(last_cpu);
+
+	/* All log10 levels before the last one have all values used */
+	for (int lvl = 0; lvl < last_lvl; lvl++) {
+		int nr_values = ilog10(lvl + 1) - ilog10(lvl);
+
+		nr_chars += nr_values * (lvl + 1);
+	}
+	/* Last level is incomplete */
+	nr_chars += (nr_bits - ilog10(last_lvl)) * (last_lvl + 1);
+
+	return nr_chars;
+}
+
+static void print_cpumask_to_seq(struct tep_handle *tep,
+				 struct trace_seq *s, const char *format,
+				 int len_arg, const void *data, int size)
+{
+	int firstone = -1, firstzero = -1;
+	int nr_bits = size * 8;
+	bool first = true;
+	int str_size = 0;
+	char buf[12]; /* '-' + log10(2^32) + 1 digits + '\0' */
+	char *str;
+	int index;
+	int i;
+
+	str = malloc(cpumask_worst_size(nr_bits) + 1);
+	if (!str) {
+		do_warning("%s: not enough memory!", __func__);
+		return;
+	}
+
+	for (i = 0; i < size; i++) {
+		unsigned char byte;
+		int fmtsize;
+
+		if (tep->file_bigendian)
+			index = size - (i + 1);
+		else
+			index = i;
+
+		/* Byte by byte scan, not the best... */
+		byte = *(((unsigned char *)data) + index);
+more:
+		/* First find a bit set to one...*/
+		if (firstone < 0 && byte) {
+			/*
+			 * Set all lower bits, so a later ffz on this same byte
+			 * is guaranteed to find a later bit.
+			 */
+			firstone = ffs(byte) - 1;
+			byte |= (1 << firstone) - 1;
+			firstone += i * 8;
+		}
+
+		if (firstone < 0)
+			continue;
+
+		/* ...Then find a bit set to zero */
+		if ((~byte) & 0xFF) {
+			/*
+			 * Clear all lower bits, so a later ffs on this same
+			 * byte is guaranteed to find a later bit.
+			 */
+			firstzero = ffs(~byte) - 1;
+			byte &= ~((1 << (firstzero)) - 1);
+			firstzero += i * 8;
+		} else if (i == size - 1) { /* ...Or reach the end of the mask */
+			firstzero = nr_bits;
+			byte = 0;
+		} else {
+			continue;
+		}
+
+		/* We've found a bit set to one, and a later bit set to zero. */
+		if (!first) {
+			str[str_size] = ',';
+			str_size++;
+		}
+		first = false;
+
+		/* It takes {log10(number) + 1} chars to format a number */
+		fmtsize = log10(firstone) + 1;
+		snprintf(buf, fmtsize + 1, "%d", firstone);
+		memcpy(str + str_size, buf, fmtsize);
+		str_size += fmtsize;
+
+		if (firstzero > firstone + 1) {
+			fmtsize = log10(firstzero - 1) + 2;
+			snprintf(buf, fmtsize + 1, "-%d", firstzero - 1);
+			memcpy(str + str_size, buf, fmtsize);
+			str_size += fmtsize;
+		}
+
+		firstzero = firstone = -1;
+		if (byte)
+			goto more;
+	}
+
+	str[str_size] = 0;
+	str_size++;
+
+	if (len_arg >= 0)
+		trace_seq_printf(s, format, len_arg, str);
+	else
+		trace_seq_printf(s, format, str);
+
+	free(str);
+}
+
 static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
@@ -4657,7 +4812,6 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
-	case TEP_PRINT_CPUMASK:
 	case TEP_PRINT_BITMASK: {
 		if (!arg->bitmask.field) {
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
@@ -4670,6 +4824,18 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 				     data + offset, len);
 		break;
 	}
+	case TEP_PRINT_CPUMASK: {
+		if (!arg->bitmask.field) {
+			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
+			arg->bitmask.offset = arg->bitmask.field->offset;
+		}
+		if (!arg->bitmask.field)
+			break;
+		dynamic_offset_field(tep, arg->bitmask.field, data, size, &offset, &len);
+		print_cpumask_to_seq(tep, s, format, len_arg,
+				     data + offset, len);
+		break;
+	}
 	case TEP_PRINT_OP:
 		/*
 		 * The only op for string should be ? :
-- 
2.31.1

