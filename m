Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F5FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Oct 2022 09:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJLJyq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 05:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJLJyn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 05:54:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1914EFE6
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Oct 2022 02:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=XbAnKgPpGW7MzZYP96I3lRUTtdOwXMauIcXPRwcWH3Q=; t=1665568481; x=1666778081; 
        b=xHWaKizpLahr2fA34CDsz2EJFbkM8deO1xMslJc9b/xEDAChuUSuVp7VCH2VipWDJxYbS4gXO3T
        YRll7iX+nQ0DlR4WGv3M7lCMaSPQ/hj5guaVP/FKDOGxBGMkSZJCjjBE6zCJvenMSGxN5vxSFEGJS
        3FFvcMj8KAItm6jScVR3CaILKiPpSGAJA751pg5BYC8u+b9T6vCo+tUpIZzpzXsab5mmT6lR7rWA4
        01qnTiNFZTqDKGjgGPyAEZaWeamzEluI/fGk8CARmWybcW4UXkkASVbWlTgdwrqdn9paKeiVeFqfz
        9cNsimS4SUQKoGDt90+TKfxeUXj5fhdehsaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <benjamin@sipsolutions.net>)
        id 1oiYRf-004lHd-2Y;
        Wed, 12 Oct 2022 11:54:35 +0200
From:   Benjamin Berg <benjamin@sipsolutions.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: [RFC PATCH] libtraceevent: Implement record reference counting
Date:   Wed, 12 Oct 2022 11:54:29 +0200
Message-Id: <20221012095429.781710-1-benjamin@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The reference counting was handled internal to trace-cmd. This can be a
problem for plugins that may want to reference record, which is in
particular required for python to work properly.

As such, implement reference counting within libtraceevent. To remain
backward compatible with older trace-cmd versions, this patchset
redefines the priv pointer data be allocated by libtraceevent as part of
the record itself. This allows backward compatibility as long as the
user was not compiled with DEBUG_RECORD enabled.

There might be alternatives to this, e.g.:
 * Set a high bit in the ref_count
 * Drop backward compatibility

The alloc_addr is left in the structure, is set appropriately and may be
overwritten by the API user for its own use.
---
 include/traceevent/event-parse.h | 37 +++++++++++++++++----
 include/traceevent/event-utils.h |  3 --
 src/event-parse.c                | 55 ++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 10 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 0b911e1..c161754 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -22,6 +22,14 @@
 #define DEBUG_RECORD 0
 #endif
 
+#ifndef __deprecated
+#define __deprecated(msg) __attribute__((deprecated("msg")))
+#endif
+
+#ifndef __te_private
+#define __te_private(msg) __attribute__((deprecated("msg")))
+#endif
+
 struct tep_record {
 	unsigned long long	ts;
 	unsigned long long	offset;
@@ -30,16 +38,32 @@ struct tep_record {
 	int			size;		/* size of data */
 	void			*data;
 	int			cpu;
-	int			ref_count;
-	int			locked;		/* Do not free, even if ref_count is zero */
+
+	int			ref_count __te_private(use ref/unref instead);
+	int			locked __deprecated(do not use);
 	void			*priv;
+
 #if DEBUG_RECORD
-	struct tep_record	*prev;
-	struct tep_record	*next;
-	long			alloc_addr;
+	unsigned long		alloc_addr;	/* Location ref'ing the last time */
+#endif
+
+#ifdef TE_PRIVATE
+	/* These private fields are only valid if priv is pointing  to
+	 * _priv_alloc. If that is not the case, the API user has not yet
+	 * been ported to the new API.
+	 * NOTE: Adding new fields does not break ABI/API.
+	 */
+	void (*_finalize) (struct tep_record *record);
+	void			*_priv_alloc[0];
 #endif
 };
 
+
+struct tep_record *tep_record_alloc(int priv_size,
+				    void (*finalize) (struct tep_record *record));
+void tep_record_ref(struct tep_record *record);
+void tep_record_unref(struct tep_record *record);
+
 /* ----------------------- tep ----------------------- */
 
 struct tep_handle;
@@ -774,8 +798,7 @@ enum tep_loglevel {
 };
 void tep_set_loglevel(enum tep_loglevel level);
 
-/* DEPRECATED */
 void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field);
+		     struct tep_format_field *field) __deprecated(Use tep_print_field_content instead);
 
 #endif /* _PARSE_EVENTS_H */
diff --git a/include/traceevent/event-utils.h b/include/traceevent/event-utils.h
index 44f7968..14edbf8 100644
--- a/include/traceevent/event-utils.h
+++ b/include/traceevent/event-utils.h
@@ -23,9 +23,6 @@ int tep_vprint(const char *name, enum tep_loglevel level,
 int __tep_vprint(const char *name, enum tep_loglevel level,
 		 bool print_err, const char *fmt, va_list ap);
 
-
-#define __deprecated(msg) __attribute__((deprecated("msg")))
-
 /* For backward compatibilty, do not use */
 int tep_vwarning(const char *name, const char *fmt, va_list ap) __deprecated(Use tep_vprint instead);
 void pr_stat(const char *fmt, ...) __deprecated(Use tep_info instead);
diff --git a/src/event-parse.c b/src/event-parse.c
index 980e980..7e81a32 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -14,6 +14,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <stdarg.h>
+#include <stddef.h>
 #include <ctype.h>
 #include <errno.h>
 #include <stdint.h>
@@ -22,6 +23,10 @@
 #include <linux/time64.h>
 
 #include <netinet/in.h>
+
+#define __te_private(msg)
+#define TE_PRIVATE 1
+
 #include "event-parse.h"
 
 #include "event-parse-local.h"
@@ -8113,6 +8118,56 @@ int tep_get_ref(struct tep_handle *tep)
 	return 0;
 }
 
+struct tep_record *tep_record_alloc(int priv_size,
+				    void (*finalize) (struct tep_record *record))
+{
+	struct tep_record *res;
+
+	res = malloc(sizeof(*res) + priv_size);
+	if (!res)
+		return NULL;
+
+	memset(res, 0, sizeof(*res) + priv_size);
+	res->ref_count = 1;
+	res->priv = res->_priv_alloc;
+	res->_finalize = finalize;
+
+	return res;
+}
+
+void tep_record_ref(struct tep_record *record)
+{
+	record->ref_count++;
+
+#if DEBUG_RECORD
+	record->alloc_addr = (unsigned long)__builtin_return_address(0);
+#endif
+}
+
+void tep_record_unref(struct tep_record *record)
+{
+	if (record->ref_count  <= 0) {
+		tep_warning("Invalid refcount on record %p", record);
+		return;
+	}
+
+	record->ref_count--;
+
+	if (record->ref_count)
+		return;
+
+	if (record->priv != record->_priv_alloc) {
+		tep_warning("Leaking record %p, update user to new allocation API.",
+			    record);
+		return;
+	}
+
+	if (record->_finalize)
+		record->_finalize(record);
+
+	free(record);
+}
+
 __hidden void free_tep_format_field(struct tep_format_field *field)
 {
 	free(field->type);
-- 
2.37.3

