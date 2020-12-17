Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE24C2BBCF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E99A238D6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgLQJrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgLQJrR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:17 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63534C0611CC
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:37 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id a12so25865112wrv.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HoLQHa8sl8kTyKlHznALMq2ZsESwP03ZOzMjp/2wQpc=;
        b=CPEOcFnpFUUyITw8W7UdeXuQbPL1t7nKh2r8U4D+DymSImSzDT2dJC6D4w+OWGbsHv
         7zPW1LkqVxEJAKITIj3NKOwk6X0cp/iRIkFBuOPAaY/VvnaK8z3bVUvciTzo/lviib26
         sFmODRpCJlS4KXgxQJvrfPOjGD0+lft4t4xH64rC0XxiYx3G22MMuphpyd2kWmnDeCPx
         aE3BkXegEOSH2yBy/C8a+oEjrzpxdL9uGNJMZQGqRU86mApstnKTHsbdH7DFjTvPEnjD
         HeCGha2vRK+rtDDlxLKTVGRxOJQRkfzpnVWVY1llStXtWTa8fxrOAl4HjLbCqMvhWO22
         1CgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HoLQHa8sl8kTyKlHznALMq2ZsESwP03ZOzMjp/2wQpc=;
        b=UI+EFNkwvY4A1azklz0Rx1+ntxntGFMpOHO2PaUkw4RK6Fsn1jNH31L66gHTQ9sS+N
         u4N23MwIW5MuuPcPh+vEgKINhiYYLC36YM38zu+bCoLSjV/8B8fLtkzIdgydowfOJrp8
         JMpGlVUgL8nlBms3CVoiDPBDOnzr/V5jQTbEiuhFL9jfh5RDswMZAWtEWYjIOEpI7DkF
         YSUCBMXXSDTYZ2wPJ/iwVcRrV9ELZrAYY/65fE7Cxr0rzTb5I/fnIc1XiieqawJiJy63
         Iyst5WZocmHMWiuBFbk6wP7knqvgulM094skHlnKc9l+XDTyU+Qm7eGrtXExfFsFQF89
         i3AQ==
X-Gm-Message-State: AOAM533vFCIzDghobps9mfrB1RTXkeq9k1YryYNH6P6GBapWE/M5DODy
        lhR+szzgOcQvvGuvxCKXSJs=
X-Google-Smtp-Source: ABdhPJwPS3IEGpCewOEm8TFR9ewzU/eCvQ9d5T4vUhFFGy4QcskVMEpcsqIUhF8HAYsBstC9ZdHaDg==
X-Received: by 2002:a5d:61ca:: with SMTP id q10mr42652793wrv.124.1608198396194;
        Thu, 17 Dec 2020 01:46:36 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/9] libtracefs man pages: helper APIs for working with trace instances.
Date:   Thu, 17 Dec 2020 11:46:24 +0200
Message-Id: <20201217094626.1402191-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_instance_get_name()
tracefs_instances_walk()
tracefs_instance_exists()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-utils.txt | 111 +++++++++++++++++++
 1 file changed, 111 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-utils.txt

diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
new file mode 100644
index 0000000..1630d5c
--- /dev/null
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -0,0 +1,111 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_instance_get_name, tracefs_instances_walk, tracefs_instance_exists -
+Helper functions for working with tracing instances.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
+bool *tracefs_instance_exists*(const char pass:[*]_name_);
+
+--
+
+DESCRIPTION
+-----------
+Helper functions for working with trace instances.
+
+The _tracefs_instance_get_name()_ function returns the name of the given _instance_.
+Note that the top instance has no name, the function returns NULL for it.
+
+The _tracefs_instances_walk()_ function walks through all configured tracing
+instances in the system and calls _callback_ for each one of them. The _context_
+argument is passed to the _callback_, together with the instance name. If the
+_callback_ returns non-zero, the iteration stops.
+
+The _tracefs_instance_exists()_ function checks if an instance with given _name_
+exists in the system.
+
+RETURN VALUE
+------------
+The _tracefs_instance_get_name()_ returns string or NULL in case of the top
+instance. The returned string must _not_ be freed.
+
+The _tracefs_instances_walk()_ function returns 0, if all instances were iterated, 1
+if the iteration was stopped by the _callback_, or -1 in case of an error.
+
+The _tracefs_instance_exists()_ returns true if an instance with given name
+exists in the system or false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+struct tracefs_instance *inst;
+....
+char *name = tracefs_instance_get_name(inst);
+
+	if(name) {
+		/* Got name of the instance */
+	}
+
+...
+static int instance_walk(char *name, void *context)
+{
+	/* Got instance with name */
+	return 0;
+}
+...
+	if (tracefs_instances_walk(instance_walk, NULL) < 0) {
+		/* Error walking through the instances */
+	}
+...
+	if (tracefs_instance_exists("foo")) {
+		/* There is instance with name foo in the system */
+	} else {
+		/* There is no instance with name foo in the system */
+	}
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

