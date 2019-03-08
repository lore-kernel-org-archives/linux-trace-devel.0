Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639F5C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43BA72087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfCHNha (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36566 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfCHNh3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:29 -0500
Received: by mail-wr1-f68.google.com with SMTP id o17so21411951wrw.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CKZ0vQumDnE4o2awGyv+reBvTJfL3GSDGfpLWC0Z54U=;
        b=SIxmcuQcjMr72w5RdwVVrHvOhDoqiHA+USMmtVu7tAWd9XFuQco7ZHqBISeZQjZCfI
         mVLC71QWMOPwsO7HJTQAmjnxrFW+cQKa4fDhwUFbBXPbPD6HhFnIRLlUYtf/DxYGEcOH
         YVRloEAvFzXyz9iHOcdxVJ8hTn1gkSUFqebXNw1RAwSBAVxSoMrDRw7xm5/97pJKnJTt
         xnxaH7QloRkRMEdbBCKQdseBK491sbK9LI2meDrop/V10bY90kufLQt3hp80xrD8Tm1/
         bqxtaS1RaeiG16XpkYdlqfJ/+RO0STUJtcnc4rJtL9OT+l8ny/vlVlO1lyKrbfzFWZVz
         rxig==
X-Gm-Message-State: APjAAAXcGT4S2kG7ggvkOtKrNR8Tw4/pLjKxc1RN9Gc0WAwZR/PbyAHz
        RV1KOGM3XZQqqIZf3HcQCHg=
X-Google-Smtp-Source: APXvYqx43rOFgMo2M44K7UcwaTODSzxJWQbnj1TMoOnBVj1UgtGpLlkmYZn3q/qv/h3TF9zX8da2lw==
X-Received: by 2002:adf:dfca:: with SMTP id q10mr11264040wrn.45.1552052248309;
        Fri, 08 Mar 2019 05:37:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:27 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 33/46] tools/lib/traceevent: Man page for tep_filter_make_string()
Date:   Fri,  8 Mar 2019 15:36:41 +0200
Message-Id: <20190308133654.21264-34-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_filter_make_string()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_show.txt             | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt
new file mode 100644
index 000000000000..8d54b401018e
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt
@@ -0,0 +1,75 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_make_string - Returns a string showing the filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+char pass:[*]*tep_filter_make_string*(struct tep_event_filter pass:[*]_filter_, int _event_id_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_make_string()_ function constructs a string, displaying
+the _filter_ contents for given _event_id_.
+
+RETURN VALUE
+------------
+The _tep_filter_make_string()_ function returns a string, which must be freed
+with free(), or NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+...
+char *fstring = tep_filter_make_string(filter, 352);
+if (fstring != NULL) {
+	/* The filter for event 352 is in fstring */
+	free(fstring);
+}
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1

