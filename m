Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BCEC10F1B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 13 Dec 2022 17:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLMRCY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 12:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbiLMRBU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 12:01:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499F22506
        for <linux-trace-devel@vger.kernel.org>; Tue, 13 Dec 2022 08:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670950629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRu5GBwkrPlWnMueKheHDziQfSXO0ZGGE3sEIVBOPJ4=;
        b=UFcnrkP6Z4MY7tRbLwzSCU20jAKFb4USMZxpjRitbCCmDGeHbcdqbtJoUWT5zffUkbhRQS
        W9QhouRuevSDcVYtAaCly/7SGVCAwBE5xdIAIwk2fVENT8Iv6JHnowK/P1ApcMIJ6GitK8
        OTNBH0Vs2ygIlGVj/9uS3IMMDnKcyP4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-VVCFzYgSPeWV12DJwf78NA-1; Tue, 13 Dec 2022 11:57:07 -0500
X-MC-Unique: VVCFzYgSPeWV12DJwf78NA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4361F1C075A3;
        Tue, 13 Dec 2022 16:57:07 +0000 (UTC)
Received: from vschneid.remote.csb (unknown [10.33.36.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 897FB1121314;
        Tue, 13 Dec 2022 16:57:06 +0000 (UTC)
From:   Valentin Schneider <vschneid@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: [PATCH v3 3/4] libtraceevent: Pretty-print cpumask fields as a cpulist
Date:   Tue, 13 Dec 2022 16:56:19 +0000
Message-Id: <20221213165620.1034287-4-vschneid@redhat.com>
In-Reply-To: <20221213165620.1034287-1-vschneid@redhat.com>
References: <20221213165620.1034287-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
index ba8e727..d1363a5 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4491,6 +4491,161 @@ static void print_bitmask_to_seq(struct tep_handle *tep,
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
@@ -4694,7 +4849,6 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
-	case TEP_PRINT_CPUMASK:
 	case TEP_PRINT_BITMASK: {
 		if (!arg->bitmask.field) {
 			arg->bitmask.field = tep_find_any_field(event, arg->bitmask.bitmask);
@@ -4707,6 +4861,18 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
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

