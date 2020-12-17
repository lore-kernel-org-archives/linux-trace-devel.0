Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503C0C2BBCD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20746238E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgLQJrQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgLQJrP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:15 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422C4C0617B0
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:35 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r3so25923913wrt.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jTHsAv2LocixUIxaZBHDXqlapt2XOT62Xplq6fOgeM=;
        b=Fze13qkti54W/KNVY+5tz6XbnwIiVx8PEW0XXD2yBKsWRkOaEheYCly0PjBcDm/EHN
         hxh/oymt97SS4hS9SJ85oCHYMUz9j4ywB7Z2hkoHO46svpr+/45qvTo8xHGm2kc8M0ky
         mChfPlcqnHsN7TD57iFbezJbv5+cH7Cioag4Hv+zCZWZM7Zb/obhJ+ddujWbKGGb5ib6
         WXAAOBAjJlg6zDiPJEdga9y+tzhprInWGYtoQeH1IvaNBPPOBNIdBn+RfGQM2VQZH0yH
         iJe+83WKqx4+QRNrjtdtol1Ai5JH79FzVBmPWpH5Yn2Q8ihRx8EoZXceFsUSueLteOVB
         C1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3jTHsAv2LocixUIxaZBHDXqlapt2XOT62Xplq6fOgeM=;
        b=KYWsUbA20cWd1pIagzh/WqvraNt5n73vOM22Tv5V/sqIilPubh5FHXDux6PQc/jID2
         n6UNMDft5SnfvLKLsjY6P7Z3UOm5WMgOKBsL5j2KmNIcCq3FDi0EBa3Aarr5u/plhTEZ
         24PDl0kidepxxkOacQ0w4+8yDBj3rmKVLR/kfw9kjOtIcgJdB2ckb6XDU5GKPuXUdeZy
         62Gq/rvwX8FsKTioayqXznducQzwm7USj54nTa2JETdqhR27J0nBdb/HcEfjqxKRW4ib
         Hby5OOcM5lssj8KStl+FjURaBUl94ozedvFdjgwyDhDSEgqSh6VGDN7oX9kgB8q/0ppR
         EovA==
X-Gm-Message-State: AOAM533XcuzXlHXrBYvErrCiDZCv+xZZ51b4P5o8oJtlRg6lY060cJ9E
        RskAp/yN1+m0H5bIHDFdr+6bdn07xtr9rg==
X-Google-Smtp-Source: ABdhPJxsoP7UAq62MuZ4PJh4+OIeJfynTN3GZFA/6Ab+NlxgmXC1m8O9PtKpJxlMy1PiFB6Izt41Aw==
X-Received: by 2002:a5d:6902:: with SMTP id t2mr42454876wru.214.1608198394004;
        Thu, 17 Dec 2020 01:46:34 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/9] libtracefs man pages: APIs for managing trace instances.
Date:   Thu, 17 Dec 2020 11:46:22 +0200
Message-Id: <20201217094626.1402191-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_instance_create()
tracefs_instance_destroy()
tracefs_instance_free()
tracefs_instance_is_new()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-manage.txt | 104 ++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-manage.txt

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
new file mode 100644
index 0000000..ca08269
--- /dev/null
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -0,0 +1,104 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_free,
+tracefs_instance_is_new - Manage trace instances.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
+int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
+void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
+bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
+
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to manage trace instances.
+
+The _tracefs_instance_create()_ function creates a new trace instance with given
+_name_, if it does not already exist in the system. It allocates and initializes
+a new tracefs_instance structure and returns it.
+
+The _tracefs_instance_destroy()_ destroys the trace _instance_ and frees the
+tracefs_instance structure.
+
+The _tracefs_instance_free()_ function frees the tracefs_instance structure,
+without destroying the trace instance.
+
+The _tracefs_instance_is_new()_ function checks if the given _instance_ is newly
+created by _tracefs_instance_create()_, or it has been in the system before that.
+
+RETURN VALUE
+------------
+The _tracefs_instance_create()_ function returns a pointer to a newly allocated
+tracefs_instance structure. It must be freed with _tracefs_instance_destroy()_ or
+_tracefs_instance_free()_.
+
+The _tracefs_instance_destroy()_ function returns -1 in case of an error,
+or 0 otherwise.
+
+The _tracefs_instance_is_new()_ function returns true if the instance is
+created by _tracefs_instance_create()_ or false if it was in the system
+before that.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+struct tracefs_instance *inst = tracefs_instance_create("foo");
+	if (!inst) {
+		/* Error creating a new trace instance */
+		...
+	}
+
+	...
+
+	if (tracefs_instance_is_new(inst))
+		tracefs_instance_destroy(inst);
+	else
+		tracefs_instance_free(inst);
+--
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
-- 
2.28.0

