Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1770BC10F13
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C53872084D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BX3HTi2J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfDKWJH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:09:07 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34999 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfDKWJH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 18:09:07 -0400
Received: by mail-io1-f65.google.com with SMTP id p16so6802103iod.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Apr 2019 15:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dB1QaR+oryWm7I4D8N9CxELwJzcot7fYy9K+LcuHORU=;
        b=BX3HTi2J6Q9wHGAARCT7efSesYMqfEuVgVcQhJ/8zAw/x2lw8FGBtg/Qx3uNKV33r+
         08vYiOFE7uIEdfa34CK7DHXsh56HsI0pbS4OQ9yfcwcVdMRvlb506KuCa7ePgJrjiIzS
         tgG1XTBuuACjx8NuURzxcTB/nxVR3UZQl7Z6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dB1QaR+oryWm7I4D8N9CxELwJzcot7fYy9K+LcuHORU=;
        b=lF52L0SowCTIZL2D+oJ+zF/0gvqA9+It1VVn7gXneCJTWM7jFwlbs5WSzl1VZaZ+zj
         ZPvvH4oLg6ON/LoDSpYvMH23d5Tyjgcx4tFwPrjea2wNdnhi90sSH7z3YoLYOgPriQkS
         JPwmccHdiR75WakNeoHmhjSpBVAS79SGCe1CtjUa/3OPCl+T4nesEwEW4JcoGHhs/jF1
         dQUGAvOJBGXiWE8cOm6ACupnsq4hjDTL+AEk3CZZ3rKx888ZAhbmjH8zxeg1iBtbocXO
         CXoaHAwQbStpKNPGAXcTogiT7fWIMJsyfp/UBzWvWintmBS8nhoBblDDZk9Sa0Y01v4u
         2BjA==
X-Gm-Message-State: APjAAAVW8hXJIFfKQ3WN4gNN5EPv6xFYq/OczRaWEWPGUc4U83CLorl7
        +fF0SBgbXNo8TXoht1nj/gEAZkq5Mzc7JI4Q
X-Google-Smtp-Source: APXvYqyA5WtSSrzrF16G5xI+OM7Nmxy8lPUkl0+9gX9Q8JhllZrpBI1uNO8Vcsv6R1ECVAPTnr5fnA==
X-Received: by 2002:a5e:c705:: with SMTP id f5mr16138882iop.40.1555020546314;
        Thu, 11 Apr 2019 15:09:06 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id 64sm3298762ite.42.2019.04.11.15.09.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 15:09:05 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v1 1/4] trace_events: Add trace_print_register to print register fields
Date:   Thu, 11 Apr 2019 16:08:19 -0600
Message-Id: <20190411220822.81845-2-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190411220822.81845-1-rrangel@chromium.org>
References: <20190411220822.81845-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a hybrid method that combines the functionality of
trace_print_flags_seq and trace_print_symbols_seq. It supports printing
bit fields, enum fields, and numeric fields.

Given the following register definition:
  * 0   - Enabled
  * 1   - Width, 0 = 1-bits, 1 = 4-bits
  * 2:3 - DMA, 0 = None, 1 = SDMA, 2 = ADMA, 3 = ADMA2
  * 4:7 - Timeout Counter

The register fields could be defined as follows:

  const struct trace_print_field reg[] = {
    {1<<0, "ENABLED"},
    {
      .mask = 1<<1,
      .name = "WIDTH",
      .symbols = (const struct trace_print_flags[]) {
        {0, "1-BIT"},
        {1, "4-BIT"},
        {}
      }
    }, {
      .mask = 3<<2,
      .symbols = (const struct trace_print_flags[]) {
        {0, "NONE"},
        {1, "SDMA"},
        {2, "ADMA"},
        {3, "ADMA2"},
        {}
      }
    },
    {0xF<<4, "TIMEOUT"}
  }

This would print out the following given value 0xAB:

ENABLED: 1 | WIDTH: 4-BIT | ADMA | TIMEOUT: 0xA

See https://pastebin.com/x73d5cvL for this in action.

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 include/linux/trace_events.h    |   4 ++
 include/linux/tracepoint-defs.h |   6 ++
 include/trace/trace_events.h    |   9 +++
 kernel/trace/trace_output.c     | 121 ++++++++++++++++++++++++++++++++
 4 files changed, 140 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 8a62731673f7..3c44909ce8b3 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -23,6 +23,10 @@ const char *trace_print_flags_seq(struct trace_seq *p, const char *delim,
 const char *trace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 				    const struct trace_print_flags *symbol_array);
 
+const char *trace_print_register(struct trace_seq *p,
+				 const struct trace_print_field fields[],
+				 unsigned long val, unsigned long mask);
+
 #if BITS_PER_LONG == 32
 const char *trace_print_flags_seq_u64(struct trace_seq *p, const char *delim,
 		      unsigned long long flags,
diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
index 49ba9cde7e4b..c3dc27c192f4 100644
--- a/include/linux/tracepoint-defs.h
+++ b/include/linux/tracepoint-defs.h
@@ -16,6 +16,12 @@ struct trace_print_flags {
 	const char		*name;
 };
 
+struct trace_print_field {
+	unsigned long			mask;
+	const char			*name;
+	const struct trace_print_flags	*symbols;
+};
+
 struct trace_print_flags_u64 {
 	unsigned long long	mask;
 	const char		*name;
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 4ecdfe2e3580..6adc32fcb1c3 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -300,6 +300,14 @@ TRACE_MAKE_SYSTEM_STR();
 		trace_print_symbols_seq(p, value, symbols);		\
 	})
 
+#undef __print_register
+#define __print_register(value, mask, field_array...)			\
+	({								\
+		static const struct trace_print_field fields[] =	\
+			{ field_array, {} };			\
+		trace_print_register(p, value, mask, fields);		\
+	})
+
 #undef __print_flags_u64
 #undef __print_symbolic_u64
 #if BITS_PER_LONG == 32
@@ -744,6 +752,7 @@ static inline void ftrace_test_probe_##call(void)			\
 
 #undef __print_flags
 #undef __print_symbolic
+#undef __print_register
 #undef __print_hex
 #undef __print_hex_str
 #undef __get_dynamic_array
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 54373d93e251..cd5727ad54c3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -124,6 +124,127 @@ trace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 }
 EXPORT_SYMBOL(trace_print_symbols_seq);
 
+/**
+ * trace_print_register - Prints all the fields of a register.
+ *
+ * This is a hybrid method that combines the functionality of
+ * trace_print_flags_seq and trace_print_symbols_seq. It supports printing
+ * bit fields, enum fields, and numeric fields.
+ *
+ * Given the following register definition:
+ *   * 0   - Enabled
+ *   * 1   - Width, 0 = 1-bits, 1 = 4-bits
+ *   * 2:3 - DMA, 0 = None, 1 = SDMA, 2 = ADMA, 3 = ADMA2
+ *   * 4:7 - Timeout Counter
+ *
+ * The register fields could be defined as follows:
+ *
+ *   const struct trace_print_field reg[] = {
+ *     {1<<0, "ENABLED"},
+ *     {
+ *       .mask = 1<<1,
+ *       .name = "WIDTH",
+ *       .symbols = (const struct trace_print_flags[]) {
+ *         {0, "1-BIT"},
+ *         {1, "4-BIT"},
+ *         {}
+ *       }
+ *     }, {
+ *       .mask = 3<<2,
+ *       .symbols = (const struct trace_print_flags[]) {
+ *         {0, "NONE"},
+ *         {1, "SDMA"},
+ *         {2, "ADMA"},
+ *         {3, "ADMA2"},
+ *         {}
+ *       }
+ *     },
+ *     {0xF<<4, "TIMEOUT"}
+ *   }
+ *
+ * This would print out the following given value 0xAB:
+ *
+ * ENABLED: 1 | WIDTH: 4-BIT | ADMA | TIMEOUT: 0xA
+ *
+ * @p: trace buffer
+ * @fields: Array of fields that describe the register. Must be terminated with
+ *          an empty value.
+ * @val: register value
+ * @mask: Mask that defines the bits present in @val. Useful if only a subset
+ *        of the register was read. Any fields that fall outside of the mask
+ *        will not be printed.
+ */
+const char *trace_print_register(struct trace_seq *p,
+				 const struct trace_print_field fields[],
+				 unsigned long val, unsigned long mask)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	char *tail;
+	unsigned long fval;
+	int first = 1, symbol_found;
+	const struct trace_print_field *field;
+	const struct trace_print_flags *symbol;
+
+	for (field = fields; field->mask; field++) {
+		/* Make sure the field mask is within the accessed bits */
+		if ((mask & field->mask) != field->mask)
+			continue;
+
+		if (!first)
+			trace_seq_puts(p, " | ");
+
+		first = 0;
+
+		if (field->name) {
+			trace_seq_puts(p, field->name);
+			trace_seq_puts(p, ": ");
+		}
+
+		fval = val & field->mask;
+		fval >>= ffs(field->mask) - 1;
+
+		val &= ~field->mask;
+
+		symbol_found = 0;
+		for (symbol = field->symbols; symbol && symbol->name;
+		     symbol++) {
+			if (symbol->mask != fval)
+				continue;
+			trace_seq_puts(p, symbol->name);
+			symbol_found = 1;
+			break;
+		}
+
+		if (!symbol_found) {
+			if (fval == 0) {
+				trace_seq_puts(p, "0");
+			} else if (fval == 1) {
+				trace_seq_puts(p, "1");
+			} else {
+				trace_seq_printf(p, "%#x", fval);
+
+				/* Strip off the null terminator */
+				for (tail = trace_seq_buffer_ptr(p) - 1;
+				     tail > ret && !*tail; tail--) {
+					p->seq.len--;
+				}
+			}
+		}
+	}
+
+	/* Print any left over bits */
+	if (val) {
+		if (!first)
+			trace_seq_puts(p, " | ");
+		trace_seq_printf(p, "%#x", val);
+	}
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(trace_print_register);
+
 #if BITS_PER_LONG == 32
 const char *
 trace_print_flags_seq_u64(struct trace_seq *p, const char *delim,
-- 
2.21.0.392.gf8f6787159e-goog

