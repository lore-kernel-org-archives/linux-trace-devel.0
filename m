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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9607C4332D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F0EA22513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgLUGD6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgLUGD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F93C0611CC
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:01 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g20so11834465ejb.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+A8+Hn7YDKykiwvd1w4P2UVCb0lnehfD8DN5Tp5AImQ=;
        b=f7GurZX/AyMvVbmdUMnNS+DpytEcA4Evbp3XDU+ZROD6Wp+l0dJBsp5jwVZdkJHeq7
         XS9ZFXe2JGL0eBTeuOJ168drPL31R0lgCAIBvklCW6uL7ORhS6TyKkN9wJniFF3TRzHF
         oukSO3QtywoTuIRYzskLwfxIkXuD73aI5q6U7rQ3I47dB+uTkVo9ASNIZe36khAMqvLj
         7h0opIbwGuJdWYaGzKOorrth+tpeqxF6MfI981PCK8/VmP6sEVjfnplUF3H4L/YGRN15
         a5+0Btf8h/4aNU55W+MLZ7YFZJVyoTmF9iS7AxN22QTK+38hsSn8Y7qN2LgU26p1pg6A
         CDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+A8+Hn7YDKykiwvd1w4P2UVCb0lnehfD8DN5Tp5AImQ=;
        b=LFgiPN39gM9ewjrO4nS6mUw2anSGhJjp8pBZoBL0NkzCk+1BrwymqPBMw6dhcW7Yql
         AmePYgwrVeppVd7EWfGiA5pm4nh/zwslH2zxqcDy6Ala8DRuBJO9KRS9hSYlwyvL7NEt
         mt5IQKqEbsJChwjOO9azueDmDlxhS70Y2LB4WgFGHVR2JzNPii566w2PtNBv8XlntB2f
         5+2WJMRIRXNsWP8WKfvgzVnZsfLbbW5c6bxekCSTT6FU8Bk32HZ2I6n2+sixFa/cKdBg
         lHwUvcgYa1w7Aix+oeC4GIdoTf7znwgmoC7I0E8UydBtk6PAz3Q6IemodA75IUC2oiUT
         +tsw==
X-Gm-Message-State: AOAM531R5D11M77ERvq6e61g2e054rd/tG7j+9LtKKtkHBdzQVxoupxd
        1si5Y3djEJz80+ElQ6rt/8mDHBlPiI2XH16Z
X-Google-Smtp-Source: ABdhPJyDI4l/wb1dP/cbUDsNT/QXpqTofndDiOyoYMhbyxyQKM98GQXY7TJ2RYWq64ht+tK1GII4Dg==
X-Received: by 2002:a17:907:2071:: with SMTP id qp17mr14177068ejb.110.1608530580099;
        Sun, 20 Dec 2020 22:03:00 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/8] libtracefs man pages: APIs for managing trace instances.
Date:   Mon, 21 Dec 2020 08:02:48 +0200
Message-Id: <20201221060252.177890-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060252.177890-1-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
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
 Documentation/libtracefs-instances-manage.txt | 111 ++++++++++++++++++
 1 file changed, 111 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-manage.txt

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
new file mode 100644
index 0000000..aca2161
--- /dev/null
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -0,0 +1,111 @@
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
+This set of functions can be used to manage trace instances. A trace
+instance is a sub buffer used by the Linux tracing system. Given a unique
+name, the events enabled in an instance do not affect the main tracing
+system, nor other instances, as events enabled in the main tracing system
+or other instances do not affect the given instance.
+
+The _tracefs_instance_create()_ function allocates and initializes a new
+tracefs_instance structure and returns it. If the instance does not yet
+exist in the system, it will be created.
+
+The _tracefs_instance_destroy()_ frees the _instance_ structure, and will
+also remove the trace instance from the system.
+
+The _tracefs_instance_free()_ function frees the tracefs_instance structure,
+without removing the trace instance from the system.
+
+The _tracefs_instance_is_new()_ function checks if the given _instance_ is
+newly created by _tracefs_instance_create()_, or it has been in the system
+before that.
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
+The _tracefs_instance_is_new()_ function returns true if the
+_tracefs_instance_create() that allocated _instance_ also created the
+trace instance in the system, or false if the trace instance already
+existed in the system when _instance_ was allocated by
+_tracefs_instance_create()_.
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

